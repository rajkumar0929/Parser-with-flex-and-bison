CC = gcc
CFLAGS = -Wall -Wextra -g

LEX = flex
YACC = bison

SRC = src
OBJ = parser.tab.o lex.yy.o src/main.o src/ast.o

all: parser

parser: $(OBJ)
	$(CC) $(CFLAGS) -o parser $(OBJ)

parser.tab.c parser.tab.h: $(SRC)/parser.y
	$(YACC) -d $(SRC)/parser.y

lex.yy.c: $(SRC)/lexer.l parser.tab.h
	$(LEX) $(SRC)/lexer.l

src/main.o: src/main.c
	$(CC) $(CFLAGS) -c src/main.c -o src/main.o

src/ast.o: src/ast.c src/ast.h
	$(CC) $(CFLAGS) -c src/ast.c -o src/ast.o

clean:
	rm -f parser *.o src/*.o lex.yy.c parser.tab.c parser.tab.h
