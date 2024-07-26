; File: library686.asm
; Author: Brandyn Tucknott
; Last Updated: 9 February 2024
; Description:
;   A collection of MACROS and functions for commonly used features in higher level lanuages.
;   This library is meant for Intel x86_64 architecture.
section .bss
    str21_buffer resb 21    ; 21 byte buffer (mainly for WriteUInt and WriteInt)

section .data
    new_line_str db 10 ; 10 = ascii new line char
    space_str db " "
    hyphen_str db "-"
    tab db 9 ; 9 = ascii tab char

section .text
; =======================================================================================================================
; =======================================================================================================================
; MACRO DEFINITIONS
; =======================================================================================================================
; =======================================================================================================================

; exits the program with given exit code
%macro EXIT 1 ; exit code
    mov rdi, %1
    mov rax, 60
    syscall
%endmacro

; print the new line char to the console
%macro NL 0
    push rax
    push rdi
    push rsi
    push rdx
    push rcx        ; needs to be pushed bc syscall modifies rcx:r11
    push r11
    mov rax, 1
    mov rdi, 1
    mov rsi, new_line_str
    mov rdx, 1
    syscall
    pop r11
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    pop rax
%endmacro

%macro NEWLINES 1
    push rax
    push rdi
    push rsi
    push rdx
    push rcx        ; needs to be pushed bc syscall modifies rcx:r11
    push r11

    mov rcx, %1     ; how many newlines to print
    mov rax, 1
    mov rdi, 1
    mov rsi, new_line_str
    mov rdx, 1
    _NEWLINES_loop:
        push rcx
        syscall     ; rcx:r11 are changed during syscall
        pop rcx
        loop _NEWLINES_loop

    pop r11
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    pop rax
%endmacro

%macro HYPHEN 0
    push rax
    push rdi
    push rsi
    push rdx
    push rcx        ; needs to be pushed bc syscall modifies rcx:r11
    push r11
    mov rax, 1
    mov rdi, 1
    mov rsi, hyphen_str
    mov rdx, 1
    syscall
    pop r11
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    pop rax
%endmacro

; print the space char ' ' to the console
%macro SPACE 0
    push rax
    push rdi
    push rsi
    push rdx
    push rcx        ; needs to be pushed bc syscall modifies rcx:r11
    push r11
    mov rax, 1
    mov rdi, 1
    mov rsi, space_str
    mov rdx, 1
    syscall
    pop r11
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    pop rax
%endmacro

%macro TAB 0
    push rax
    push rdi
    push rsi
    push rdx
    push rcx        ; needs to be pushed bc syscall modifies rcx:r11
    push r11
    mov rax, 1
    mov rdi, 1
    mov rsi, tab
    mov rdx, 1
    syscall
    pop r11
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    pop rax
%endmacro

; zeros out the given buffer
%macro ZERO_BUFFER 2 ; buffer, buffer length
    push rax
    push rbx
    mov rax, %1
    mov rbx, %2

    call ZeroBuffer
    pop rbx
    pop rax
%endmacro

; prints all values in the buffer to the console (until it hits the null char)
%macro WRITE_BUFFER 1
    push rsi
    mov rsi, %1 ; rsi = buffer
    call WriteBuffer
    pop rsi
%endmacro

; prints all (buffer length) values in the buffer to the console
%macro WRITE_BUFFERLEN 2 ; buffer, buffer length
    push rax
    push rdi
    push rsi
    push rdx
    push rcx        ; needs to be pushed bc syscall modifies rcx:r11
    push r11
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
    pop r11
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    pop rax
%endmacro

; prints unsigned integer
%macro WRITE_UINT 1 ; unsigned int
    push rax
    mov rax, %1
    call WriteUInt
    pop rax
%endmacro

; prints signed integer
%macro WRITE_INT 1 ; signed int
    push rax
    mov rax, %1
    call WriteInt
    pop rax
%endmacro

; =======================================================================================================================
; =======================================================================================================================
; HELPER FUNCTION DEFINITIONS
; =======================================================================================================================
; =======================================================================================================================
; fills the input buffer with 0's
; input:
;   rax - buffer
;   rbx - length
; output:
;   fills buffer with 0's
ZeroBuffer:
    push rcx
    mov rcx, 0 ; loop counter
    zero_buffer_loop:
        ; if we have checked all spaces in the buffer
        cmp rcx, rbx
        je zero_buffer_end

        ; else, store zero in the byte, and increment buffer pointer
        mov BYTE [rax], 0
        inc rcx
        inc rax
        jmp zero_buffer_loop

    zero_buffer_end:
        pop rcx
        ret
; prints all chars in the buffer
; input:
;   rsi - buffer (must end with a null char)
; output:
;   prints the buffer to console
WriteBuffer:
    push rax
    push rsi
    push rdx
    push rcx        ; needs to be pushed bc syscall modifies rcx:r11
    push r11
    ; loop through and find length of buffer (find null char)
    mov rax, rsi ; rax = buffer
    mov rdx, 0 ; rdx = length
    write_buffer_find_length:
        ; mov rbx, rax ; no need to push-pop rbx, it is not used elsewhere in this function
        cmp BYTE [rax], 0
        je write_buffer_writeSYSCALL

        inc QWORD rax
        inc QWORD rdx
        jmp write_buffer_find_length
    ; pass to write syscall
    write_buffer_writeSYSCALL:
        mov rax, 1
        mov rdi, 1
        ; rsi already == char*
        ; rdx already == length
        syscall
        pop r11
        pop rcx
        pop rdx
        pop rsi
        pop rax
        ret

