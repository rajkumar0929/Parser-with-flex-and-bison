#include <stdio.h>
#include "ast.h"

int yyparse(void);
extern ASTNode *root;

int main(void) {
    if (yyparse() == 0 && root) {
        ast_check_semantics(root);
        ast_print(root, 0);
    }
    return 0;
}
