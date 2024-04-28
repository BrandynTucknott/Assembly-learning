%include "../../library64.asm"

section .data
    fopened db "file has been successfully opened", 0
    fclosed db "file has been successfully closed", 0

section .bss
    fd resq 1               ; file descriptor
    fbuffer resb 1001       ; 1000 byte buffer + null char


section .text
global _start

_start:
    ; get file name
    pop rax     ; argc
    pop rax     ; argv[0]
    pop rax     ; argv[1]
    ; open file
    mov rdi, rax            ; char* filename
    mov rax, 2              ; open file syscall num
    mov rsi, 0              ; flags
    mov rdx, 0              ; file mode RD 0 / WR 1 / RD + WR 2
    syscall
    
    ; save fd
    mov rdi, fd
    mov [rdi], rax

    WRITE_BUFFER fopened
    NL

    ; read from file process
    mov r10, 0  ; total count, '(' = + 1, ')' = -1
    _process_loop:
        ; get buffer portion
        ZERO_BUFFER fbuffer, 1001
        mov rax, 0
        mov rdi, [fd]
        mov rsi, fbuffer
        mov rdx, 1000
        syscall
        ; parse buffer and modify counts
        mov rbx, fbuffer
        mov rcx, 0
        _parse_buffer_loop:
            mov rax, 4
            mul rcx
            mov rdx, [rbx + rax]

            cmp rdx, 40         ; ascii 40 == '('
            jz _end_of_buffer_null_char
            je _inc_count
            
            ; else dec_count
            dec r10
            EXIT 99
            jmp _loop_prep

            _inc_count:
                inc r10
                EXIT 100
            ; prep for next iteration
            _loop_prep:
                inc rcx
                jmp _parse_buffer_loop
        ; get a new buffer worth of data
        jmp _process_loop
        ; hit null char, stop reading and print results
        _end_of_buffer_null_char:
            EXIT r10


    ; close file
    mov rax, 3
    mov rdi, [fd]
    syscall

    WRITE_BUFFER fclosed
    NL

    EXIT 0
