
section .bss
    num resd 0x01
section .data


global _start
_start:
    mov eax, num
    xor ebx, ebx ; clear ebx
    mov dword [eax], 0x64
    add byte bl, [eax]

    ; exit
    mov eax, 0x01
    ; xor ebx, ebx
    int 0x80