.global _start
.intel_syntax noprefix

_start:
    call enableRawMode

    mov rax, 1 # syscall write
    mov rdi, 1
    lea rsi, [cursorHide]
    mov rdx, offset cursorHideLen
    syscall

    mov eax, 16 # sycsall ioctl terminal screen info
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

restartLoop:
    xor r10, r10
loop: 
    cmp r10, r8
    je endLoop

    mov byte ptr [r9 + r10], '#'

    inc r10
    jmp loop
endLoop:
    mov rax, 1 # syscall write
    mov rdi, 1
    lea rsi, [cursorHome]
    mov rdx, offset cursorHomeLen
    syscall

    mov rax, 1 # syscall write
    mov rdi, 1
    mov rsi, r9
    mov rdx, r8
    syscall

    jmp restartLoop

    mov rdi, 0
    jmp exit
error:
    mov rax, 1
    mov rdi, 1
    lea rsi, [errorMessage]
    mov rdx, offset errorMessageLen
    syscall

    mov rdi, 1

# rdi error code
exit:
    pop rsi
    pop rdi

    call freeMemory

    mov rax, 60 # exit
    syscall

enableRawMode:
    mov rax, 16 # syscall ioctl
    mov rdi, 1 # stdout
    mov rsi, 0x5401 # tcgets
    lea rdx, [termios]
    syscall

    cmp rax, 0
    jl error

    mov eax, dword [termios + 12] # flags
    and eax, ~(2 | 8) # icanon and echo bits
    mov dword [termios + 12], eax

    mov rax, 16 # ioctl
    mov rdi, 1 # stdout
    mov rsi, 0x5402 # tcsets
    lea rdx, [termios]
    syscall

    cmp rax, 0
    jl error

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

termios:
    .space 36

# data is like initialised data included in the program file
.section .data

errorMessage: .ascii "Error"
.equ errorMessageLen, . - errorMessage

clearScreen: .ascii "\x1b[2J"
.equ clearScreenLen, . - clearScreen

cursorHome: .ascii "\x1b[H"
.equ cursorHomeLen, . - cursorHome

cursorHide: .ascii "\x1b[?25l"
.equ cursorHideLen, . - cursorHide