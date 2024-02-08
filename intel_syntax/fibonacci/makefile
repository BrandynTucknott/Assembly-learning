fib: fib.asm ../library32.asm
	nasm -g -f elf fib.asm
	ld -g fib.o -m elf_i386 -o fib

clean:
	rm *.o fib