%include "library64.asm"

section .data
    beginLibTest db "Starting library64.asm test", 10, 0
    beginLibTest_len equ $ - beginLibTest
    endLibTest db "library64.asm test has been complete", 10, 0
    testWriteBufferCase1 db "Does this show up?", 10, 0
    testWriteBufferCase2 db "I think this does", 10, 0

    endWriteBufferTest db "Write Buffer test complete", 10, 0
    endUIntTest db "Unsigned Integer test complete", 10, 0
    endSignedIntTest db "Signed Integer test complete", 10, 0

    ; 27 = ascii 'ESCAPE'
    yellow db 27, '[93m', 0 ; ANSI escape for yellow text
    yellow_len equ $ - yellow
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
    WRITE_BUFFER testWriteBufferCase1
    WRITE_BUFFER testWriteBufferCase2
    WRITE_BUFFER green
    WRITE_BUFFER endWriteBufferTest
    WRITE_BUFFER reset

    ; test WriteUInt function
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
    WRITE_BUFFER green
    WRITE_BUFFER endSignedIntTest
    WRITE_BUFFER reset
    WRITE_BUFFER yellow
    WRITE_BUFFER endLibTest
    WRITE_BUFFER reset
    EXIT 0