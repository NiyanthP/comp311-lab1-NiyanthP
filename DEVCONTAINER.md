# Dev Container Quick Start

A Dev Container gives you a pre-configured programming environment inside
VS Code. The RISC-V compiler and COMP 311 scripts run inside the container
rather than being installed directly on your laptop.

## What you need

Install:

1. Docker Desktop
2. Visual Studio Code
3. The VS Code **Dev Containers** extension

## Open the container

1. Clone/download your assignment repository.
2. Open the repository folder in VS Code.
3. Press `Cmd + Shift + P` on macOS or `Ctrl + Shift + P` on Windows.
4. Select **Dev Containers: Reopen in Container**.
5. Wait for the first build to finish.
6. Open a new VS Code terminal and run:

```bash
311-check
```

You should see:

```text
Success: generated RV32I assembly.
```

## How do I know I am inside the container?

Run:

```bash
whoami
```

It will normally print:

```text
vscode
```

If `311-check` or `riscv64-unknown-elf-gcc` is not found, you are probably
using your host computer's terminal instead of the terminal inside the Dev
Container.

## If the container needs to be rebuilt

Open the Command Palette and select:

```text
Dev Containers: Rebuild Container
```

## Compiling C to RISC-V

Optimization off:

```bash
311-compile -O0 starter/scale_add.c
```

Optimization on:

```bash
311-compile -O2 starter/scale_add.c
```

Remember:

```text
-O0 = capital O + zero
-O2 = capital O + two
```

Generated files appear in `build/`, for example:

```text
build/scale_add_O0.s
build/scale_add_O0.o
build/scale_add_O0.dump
```

The `.s` file contains compiler-generated RISC-V assembly.

## Assembling hand-written RISC-V

```bash
311-assemble starter/part1.s
```

The resulting object file and disassembly appear in `build/`.

## Checking your submission

Before pushing your final work, run:

```bash
311-submit-check
```

It checks that the required files exist and warns about obvious unanswered
template placeholders.

## If something goes wrong

If you get `command not found`, first make sure VS Code is actually reopened
inside the Dev Container.

If needed:

```text
Cmd/Ctrl + Shift + P
Dev Containers: Rebuild Container
```

The main rule to remember is:

> Run the COMP 311 commands from the VS Code terminal **inside the Dev Container**.
