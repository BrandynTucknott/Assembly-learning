; a project for me to learn about multithreading in assembly

%include "../library32.asm"

section .bss

section .data
    hello0 db "Hello from thread 0", 0
    hello1 db "Hello from thread 1", 0
    errorcode db "errorcode: ", 0

section .text

global _start
_start:
    ; create child stack space
    mov eax, 192 ; mmap2 syscall num
    mov ebx, 0 ; address (Kernel should choose location)
    mov ecx, 4096; child stack size (bytes)
    mov edx, 7 ; BITWISE OR(PROT_READ [4] | PROT_WRITE [2] | MAP_ANONYMOUS [1])
    mov esi, -1 ; fd (ignored)
    ; mov edi, 0 ; offset (ignored)
    int 0x80

    ; create separate thread
    mov eax, 120        ; clone syscall number
    mov ebx, child_fn   ; pointer to child function
    mov ecx, esi        ; child stack pointer
    mov edx, 0x11       ; CLONE_VM | CLONE_FS | CLONE_FILES
    mov esi, 0          ; argument for child function
    int 0x80

    ; Parent process continues here
    mov ecx, 5
    parent_loop:
        WRITE_BUFFER hello0
        NL
        loop parent_loop

    EXIT 0 ; Exit the program

child_fn: ; Child process continues here
    mov ecx, 5
    child_loop:
        WRITE_BUFFER hello1
        NL
        loop child_loop

    EXIT 0 ; Exit the child process