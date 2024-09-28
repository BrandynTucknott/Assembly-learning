tlib64: testLib64.asm library64.asm
	nasm testLib64.asm -g -f elf64
	ld testLib64.o -g -o tlib64
	./tlib64

x:
	./tlib64

test: test.asm library64.asm
	nasm test.asm -f elf64
	ld test.o -o test
	./test

clean:
	rm *.o tlib64 test