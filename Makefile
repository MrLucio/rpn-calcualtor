all:
	gcc -m32 -gstabs -c src/input.s -o obj/input.o
	gcc -m32 -gstabs -c src/strcpy.s -o obj/strcpy.o
	gcc -m32 -gstabs -c src/itoa.s -o obj/itoa.o
	gcc -m32 -gstabs -c src/main.c -o obj/main.o
	gcc -m32 -gstabs obj/input.o obj/strcpy.o obj/itoa.o obj/main.o -o bin/a.out
	./bin/a.out test/in_3.txt test/out_3.txt
