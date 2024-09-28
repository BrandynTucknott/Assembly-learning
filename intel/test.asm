%include "library64.asm"

section .data
    msg db "This is the message", 10, 0
    msg_len equ $ - msg

    msg2 db "Another message", 10, 0
    msg2_len equ $ - msg2

section .bss
    buffer resb 100


section .text
global _start
_start:
    WRITE_BUFFER msg

    mov rcx, 2
    mov rdx, rcx

    ; sub rsp, rcx ; reserve 3 bytes on stack
    mov rdi, buffer

    mov al, 10
    rep stosb ; repeatedly byte read from register al
    mov al, 0
    mov rcx, 1
    rep stosb

    mov rsi, buffer
    mov rax, 1
    mov rdi, 1
    syscall

    WRITE_BUFFER msg2

    ; exit
    mov rax, 60
    mov rdi, 0
    syscall