%include "../library64.asm"

section .data
    timespec:
        .tv_sec dq 0
        .tv_nsec dq 20
    thread_stack_size equ 4096
    t_error db "Something is not right", 0
    _lock dq 0

    parent_thread_msg db "From parent thread", 0
    child_thread_msg db "From child thread", 0

    thread0_id dq 0
    thread1_id dq 0

section .bss
    thread1_stack resb thread_stack_size
    stack_ptr resq 1

section .text
global _start
_start:
    mov rax, stack_ptr      ; init second thread stack ptr
    mov qword [rax], thread1_stack
    add qword [rax], thread_stack_size - 1
    
    mov rax, 56     ; clone syscall
    mov rdi, 0
    mov rsi, stack_ptr
    mov rdx, 0
    mov r10, 0
    mov r8, 0
    syscall

    test rax, rax       ; check for thread creation errors
    jl thread_error

    ; save thread num
    ; cmp rax, 0
    ; je _save_child_thread_id
    ; jmp thread_functions

    ; ; save child thread id
    ; mov [thread1_id], rax
    push rax

    thread_functions:
        mov rax, 0
        mov rbx, 1

        ; cmpxchg mem, reg
        ; mem == rax, mem = reg ? rax = mem
        _try_lock:
            lock cmpxchg [_lock], rbx
            je _write_message

            ; if not equal, wait and try again
            mov rax, 35
            mov rdi, timespec
            syscall
            mov rax, 0  ; get ready for another _try_lock cmpxchg

        _write_message:
            pop rax
            cmp rax, 0
            jnz _do_child_function

            ; do parent function
            WRITE_BUFFER parent_thread_msg
            NewL
            mov qword [_lock], 0    ; free up the lock
            jmp _exit


        _do_child_function:
            WRITE_BUFFER child_thread_msg
            NewL
            mov qword [_lock], 0    ; free up the lock

    _exit:
        EXIT 0
; =========== END OF _start ====================



thread_error:
    WRITE_BUFFER t_error
    NL

    EXIT 1