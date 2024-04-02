section .bss
    buffer resd 0x20
    num resd 0x01

section .data
    BUFFER_SIZE equ 0x20

    prompt db "Enter input (32 chars): ", 0x00
    PROMPT_SIZE equ $ - prompt

    new_line_str db 0x0A
    new_line_str_size equ $ - new_line_str

    test_var dd 0x32

section .text
nl:
    push eax ; save vals in registers before printing
    push ebx
    push ecx
    push edx
    mov eax, 0x04
    mov ebx, 0x01
    mov ecx, new_line_str
    mov edx, new_line_str_size
    int 0x80
    pop edx ; retrieve saved vals before returning
    pop ecx
    pop ebx
    pop eax
    ret

global _start
_start:
    ; print prompt
    mov eax, 0x04
    mov ebx, 0x01
    mov ecx, prompt
    mov edx, PROMPT_SIZE
    int 0x80
    ; read input
    mov eax, 0x03
    mov ebx, 0x00
    mov ecx, buffer
    mov edx, BUFFER_SIZE
    int 0x80

    call nl
    ; print back input
    mov eax, 0x04
    mov ebx, 0x01
    mov ecx, buffer
    mov edx, BUFFER_SIZE
    int 0x80

    mov dword ecx, num
    mov dword edx, [buffer]
    mov dword [ecx], edx
    sub dword [ecx], 0x30

    mov ebx, [num]
    ; exit
    mov eax, 1
    ;xor ebx, ebx
    mov dword [test_var], 0x54
    mov ebx, [test_var]
    int 0x80