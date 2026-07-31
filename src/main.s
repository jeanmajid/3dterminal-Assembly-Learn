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

    movzx r11, word ptr [winsize] # height
    movzx r12, word ptr [winsize + 2] # width

    mov rax, r11
    mov rbx, r12
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
    xor rcx, rcx
loop: 
    cmp rcx, r8
    je endLoop

    mov byte ptr [r9 + rcx], ' '

    inc rcx
    jmp loop
endLoop:
    mov rax, SYSCALL_WRITE
    mov rdi, FD_OUT
    lea rsi, [cursorHome]
    mov rdx, offset cursorHomeLen
    syscall


    mov eax, dword ptr [zero]
    mov [vectorArray], eax
    mov [vectorArray + 4], eax

    mov eax, dword ptr [one]
    mov [vectorArray + 8], eax

    lea rdi, [vectorArray]
    call setPixel

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
setPixel:
    call screenProject

    # (y * width) + x
    mov edi, eax
    imul edi, r12d
    add edi, esi

    # edi = index into screen

    mov byte ptr [r9 + rdi], '#'
    
    ret

# rdi pointer to vector 1 in memory
# rsi pointer to vector 2 in memory
line:
    
    ret

# rdi pointer to vector in memory
# return
# x = esi
# y = eax
screenProject:
    # x = Math.floor(((x / z + 1) / 2) * this.width)

    movss xmm7, [rdi + 8] # z
    movss xmm0, [rdi] # x
    
    divss xmm0, xmm7
    addss xmm0, [one]
    mulss xmm0, [half]

    # first we gotta convert the int into a float
    movzx eax, word ptr [winsize + 2]
    cvtsi2ss xmm1, eax
    mulss xmm0, xmm1

    cvttss2si esi, xmm0

    # y = Math.floor(((1 - y / z) / 2) * this.height)

    movss xmm2, [rdi + 4] # y
    divss xmm2, xmm7

    movss xmm3, [one]
    subss xmm3, xmm2
    mulss xmm3, [half]

    # first we gotta convert the int into a float
    movzx eax, word ptr [winsize]
    cvtsi2ss xmm1, eax
    mulss xmm3, xmm1

    cvttss2si eax, xmm3

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

# read only data
.section .rodata

zero:
    .float 0

half:
    .float 0.5

one:
    .float 1

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
