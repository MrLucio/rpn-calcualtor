GCC = gcc -m32
NO_LINK = -c
DEBUG = -gstabs

all: obj/postfix.o obj/strcpy.o obj/itoa.o obj/main.o 	# Dipendenze definite in all, per una migliore comprensione
	${GCC} ${DEBUG} obj/postfix.o obj/strcpy.o obj/itoa.o obj/main.o -o bin/postfix
	./bin/postfix test/in_1.txt test/out_1.txt

obj/postfix.o: src/postfix.s
	${GCC} ${DEBUG} ${NO_LINK} src/postfix.s -o obj/postfix.o

obj/strcpy.o: src/strcpy.s
	${GCC} ${DEBUG} ${NO_LINK} src/strcpy.s -o obj/strcpy.o

obj/itoa.o: src/itoa.s
	${GCC} ${DEBUG} ${NO_LINK} src/itoa.s -o obj/itoa.o

obj/main.o: src/main.c
	${GCC} ${DEBUG} ${NO_LINK} src/main.c -o obj/main.o

clean:
	rm -f obj/*
