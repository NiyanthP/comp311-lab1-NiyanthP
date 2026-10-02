# COMP 311 Lab Answers

Your name: Niyanth Ponnusamy


---

# Part 1: You Are the Compiler

## 1. RV32I translation

Also place your completed code in `starter/part1.s`.

```asm
    lw   t1, 4(t0) # t1 = values[1]   
    lw   t2, 12(t0)  # t2 = values[3]  
    add  t3, t1, t2 # t3 = values[1] + values[3]
    addi t3, t3, 5 # t3 = t3 + 5      
    ret
```

## 2. Which instructions access memory?

    lw   t1, 4(t0)      
    lw   t2, 12(t0)
    They read memory into a register.

## 3. Why are the array offsets measured in bytes rather than array indices?

Memory is numbered byte by byte and an integer is 4 bytes. So to move forward to another index we multiply 4 x (index adjustment).

## 4. What is the minimum number of RISC-V instructions needed?

4 instructions. We need 2 lw to load values[1] and values[3]. Then another one to add these two values. Finally, another one to add 5. 

---

# Part 2: Predict Before You Compile

## 1. Which version do you predict will require less machine work?

I think scale_shift will require less machine work.

## 2. Why?

scale_shift just shifts left by 3 which is just multiplying by 8. scale_add adds x 8 times which will probably require more machine work. 

## 3. What do you expect the machine-level instructions to do differently?

scale_shift should compile in 1 instruction while scale_add will take a loop and have a lot more instructions as they had to add 1 to i and add x to the result. Also it has to make sure i is always less than 8. 

---

# Part 3: Compile to RV32I

## Annotated assembly excerpts

### `scale_add`, `-O0`

```asm
scale_add:
	addi	sp,sp,-48 # set up the stack
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)     
	sw	zero,-20(s0) # result = 0
	sw	zero,-24(s0) # i = 0
	j	.L2  #  check the loop condition
.L3: # loop body
	lw	a4,-20(s0)
	lw	a5,-36(s0)
	add	a5,a4,a5  # result + x
	sw	a5,-20(s0)
	lw	a5,-24(s0)
	addi	a5,a5,1 # i++
	sw	a5,-24(s0)
.L2:  # loop check
	lw	a4,-24(s0)
	li	a5,7
	ble	a4,a5,.L3  # if i <= 7 then loop again
	lw	a5,-20(s0)
	mv	a0,a5  # result in a0 to return it
	lw	s0,44(sp)      
	addi	sp,sp,48
	jr	ra              
```

### `scale_shift`, `-O0`

```asm
scale_shift:
	addi	sp,sp,-32 # set up the stack
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)      
	lw	a5,-20(s0)
	slli	a5,a5,3  # x << 3 
	mv	a0,a5   # put result in a0 to return it
	lw	s0,28(sp) # clean up the stack
	addi	sp,sp,32
	jr	ra              
```

### `scale_add`, `-O2`

```asm
scale_add:
	slli	a0,a0,3 # x * 8
	ret                     
```

### `scale_shift`, `-O2`

```asm
scale_shift:
	slli	a0,a0,3 # x * 8
	ret                     
```

## Instruction counts

| Version | Optimization | Total static instructions in function | Loads / Stores | Arithmetic / Logic | Branches / Jumps |
|---|---:|---:|---:|---:|---:|
| `scale_add` | `-O0` | 22 | 12 | 7 | 3 |
| `scale_shift` | `-O0` | 10 | 4 | 5 | 1 |
| `scale_add` | `-O2` | 2 | 0 | 1 | 1 |
| `scale_shift` | `-O2` | 2 | 0 | 1 | 1 |

## 1. What major differences do you observe between `-O0` and `-O2`?

The compiler does everything step by step in -O0. In -O2, it skips all of the extra work and each function just becomes the two instructions. 

## 2. What happened to the repeated-addition loop under optimization?

The loop is no longer there because the compiler realized it could just miltiply/shift left by 3 which would be more optimal. 

