mt: multhread.asm
	nasm multhread.asm -g -f elf64
	ld multhread.o -g -o mt
	./mt

cmt: multhread.c
	g++ -g multhread.c -o cmt
	./cmt

clean:
	rm *.o mt cmt