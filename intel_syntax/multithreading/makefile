mt: multhread.asm
	nasm multhread.asm -g -f elf64
	ld multhread.o -g -o mt
	./mt

clean:
	rm *.o mt