## 3. Did the optimized versions become more similar?

Yes. They became the same thing: slli	a0,a0,3

## 4. Was your original prediction still meaningful after optimization?

It was right for -O0 but when it was optimized in -O2, it no longer mattered. 

---

# Part 4: Static vs. Dynamic Instruction Count

## 1. Identify the loop body and paste the relevant assembly.

```asm
.L3: # loop body
	lw	a4,-20(s0)
	lw	a5,-36(s0)
	add	a5,a4,a5 # result + x
	sw	a5,-20(s0)
	lw	a5,-24(s0)
	addi	a5,a5,1 # i++
	sw	a5,-24(s0)
.L2: # loop check
	lw	a4,-24(s0)
	li	a5,7
	ble	a4,a5,.L3 # if i <= 7 then loop again
```

## 2. How many static instructions are in the loop body?

There are 10 instructions.

## 3. How many times does the loop execute?

The loop executes 8 times. The check runs 1 more time than the body. 

## 4. How many dynamic instruction executions are caused by the loop body?

(7 body instructions × 8) + (3 check instructions × 9) = 83

## 5. Why is this different from the static instruction count?

The dynamic count shows how many times instructions actually run since there is a loop that runs 8 times. The static count is only 10 because it is counted only once.

---

# Part 5: Array Indexing vs. Pointer Iteration

## Prediction

### 1. Which version do you predict will require less machine work?

I think sum_pointer will require less machine work  becuase it just moves the pointer forward each time while sum_indexed has to recalculate the address of a[i].

### 2. What do you expect the assembly for each version to do differently?

I think sum_pointer to just load from the pointer and add 4. I think sum_indexed ill multiple each i by 4 and add it to the base address. 

## Investigation

### 3. In `sum_indexed`, where is the array element address computed?

```asm
lw   a5,-24(s0) # load i
slli a5,a5,2 # i * 4 (convert index to bytes)
lw   a4,-36(s0) # load base address a
add  a5,a4,a5 # address = a + i*4
lw   a5,0(a5)  # load a[i]
```

Explanation:

The address is computed inside the loop after every iteration. It shifts i left by 2 and adds it to the base address to get a[i].

### 4. In `sum_pointer`, how does the pointer change each iteration?

```asm
lw   a5,-36(s0) # load pointer a
addi a5,a5,4 # a++ (move forward 4 bytes = one int)
sw   a5,-36(s0) # save updated pointer
```

Explanation:

The pointer just gets added to 4 each time so that it san moce to the next int. 

### 5. At `-O0`, which version appears to require more machine work? What evidence are you using?

sum_indexed does more work because its loop is 14 instructions per iteration (11 + 3) wwhile sum_pointer's is 11 (8 + 3). This is becasue sum_indexed does the slli + add address math inside the loop while sum_pointer does the math just once. 

### 6. At `-O2`, how similar are the two generated implementations?

The loops are basically the same thing. The only diference is bne vs bgtu. THe compiler turned sum_indexed into a pointer loop and computed the end eddress with slli and add. There is a different order for the empty array check. 

### 7. Is pointer-based C automatically faster than indexed C?

No. It was faster for -O0 but they run the same instruction loop for -O2. 

### 8. What does this tell you about source-level performance claims?

You can't tell which C code is faster just by looking at it because the compiler cna change and rewrite them into the same thing. 

---

# Part 6: Modification Experiment

## Prediction

### 1. Do you predict the static instruction count will increase or decrease? Why?

It will increase. The loop body has 2 additions so there are more instruction in the code (extra load and add).

### 2. Do you predict the number of loop iterations will increase or decrease?

It will decrease by 1/2. i does up by 2 instead of 1 so the loop will only run n/2 times. 

### 3. Do you predict the dynamic instruction count will increase or decrease? Why?

I think it will decrease because now there is an extra load and add but updating i, comparing it, and branching only happens half as often. 

## Results

### 4. Did the static instruction count increase or decrease?

The static instruction count increased. The original had 14 instructions and this version has 23.

