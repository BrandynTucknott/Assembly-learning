# to run this program (especially after making changes):
#   as file.s -o file.o
#   ld file.o -o file
#   ./file

.global _start

_start:
    # sys_write
    mov $1, %rax
    mov $1, %rdi
    lea [hello_world], %rsi
    mov $14, %rdx
    syscall

    # sys_exit
    mov $60, %rax
    mov $0, %rdi
    syscall

hello_world:
    .asciz "Hello, World!\n"
