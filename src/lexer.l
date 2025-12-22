%{
#include "parser.tab.h"
#include <stdio.h>

int line_no = 1;
%}

%%

[ \t\r]+                 ;
\n                        { line_no++; }

"var"                     { return VAR; }
"if"                      { return IF; }
"else"                    { return ELSE; }
"while"                   { return WHILE; }

"=="                      { return EQ; }
"!="                      { return NEQ; }
"<="                      { return LE; }
">="                      { return GE; }
"<"                       { return LT; }
">"                       { return GT; }

"+"                       { return PLUS; }
"-"                       { return MINUS; }
"*"                       { return STAR; }
"/"                       { return SLASH; }
"="                       { return ASSIGN; }

"("                       { return LPAREN; }
")"                       { return RPAREN; }
"{"                       { return LBRACE; }
"}"                       { return RBRACE; }
";"                       { return SEMICOLON; }

[0-9]+                    { return INTEGER; }
[a-zA-Z_][a-zA-Z0-9_]*    { return IDENTIFIER; }

. {
    fprintf(stderr,
            "Lexer error at line %d: invalid character '%s'\n",
            line_no, yytext);
}

%%

int yywrap(void) {
    return 1;
}
