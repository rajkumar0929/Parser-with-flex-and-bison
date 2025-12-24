#include "ast.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol_table.h"

static void indent(int n) {
    for (int i = 0; i < n; i++) {
        printf("  ");
    }
}

ASTNode *ast_new_node(ASTNodeType type) {
    ASTNode *n = malloc(sizeof(ASTNode));
    n->type = type;
    n->name = NULL;
    n->value = 0;
    n->op = 0;
    n->left = n->right = n->third = n->next = NULL;
    return n;
}

ASTNode *ast_new_int(int value) {
    ASTNode *n = ast_new_node(AST_INTEGER);
    n->value = value;
    return n;
}

ASTNode *ast_new_id(char *name) {
    ASTNode *n = ast_new_node(AST_IDENTIFIER);
    n->name = strdup(name);
    return n;
}

ASTNode *ast_new_binop(char op, ASTNode *left, ASTNode *right) {
    ASTNode *n = ast_new_node(AST_BINOP);
    n->op = op;
    n->left = left;
    n->right = right;
    return n;
}

void ast_print(ASTNode *node, int indent_level) {
    if (!node) return;

    indent(indent_level);

    switch (node->type) {
    case AST_PROGRAM: {
        printf("PROGRAM\n");
        ASTNode *s = node->left;
        while (s) {
            ast_print(s, indent_level + 1);
            s = s->next;
        }
        break;
    }

    case AST_VAR_DECL:
        printf("VAR_DECL %s\n", node->name);
        ast_print(node->left, indent_level + 1);
        break;

    case AST_ASSIGN:
        printf("ASSIGN %s\n", node->name);
        ast_print(node->left, indent_level + 1);
        break;

    case AST_IF:
        printf("IF\n");
        ast_print(node->left, indent_level + 1);   // condition
        ast_print(node->right, indent_level + 1);  // then
        ast_print(node->third, indent_level + 1);  // else
        break;

    case AST_WHILE:
        printf("WHILE\n");
        ast_print(node->left, indent_level + 1);
        ast_print(node->right, indent_level + 1);
        break;

    case AST_BLOCK: {
        printf("BLOCK\n");
        ASTNode *s = node->left;
        while (s) {
            ast_print(s, indent_level + 1);
            s = s->next;
        }
        break;
    }

    case AST_BINOP:
        printf("BINOP %c\n", node->op);
        ast_print(node->left, indent_level + 1);
        ast_print(node->right, indent_level + 1);
        break;

    case AST_IDENTIFIER:
        printf("IDENT %s\n", node->name);
        break;

    case AST_INTEGER:
        printf("INT %d\n", node->value);
        break;

    case AST_STATEMENT_LIST:
    /* no-op: statements are handled via linked list */
    break;

    }
}

void ast_check_semantics(ASTNode *node) {
    if (!node) return;

    switch (node->type) {

    case AST_PROGRAM: {
        symtab_init();
        ASTNode *s = node->left;
        while (s) {
            ast_check_semantics(s);
            s = s->next;
        }
        break;
    }

    case AST_STATEMENT_LIST:
        ast_check_semantics(node->left);
        ast_check_semantics(node->next);
        break;

    case AST_VAR_DECL:
        if (symtab_is_declared(node->name)) {
            fprintf(stderr,
                "Semantic error: redeclaration of variable '%s'\n",
                node->name);
            exit(1);
        }
        symtab_declare(node->name);
        ast_check_semantics(node->left);  // initializer
        break;

    case AST_ASSIGN:
        if (!symtab_is_declared(node->name)) {
            fprintf(stderr,
                "Semantic error: variable '%s' used before declaration\n",
                node->name);
            exit(1);
        }
        ast_check_semantics(node->left);
        break;

    case AST_IDENTIFIER:
        if (!symtab_is_declared(node->name)) {
            fprintf(stderr,
                "Semantic error: variable '%s' used before declaration\n",
                node->name);
            exit(1);
        }
        break;

    case AST_BINOP:
        ast_check_semantics(node->left);
        ast_check_semantics(node->right);
        break;

    case AST_IF:
        ast_check_semantics(node->left);
        ast_check_semantics(node->right);
        ast_check_semantics(node->third);
        break;

    case AST_WHILE:
        ast_check_semantics(node->left);
        ast_check_semantics(node->right);
        break;

    case AST_BLOCK: {
        ASTNode *s = node->left;
        while (s) {
            ast_check_semantics(s);
            s = s->next;
        }
        break;
    }

    case AST_INTEGER:
        break;
    }
}