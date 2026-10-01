# COMP 311 Lab: What Does the Machine Actually Do?

## Overview

In C, a single line of code can hide a surprising amount of work. In this lab,
you will investigate what happens when C programs are translated into RISC-V.

You will begin by acting as the compiler yourself: translating a small C
expression into assembly. Then you will use a real compiler to generate RV32I
assembly, inspect the instructions it produces, and compare different
implementations.

Throughout the lab, we will return to one question:

> **Can we tell which C program is faster just by looking at the C code?**

You will use generated assembly and instruction counts as evidence.

Record **all written answers** in `answers.md`.

---

## Learning Goals

By the end of this lab, you should be able to:

- translate a small C expression into RV32I assembly,
- read and annotate compiler-generated RISC-V,
- distinguish between static and dynamic instruction count,
- identify arithmetic, memory, and control-flow instructions,
- explain how compiler optimizations change generated assembly,
- compare two C implementations using machine-level evidence,
- explain why source-code appearance alone is not always enough to predict performance.

---

## Setup

**Start by following the setup instructions in `README.md`.**

Open the repository in VS Code, choose:

```text
Dev Containers: Reopen in Container
```

and then run:

```bash
311-check
```

You should see:

```text
Success: generated RV32I assembly.
```

Your starting repository should contain:

```text
README.md
LAB.md
DEVCONTAINER.md
answers.md
starter/
scripts/
build/
```

If any of those are missing before you begin, check that you cloned/opened the
correct repository.

### Optimization flags used in this lab

Be careful when reading the compiler flags:

```text
-O0 = capital O + zero  → optimization off
-O2 = capital O + two   → optimization on
```

Generated files will appear in `build/`.

---

# Part 1: You Are the Compiler

Before asking a compiler to generate assembly, you will translate a short C
statement yourself.

Open:

```text
starter/part1.s
```

Assume:

```text
t0 = base address of values
t1 = available temporary register
t2 = available temporary register
t3 = result
```

Each element of `values` is a 32-bit integer.

Translate:

```c
result = values[1] + values[3] + 5;
```

You may use the instructions you have learned in class, including `lw`, `add`,
and `addi`.

After editing `starter/part1.s`, run:

```bash
311-assemble starter/part1.s
```

### Submit in `answers.md`

**1. Write your RV32I translation.**

**2. Which instructions access memory?**

**3. Why are the offsets for `values[1]` and `values[3]` measured in bytes rather than array indices?**

**4. What is the minimum number of RISC-V instructions needed to implement this one line of C using the assumptions above?**

---

# Part 2: Predict Before You Compile

Compare:

```text
starter/scale_add.c
starter/scale_shift.c
```

Both compute `8 * x`.

Before compiling either version, answer the following in `answers.md`.

### Submit in `answers.md`

**1. Which version do you predict will require less machine work?**

**2. Why?**

**3. What do you expect the machine-level instructions for the two versions to do differently?**

Do not justify your answer by saying that one version has fewer lines of C.
Think about the operations the machine may need to perform.

---

# Part 3: Compile to RV32I

Compile both functions with optimization off:

```bash
311-compile -O0 starter/scale_add.c
311-compile -O0 starter/scale_shift.c
```

Then compile both with optimization on:

```bash
311-compile -O2 starter/scale_add.c
311-compile -O2 starter/scale_shift.c
```

Reminder:

```text
-O0 = capital O + zero
-O2 = capital O + two
```

Open:

```text
build/scale_add_O0.s
build/scale_shift_O0.s
build/scale_add_O2.s
build/scale_shift_O2.s
```

You do **not** need to understand every assembler directive.

## What should you count?

For the table below, **Total static instructions in function** means:

> Count every RISC-V instruction from the function's first instruction through
> its return instruction.

Count function setup/teardown instructions if the compiler generated them.

Do **not** count:

- labels such as `scale_add:`
- assembler directives such as `.text`, `.globl`, `.align`, or `.size`
- comments

