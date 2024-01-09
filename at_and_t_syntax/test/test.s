# a file to be constantly changed: contains the last thing I tested
# to run:
#   make
#   ./test

exit:  
    mov $60, %rax
    mov $0, %rdi
    syscall

.globl _start

_start:
    mov $5, %rax
    mov $3, %rbx
    cmp %rbx, %rax

    mov %rax, %rdi

    mov $60, %rax

    syscall



    # call exit
