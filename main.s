.global _start
.intel_syntax noprefix

_start:
    ; mov eax, 0x10 # ioctl, terminal screen info
    ; mov edi, 1
    ; mov esi, 0x00005401
    ; lea rdx, [winsize]
    ; syscall

    ; mov eax, word [winsize]
    ; mov ebx, word [winsize + 2]

    mov byte ptr [screenBuffer], 'H'
    mov byte ptr [screenBuffer] + 1, '\n'
    mov rdx, 2
    call printNumber

    mov rax, 60 # exit
    mov rdi, 0 # error code
    syscall


printNumber:
    # this function is not done
    mov rdi, 50

    xor r8, r8

    

    mov rax, rdi
    xor rdx, rdx
    mov rbx, 10

    div rbx

    # rax = result
    # rdx = remainder

    mov rdi, rax
    
    add rdi, 48
    mov byte ptr [printBuffer], dil
    mov byte ptr [printBuffer] + 1, '\n'

    mov rax, 1
    mov rdi, 1
    mov rdx, 2
    lea rsi, [printBuffer]
    syscall
    ret

# write length into rdx please
printScreen:
    mov rax, 1
    mov rdi, 1
    lea rsi, [screenBuffer]
    syscall
    ret

# bss is not in the program file, so nice for buffers
.section .bss

winsize:
    .space 8

screenBuffer:
    .space 128

printBuffer:
    .space 128

# data is like initialised data included in the program file
.section .data

