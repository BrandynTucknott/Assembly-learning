; a project for me to learn about multithreading in assembly

%include "../library64.asm"

section .data
    hello0 db "Hello from thread 0", 0
    hello1 db "Hello from thread 1", 0

    t_error db "Something is not right", 0
    
    thread_stack_size equ 4096

section .bss
    thread1_stack resb thread_stack_size
    stack_ptr resq 1

section .text

global _start
_start:
    ; create child stack space
    mov rax, 9 ; mmap syscall num
    mov rdi, 0 ; address (Kernel should choose location)
    mov rsi, thread_stack_size; child stack size (bytes)
    mov rdx, 3 ; protection flags (e.g., PROT_READ[0x01] | PROT_WRITE[0x02])
    mov r10, 0x20022 ; flags (e.g., MAP_STACK[0x20000] | MAP_ANONYMOUS[0x20] | MAP_PRIVATE[0x02])
    mov r8, -1 ; file descriptor (ignored for anonymous mappings)
    mov r9, 0 ; offset (ignored for anonymoys mapping)
    syscall

    ; address of freed memory returned in rax
    add rax, thread_stack_size - 1

    ; create separate thread
    ; rax  -  syscall num ( clone )
    ; rdi  -  unsigned long clone flags
    ; rsi  -  unsigned long newsp
    ; rdx  -  void *parent TID
    ; r10  -  void *child TID
    ; r8   -  unsigned int TID (thread ptr?)
    mov rax, 56
    mov rdi, 0xb00 ; CLONE_VM[0x100] | CLONE_THREAD[0x800] | CLONE_FS[0x200] | //CLONE_FILES[0x400]//
    mov rsi, rax
    mov rdx, 0
    mov r10, 1
    mov r8, child_fn
    syscall

    test rax, rax
    jl thread_error

    ; Parent process continues here
    WRITE_BUFFER hello0
    NL

    EXIT 0
    ; =============== END OF PARENT PROCESS ===========

    thread_error:
        WRITE_BUFFER t_error
        NL

        EXIT 1


    child_fn: ; Child process continues here
        WRITE_BUFFER hello1
        NL

        EXIT 0 ; Exit the child process
    ; =============== END OF CHILD PROCESS ============