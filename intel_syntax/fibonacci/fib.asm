%include "../library32.asm"

; can only print the first 46 fibonacci numbers before it breaks (due to 32 bit registers and data storage)

; prints out numbers in the fibonacci sequence (first array_size)
section .data
    array_size equ 46 ; doubles as N for printing the first N fibonacci numbers
    bytes_per_element equ 0x04

section .bss
    array resd array_size

section .text

global _start

_start:
    ; create an array to store nums -DONE
    ; set first element in array equal to 1
    mov DWORD [array], 1
    mov DWORD [array + bytes_per_element], 1

    WRITE_UINT [array] ; setup print - print array[0] = 1
    SPACE
    WRITE_UINT [array + bytes_per_element] ; print array[1] = 1

    ; edi: array index
    ; esi: current fib num 
    mov edi, 2
    ; loop to calculate and print all nums in series up until Nth num
    loop:
        ; calculate next fibonacci num
        ; mov esi, [array + (edi - 1) * bytes_per_element] ; array + edi * BPE - 1 * BPE
        mov esi, array
        mov eax, bytes_per_element
        mov ebx, edi
        sub DWORD ebx, 1
        CDQ
        mul ebx ; eax = eax * ebx = (edi - 1) * bytes_per_element
        add DWORD esi, eax
        mov DWORD ecx, [esi] ; ecx = array[i - 1]

        ; add esi, [array + (edi - 2) * bytes_per_element] ; array + edi * BPE - 2 * BPE
        mov esi, array
        mov eax, bytes_per_element
        mov ebx, edi
        sub DWORD ebx, 2
        CDQ
        mul ebx ; eax = eax * ebx = (edi - 2) * bytes_per_element
        add DWORD esi, eax
        add DWORD ecx, [esi] ; ecx = array[i - 1] += array[i - 2]

        ; now edi holds the value for the next fib num
        ; mov eax, array
        ; add eax, edi
        ; mov [eax], ecx ; new fib num now stored in array at index edi
        mov eax, edi
        mov ebx, bytes_per_element
        CDQ
        mul ebx ; eax = edi * bytes_per_element
        mov ebx, array
        add DWORD ebx, eax
        mov DWORD [ebx], ecx ; ebx = array + eax --> [ebx] = array[i]

        SPACE
        WRITE_UINT ecx

        inc edi ; update index: doubles as number of fib nums printed

        ; check for loop exit
        cmp edi, array_size
        je exit
        jmp loop

    ; exit the program -DONE
    exit:
        NL
        EXIT 0
