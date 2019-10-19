FILES = scanner.cpp parser.cpp
CC = g++

parser: $(FILES)
	$(CC) $(FILES) -o parser -lfl

scanner.cpp: scanner.l
	flex scanner.l

parser.cpp: parser.y
	bison -o parser.cpp -d parser.y

clean:
	rm scanner.cpp scanner.hpp parser.cpp parser.hpp
