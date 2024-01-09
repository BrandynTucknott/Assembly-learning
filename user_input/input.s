# This program should ask the user for an input, receieve the input, then print the input back to the user
# to run:
#    as input.s -o input.o
#    ld input.o -o input
#    ./input

.section .data
    buffer_size = 8
    get_prompt: .asciz "Get user input: "
    write_string: .asciz "Given user input: "
    test_str: .asciz "test\n"

.section .bss
    buffer: .space buffer_size

.section .text
# function to get the length of a string (said string will need to be passed into a register as a parameter)
#   %rbx contains the string (must be null-terminated)
#   %rdx contains the length of the string
get_str_length:
    # init length to 0
    mov $0, %rdx
    mov %rbx, %rsp

    # loop until the null-terminated char is found
    loop:
        mov $0, %al # scuffed 8 bit representation of 0 for cmpb (moved into the last 8 bits for %rax)
        cmpb (%rsp), %al # if char at index edi is the null terminater, end loop (str len doubles as an index value during calculation)
        je end

        add $1, %rsp # increment char
        add $1, %rdx # increment length
    end: ret

# function to print text to prompt user for input
print_prompt:
    mov $1, %rax
    mov $1, %rdi
    mov %rbx, %rsi
    # %rdx already contains the length of the string, as this function is only called directly after a get_str_length call
    syscall
    ret

# function to get user input
get_user_input:
    mov $0, %rax
    mov $0, %rdi
    mov $buffer, %rsi
    mov $buffer_size, %rdx
    syscall
    ret

# function to print user input
print_user_input:
    # get the length of the string, stored in %rcx, and use %rbx as the parameter
    mov $test_str, %rbx # pass string into parameter
    call get_str_length
    call print_prompt
    ret

# function to exit the program
exit_program:
    mov $60, %rax
    mov $0, %rdi
    syscall

.globl _start

_start:
    # call get_user_input
    call print_user_input
    call exit_program
