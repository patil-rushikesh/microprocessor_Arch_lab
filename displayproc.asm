section .bss
    char_ans resb 2

%macro print 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdi, %2
    syscall
%endmacro

%macro exit 0
    mov rax, 60
    mov rdi, 0
    syscall
%endmacro

section .text
    global _start

_start:
    mov rax, 20
    call display
    exit

display:
    mov rbx, 16
    mov rcx, 2
    mov rsi, char_ans+1
cnt:
    mov rdx, 0
    div rbx
    cmp dl, 09h
    jbe add30
    add dl, 07h
add30:
    add dl, 30h
    mov [rsi], dl
    dec rsi
    dec rcx
    jnz cnt
    print char_ans, 2
ret