CC = gcc
CFLAGS = -Wall -g -Wno-unused-function

all: parser

parser: lex.yy.c parser.tab.c types.h
	$(CC) $(CFLAGS) -o parser lex.yy.c parser.tab.c -lfl

parser.tab.c parser.tab.h: parser.y types.h
	bison -d parser.y
	@touch parser.tab.c parser.tab.h

lex.yy.c: lexer.l parser.tab.h types.h
	flex lexer.l
	@touch lex.yy.c

clean:
	rm -f parser lex.yy.c parser.tab.c parser.tab.h

distclean: clean
	rm -f *~

.PHONY: all clean distclean
