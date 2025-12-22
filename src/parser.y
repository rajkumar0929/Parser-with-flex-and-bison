%{
#include <stdio.h>

int yylex(void);
int yyerror(const char *s);
%}

/* ---------- Tokens ---------- */
%token VAR IF ELSE WHILE
%token IDENTIFIER INTEGER

%token PLUS MINUS STAR SLASH
%token ASSIGN

%token EQ NEQ LT GT LE GE

%token LPAREN RPAREN
%token LBRACE RBRACE
%token SEMICOLON

%%

program
    : statement_list
    ;

statement_list
    : statement_list statement
    | /* empty */
    ;

statement
    : variable_decl
    | assignment
    | if_statement
    | while_statement
    | block
    ;

block
    : LBRACE statement_list RBRACE
    ;

variable_decl
    : VAR IDENTIFIER SEMICOLON
    | VAR IDENTIFIER ASSIGN expression SEMICOLON
    ;

assignment
    : IDENTIFIER ASSIGN expression SEMICOLON
    ;

if_statement
    : IF LPAREN expression RPAREN statement
    | IF LPAREN expression RPAREN statement ELSE statement
    ;

while_statement
    : WHILE LPAREN expression RPAREN statement
    ;

/* ---------- Expressions ---------- */

expression
    : comparison
    ;

comparison
    : arithmetic
    | comparison EQ arithmetic
    | comparison NEQ arithmetic
    | comparison LT arithmetic
    | comparison GT arithmetic
    | comparison LE arithmetic
    | comparison GE arithmetic
    ;

arithmetic
    : term
    | arithmetic PLUS term
    | arithmetic MINUS term
    ;

term
    : factor
    | term STAR factor
    | term SLASH factor
    ;

factor
    : INTEGER
    | IDENTIFIER
    | LPAREN expression RPAREN
    ;

%%

int yyerror(const char *s) {
    fprintf(stderr, "Parse error: %s\n", s);
    return 0;
}
