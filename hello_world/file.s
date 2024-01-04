.global _start
.intel_syntax noprefix

// use sys-table to do things (look this up)
_start:
    // sys_write
    mov rax, 1
    mov rdi, 1
    lea rsi, [hello_world]
    mov rdx, 14
    syscall

    // sys_exit
    mov rax, 60
    mov rdi, 0
    syscall

hello_world:
    .asciz "Hello, World!\n"
