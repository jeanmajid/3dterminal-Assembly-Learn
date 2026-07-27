.global printNumber
.intel_syntax noprefix

# rdi should have the number to print
printNumber:
    push r8
    push r10

    mov r8, 1
    lea r10, [printBuffer + PRINT_BUFFER_SIZE]

    mov byte ptr [r10], '\n'
    dec r10

    mov rax, rdi
loop:
    xor rdx, rdx
    mov rbx, 10

    div rbx

    # rax = result
    # rdx = remainder

    cmp rax, 0
    je endLoop

    add rdx, '0'
    mov byte ptr [r10], dl
    dec r10
    inc r8

    jmp loop
endLoop:
    add r8, 2
    add rdx, '0'
    mov byte ptr [r10], dl
    dec r10

    mov rax, 1 # syscall write
    mov rdi, 1 # terminal out
    mov rdx, r8 # amount of bytes to write

    lea rsi, [r10] # load print buffer
    syscall

    pop r10
    pop r8
    ret

.section .bss

.equ PRINT_BUFFER_SIZE, 128
printBuffer:
    .space PRINT_BUFFER_SIZE