For the category columns, count the instructions that fit that category. Some
instructions may not fit one of the three listed categories, so the category
columns do not necessarily need to sum to the total.

## Annotate the Assembly

For each function, identify the major instructions responsible for:

- performing the computation,
- updating/checking the loop, if one exists,
- returning the result.

Paste **short, relevant assembly excerpts** into `answers.md` and add comments
explaining what the major instructions do. You do not need to submit the full
generated `.s` files.

### Submit in `answers.md`

Complete this table:

| Version | Optimization | Total static instructions in function | Loads / Stores | Arithmetic / Logic | Branches / Jumps |
|---|---:|---:|---:|---:|---:|
| `scale_add` | `-O0` |  |  |  |  |
| `scale_shift` | `-O0` |  |  |  |  |
| `scale_add` | `-O2` |  |  |  |  |
| `scale_shift` | `-O2` |  |  |  |  |

Then answer:

**1. What major differences do you observe between `-O0` and `-O2`?**

**2. What happened to the repeated-addition loop under optimization?**

**3. Did the optimized versions become more similar?**

**4. Was your original prediction still meaningful after compiler optimization? Why or why not?**

---

# Part 4: Static vs. Dynamic Instruction Count

A **static instruction count** tells us how many instructions appear in a
piece of code.

A **dynamic instruction count** tells us how many instructions are actually
executed during one run.

These are not necessarily the same.

For example, suppose a loop body contains four instructions:

```asm
add   ...
addi  ...
addi  ...
blt   ...
```

The static count is four instructions.

If the loop executes eight times, those instructions account for approximately:

```text
4 instructions × 8 iterations = 32 instruction executions
```

before accounting for setup and exit instructions outside the loop.

Use the `scale_add` assembly generated at `-O0`.

### Submit in `answers.md`

**1. Identify the loop body. Paste the relevant assembly excerpt.**

**2. How many static instructions are in the loop body?**

**3. How many times does the loop execute?**

**4. How many dynamic instruction executions are caused by the loop body? Show your reasoning.**

**5. Why is this dynamic count different from the static instruction count?**

---

# Part 5: A More Realistic Comparison

Now compare two implementations of the same array computation:

```text
starter/array_indexed.c
starter/array_pointer.c
```

Before compiling, answer the prediction questions in `answers.md`.

### Submit your prediction in `answers.md`

**1. Which version do you predict will require less machine work?**

**2. What do you expect the assembly for each version to do differently?**

Now compile both versions:

```bash
311-compile -O0 starter/array_indexed.c
311-compile -O0 starter/array_pointer.c

311-compile -O2 starter/array_indexed.c
311-compile -O2 starter/array_pointer.c
```

Inspect:

```text
build/array_indexed_O0.s
build/array_pointer_O0.s
build/array_indexed_O2.s
build/array_pointer_O2.s
```

### Submit in `answers.md`

**3. In `sum_indexed`, where can you see the computation of an array element address? Paste a short excerpt.**

**4. In `sum_pointer`, how does the pointer change from one iteration to the next? Paste a short excerpt.**

**5. At `-O0`, which version appears to require more machine work? What evidence are you using?**

**6. At `-O2`, how similar are the two generated implementations?**

**7. Based on the generated assembly, is pointer-based C automatically faster than indexed C? Explain.**

**8. What does this tell you about making performance claims from source code alone?**

---

# Part 6: Modify the Program

Create a **new source file** for your modified implementation so you can compare
the original and modified assembly side-by-side.

Start by copying the original:

```bash
cp starter/array_indexed.c starter/array_indexed_two_at_a_time.c
```

Edit:

```text
starter/array_indexed_two_at_a_time.c
```

so each loop iteration processes two elements. You may assume `n` is even.

For example, the loop structure could be:

```c
for (int i = 0; i < n; i += 2) {
    sum += a[i];
    sum += a[i + 1];
}
```

Before compiling, answer the prediction questions in `answers.md`.

