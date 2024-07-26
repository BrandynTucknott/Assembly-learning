%include "library64.asm"

section .data
    beginLibTest db "Starting library64.asm test", 10, 0
    beginLibTest_len equ $ - beginLibTest
    endLibTest db "library64.asm test has been complete", 10, 0
    testWriteBufferCase1 db "Does this show up?", 10, 0
    testWriteBufferCase2 db "I think this does", 10, 0

    beginWriteBufferTest db "Starting WriteBuffer test", 10, 0
    beginWriteBufferTest_len equ $ - beginWriteBufferTest
    endWriteBufferTest db "WriteBuffer test complete", 10, 0
    beginUIntTest db "Starting WriteUInt test", 10, 0
    endUIntTest db "WriteUInt test complete", 10, 0
    beginSignedIntTest db "Starting WriteInt test", 10, 0
    endSignedIntTest db "WriteInt test complete", 10, 0

    ; 27 = ascii 'ESCAPE'
    yellow db 27, '[93m', 0 ; ANSI escape for yellow text
    yellow_len equ $ - yellow
    cyan db 27, '[36m', 0 ; ANSI escape for cyan text
    cyan_len equ $ - cyan
    green db 27, '[32m', 0 ; ANSI escape for green text
    reset db 27, '[0m', 0 ; ANSI escape for text reset
    reset_len equ $ - reset
section .text

global _start
_start:
    ; change text color to yellow
    mov rax, 1
    mov rdi, 1
    mov rsi, yellow
    mov rdx, yellow_len
    syscall
    ; print test start
    mov rax, 1
    mov rdi, 1
    mov rsi, beginLibTest
    mov rdx, beginLibTest_len
    syscall
    ; reset color
    mov rax, 1
    mov rdi, 1
    mov rsi, reset
    mov rdx, reset_len
    syscall



    ; test WRITE_BUFFER macro
    mov rax, 1
    mov rdi, 1
    mov rsi, cyan
    mov rdx, cyan_len
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, beginWriteBufferTest
    mov rdx, beginWriteBufferTest_len
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, reset
    mov rdx, reset_len
    syscall
    WRITE_BUFFER testWriteBufferCase1
    WRITE_BUFFER testWriteBufferCase2
    WRITE_BUFFER green
    WRITE_BUFFER endWriteBufferTest
    WRITE_BUFFER reset

    ; test WriteUInt function
    WRITE_BUFFER cyan
    WRITE_BUFFER beginUIntTest
    WRITE_BUFFER reset
    mov rax, 0
    call WriteUInt
    NL
    mov rax, 213
    call WriteUInt
    NL
    mov rax, 60457
    call WriteUInt
    NL
    mov rax, 1023456789
    call WriteUInt
    NL
    mov rax, 10234567891023456789
    call WriteUInt
    NL
    WRITE_BUFFER green
    WRITE_BUFFER endUIntTest
    WRITE_BUFFER reset

    ; test WriteInt function
    WRITE_BUFFER cyan
    WRITE_BUFFER beginSignedIntTest
    WRITE_BUFFER reset
    mov rax, 0
    call WriteInt
    NL
    mov rax, 5
    call WriteInt
    NL
    sub rax, 6
    call WriteInt
    NL
    mov rax, -10
    call WriteInt
    NL
    WRITE_BUFFER green
    WRITE_BUFFER endSignedIntTest
    WRITE_BUFFER reset

    ; print ending message
    WRITE_BUFFER yellow
    WRITE_BUFFER endLibTest
    WRITE_BUFFER reset
    EXIT 0