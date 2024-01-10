section .data
    str: db "Hello, World!", 0x0A, 0
    str_len equ $ - str
section .text

global _start

_start:
    ;sys_write
    mov eax, 4
    mov ebx, 1
    mov ecx, str
    mov edx, str_len
    int 0x80

    ;sys_exit
    mov eax, 1
    mov ebx, 0
    int 0x80
