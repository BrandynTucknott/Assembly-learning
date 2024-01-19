; use 2 bytes for 

section .data
    ;buffer resb 0x06 ; null terminator - NOTE: 5 bytes reserved for num: the largest it can get with 2 bytes is 5 digits in decimal
    buffer_max_index equ 0x04 ;[buffer + buffer_max_index] = last char in buffer
    buffer_index dd 0x00 ;current index for accessing chars in the buffer
    buffer_len equ 0x06

    current_val dd 0xfff ; should be 4095, starting val to print

    new_line db 0x0A, 0x00
    new_line_len equ $ - new_line
section .bss
    buffer resb 0x06
section .text
; function to print out whatever is in the buffer
write:
    mov eax, 0x04
    mov ebx, 0x01
    mov ecx, buffer
    mov edx, buffer_len
    int 0x80
    ret


; prints a new line
print_new_line:
    mov eax, 0x04
    mov ebx, 0x01
    mov ecx, new_line
    mov edx, new_line_len
    int 0x80
    ret

global _start
_start:
    ; scuffed initialize
    mov byte [buffer + 0x05], 0x00 ; end string with null char
    loop:
        ; get the current digit
        mov eax, [current_val]
        ; if current_val == 0, exit loop
        cmp eax, 0x00
        je outside_loop
        mov ebx, 0x0A ;get digits in base 10
        xor edx, edx ; set remainder to 0 before divide
        div ebx ; divide eax by ebx, store remainder in edx
        
        ; save current val
        mov [current_val], eax
        ;mov esi, eax

        ; save remainder to string
        xor eax, eax ; zero-out the register
        add byte al, buffer_max_index ; get the correct index of buffer (starting from right to left)
        sub eax, [buffer_index]

        add edx, 0x30 ; turn from number into ascii
        mov [buffer + eax], dl ; move reminder into buffer (it is the base 10 digit)
        inc dword [buffer_index] ; increment buffer index

        ; MAYBE REMOVE??? -- prints char by char -- KEEP JMP LOOP
        ;call write ; REMOVE?????
        ;call print_new_line ; REMOVE????????
        jmp loop
outside_loop:
    ; outside of conversion loop
    call write
    call print_new_line

    ; exit program
    mov eax, 0x01
    xor ebx, ebx ; 0x00
    int 0x80