# COMP 311: What Does the Machine Actually Do?

In this lab, you will investigate how C programs are translated into RISC-V
and how different implementations affect the amount of work performed by the
machine.

You will:

- write a small amount of RV32I assembly by hand,
- compile C programs to RV32I,
- compare compiler output at different optimization levels,
- inspect generated assembly,
- distinguish static and dynamic instruction count,
- and use machine-level evidence to evaluate performance claims.

## Getting Started

### 1. Open this repository in VS Code

Clone your repository and open the repository folder in Visual Studio
Code.

### 2. Reopen the project in the Dev Container

Open the Command Palette:

```text
Mac:     Cmd + Shift + P
Windows: Ctrl + Shift + P
```

Choose:

```text
Dev Containers: Reopen in Container
```

The first build may take a few minutes.

### 3. Check your environment

Open a terminal **inside VS Code** and run:

```bash
311-check
```

You should see:

```text
Success: generated RV32I assembly.
```

If you see `command not found`, make sure you are using the terminal inside
the Dev Container rather than your normal system terminal.

For more setup help, see `DEVCONTAINER.md`.

## Expected Starting Files

Your repository should begin with this structure:

```text
.
├── README.md
├── LAB.md
├── DEVCONTAINER.md
├── answers.md
├── starter/
│   ├── part1.s
│   ├── scale_add.c
│   ├── scale_shift.c
│   ├── array_indexed.c
│   ├── array_pointer.c
│   ├── mul8.c
│   └── shift8.c
├── scripts/
│   ├── 311-check
│   ├── 311-compile
│   ├── 311-assemble
│   └── 311-submit-check
└── build/
```

Files produced by the compiler will appear in `build/`.

## Important Files

- `LAB.md` — full lab instructions
- `answers.md` — **write all submitted written answers here**
- `starter/` — C and assembly programs used in the lab
- `DEVCONTAINER.md` — setup/troubleshooting help
- `build/` — generated assembly, object files, and disassembly

You should not normally edit files in `build/`.

## A Note About `-O0` and `-O2`

The optimization flag begins with a **capital letter O**, not the number zero:

```text
-O0 = capital O followed by zero → optimization off
-O2 = capital O followed by two  → optimization on
```

## Useful Commands

Compile C to RV32I with optimization off:

```bash
311-compile -O0 starter/scale_add.c
```

Compile the same program with optimization on:

```bash
311-compile -O2 starter/scale_add.c
```

Assemble hand-written RV32I:

```bash
311-assemble starter/part1.s
```

Generated assembly and disassembly will appear in `build/`.

## Target ISA

This environment targets:

```text
ISA: RV32I
ABI: ILP32
```

The compiler executable is named `riscv64-unknown-elf-gcc`, but the course
scripts explicitly use:

```text
-march=rv32i
-mabi=ilp32
```

so the generated code is 32-bit RISC-V using the base integer ISA.

## What You Will Submit

Commit and push these files:

```text
answers.md
starter/part1.s
starter/array_indexed_two_at_a_time.c
```

Your `answers.md` file includes the requested tables, explanations, and short
annotated assembly excerpts.

You do **not** need to commit generated files in `build/`, including `.s`, `.o`,
or `.dump` files.

Before submitting, run:

```bash
311-submit-check
```

This checks that the required submission files exist and warns you if obvious
template placeholders are still present.

## The Main Idea

Throughout the lab, use this workflow:

> **Predict → Compile → Inspect → Count → Compare → Explain**

The goal is not to memorize compiler behavior. The goal is to understand how
source code becomes machine instructions and how we can use those instructions
to reason about the work the machine performs.

For now, we will use instruction count as a simple measure of machine work.
Later in the course, we will see why programs with similar instruction counts
can still take different amounts of time to execute.