### Submit your prediction in `answers.md`

**1. Do you predict the static instruction count will increase or decrease? Why?**

**2. Do you predict the number of loop iterations will increase or decrease?**

**3. Do you predict the dynamic instruction count will increase or decrease? Why?**

Compile the modified file:

```bash
311-compile -O0 starter/array_indexed_two_at_a_time.c
311-compile -O2 starter/array_indexed_two_at_a_time.c
```

Now your original and modified generated assembly remain separate:

```text
build/array_indexed_O0.s
build/array_indexed_O2.s

build/array_indexed_two_at_a_time_O0.s
build/array_indexed_two_at_a_time_O2.s
```

Compare them directly.

### Submit in `answers.md`

**4. Did the static instruction count increase or decrease?**

**5. Did the number of loop iterations increase or decrease?**

**6. Did your estimated dynamic instruction count increase or decrease? Show your reasoning.**

**7. Why can static and dynamic instruction counts move in different directions?**

**8. Did the optimizer preserve your source-level transformation, or did it generate something different?**

You will submit `starter/array_indexed_two_at_a_time.c`, but you do **not**
need to submit the generated files in `build/`. Paste any assembly excerpts
you use as evidence into `answers.md`.

---

# Part 7: Performance Claims and Compiler Optimization

Compare:

```text
starter/mul8.c
starter/shift8.c
```

Suppose someone makes the following claim:

> "The shift version is faster because bit shifting is always cheaper than multiplication."

### Submit your prediction in `answers.md`

**1. Before compiling, predict what assembly each version will produce.**

Then compile both:

```bash
311-compile -O0 starter/mul8.c
311-compile -O0 starter/shift8.c

311-compile -O2 starter/mul8.c
311-compile -O2 starter/shift8.c
```

### Submit in `answers.md`

**2. Are the generated instructions different at `-O0`? What evidence do you see?**

**3. Are they different at `-O2`? What evidence do you see?**

**4. Does the evidence support the claim that manually replacing multiplication by 8 with a shift necessarily improves performance? Explain.**

**5. What role does the compiler play in evaluating source-level optimization advice?**

---

# Part 8: Final Reflection

Answer each question in 2–4 sentences in `answers.md`.

**1. What was the most surprising difference between the C code and the generated RISC-V?**

**2. Why is dynamic instruction count often more informative than static instruction count?**

**3. Why might fewer instructions still not guarantee a proportionally faster program?**

**4. Looking across Parts 2–7, what did compiler optimization change most dramatically? Support your answer with examples from at least two earlier parts.**

**5. If someone claims that one C implementation is "faster," what evidence would you now want before accepting that claim?**

---

# Submission

Before submitting, run:

```bash
311-submit-check
```

Commit and push exactly these student-created/modified deliverables:

```text
answers.md
starter/part1.s
starter/array_indexed_two_at_a_time.c
```

Your completed `answers.md` should contain:

- all predictions,
- all instruction-count tables,
- short annotated assembly excerpts where requested,
- answers to all written questions,
- and the final reflection.

You do **not** need to submit generated `.s`, `.o`, or `.dump` files from
`build/`.

---

# Grading Breakdown

| Component | Percentage |
|---|---:|
| Part 1: Hand-written C → RISC-V | 15% |
| Part 2–3: Prediction and compiler investigation | 20% |
| Part 4: Static vs. dynamic instruction count | 15% |
| Part 5: Indexed vs. pointer comparison | 20% |
| Part 6: Modification experiment | 15% |
| Part 7: Performance claim investigation | 5% |
| Part 8: Final reflection | 10% |
| **Total** | **100%** |

---

## One Important Reminder

The goal of this lab is not to memorize compiler behavior.

The goal is to practice this workflow:

> **Predict → Compile → Inspect → Count → Compare → Explain**

For now, we are using executed instruction count as a simple measure of machine
work. Later in the course, we will see why two programs executing the same
number of instructions can still take different amounts of time.
