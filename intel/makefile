tlib64: testLib64.asm library64.asm
	nasm testLib64.asm -g -f elf64
	ld testLib64.o -g -o tlib64
	./tlib64

clean:
	rm *.o tlib64