section .text

global _start
_start:
    mov eax, 0x64
    mov ebx, 0x05

    div ebx

    mov ebx, eax
    mov eax, 1
    int 0x80