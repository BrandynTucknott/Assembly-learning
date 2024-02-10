%include "../library64.asm"

; can only print the first 93 fibonacci numbers before integer overflow

; prints out numbers in the fibonacci sequence (first array_size)
section .data
    array_size equ 93 ; doubles as N for printing the first N fibonacci numbers
    bytes_per_element equ 8
    fib_label db "Fib Num ", 0
    colon db ": ", 0

section .bss
    array resq array_size

section .text

global _start

_start:
    ; create an array to store nums
    ; set first element in array equal to 1
    mov QWORD [array], 1
    mov QWORD [array + bytes_per_element], 1

    ; setup print - print array[0] = 1
    WRITE_BUFFER fib_label
    WRITE_UINT 0
    WRITE_BUFFER colon
    WRITE_UINT [array]
    NL

    ; print array[1] = 1
    WRITE_BUFFER fib_label
    WRITE_UINT 1
    WRITE_BUFFER colon
    WRITE_UINT [array + bytes_per_element]
    NL

    ; rdi: array index
    ; rsi: current fib num 
    mov rdi, 2
    ; loop to calculate and print all nums in series up until Nth num
    loop:
        ; calculate next fibonacci num
        ; mov rsi, [array + (rdi - 1) * bytes_per_element] ; array + rdi * BPE - 1 * BPE
        mov rsi, array
        mov rax, bytes_per_element
        mov rbx, rdi
        sub rbx, 1
        mul rbx ; rax = rax * rbx = (rdi - 1) * bytes_per_element
        add rsi, rax
        mov QWORD rcx, [rsi] ; rcx = array[i - 1]

        ; add rsi, [array + (rdi - 2) * bytes_per_element] ; array + rdi * BPE - 2 * BPE
        mov rsi, array
        mov rax, bytes_per_element
        mov rbx, rdi
        sub QWORD rbx, 2
        mul rbx ; rax = rax * rbx = (rdi - 2) * bytes_per_element
        add QWORD rsi, rax
        add QWORD rcx, [rsi] ; rcx = array[i - 1] += array[i - 2]

        ; now rdi holds the value for the next fib num
        mov rax, rdi
        mov rbx, bytes_per_element
        mov rdx, 0
        mul rbx ; rax = rdi * bytes_per_element
        mov rbx, array
        add QWORD rbx, rax
        mov QWORD [rbx], rcx ; rbx = array + rax --> [rbx] = array[i]

        WRITE_BUFFER fib_label
        WRITE_UINT rdi
        WRITE_BUFFER colon
        WRITE_UINT rcx
        NL

        inc QWORD rdi ; update index: doubles as number of fib nums printed

        ; check for loop exit
        cmp rdi, array_size
        je exit
        jmp loop

    ; exit the program
    exit:
        NL
        EXIT 0
