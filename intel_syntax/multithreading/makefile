multhread: multhread.asm
	nasm multhread.asm -g -f elf
	ld multhread.o -g -m elf_i386 -o mt
	./mt

clean:
	rm *.o multhread