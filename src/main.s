.global _start
.intel_syntax noprefix

_start:
    mov eax, 16 # ioctl, terminal screen info
    mov rdi, 1
    mov rsi, 0x5413
    lea rdx, [winsize]
    syscall

    cmp rax, 0
    jl error

    movzx rax, word ptr [winsize] # height
    movzx rbx, word ptr [winsize + 2] # width
    # rax = height * width (theres also imul/idiv which is nicer, but idk what the convention really is and what I should use)
    mul rbx

    # r8 = size
    mov r8, rax

    mov rsi, rax
    call getMemory
    # rax now holds pointer to memory

    # r9 = *buffer
    mov r9, rax

    xor r10, r10
loop: 
    cmp r10, r8
    je endLoop

    mov byte ptr [r9 + r10], '#'

    inc r10
    jmp loop
endLoop:

    mov rdx, r8
    mov rsi, r9
    call printScreen

    mov rdi, 0
    jmp exit
error:
    mov rax, 1
    mov rdi, 1
    mov rdx, errorMessageLen
    lea rsi, [errorMessage]
    syscall

    mov rdi, 1

# rdi error code
exit:
    pop rsi
    pop rdi

    call freeMemory

    mov rax, 60 # exit
    syscall

# rdx screen size
# rsi screen buffer
printScreen:
    mov rax, 1
    mov rdi, 1
    syscall
    ret

# rsi takes amount of bytes
# address of memory returned in rax
getMemory:
    push r8
    push r9

    mov rax, 9 # mmap syscall
    mov rdi, 0 # address
    mov rdx, 3 # protection, this is read write
    mov r10, 0x22 # flags, private and anonymous
    mov r8, -1 # file discriptor
    mov r9, 0 # offset
    syscall

    cmp rax, 0
    jl error

    pop r9
    pop r8

    ret

# rdi pointer to memory
# rsi size
freeMemory:
    mov rax, 11 # munmap syscall
    syscall

    ret


# bss is not in the program file, so nice for buffers
.section .bss

winsize:
    .space 8

# data is like initialised data included in the program file
.section .data

errorMessage: .ascii "Error"
.equ errorMessageLen, . - errorMessage
    