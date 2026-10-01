# COMP 311 Lab Answers

Your name:

- [YOUR ANSWER HERE]
- [YOUR ANSWER HERE]

Replace every `[YOUR ANSWER HERE]` and `TBD` below before submission.

---

# Part 1: You Are the Compiler

## 1. RV32I translation

Also place your completed code in `starter/part1.s`.

```asm
# [YOUR ANSWER HERE]
```

## 2. Which instructions access memory?

[YOUR ANSWER HERE]

## 3. Why are the array offsets measured in bytes rather than array indices?

[YOUR ANSWER HERE]

## 4. What is the minimum number of RISC-V instructions needed?

[YOUR ANSWER HERE]

---

# Part 2: Predict Before You Compile

## 1. Which version do you predict will require less machine work?

[YOUR ANSWER HERE]

## 2. Why?

[YOUR ANSWER HERE]

## 3. What do you expect the machine-level instructions to do differently?

[YOUR ANSWER HERE]

---

# Part 3: Compile to RV32I

## Annotated assembly excerpts

### `scale_add`, `-O0`

```asm
# [YOUR ANSWER HERE]
```

### `scale_shift`, `-O0`

```asm
# [YOUR ANSWER HERE]
```

### `scale_add`, `-O2`

```asm
# [YOUR ANSWER HERE]
```

### `scale_shift`, `-O2`

```asm
# [YOUR ANSWER HERE]
```

## Instruction counts

| Version | Optimization | Total static instructions in function | Loads / Stores | Arithmetic / Logic | Branches / Jumps |
|---|---:|---:|---:|---:|---:|
| `scale_add` | `-O0` | TBD | TBD | TBD | TBD |
| `scale_shift` | `-O0` | TBD | TBD | TBD | TBD |
| `scale_add` | `-O2` | TBD | TBD | TBD | TBD |
| `scale_shift` | `-O2` | TBD | TBD | TBD | TBD |

## 1. What major differences do you observe between `-O0` and `-O2`?

[YOUR ANSWER HERE]

## 2. What happened to the repeated-addition loop under optimization?

[YOUR ANSWER HERE]

## 3. Did the optimized versions become more similar?

[YOUR ANSWER HERE]

## 4. Was your original prediction still meaningful after optimization?

[YOUR ANSWER HERE]

---

# Part 4: Static vs. Dynamic Instruction Count

## 1. Identify the loop body and paste the relevant assembly.

```asm
# [YOUR ANSWER HERE]
```

## 2. How many static instructions are in the loop body?

[YOUR ANSWER HERE]

## 3. How many times does the loop execute?

[YOUR ANSWER HERE]

## 4. How many dynamic instruction executions are caused by the loop body?

Show your reasoning.

[YOUR ANSWER HERE]

## 5. Why is this different from the static instruction count?

[YOUR ANSWER HERE]

---

# Part 5: Array Indexing vs. Pointer Iteration

## Prediction

### 1. Which version do you predict will require less machine work?

[YOUR ANSWER HERE]

### 2. What do you expect the assembly for each version to do differently?

[YOUR ANSWER HERE]

## Investigation

### 3. In `sum_indexed`, where is the array element address computed?

```asm
# [YOUR ANSWER HERE]
```

Explanation:

[YOUR ANSWER HERE]

### 4. In `sum_pointer`, how does the pointer change each iteration?

```asm
# [YOUR ANSWER HERE]
```

Explanation:

[YOUR ANSWER HERE]

### 5. At `-O0`, which version appears to require more machine work? What evidence are you using?

[YOUR ANSWER HERE]

### 6. At `-O2`, how similar are the two generated implementations?

[YOUR ANSWER HERE]

### 7. Is pointer-based C automatically faster than indexed C?

[YOUR ANSWER HERE]

### 8. What does this tell you about source-level performance claims?

[YOUR ANSWER HERE]

---

# Part 6: Modification Experiment

## Prediction

### 1. Do you predict the static instruction count will increase or decrease? Why?

[YOUR ANSWER HERE]

### 2. Do you predict the number of loop iterations will increase or decrease?

[YOUR ANSWER HERE]

### 3. Do you predict the dynamic instruction count will increase or decrease? Why?

[YOUR ANSWER HERE]

## Results

### 4. Did the static instruction count increase or decrease?

[YOUR ANSWER HERE]

### 5. Did the number of loop iterations increase or decrease?

[YOUR ANSWER HERE]

### 6. Did your estimated dynamic instruction count increase or decrease?

Show your reasoning.

[YOUR ANSWER HERE]

### 7. Why can static and dynamic instruction counts move in different directions?

[YOUR ANSWER HERE]

### 8. Did the optimizer preserve your source-level transformation?

[YOUR ANSWER HERE]

Optional short assembly excerpt used as evidence:

```asm
# [YOUR ANSWER HERE]
```

---

# Part 7: Performance Claim Investigation

## 1. Before compiling, predict what assembly each version will produce.

[YOUR ANSWER HERE]

## 2. Are the generated instructions different at `-O0`?

[YOUR ANSWER HERE]

Relevant excerpt(s):

```asm
# [YOUR ANSWER HERE]
```

## 3. Are they different at `-O2`?

[YOUR ANSWER HERE]

Relevant excerpt(s):

```asm
# [YOUR ANSWER HERE]
```

## 4. Does manually replacing multiplication by 8 with a shift necessarily improve performance?

[YOUR ANSWER HERE]

## 5. What role does the compiler play in evaluating source-level optimization advice?

[YOUR ANSWER HERE]

---

# Part 8: Final Reflection

Answer each in 2–4 sentences.

## 1. What was the most surprising difference between the C code and the generated RISC-V?

[YOUR ANSWER HERE]

## 2. Why is dynamic instruction count often more informative than static instruction count?

[YOUR ANSWER HERE]

## 3. Why might fewer instructions still not guarantee a proportionally faster program?

[YOUR ANSWER HERE]

## 4. Looking across Parts 2–7, what did compiler optimization change most dramatically?

Use examples from at least two earlier parts.

[YOUR ANSWER HERE]

## 5. What evidence would you want before accepting a claim that one C implementation is "faster"?

[YOUR ANSWER HERE]
