rsa: rsa.asm
	nasm rsa.asm -g -f elf64
	ld rsa.o -g -o rsa
	./rsa

x: rsa
	./rsa

clean:
	rm *.o rsa