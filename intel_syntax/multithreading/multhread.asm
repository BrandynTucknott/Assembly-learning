; a project for me to learn about multithreading in assembly

%include "../library64.asm"

section .data
    hello db "Hello from thread ", 0
    t_error db "Something is not right", 0
    
    thread_stack_size equ 4096
    _lock dq 0                    ; qword to match with register size

    timespec dq 2, 2000000000

    thread0_counter dq 0
    thread1_counter dq 0

    barrier_thread_count dq 0

    PRINT_LIMIT equ 10

section .bss
    thread1_stack resb thread_stack_size
    stack_ptr resq 1

section .text

global _start
_start:

    ; testing sleep

    mov rax, 5
    WRITE_UINT rax
    NL


    mov rdx, timespec
    add rdx, 8

    mov rax, 35
    mov rdi, timespec
    mov rsi, rdx
    syscall

    mov rax, 10
    WRITE_UINT rax
    NL

    EXIT 0



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

    ; WRITE_UINT rax
    ; NL

    ; EXIT 0

    ; push rax            ; preserve TID

    ; barrier, all threads have reaches this point
    _await_threads:
        WRITE_UINT rax
        NL
        inc qword [barrier_thread_count]

        _wait:
            cmp qword [barrier_thread_count], 2
            je _try_lock        ; else wait then check again

            push rax
            mov rax, 35
            mov rdi, timespec
            mov rsi, 0
            syscall
            pop rax
            jmp _wait

    ; mutex lock area (atomic)
    ; if lock is available
    ; enter lock and do process
    ; if not, sleep and try again
    _try_lock:
        push rax
        push rax
        mov rbx, _lock
        mov rcx, 0
        lock cmpxchg qword [rbx], rcx
        je _mutex_lock

        ; else, sleep
        mov rax, 35                 ; sleep for 100ms
        mov rdi, timespec
        mov rsi, 0
        syscall
        pop rax             ; retrieve TID
        jmp _try_lock               ; try again


    _mutex_lock:
        mov qword [_lock], 1    ; close lock
        WRITE_BUFFER hello    ; execute process
        pop rax             ; retrieve TID
        WRITE_UINT rax
        NL

        cmp rax, 0
        jne child_thread_iterate

        inc qword [thread0_counter]
        mov qword [_lock], 0                ; free up lock
        cmp qword [thread0_counter], PRINT_LIMIT
        jl _try_lock
        jmp _exit

        child_thread_iterate:
            inc qword [thread1_counter]
            mov qword [_lock], 0                ; free up lock
            cmp qword [thread0_counter], PRINT_LIMIT
            jl _try_lock
    _exit:
        EXIT 0

    thread_error:
        WRITE_BUFFER t_error
        NL

        EXIT 1