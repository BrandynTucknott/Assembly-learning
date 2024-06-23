%include "../../library64.asm"

section .data
    fopened db "file has been successfully opened", 0
    fclosed db "file has been successfully closed", 0

    floor_level_str db "Floor Santa must go to: ", 0
    FILE_BUFFER_SIZE equ 1000

section .bss
    fd resq 1               ; file descriptor
    fbuffer resb FILE_BUFFER_SIZE       ; 1000 byte buffer
    floor_level_int resq 1  ; signed integer respresenting how far up/down Santa has to go


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
    mov QWORD [floor_level_int], 0
    _process_loop:
        ; get buffer portion
        ZERO_BUFFER fbuffer, FILE_BUFFER_SIZE
        mov rax, 0
        mov rdi, [fd]
        mov rsi, fbuffer
        mov rdx, FILE_BUFFER_SIZE
        syscall
        ; parse buffer and modify counts
        mov rbx, QWORD fbuffer
        mov rcx, 0
        _parse_buffer_loop:
            xor rdx, rdx
            mov BYTE dl, [rbx + rcx]

            cmp rdx, 0
            je _done_reading_file

            cmp rdx, 40         ; ascii 40 == '('
            je _inc_count
            
            ; else dec_count bc char == ')'
            dec QWORD [floor_level_int]
            jmp _loop_prep

            _inc_count:
                inc QWORD [floor_level_int]
            ; prep for next iteration
            _loop_prep:
                inc rcx
                cmp rcx, FILE_BUFFER_SIZE
                jl _parse_buffer_loop
                jmp _process_loop
        ; get a new buffer worth of data
        ; jmp _process_loop

    _done_reading_file:     ; print the floor needed to go to
        WRITE_BUFFER floor_level_str

        mov rax, [floor_level_int]
        mov rbx, 1 << 63
        and rax, rbx

        NL
        WRITE_UINT rbx
        NL
        WRITE_UINT rax
        NL


        cmp rax, rbx
        mov rax, [floor_level_int]
        jl _output_positive_count

        ; negative output
        HYPHEN
        dec rax
        not rax ; convert to actual number from two's complement

        ; output positive count
        _output_positive_count:
            WRITE_UINT rax
            NL


    ; close file
    mov rax, 3
    mov rdi, [fd]
    syscall

    WRITE_BUFFER fclosed
    NL

    EXIT 0
