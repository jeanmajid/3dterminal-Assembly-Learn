.global _start
.intel_syntax noprefix

_start:
    # mov eax, 0x10 # ioctl, terminal screen info
    # mov edi, 1
    # mov esi, 0x00005401
    # lea rdx, [winsize]
    # syscall

    # mov eax, word [winsize]
    # mov ebx, word [winsize + 2]

    mov rdi, 123
    call printNumber

    mov rax, 60 # exit
    mov rdi, 0 # error code
    syscall

# write length into rdx please
printScreen:
    mov rax, 1
    mov rdi, 1
    mov rdx, SCREEN_BUFFER_SIZE
    lea rsi, [screenBuffer]
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
