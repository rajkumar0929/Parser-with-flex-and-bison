# Lab 2B – Lexer and Parser Implementation

## Overview
This project implements a lexer and parser for the given grammar using **Flex** and **Bison**. The parser performs syntactic analysis and basic semantic checks, including symbol table management. The implementation is intended to be built and tested in a Linux environment.

---

## Build Instructions
Ensure the following tools are installed:
- `gcc`
- `flex`
- `bison`
- `make`

To build the parser, run:
```sh
make
```
This will generate the executable (typically named `parser`).

---

## How to Run the Parser
You can run the parser by providing an input program via standard input:
```sh
./parser < input.txt
```

---

## How to Run Tests
Test cases are organized into `tests/valid` and `tests/invalid` directories.

To run all valid test cases:
```sh
for f in tests/valid/*.txt; do
    echo "==> $f"
    ./parser < "$f"
done
```

To run all invalid test cases:
```sh
for f in tests/invalid/*.txt; do
    echo "==> $f"
    ./parser < "$f"
done
```

---

## Source Files
The `src/` directory contains the following key files:
- `lexer.l` – Flex specification for lexical analysis
- `parser.y` – Bison grammar and parsing rules
- `main.c` – Entry point for the parser
- `ast.c` / `ast.h` – Abstract Syntax Tree implementation
- `symbol_table.c` / `symbol_table.h` – Symbol table implementation used for semantic checks

---

## Assumptions and Deviations from the Sample Grammar
- Variable declarations must appear before use.
- Redeclaration of identifiers within the same scope is treated as an error.
- Basic semantic errors such as use-before-declaration and invalid assignments are detected.
- Error handling is designed to stop parsing on the first critical error, rather than attempting full recovery.

Any deviation from the sample grammar or additional semantic checks have been explicitly implemented to improve correctness and clarity of error reporting.

