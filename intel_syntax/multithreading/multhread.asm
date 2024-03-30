; a project for me to learn about multithreading in assembly

%include "../library64.asm"

section .data
    timespec:
        .tv_sec dq 1
        .tv_nsec dq 0
    
    hello db "Hello from thread ", 0
    t_error db "Something is not right", 0
    barrier_wait db "Had to wait at barrier", 0
    
    thread_stack_size equ 4096
    _lock dq 0                    ; qword to match with register size

    thread0_counter dq 0        ; for mutex lock
    thread1_counter dq 0

    thread0_barrier dq 0        ; for barrier count
    thread1_barrier dq 0

    PRINT_LIMIT equ 5      ; num times thread message is printed

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

    ; barrier, all threads have reaches this point
    ; (not necessary, but I want to say that I made a barrier)
    _await_threads:
        cmp rax, 0
        jnz _inc_child_thread

        inc qword [thread0_barrier]
        jmp _wait

        _inc_child_thread:
            inc qword [thread1_barrier]

        _wait:
            mov rsi, [thread0_barrier]
            add rsi, [thread1_barrier]
            cmp rsi, 2        ; are both threads waiting at the barrier?
            je _try_lock        ; yes, both threads are here
            ; else wait then check again

            WRITE_UINT rax
            SPACE
            WRITE_UINT [thread0_barrier]
            SPACE
            WRITE_UINT [thread1_barrier]
            SPACE
            WRITE_BUFFER barrier_wait
            NewL

            push rax
            mov rax, 35
            mov rdi, timespec
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
        ; cmpxchg mem, reg
        ;   if mem == rax, mem = reg
        ;   else rax = mem
        ; mem == rax, mem = reg ? rax = mem
        mov rax, 0
        mov rcx, 0
        lock cmpxchg qword [rbx], rcx
        je _mutex_lock

        ; else, sleep
        mov rax, 35                 ; sleep for 100ms
        mov rdi, timespec
        syscall
        pop rax             ; retrieve TID
        jmp _try_lock               ; try again


    _mutex_lock:
        mov qword [_lock], 1    ; close lock
        WRITE_BUFFER hello    ; execute process
        pop rax             ; retrieve TID
        WRITE_UINT rax
        NewL

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