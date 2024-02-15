; a project for me to learn about multithreading in assembly

%include "../library64.asm"

section .data
    hello0 db "Hello from thread 0", 0
    hello1 db "Hello from thread 1", 0
    
    thread_stack_size equ 4096

section .bss
    thread1_stack resb thread_stack_size

section .text

global _start
_start:
    ; create child stack space
    mov rax, 9 ; mmap syscall num
    mov rdi, 0 ; address (Kernel should choose location)
    mov rsi, thread_stack_size; child stack size (bytes)
    mov rdx, 7 ; BITWISE OR(PROT_READ [4] | PROT_WRITE [2] | MAP_ANONYMOUS [1])
    mov r10, -1 ; fd (ignored)
    ; mov r8, 0 ; offset (ignored)
    syscall

    ; create separate thread
    mov rax, 56         ; clone syscall number
    mov rdi, child_fn   ; pointer to child function
    ; mov rsi      ; child stack pointer
    mov rdx, 0x11       ; CLONE_VM | CLONE_FS | CLONE_FILES
    mov r10, 0          ; argument for child function
    syscall

    ; Parent process continues here
    mov rcx, 5
    parent_loop:
        WRITE_BUFFER hello0
        NL
        loop parent_loop

    EXIT 0 ; Exit the program
    ; =============== END OF PARENT PROCESS ===========

child_fn: ; Child process continues here
    mov rcx, 5
    child_loop:
        WRITE_BUFFER hello1
        NL
        loop child_loop

    EXIT 0 ; Exit the child process
    ; =============== END OF CHILD PROCESS ============