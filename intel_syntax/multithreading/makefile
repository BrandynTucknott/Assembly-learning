mt: multhread.asm
	nasm multhread.asm -g -f elf64
	ld multhread.o -g -o mt
	./mt

test: test.asm
	nasm test.asm -g -f elf64
	ld test.o -g -o test
	./test

clean:
	rm *.o mt