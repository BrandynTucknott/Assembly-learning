.section .data
.section .bss
.section .text
.global _start
_start:
    # exit program
    mov $1, %eax
    mov $0, %ebx
    int $0x80
