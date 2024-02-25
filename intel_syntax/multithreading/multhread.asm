; a project for me to learn about multithreading in assembly

%include "../library64.asm"

section .data
    hello0 db "Hello from thread 0", 0
    hello1 db "Hello from thread 1", 0
    
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
    mov rax, 56         ; clone syscall number
    mov rdi, child_fn   ; pointer to child function
    mov rsi, rax      ; child stack pointer
    mov rdx, 0xf00       ; CLONE_VM[0x100] | CLONE_THREAD[0x800] | CLONE_FS[0x200] | CLONE_FILES[0x400]
    mov r10, 0          ; argument for child function
    syscall

    ; Parent process continues here
    WRITE_BUFFER hello0
    NL

    EXIT 0
    ; EXIT 0 ; Exit the program

    child_fn: ; Child process continues here
        WRITE_BUFFER hello1
        NL

        EXIT 0 ; Exit the child process
    ; =============== END OF CHILD PROCESS ============
    ; =============== END OF PARENT PROCESS ===========