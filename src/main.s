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

    push rax

    mov rsi, rax
    call getMemory
    # rax now holds pointer to memory

    push rax

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

printScreen:
    mov rax, 1
    mov rdi, 1
    mov rdx, SCREEN_BUFFER_SIZE
    lea rsi, [screenBuffer]
    syscall
    ret

# rsi takes amount of bytes
# address of memory returned in rax
getMemory:
    mov rax, 9 # mmap syscall
    mov rdi, 0 # address
    mov rdx, 3 # protection, this is read write
    mov r10, 0x22 # flags, private and anonymous
    mov r8, -1 # file discriptor
    mov r9, 0 # offset
    syscall

    cmp rax, 0
    jl error

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

.equ SCREEN_BUFFER_SIZE, 128
screenBuffer:
    .space SCREEN_BUFFER_SIZE

# data is like initialised data included in the program file
.section .data

errorMessage: .ascii "Error"
.equ errorMessageLen, . - errorMessage
    