### 5. Did the number of loop iterations increase or decrease?

The number of loop iterations decreased by 1/2. The loop runs n/2 times. 

### 6. Did your estimated dynamic instruction count increase or decrease?

Show your reasoning.
Original: 14 x 8 = 112
New: 23 x 4 = 92

The new version has 20 fewer instructions in the loop even though the loop is bigger.

### 7. Why can static and dynamic instruction counts move in different directions?

Static counts how many instructions are written while dynamic counts how many actually run. The new loop is longer but runs 1/2 as many times. 

### 8. Did the optimizer preserve your source-level transformation?

Kind of. For -O2, the compiler kept the two at a time idea but it turned the indexed code into a pointer loop that moves 8 bytes each time. 

Optional short assembly excerpt used as evidence:

```asm
.L3:
	lw	a2,0(a5) # load a[i]
	lw	a3,4(a5) # load a[i + 1]
	addi	a5,a5,8 # move pointer forward 2 ints (8 bytes)
	add	a0,a0,a2 # sum += a[i]
	add	a0,a0,a3  # sum += a[i + 1]
	bne	a4,a5,.L3  # loop until the pointer reaches the end
```

---

# Part 7: Performance Claim Investigation

## 1. Before compiling, predict what assembly each version will produce.

I think the compiler will use slli to shift left by 3 for both mul8 and shift8. Multiplying by 8 and shifting left by 3 is the same thing. 

## 2. Are the generated instructions different at `-O0`?

They are the same. Both are 10 instructions with the same setup and both compute the result with slli a5,a5,3.

Relevant excerpt(s):

```asm
# mul8 -O0
	lw	a5,-20(s0) # load x
	slli	a5,a5,3  # x * 8 done as a shift
	mv	a0,a5 

# shift8 -O0
	lw	a5,-20(s0) # load x
	slli	a5,a5,3   # x << 3
	mv	a0,a5           
```

## 3. Are they different at `-O2`?

They are the same. Both are 2 instructions. 

Relevant excerpt(s):

```asm
# mul8 -O2
	slli	a0,a0,3 # a0 = x * 8
	ret

# shift8 -O2
	slli	a0,a0,3 # a0 = x << 3
	ret
```

## 4. Does manually replacing multiplication by 8 with a shift necessarily improve performance?

No the compiler already changes x * 8 to shift left by 3 even at -O0. 

## 5. What role does the compiler play in evaluating source-level optimization advice?

The only way to know if a change helps is by looking at the assembly the compiler produces. This is because the compiler already optimizes automatically.

---

# Part 8: Final Reflection

Answer each in 2–4 sentences.

## 1. What was the most surprising difference between the C code and the generated RISC-V?

The most surprising thing was probably how the compiler deleted the whole loop in scale_add for O2. I thought the loop would still be there but it would just be faster. But it completely changed it by realizing it could just multiply and use a slli instruction. 

## 2. Why is dynamic instruction count often more informative than static instruction count?

Dynamic instruction counts show how many instructions actually run which is essentially how much work the machine actually does. Static count just counts the number of instructions and doesn't take loops into account. For example, in part 4, the loop had 10 static instructions but they executed 83 instructions. 

## 3. Why might fewer instructions still not guarantee a proportionally faster program?

Some instructions could take longer. lw, for example, has to go to memory which is much slower than add. Branches can also slow the processor down if it guesses wrong. So we need to take into account which instructions are actually being run. 

## 4. Looking across Parts 2–7, what did compiler optimization change most dramatically?

The biggest change was that -O2 made different C code turn into the same assembly. In part 3, the scale_add function went from 22 to 2 instructions which was the same as scale_shift. In part 5, sum_indexed and sum_pointer went from 14 and 11 instructions to a 4 instruction loop. 

## 5. What evidence would you want before accepting a claim that one C implementation is "faster"?

I'd want to see dynamic instruction counts and compare it with the actual assembly. I also want the programs to be timed because instruction counts don't account for everything. 
