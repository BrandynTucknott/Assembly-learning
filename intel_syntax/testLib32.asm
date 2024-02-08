%include "library32.asm"

section .data
    testWriteBufferCase1 db "Does this show up?", 10, 0
    testWriteBufferCase2 db "I think this does", 10, 0
section .text

global _start
_start:
    ; test WRITE_BUFFER macro
    WRITE_BUFFER testWriteBufferCase1
    WRITE_BUFFER testWriteBufferCase2

    ; test WriteUInt function
    mov eax, 0
    call WriteUInt
    NL
    mov eax, 213
    call WriteUInt
    NL
    mov eax, 60457
    call WriteUInt
    NL
    mov eax, 1023456789
    call WriteUInt
    NL
    WRITE_BUFFER testWriteBufferCase1
    WRITE_BUFFER testWriteBufferCase2
    EXIT 0