%include "../../library64.asm"

section .data
    fopened db "file has been successfully opened", 0
    fclosed db "file has been successfully closed", 0

    floor_level_str db "Floor Santa must go to: ", 0
    basement_pos_str db "First entered the basement at position: ", 0
    FILE_BUFFER_SIZE equ 1000

section .bss
    fd resq 1               ; file descriptor
    fbuffer resb FILE_BUFFER_SIZE       ; 1000 byte buffer
    up_int resq 1
    down_int resq 1
    first_in_basement_pos resq 1


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

    ; WRITE_BUFFER fopened
    ; NL

    
    ; zero out floor_level
    mov qword [up_int], 0
    mov qword [down_int], 0
    mov qword [first_in_basement_pos], 0


    ; read from file process
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
            inc qword [down_int]
            jmp _loop_prep

            _inc_count:
                inc qword [up_int]
            ; prep for next iteration
            _loop_prep:
                cmp qword [first_in_basement_pos], 0
                jg _final_loop_prep_stages
                ; in basement? check
                push rax
                push rbx

                mov rax, [up_int]
                mov rbx, [down_int]
                cmp rbx, rax
                jle _close_basement_check

                ; first in basement, store the position
                mov rax, [up_int]
                mov rbx, [down_int]
                add qword [first_in_basement_pos], rax
                add qword [first_in_basement_pos], rbx
                
                _close_basement_check:
                    pop rbx
                    pop rax
                _final_loop_prep_stages:
                    inc rcx
                    cmp rcx, FILE_BUFFER_SIZE
                    jl _parse_buffer_loop
                    jmp _process_loop
        ; get a new buffer worth of data
        ; jmp _process_loop

    _done_reading_file:     ; print the floor needed to go to
        ; figure out if ups > downs
        mov rax, [up_int]
        mov rbx, [down_int]
        mov rcx, 0 ; will hold the final value (unsigned): |ups - downs|
        mov rdx, 0 ; determines if we are printing a negative sign: 0 - no, 1 - yes

        cmp rax, rbx
        jge _output_positive_count


        ; delete this block: prints out num ups and downs
        ; push rax
        ; mov rax, [up_int]
        ; NL
        ; WRITE_UINT rax
        ; HYPHEN
        ; mov rax, [down_int]
        ; WRITE_UINT rax
        ; NL
        ; pop rax

        ; negative output
        inc rdx
        mov rcx, rbx
        sub rcx, rax
        jmp _print_floor

        ; output positive count
        _output_positive_count:
            mov rcx, rax
            sub rcx, rbx

        ; actually print the stuff here
        _print_floor:
            WRITE_BUFFER floor_level_str
            cmp rdx, 0 ; rdx == 0 ? don't print negative sign : print negative sign
            jz _just_print
            HYPHEN
            _just_print:
                WRITE_UINT rcx
                NL
        _print_basement_pos:
            WRITE_BUFFER basement_pos_str
            WRITE_UINT [first_in_basement_pos]
            NL


    ; close file
    mov rax, 3
    mov rdi, [fd]
    syscall

    ; WRITE_BUFFER fclosed
    ; NL

    EXIT 0
