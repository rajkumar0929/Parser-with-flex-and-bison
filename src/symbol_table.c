#include "symbol_table.h"
#include <stdlib.h>
#include <string.h>

static Symbol *head = NULL;

void symtab_init(void) {
    head = NULL;
}

int symtab_is_declared(const char *name) {
    for (Symbol *s = head; s != NULL; s = s->next) {
        if (strcmp(s->name, name) == 0)
            return 1;
    }
    return 0;
}

void symtab_declare(const char *name) {
    Symbol *s = malloc(sizeof(Symbol));
    s->name = strdup(name);
    s->next = head;
    head = s;
}
