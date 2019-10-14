FILES = lex.yy.c parser.tab.c
CC = gcc

parser: $(FILES)
	$(CC) $(FILES) -o parser -lfl

lex.yy.c: scanner.l
	flex scanner.l

parser.tab.c: parser.y
	bison -d parser.y

clean:
	rm lex.yy.c parser.tab.c parser.tab.h
