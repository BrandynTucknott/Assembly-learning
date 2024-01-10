; prints out numbers in the fibonacci sequence (first array_size)

section .data
    array_size equ 11
    bytes_per_element equ 1

section .bss
    array resb array_size * bytes_per_element ; reserve 1 byte per num in fibonacci sequence

section .text

; function which prints string to terminal: 
;   esi - string
;   edi - length
print:
    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    mov edx, edi
    int 0x80

global _start

_start:
    ; create an array to store nums -DONE
    ; set first two elements in array equal to 1
    mov eax, array
    mov (eax), 1
    add eax, bytes_per_element
    mov (eax), 1
    ; loop to calculate and print all nums in series up until Nth num

    ; exit the program -DONE
    mov eax, 1
    mov ebx, 0
    int 0x80
