.global _start
.intel_syntax noprefix

.equ SYSCALL_WRITE, 1
.equ SYSCALL_IOCTL, 16
.equ SYSCALL_MMAP, 9
.equ SYSCALL_MUNMAP, 11

.equ FD_OUT, 1

_start:
    call enableRawMode

    mov rax, SYSCALL_WRITE
    mov rdi, FD_OUT
    lea rsi, [cursorHide]
    mov rdx, offset cursorHideLen
    syscall

    mov eax, SYSCALL_IOCTL # terminal screen info
    mov rdi, FD_OUT
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
    mov rax, SYSCALL_WRITE
    mov rdi, FD_OUT
    lea rsi, [cursorHome]
    mov rdx, offset cursorHomeLen
    syscall

    mov rax, SYSCALL_WRITE
    mov rdi, FD_OUT
    mov rsi, r9
    mov rdx, r8
    syscall

    jmp restartLoop

    mov rdi, 0
    jmp exit
error:
    mov rax, SYSCALL_WRITE
    mov rdi, FD_OUT
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

# rdi pointer to vector in memory
screenProject:
    ret

enableRawMode:
    mov rax, SYSCALL_IOCTL
    mov rdi, FD_OUT
    mov rsi, 0x5401 # tcgets
    lea rdx, [termios]
    syscall

    cmp rax, 0
    jl error

    mov eax, dword [termios + 12] # flags
    and eax, ~(2 | 8) # icanon and echo bits
    mov dword [termios + 12], eax

    mov rax, SYSCALL_IOCTL
    mov rdi, FD_OUT
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

    mov rax, SYSCALL_MMAP
    mov rdi, 0 # address
    mov rdx, 3 # protection, this is read write
    mov r10, 0x22 # flags, private and anonymous
    mov r8, -1 # file descriptor
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
    mov rax, SYSCALL_MUNMAP
    syscall

    ret


# bss is not in the program file, so nice for buffers
.section .bss

winsize:
    .space 8

termios:
    .space 36

vectorArray:
    .space (3 * 4) * 100

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

# start loop
#    call getTime
#    mov r12, rax
# end loop
#    call getTime
#    # frame time
#    sub rax, r12
#
#    cmp rax, 0
#    je restartLoop
#
#    mov rbx, rax
#    mov rax, 1000000000
#    xor rdx, rdx
#    div rbx
#
#    # rax = fps
#    mov rdi, rax
#    call printNumber