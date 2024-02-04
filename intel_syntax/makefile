library: library32.asm
	nasm library32.asm -g -f elf
	ld library32.o -g -m elf_i386 -o lib

testlib: testLib32.asm
	nasm testLib32.asm -g -f elf
	ld testLib32.asm -g -m elf_i386 -o tlib

clean:
	rm *.o lib tlib