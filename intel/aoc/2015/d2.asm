%include "../../library64.asm"

section .data
    fopened db 27, "[32mfile successfully opened", 27, "[0m", 0
    fclosed db 27, "[32mfile successfully closed", 27, "[0m", 0

    fbuffer_size equ 1000

section .bss
    fd resq 1
    fbuffer resb fbuffer_size

    ; stores the length, width, and height (string format) of a singular box
    length_buffer resb fbuffer_size
    width_buffer resb fbuffer_size
    height_buffer resb fbuffer_size

    ; stores the number of steps the fd should step back (is a negative number)
    offset resq 1

    ; stores the total length of wrapping paper required
    wrapping_paper_length resq 1

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
        ; fill buffer
        mov rax, 0
        mov rdi, [fd]
        mov rsi, fbuffer
        mov rdx, fbuffer_size
        syscall

        ; REMOVE_ME: print buffer contents
        WRITE_BUFFER fbuffer
        NL
        
        ; read buffer and count characters until the first \n is found
        mov rax, fbuffer
        mov qword [offset], 0
        xor rdx, rdx    ; temp register to store the single char from buffer
        _read_1_char: ; offset operates as a tmp variable here until it is set in _parse_buffer
            ; xor rdx, rdx
            mov dl, [rax]
            dec qword [offset] ; recall offset here is num_chars_before_first_newline
            cmp dl, 10 ; 10 = newline
            je _parse_buffer

            ; cmp dl, 0
            ; je _set_offset

            ; keep looking
            inc rax
            jmp _read_1_char
        
        _parse_buffer: ; 1 box at a time
            ; set offset to fbuffer_size - num_chars_before_first_newline
            ; HYPHEN
            ; HYPHEN
            ; HYPHEN
            ; NL
            ; mov rax, fbuffer_size
            ; mov rdi, [offset]
            ; sub rdi, rax ; rdi - rax = -(rax - rdi) = -(num_chars_to_move_back [pos int]) = [neg int]
            ; mov qword [offset], rdi
            WRITE_INT [offset]
            ; fill length
            ; fill width
            ; fill height
            mov qword [offset], 0
            NL
            HYPHEN
            HYPHEN
            HYPHEN
            NL
        
        ; TEST: move SEEK_CUR back
        ; rdx = 0: SEEK_SET
        ; rdx = 1: SEEK_CUR
        ; rdx = 2: SEEK_END
        mov rax, 8
        mov rdi, [fd]
        ; mov rsi, [offset]
        mov rsi, -5
        mov rdx, 1
        syscall
        ; TEST: re-fill buffer
        ZERO_BUFFER fbuffer, fbuffer_size
        mov rax, 0
        mov rdi, [fd]
        mov rsi, fbuffer
        mov rdx, fbuffer_size
        syscall
        ; TEST: print buffer contents
        WRITE_BUFFER fbuffer
        HYPHEN
        HYPHEN
        HYPHEN
        NL
        

    ; close file
    mov rax, 3
    mov rdi, [fd]
    syscall

    ; temp code: print (file closed)
    WRITE_BUFFER fclosed
    NL

    EXIT 0