# lib32: library32.asm
# 	nasm library32.asm -g -f elf
# 	ld library32.o -g -m elf_i386 -o lib32

tlib32: testLib32.asm library32.asm
	nasm testLib32.asm -g -f elf
	ld testLib32.o -g -m elf_i386 -o tlib32

clean:
	rm *.o tlib32