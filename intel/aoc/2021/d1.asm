%include "../../library64.asm"

section .rodata
    DEPTH_ARR_SIZE equ 2100
    FBUFFER_SIZE equ 21 * DEPTH_ARR_SIZE + 1 ; (20 max digits + newline) + null char
section .data

section .bss
    fd resq 1
    depth_inc_count resq 1

    depth_arr resq DEPTH_ARR_SIZE
    fbuffer resb FBUFFER_SIZE
    

section .text
global _start
_start:
    pop rax ; argc
    pop rax ; argv[0]
    pop rdi ; argv[1], filename

    ; open file
    mov rax, 2
    ; rdi contains the filename already
    mov rsi, 0
    mov rdx, 0
    syscall

    ; save fd
    mov rdi, fd
    mov [rdi], rax

    ; zero out vars
    mov qword [depth_inc_count], 1
    ZERO_BUFFER depth_arr, DEPTH_ARR_SIZE

    ; read file
    ZERO_BUFFER fbuffer, FBUFFER_SIZE

    ; fill fbuffer
    mov rax, 0
    mov rdi, [fd]
    mov rsi, fbuffer
    mov rdx, FBUFFER_SIZE
    syscall



    ; fill array
    .L1:




    ; parse array











    ; close file
    mov rax, 3
    mov rdi, [fd]
    syscall

    ; exit program
    mov rax, 60
    mov rdi, 0
    syscall