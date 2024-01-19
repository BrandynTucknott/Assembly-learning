# This program should ask the user for an input, receieve the input, then print the input back to the user
# to run:
#    make
#    ./input

.section .data
    buffer_size = 255
    get_prompt: .asciz   "  Get user input: "
    write_string: .asciz "Given user input: "

.section .bss
   buffer: .space buffer_size

.section .text
# function to get the length of a string (said string will need to be passed into a register as a parameter)
#   %rbx contains the string (must be null-terminated)
#   %rbp contains the length of the string
get_str_length:
    # init length to 0
    mov $0, %rbp
    mov %rbx, %r12 # temp string to iterate through

    # loop until the null-terminated char is found
    loop:
        mov $0, %al # scuffed 8 bit representation of 0 for cmpb (moved into the last 8 bits for %rax)
        cmpb (%r12), %al # if char at index edi is the null terminater, end loop (str len doubles as an index value during calculation)
        je end


        add $1, %r12 # increment char
        add $1, %rbp # increment length
        jmp loop
    end: ret

# function to print text to prompt user for input
print_user_input_prompt:
    mov $1, %rax
    mov $1, %rdi # 1 = std::out
    mov %rbx, %rsi
    mov %rbp, %rdx
    syscall
    ret

# function to get user input
get_user_input:
    mov $0, %rax
    mov $0, %rdi # 0 = std::in
    mov $buffer, %rsi
    mov $buffer_size, %rdx
    syscall
    ret

# function to print prompt for user input
set_up_and_print_prompt:
    # get the length of the string, stored in %rcx, and use %rbx as the parameter
    mov $get_prompt, %rbx # pass string into parameter
    call get_str_length
    call print_user_input_prompt
    ret

print_back_user_input:
    # get str len write_string: stored in rbp
    mov $write_string, %rbx
    call get_str_length

    # print write_string
    mov $1, %rax
    mov $0, %rdi
    mov $write_string, %rsi
    mov %rbp, %rdx
    syscall

    # get str len for user input: stored in rbp
    mov %r15, %rbx # user input was stored in r15
    call get_str_length

    # print user input
    mov $1, %rax
    mov $0, %rdi
    mov %r15, %rsi
    mov %rbp, %rdx
    syscall
    ret

# function to exit the program
exit_program:
    mov $60, %rax
    mov $0, %rdi
    syscall

.globl _start

_start:
    call set_up_and_print_prompt
    call get_user_input
    mov %rsi, %r15 # store user input in r15
    call print_back_user_input

    call exit_program
