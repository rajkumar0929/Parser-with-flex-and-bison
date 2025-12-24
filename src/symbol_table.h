#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

typedef struct Symbol {
    char *name;
    struct Symbol *next;
} Symbol;

void symtab_init(void);
int symtab_is_declared(const char *name);
void symtab_declare(const char *name);

#endif
