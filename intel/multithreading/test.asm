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

    ; save thread id
    push rax

    thread_functions:
        mov rax, 0
        mov rbx, 1

        ; cmpxchg mem, reg
        ; mem == rax, mem = reg ? rax = mem
        ; mutex lock
        _try_lock:
            lock cmpxchg [_lock], rbx   ; atomic thread filter
            je _lock_acquired
            jmp _spin

        _spin:
            pause       ; optimization bc using spin-lock?
            mov rax, 35
            mov rdi, timespec
            syscall
            mov rax, 0  ; get ready for another _try_lock cmpxchg
            jmp _try_lock

        _lock_acquired:
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