; =======================================================================================================================
; =======================================================================================================================
; FUNCTION DEFINITIONS
; =======================================================================================================================
; =======================================================================================================================
; prints the unsigned integer stored in rax
; input:
;   rax - unsigned integer N
; output:
;   prints rax to the console
WriteUInt:
    push rax
    push rbx
    push rcx
    push rdx
    push rdi        ; for some reason this has to be added here bc data was being overwritten idk

    ; zero out the string buffer
    ZERO_BUFFER str21_buffer, 21
    mov rbx, str21_buffer
    add QWORD rbx, 20

    
    writeUInt_N:
        ; update indicies
        sub rbx, 1

        ; N /= 10, add remainder to string buffer
        ; rax already contains the num to divide
        mov rdx, 0 ; make sure rdx:rax = rax
        mov rcx, 10
        div rcx ; rdx holds remainder, rax the quotient
        ; store remainder in buffer
        mov [rbx], dl
        add BYTE [rbx], 48 ; convert to ascii
        cmp rax, 0
        je print_string_buffer_writeUInt
        jmp writeUInt_N ; repeat until N is 0
    ; end of writeUInt_N loop - ebx contains the address of the first digit (greatest decimal digit)
    print_string_buffer_writeUInt:
        WRITE_BUFFER rbx
        pop rdi
        pop rdx
        pop rcx
        pop rbx
        pop rax
        ret
; END OF WriteUInt ==================================================

; prints the integer stored in rax
; input:
;   rax - signed integer N
; output:
;   prints rax to the console
WriteInt:
    push rax
    push rbx
    push rcx
    push rdx
    push rdi
    push rsi

    ; zero out str buffer
    push rax
    mov rax, str21_buffer
    mov rbx, 21
    call ZeroBuffer
    pop rax
    mov rbx, str21_buffer

    bsr rdi, rax ; rdi != 63 --> 2^63 bit (sign bit in this case) == 0

    ; ignore the highest bit from now on
    ; mov rcx, 0111111111111111111111111111111111111111111111111111111111111111b
    ; and rax, rcx ; this and instruction deletes the highest bit

    ; TODO: CURRENT ISSUE: not printing correctly
    ; likely solvable by using HYPHEN and WRITE_UINT macros, but this involves 2+ syscalls, 
    ; so I would like to avoid this. Instead, I aim to put everything in one buffer and print
    ; the buffer (this method would use 1 syscall)


    ; mov negative sign in
    cmp rdi, 63
    jl writeInt_N ; N >= 0
    ; N < 0
    not rax ; convert from two's complement to normal binary
    mov rcx, 0111111111111111111111111111111111111111111111111111111111111111b
    and rax, rcx ; deletes the highest bit (sign bit). NOT will undo this if done before NOT instruction
    inc rax ; finish conversion
    HYPHEN


    ; mov qword [rbx], 45
    ; dec rbx ; 20 will be added later, but only 19 should be added, so pre-emptively subtract 1

    ; mov rest of digits in
    ; add qword rbx, 20
    writeInt_N:
        WRITE_UINT rax
        ; update indicies
        ; sub rbx, 1

        ; ; N /= 10, add remainder to string buffer
        ; ; rax already contains the num to divide
        ; mov rdx, 0 ; make sure rdx:rax = rax
        ; mov rcx, 10
        ; div rcx ; rdx holds remainder, rax the quotient
        ; ; store remainder in buffer
        ; mov [rbx], dl
        ; add BYTE [rbx], 48 ; convert to ascii
        ; cmp rax, 0
        ; je print_str_buffer_writeInt
        ; jmp writeInt_N ; repeat until N is 0
    ; print val
    ; print_str_buffer_writeInt:
        ; mov rax, 1
        ; mov rdi, 1
        ; mov rsi, str21_buffer
        ; mov rdx, 21
        ; syscall

    pop rsi
    pop rdi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret
; END OF WriteInt ===================================================

; opens a specific file (fopen)
; input:
;   rax - file name (char*)
; output:
;   opens the file with the given file name
;   rax - fd (file descriptor)
OpenFile:
    push rdi
    push rsi
    push rdx
    ;   rax - file name (const char*)
    ;   rdi - flags (int)
    ;   rdx - mode (int)
    mov rdi, rax    ; char* file name
    mov rax, 2      ; syscall num
    mov rsi, 0      ; flags
    mov rdx, 0      ; mode: RD 0 / WR 1 / RD + WR
    syscall
    pop rdx
    pop rsi
    pop rdi
    ret
; END OF OpenFile ==================================================

; opens a specific file (fopen)
; input:
;   rax - fd (file descriptor)
; output:
;   closes the file
CloseFile:
    push rdi
    mov rdi, rax    ; fd
    mov rax, 2      ; syscall num
    syscall
    pop rdi
    ret
; END OF CloseFile ==================================================