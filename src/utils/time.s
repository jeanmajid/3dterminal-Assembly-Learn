.global getTime
.intel_syntax noprefix

.equ SYSCALL_CLOCK_GETTIME, 228

# returns time in rax
getTime:
    mov rax, SYSCALL_CLOCK_GETTIME
    mov rdi, 1 # monotonic clock
    lea rsi, [timespec]
    syscall

    # turning the time into nano seconds as linux gives us time in seconds plus elapsed nano in the current second
    mov rax, [timespec]
    mov rbx, 1000000000
    mul rbx

    # rax = current time nano
    add rax, [timespec + 8]

    ret

.section .bss

timespec:
    .space 16
