d2_ex: d2.asm
	nasm d2.asm -g -f elf64
	ld d2.o -g -o d2
	./d2 d2_ex1.txt
	./d2 d2_ex2.txt

d2_test: d2.asm
	nasm d2.asm -g -f elf64
	ld d2.o -g -o d2
	./d2 d2_test.txt

d1_ex: d1.asm
	nasm d1.asm -g -f elf64
	ld d1.o -g -o d1
	./d1 d1_ex1.txt
	./d1 d1_ex2.txt
	./d1 d1_ex3.txt

d1_test: d1.asm
	nasm d1.asm -g -f elf64
	ld d1.o -g -o d1
	./d1 d1_test.txt

clean: d1.asm d2.asm
	find -maxdepth 1 -type f -executable ! -name "*.asm" ! -name "*.txt" ! -name "makefile" | xargs rm
