print: print.asm
	nasm -g -f elf print.asm
	ld -g -m elf_i386 print.o -o print

ptr: ptr.asm
	nasm -g -f elf ptr.asm
	ld -g -m elf_i386 ptr.o -o ptr

buffer: buffer.asm
	nasm -g -f elf buffer.asm
	ld -g -m elf_i386 buffer.o -o buffer

div: div.asm
	nasm -g -f elf div.asm
	ld -g -m elf_i386 div.o -o div

clear:
	rm *.o print ptr buffer div