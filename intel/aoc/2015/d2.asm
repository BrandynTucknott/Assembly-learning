%include "../../library64.asm"

section .data
    fopened db "file successfully opened", 0
    fclosed db "file successfully closed", 0

    fbuffer_size equ 1000
    fd dq 1 dup(0)
    fbuffer db fbuffer_size dup(0)
    temp_buffer db fbuffer_size dup(0)      ; holds remnants from buffer that are present when buffer ends (but end of line has not been found yet)
    
    length_buffer db fbuffer_size dup(0)    ; stores the length, width, and height (string format) of a singular box
    width_buffer db fbuffer_size dup(0)
    height_buffer db buffer_size dup(0)

; section .bss
    ; fd resq 1
    ; fbuffer resb fbuffer_size

section .text
global _start
_start:
    ; get file name
    pop rdi     ; argc
    pop rdi     ; argv[0]
    pop rdi     ; argv[1]

    ; open file (rdi contains the file name)
    mov rax, 2
    mov rsi, 0
    mov rdx, 0
    syscall

    ; save fd
    mov rdi, fd
    mov [rdi], rax

    ; temp code: print (file opened)
    WRITE_BUFFER fopened
    NL

    _read_file:
        ; get buffer
        mov rax, 0
        mov rdi, [fd]
        mov rsi, fbuffer
        mov rdx, fbuffer_size
        syscall

        ; parse buffer: assumes there is at least 1 box (LxWxH\n) in the buffer
        _parse_buffer:
            ; fill length
            ; fill width
            ; fill height

            ; check if there one other box in the buffer (look for \n char)
        

    ; close file
    mov rax, 3
    mov rdi, [fd]
    syscall

    ; temp code: print (file closed)
    WRITE_BUFFER fclosed
    NL

    EXIT 0