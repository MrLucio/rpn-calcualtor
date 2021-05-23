all:
	gcc -m32 -gstabs -c src/input.s -o obj/input.o
	gcc -m32 -gstabs -c src/main.c -o obj/main.o
	gcc -m32 -gstabs obj/input.o obj/main.o -o bin/a.out
	./bin/a.out test/in1.txt test/out1.txt
