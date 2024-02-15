mt: multhread.asm
	nasm multhread.asm -g -f elf64
	ld multhread.o -g -o mt
	./mt

cmt: multhread.cpp
	g++ -g multhread.cpp -o cmt
	./cmt

clean:
	rm *.o mt cmt