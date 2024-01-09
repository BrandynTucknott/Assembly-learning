# This example is from the book 'Programming from the Ground Up' by Jonathan Bartlett
# VARS:
#   %edi - index of item being examined
#   %ebx - largest item found
#   %eax - current data item

# to run:
#   as max.s -o max.o
#   ld max.o -o max
#   ./max
#   echo $?

# memory allocations:
#   data_items - contains all item data

.section .data
data_items: # largest should be 255: values larger than 255 will be calculated correctly but printed wrong with echo cmd
    .long 4, 5, 90, 20, 28, 50, 95, 57, 129, 255, 43, 77, 32, 254

.section .text
.global _start

_start:
    mov $0, %rdi # move 0 into the index register
    mov data_items(,%edi,4), %eax # load the first byte of data
    mov %eax, %ebx # since this is the first item, %eax is the biggest

start_loop: # start loop
    cmp $0, %eax # check to see if we’ve hit the end
    je loop_exit # je - jump if equal

    add $4, %edi # incl - incrememnt the operand by one - load next value
    mov data_items(,%edi,), %eax # get 4 bytes starting at the item index
    cmp %ebx, %eax # cmpl - compare the contents of two registers - compare values
    jle start_loop # jle - jump if less than or equal to - jump to loop beginning if the new one isn’t bigger
    
    mov %eax, %ebx # move the value as the largest
    jmp start_loop # jump to loop beginning

loop_exit:
    # %ebx is the status code for the exit system call and it already has the maximum number
    mov $1, %eax # 1 is the exit() syscall
    int $0x80 # interrupt 0x80 - syscall
