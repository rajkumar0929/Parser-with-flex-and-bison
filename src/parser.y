%{
#include <stdio.h>
#include "ast.h"

int yylex(void);
int yyerror(const char *s);

extern int line_no;
extern char *yytext;

ASTNode *root;

int suppress_yyerror = 0;
%}

%code requires {
    #include "ast.h"
}

%union {
    ASTNode *node;
    char *str;
    int ival;
}

/* Tokens */
%token VAR IF ELSE WHILE
%token <str> IDENTIFIER
%token <ival> INTEGER

%token PLUS MINUS STAR SLASH
%token ASSIGN
%token EQ NEQ LT GT LE GE

%token LPAREN RPAREN
%token LBRACE RBRACE
%token SEMICOLON

%type <node> program statement_list statement
%type <node> variable_decl assignment block
%type <node> if_statement while_statement
%type <node> expression comparison arithmetic term factor

%%

program
    : statement_list {
        root = ast_new_node(AST_PROGRAM);
        root->left = $1;
      }
    | error {
        /* Missing semicolon before a new statement */
        if (yytext && (*yytext == '_' ||
            (*yytext >= 'a' && *yytext <= 'z') ||
            (*yytext >= 'A' && *yytext <= 'Z'))) {

            fprintf(stderr,
                "Syntax error at line %d: missing ';'\n",
                line_no - 1);
        }
        /* EOF case */
        else if (yytext == NULL || *yytext == '\0') {
            fprintf(stderr,
                "Syntax error at line %d: missing ';'\n",
                line_no > 1 ? line_no - 1 : line_no);
        }
        /* Genuine unexpected token */
        else {
            fprintf(stderr,
                "Syntax error at line %d: unexpected token '%s'\n",
                line_no, yytext);
        }
        YYABORT;
      }
    ;




statement_list
    : statement_list statement {
        if ($1 == NULL) {
            $$ = $2;
        } else {
            ASTNode *t = $1;
            while (t->next)
                t = t->next;
            t->next = $2;
            $$ = $1;
        }
      }
    | /* empty */ { $$ = NULL; }
    ;


statement
    : variable_decl
    | assignment
    | if_statement
    | while_statement
    | block
    ;

block
    : LBRACE statement_list RBRACE {
        ASTNode *n = ast_new_node(AST_BLOCK);
        n->left = $2;
        $$ = n;
      }
    | LBRACE statement_list error {
        fprintf(stderr,
            "Syntax error at line %d: missing '}'\n",
            line_no);
        YYABORT;
      }
    ;


variable_decl
    : VAR IDENTIFIER SEMICOLON {
        ASTNode *n = ast_new_node(AST_VAR_DECL);
        n->name = $2;
        $$ = n;
      }
    | VAR IDENTIFIER ASSIGN expression SEMICOLON {
        ASTNode *n = ast_new_node(AST_VAR_DECL);
        n->name = $2;
        n->left = $4;
        $$ = n;
      }
    ;

assignment
    : IDENTIFIER ASSIGN expression SEMICOLON {
        ASTNode *n = ast_new_node(AST_ASSIGN);
        n->name = $1;
        n->left = $3;
        $$ = n;
      }
    ;

if_statement
    : IF LPAREN expression RPAREN statement {
        ASTNode *n = ast_new_node(AST_IF);
        n->left = $3;
        n->right = $5;
        $$ = n;
      }
    | IF LPAREN expression RPAREN statement ELSE statement {
        ASTNode *n = ast_new_node(AST_IF);
        n->left = $3;
        n->right = $5;
        n->third = $7;
        $$ = n;
      }
    ;

while_statement
    : WHILE LPAREN expression RPAREN statement {
        ASTNode *n = ast_new_node(AST_WHILE);
        n->left = $3;
        n->right = $5;
        $$ = n;
      }
    ;

expression
    : comparison { $$ = $1; }
    ;

comparison
    : arithmetic
    | comparison LT arithmetic  { $$ = ast_new_binop('<', $1, $3); }
    | comparison GT arithmetic  { $$ = ast_new_binop('>', $1, $3); }
    | comparison LE arithmetic  { $$ = ast_new_binop('L', $1, $3); }
    | comparison GE arithmetic  { $$ = ast_new_binop('G', $1, $3); }
    | comparison EQ arithmetic  { $$ = ast_new_binop('E', $1, $3); }
    | comparison NEQ arithmetic { $$ = ast_new_binop('N', $1, $3); }
    ;

arithmetic
    : term
    | arithmetic PLUS term  { $$ = ast_new_binop('+', $1, $3); }
    | arithmetic MINUS term { $$ = ast_new_binop('-', $1, $3); }
    ;

term
    : factor
    | term STAR factor  { $$ = ast_new_binop('*', $1, $3); }
    | term SLASH factor { $$ = ast_new_binop('/', $1, $3); }
    ;

factor
    : INTEGER        { $$ = ast_new_int($1); }
    | IDENTIFIER     { $$ = ast_new_id($1); }
    | LPAREN expression RPAREN { $$ = $2; }
    ;

%%

int yyerror(const char *s) {
    return 0;
}



