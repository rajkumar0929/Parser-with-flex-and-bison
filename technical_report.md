# Technical Report – Parser with Flex and Bison

## 1. Introduction
This report describes the design and implementation of a compiler front-end consisting of a **lexer**, **parser**, **Abstract Syntax Tree (AST)** construction, and **basic semantic analysis**. The implementation is carried out using **Flex** for lexical analysis and **Bison** for syntax analysis, with supporting C modules for AST handling and symbol table management.

The goal of the project is to correctly recognize programs written in the designed language, construct a structured representation of the program, and detect syntactic and selected semantic errors in a clear and deterministic manner.

---

## 2. Description of the Designed Language
The designed language is a small, statically-typed, imperative programming language inspired by C-like syntax. It supports:

- Variable declarations with basic data types
- Assignment statements
- Arithmetic and relational expressions
- Block structures using braces
- Sequential execution of statements

### Key Characteristics
- **Explicit declarations**: Variables must be declared before use.
- **Statement-based execution**: Programs are composed of a sequence of statements.
- **Block scoping**: Variables declared within a block are local to that block.
- **Expression-oriented syntax**: Arithmetic and logical expressions follow standard infix notation.

The language is intentionally minimal to emphasize correct parsing, AST construction, and semantic validation rather than advanced language features.

---

## 3. Lexer Rules and Tokenization Strategy
Lexical analysis is implemented using **Flex**, which converts the input source code into a stream of tokens consumed by the parser.

### Token Categories
The lexer recognizes the following major categories of tokens:

- **Keywords**: Reserved words such as type specifiers and control-related terms
- **Identifiers**: User-defined variable names
- **Literals**: Numeric constants
- **Operators**: Arithmetic (`+`, `-`, `*`, `/`) and relational operators
- **Delimiters**: Parentheses, braces, commas, and semicolons

### Tokenization Strategy
- Longest-match and rule-priority mechanisms of Flex are used to disambiguate tokens.
- Identifiers are distinguished from keywords by matching keywords explicitly before the identifier rule.
- Whitespace and comments are ignored but used to track line numbers for error reporting.
- Invalid or unrecognized characters immediately trigger a lexical error.

This approach ensures a clean separation between lexical and syntactic responsibilities.

---

## 4. Grammar Design and Operator Precedence
The grammar is specified using **Bison** and is designed to be **LALR(1)** compliant.

### Grammar Design Principles
- Clear separation between declarations, statements, and expressions
- Elimination of left recursion where required
- Use of precedence and associativity rules to resolve ambiguity

### Operator Precedence and Associativity
Operator precedence is explicitly declared to enforce correct expression evaluation:

- Highest precedence: parentheses
- Multiplicative operators (`*`, `/`)
- Additive operators (`+`, `-`)
- Relational operators
- Assignment operator (lowest precedence)

Left associativity is used for most binary operators, while assignment is treated as right associative where applicable.

This design prevents shift-reduce conflicts and produces predictable parse trees.

---

## 5. AST Structure and Construction
The **Abstract Syntax Tree (AST)** represents the hierarchical syntactic structure of the program in a condensed form, omitting unnecessary grammar details.

### AST Node Design
Each AST node typically contains:
- Node type (e.g., declaration, assignment, expression)
- Pointers to child nodes
- Optional value fields (identifier name, literal value, operator type)

### AST Construction Strategy
- AST nodes are created during parsing using semantic actions in Bison.
- Each grammar rule responsible for a syntactic construct builds and returns the corresponding AST node.
- Child nodes are linked bottom-up as reductions occur.

The resulting AST serves as the foundation for semantic analysis and potential future compiler phases.

---

## 6. Error Handling Strategy
The system implements structured error handling at multiple levels.

### Lexical Errors
- Unrecognized characters are reported with line numbers.
- Lexical analysis terminates immediately upon encountering an invalid token.

### Syntax Errors
- Bison’s error reporting mechanism is used to detect grammar violations.
- Parsing stops on the first critical syntax error to avoid cascading errors.

### Semantic Errors
Semantic analysis is primarily enforced through the symbol table:

- Use of variables before declaration
- Redeclaration of identifiers in the same scope
- Invalid assignments or malformed expressions

Errors are reported with descriptive messages to help identify the exact cause and location.

---

## 7. Limitations and Possible Extensions

### Current Limitations
- Limited data types and language constructs
- No support for functions or parameter passing
- Error recovery is minimal and stops at the first major error
- No intermediate code generation or optimization

---

## 8. Conclusion
This project demonstrates a complete and well-structured compiler front-end, covering lexical analysis, parsing, AST construction, and basic semantic checks. The modular design ensures clarity, correctness, and extensibility, making it a strong foundation for further compiler development.

