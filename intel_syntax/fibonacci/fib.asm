; prints out numbers in the fibonacci sequence (first array_size)

section .data
    array_size equ 0x06
    bytes_per_element equ 0x02
    arr_val: db 31h, 0x00
    arr_val_len equ $ - arr_val

    space: db " ", 0x00
    space_len equ $ - space

    new_line: db "", 0x0A, 0x00
    new_line_len equ $ - new_line

section .bss
    array: resw array_size; reserve 2 byte per num in fibonacci sequence

section .text

global _start

_start:
    ; create an array to store nums -DONE
    ; set first element in array equal to 1
    mov dword [array], 0x01
    mov dword [array + bytes_per_element], 0x01

    ; setup print - print array[0] = 1
    mov eax, 0x04
    mov ebx, 0x01
    mov ecx, arr_val
    mov edx, arr_val_len
    int 0x80

    mov eax, 0x04 ; print " "
    mov ecx, space
    mov edx, space_len
    int 0x80

    ; print array[1] = 1
    mov eax, 0x04
    mov ebx, 0x01
    mov ecx, arr_val
    mov edx, arr_val_len
    int 0x80

    mov eax, 0x04 ; print " "
    mov ecx, space
    mov edx, space_len
    int 0x80

    ; edi: array index
    ; esi: current fib num 
    mov edi, 0x02
    ; loop to calculate and print all nums in series up until Nth num
    loop:
        ; calculate next fibonacci num
        mov esi, [array + (edi - 1) * bytes_per_element] ; array + edi * BPE - 1 * BPE
        add esi, [array + (edi - 2) * bytes_per_element] ; array + edi * BPE - 2 * BPE
        ; now edi holds the value for the next fib num
        mov [array + edi], esi ; new fib num now stored in array at index edi
        
        ; ==================================================================================
        ; START SUBLOOP: hex -> print one byte at a time
        ; convert each digit to hex and store in arr_val - TODO
        convert_loop:
            xor edx, edx ; clear remainder register
            ; some method of moving [array + edi] one decimal digit at a time into [arr_val]
            mov byte [arr_val], 0x0A ; [array + edi]
            add byte [arr_val], 0x30 ; convert hex digit to ascii num

        ; print converted digit
        mov eax, 0x04
        mov ebx, 0x01 ; could possibly be removed
        mov ecx, arr_val
        mov edx, arr_val_len
        int 0x80

        ; print space
        mov eax, 0x04
        mov ebx, 0x01
        mov ecx, space
        mov ebx, space_len
        int 0x80

        ; END OF SUBLOOP
        ; ==================================================================================

        add edi, 0x01 ; update index: doubles as number of fib nums printed

        ; check for loop exit
        cmp edi, array_size
        je exit

        ; else: loop again
        jmp loop

    ; exit the program -DONE
    exit:
        ; print new line
        mov eax, 0x04
        mov ebx, 0x01
        mov ecx, new_line
        mov edx, new_line_len
        int 0x80

        ; exit
        mov eax, 0x01
        mov ebx, 0x000
        int 0x80
