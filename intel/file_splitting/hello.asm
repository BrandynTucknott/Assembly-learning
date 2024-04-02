section .data
    hello db "Hello World from a different file!", 0x0A, 0x00
    hello_len equ $ - hello

section .text
%macro mHelloWorld 0
    pushad
    mov eax, 0x04
    mov ebx, 0x01
    mov ecx, hello
    mov edx, hello_len
    int 0x80
    popad
%endmacro

%macro KYS 0
    mov eax, 0x01
    mov ebx, 0x00
    int 0x80
%endmacro