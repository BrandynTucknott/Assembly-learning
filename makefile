d1_ex: d1.asm
	nasm d1.asm -g -f elf64
	ld d1.o -g -o d1
	./d1 d1_ex1.txt

d1_test: d1.asm
	nasm d1.asm -g -f elf64
	ld d1.o -g -o d1
	./d1 d1_test.txt

clean: d1.asm
	rm *.o
	find -maxdepth 1 -type f -executable -delete ! -name "*.asm" ! -name "*.txt" ! -name "makefile"
