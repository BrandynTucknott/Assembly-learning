; a project for me to learn about multithreading in assembly

%include "../library64.asm"

section .data
    hello0 db "Hello from thread 0", 0
    hello1 db "Hello from thread 1", 0
    
    thread_stack_size equ 4096

section .bss
    thread1_stack resb thread_stack_size
    stack_ptr resd 1

section .text

global _start
_start:
    ; create child stack space
    mov rax, 9 ; mmap syscall num
    mov rdi, 0 ; address (Kernel should choose location)
    mov rsi, thread_stack_size; child stack size (bytes)
    mov rdx, 3 ; protection flags (e.g., PROT_READ[0x01] | PROT_WRITE[0x02])
    mov r10, 0x22 ; flags (e.g., MAP_ANONYMOUS[0x20] | MAP_PRIVATE[0x02])
    mov r8, -1 ; file descriptor (ignored for anonymous mappings)
    mov r9, 0 ; offset (ignored for anonymoys mapping)
    syscall

    ; address of freed memory returned in rax
    mov [stack_ptr], rax

    ; move ptr to start of stack
    mov rax, thread_stack_size - 1
    add [stack_ptr], rax

    ; create separate thread
    mov rax, 56         ; clone syscall number
    mov rdi, child_fn   ; pointer to child function
    mov rsi, [stack_ptr]      ; child stack pointer
    mov rdx, 0x11       ; CLONE_VM | CLONE_FS | CLONE_FILES
    mov r10, 0          ; argument for child function
    syscall

    ; Parent process continues here
    WRITE_BUFFER hello0
    NL

    EXIT 0 ; Exit the program
    ; =============== END OF PARENT PROCESS ===========

child_fn: ; Child process continues here
    WRITE_BUFFER hello1
    NL

    EXIT 0 ; Exit the child process
    ; =============== END OF CHILD PROCESS ============