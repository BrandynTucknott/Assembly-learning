d1_ex: d1.asm d1_ex1.txt
	nasm d1.asm -f elf64 -O2
	ld d1.o -o d1
	./d1 d1_ex1.txt

d1_test: d1.asm d1_test.txt
	nasm d1.asm -f elf64 -O2
	ld d1.o -o d1
	./d1 d1_test.txt

clean: d1.asm
	find -maxdepth 1 -type f -executable ! -name "*.asm" ! -name "*.txt" ! -name "makefile" | xargs rm