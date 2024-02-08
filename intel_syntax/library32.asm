; File: library32.asm
; Author: Brandyn Tucknott
; Last Updated: 3 February 2024
; Description:
;   A collection of MACROS and functions for commonly used features in higher level lanuages.
;   This library is meant for Intel i386 assembly.
; All macros for use:
;   EXIT
;   NL
;   SPACE
;   ZERO_BUFFER - buffer, buffer length
;   WRITE_BUFFER - buffer
;   WRITE_BUFFERL - buffer, buffer length
;   WRITE_UINT - unsigned int
; All functions for use:
;   ZeroBuffer
;   WriteBuffer
;   WriteUInt
section .bss
    str11_buffer resb 0x0B ; 11 byte buffer (mainly for WriteUInt and WriteInt)
section .data
    new_line_str db 0x0A
    new_line_str_len equ $ - new_line_str

    space_str db " "
    space_str_len equ $ - space_str

section .text
; =======================================================================================================================
; =======================================================================================================================
; MACRO DEFINITIONS
; =======================================================================================================================
; =======================================================================================================================
; exits the program with given exit code
%macro EXIT 1 ; exit code
    mov ebx, %1
    mov eax, 1
    int 0x80
%endmacro

; print the new line char to the console
%macro NL 0
    pushad
    mov eax, 4
    mov ebx, 1
    mov ecx, new_line_str
    mov edx, new_line_str_len
    int 0x80
    popad
%endmacro

; print the space char ' ' to the console
%macro SPACE 0
    pushad
    mov eax, 4
    mov ebx, 1
    mov ecx, space_str
    mov edx, space_str_len
    int 0x80
    popad
%endmacro

; zeros out the given buffer
%macro ZERO_BUFFER 2 ; buffer, buffer length
    pushad
    mov esi, %1 ; eax = buffer
    mov edi, %2 ; ebx = buffer length

    call ZeroBuffer
    popad
%endmacro

; prints all values in the buffer to the console (until it hits the null char)
%macro WRITE_BUFFER 1
    push esi
    mov esi, %1 ; ecx = buffer
    call WriteBuffer
    pop esi
%endmacro

; prints all (buffer length) values in the buffer to the console
%macro WRITE_BUFFERL 2 ; buffer, buffer length
    pushad
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
    popad
%endmacro

; prints unsigned integer
%macro WRITE_UINT 1 ; unsigned int
    push eax
    mov eax, %1
    call WriteUInt
    pop eax
%endmacro
; =======================================================================================================================
; =======================================================================================================================
; HELPER FUNCTION DEFINITIONS
; =======================================================================================================================
; =======================================================================================================================
; fills the input buffer with 0's
; input:
;   esi - buffer
;   edi - length
; output:
;   fills buffer with 0's
ZeroBuffer:
    pushad
    mov eax, esi ; buffer
    mov ebx, edi ; buffer length
    mov ecx, 0 ; loop counter
    zero_buffer_loop:
        ; if we have checked all spaces in the buffer
        cmp ecx, ebx
        je zero_buffer_end

        ; else, store zero in the byte, and increment buffer pointer
        mov BYTE [eax], 0
        inc DWORD ecx
        inc DWORD eax
        jmp zero_buffer_loop

    zero_buffer_end:
        popad
        ret
; prints all chars in the buffer
; input:
;   esi - buffer (must end with a null char)
; output:
;   prints the buffer to console
WriteBuffer:
    pushad
    ; loop through and find length of buffer (find null char)
    mov eax, esi ; eax = buffer
    mov edx, 0 ; edx = length
    write_buffer_find_length:
        cmp BYTE [eax], 0
        je write_buffer_writeSYSCALL

        inc DWORD eax
        inc DWORD edx
        jmp write_buffer_find_length
    ; pass to write syscall
    write_buffer_writeSYSCALL:
        mov eax, 4
        mov ebx, 1
        mov ecx, esi
        ; edx already == length
        int 0x80
        popad
        ret

; =======================================================================================================================
; =======================================================================================================================
; FUNCTION DEFINITIONS
; =======================================================================================================================
; =======================================================================================================================
; prints the number stored in eax
; input:
;   eax - unsigned integer N
; output:
;   prints eax to the console
WriteUInt:
    pushad
    ; zero out the string buffer
    ZERO_BUFFER str11_buffer, 11
    mov ebx, str11_buffer
    ; check if N is 0
    cmp eax, 0
    je writeUInt_0
    add DWORD ebx, 10
    jmp writeUInt_N

    
    writeUInt_0:
        mov BYTE [ebx], 48 ; 48 = zero in ascii
        jmp print_string_buffer_writeUInt

    
    writeUInt_N:
        cmp eax, 0
        je print_string_buffer_writeUInt

        ; update indicies
        sub ebx, 1

        ; N /= 10, add remainder to string buffer
        ; eax already contains the num to divide
        mov ecx, 10
        cdq
        div ecx ; edx holds remainder, eax the quotient
        ; store remainder in buffer
        mov [ebx], dl
        add BYTE [ebx], 48 ; convert to ascii
        jmp writeUInt_N ; repeat until N is 0
    ; end of writeUInt_N loop - ebx contains the address of the first digit (greatest decimal digit)
    print_string_buffer_writeUInt:
        WRITE_BUFFER ebx
        popad
        ret
; END OF WriteUInt ==================================================