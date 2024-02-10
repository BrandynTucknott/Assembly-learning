fib: fib.asm ../library64.asm
	nasm -g -f elf64 fib.asm
	ld -g fib.o -o fib
	./fib

clean:
	rm *.o fib