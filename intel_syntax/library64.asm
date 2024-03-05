; File: library686.asm
; Author: Brandyn Tucknott
; Last Updated: 9 February 2024
; Description:
;   A collection of MACROS and functions for commonly used features in higher level lanuages.
;   This library is meant for Intel x86_64 architecture.
; All macros for use:
;   PUSHAD64
;   POPAD64
;   EXIT - exit code (0 - 255)
;   NL
;   SPACE
;   ZERO_BUFFER - buffer, buffer length
;   WRITE_BUFFER - buffer
;   WRITE_BUFFERL - buffer, buffer length
;   WRITE_UINT - unsigned int
; All functions for use:
;   ZeroBuffer - rsi: buffer, rdi: buffer length
;   WriteBuffer - rsi: buffer
;   WriteUInt - rax: unsigned integer
section .bss
    str21_buffer resb 21 ; 21 byte buffer (mainly for WriteUInt and WriteInt)

section .data
    new_line_str db 10 ; 10 = new line char in ascii
    space_str db " "

section .text
; =======================================================================================================================
; =======================================================================================================================
; MACRO DEFINITIONS
; =======================================================================================================================
; =======================================================================================================================
; pushes in this order: rax, rbx, rcx, rdx, rsi, rdi, r8 - r15
%macro PUSHAD64 0
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
%endmacro

; pops in this order: rdx, rcx, rbx, rax
%macro POPAD64 0
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
%endmacro

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
    mov rax, 1
    mov rdi, 1
    mov rsi, new_line_str
    mov rdx, 1
    syscall
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
    mov rax, 1
    mov rdi, 1
    mov rsi, space_str
    mov rdx, 1
    syscall
    pop rdx
    pop rsi
    pop rdi
    pop rax
%endmacro

; zeros out the given buffer
%macro ZERO_BUFFER 2 ; buffer, buffer length
    PUSHAD64
    mov rsi, %1 ; eax = buffer
    mov rdi, %2 ; ebx = buffer length

    call ZeroBuffer
    POPAD64
%endmacro

; prints all values in the buffer to the console (until it hits the null char)
%macro WRITE_BUFFER 1
    push rsi
    mov rsi, %1 ; ecx = buffer
    call WriteBuffer
    pop rsi
%endmacro

; prints all (buffer length) values in the buffer to the console
%macro WRITE_BUFFERL 2 ; buffer, buffer length
    push rax
    push rdi
    push rsi
    push rdx
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
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
; =======================================================================================================================
; =======================================================================================================================
; HELPER FUNCTION DEFINITIONS
; =======================================================================================================================
; =======================================================================================================================
; fills the input buffer with 0's
; input:
;   rsi - buffer
;   rdi - length
; output:
;   fills buffer with 0's
ZeroBuffer:
    PUSHAD64
    mov rax, rsi ; buffer
    mov rbx, rdi ; buffer length
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
        POPAD64
        ret
; prints all chars in the buffer
; input:
;   rsi - buffer (must end with a null char)
; output:
;   prints the buffer to console
WriteBuffer:
    PUSHAD64
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
        POPAD64
        ret

; =======================================================================================================================
; =======================================================================================================================
; FUNCTION DEFINITIONS
; =======================================================================================================================
; =======================================================================================================================
; prints the number stored in eax
; input:
;   rax - unsigned integer N
; output:
;   prints rax to the console
WriteUInt:
    PUSHAD64

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
        POPAD64
        ret
; END OF WriteUInt ==================================================