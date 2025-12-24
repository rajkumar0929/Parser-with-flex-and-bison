#ifndef AST_H
#define AST_H

typedef enum {
    AST_PROGRAM,
    AST_STATEMENT_LIST,

    AST_VAR_DECL,
    AST_ASSIGN,

    AST_IF,
    AST_WHILE,
    AST_BLOCK,

    AST_BINOP,
    AST_IDENTIFIER,
    AST_INTEGER
} ASTNodeType;

typedef struct ASTNode {
    ASTNodeType type;

    /* Common fields */
    char *name;          // for identifiers
    int value;           // for integers
    char op;             // for binary operators

    struct ASTNode *left;
    struct ASTNode *right;
    struct ASTNode *third;   // used for if-else

    struct ASTNode *next;    // for statement lists
} ASTNode;

/* Constructors */
ASTNode *ast_new_node(ASTNodeType type);
ASTNode *ast_new_int(int value);
ASTNode *ast_new_id(char *name);
ASTNode *ast_new_binop(char op, ASTNode *left, ASTNode *right);

/* Utility */
void ast_print(ASTNode *node, int indent);
void ast_check_semantics(ASTNode *node);


#endif
