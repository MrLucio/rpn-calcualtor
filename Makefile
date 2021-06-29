CC = gcc -m32
NO_LINK = -c

all: bin/postfix
	./bin/postfix test/in_1.txt test/out_1.txt
	./bin/postfix test/in_2.txt test/out_2.txt
	./bin/postfix test/in_3.txt test/out_3.txt
	./bin/postfix test/in_4.txt test/out_4.txt
	./bin/postfix test/in_5.txt test/out_5.txt
	./bin/postfix test/in_6.txt test/out_6.txt

bin/postfix: obj/postfix.o obj/strcpy.o obj/itoa.o obj/main.o
	${CC} obj/postfix.o obj/strcpy.o obj/itoa.o obj/main.o -o bin/postfix

obj/postfix.o: src/postfix.s
	${CC} ${NO_LINK} src/postfix.s -o obj/postfix.o

obj/strcpy.o: src/strcpy.s
	${CC} ${NO_LINK} src/strcpy.s -o obj/strcpy.o

obj/itoa.o: src/itoa.s
	${CC} ${NO_LINK} src/itoa.s -o obj/itoa.o

obj/main.o: src/main.c
	${CC} ${NO_LINK} src/main.c -o obj/main.o

clean:
	rm -f obj/*
