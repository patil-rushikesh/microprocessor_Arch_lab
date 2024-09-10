
section .data 
	emsg db 10,10,"Error Occured",10,10
	emsg_len equ $-emsg

section	.bss
	buf resB 5
    char_ans resB 4

%macro Print 2
    mov rax,1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro Read 2
    mov rax, 0
    mov rdi, 0
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro Exit 0
    mov rax,60
    mov rdi, 0
    syscall
%endmacro

section .text
    global _start

_start:
    call hex_bcd

hex_bcd:
    call accept_16
    mov ax,bx
    mov bx,10
    xor bp,bp

back:
    xor dx,dx
    div bx
    push dx
    inc bp
    cmp ax, 0
    jne back

back1:
    pop dx
    add dl ,30h
    mov [char_ans],dl
    Print char_ans,1
    dec bp
    jnz back1
RET

accept_16:
    Read buf, 5
    mov rcx,4
    mov rsi, buf
    xor bx, bx

next_byte:
    SHL bx,4
    mov al, [rsi]

    cmp al,'0'
    jb error
    cmp al,'9'
    JBE sub30

    cmp al,'A'
    jb error
    cmp al,'F'
    JBE sub37

    cmp al,'a'
    jb error
    cmp al,'f'
    JBE sub57

error:
    Print emsg, emsg_len
    Exit

sub57:
    sub al,20h
sub37:
    sub al,07h
sub30:
    sub al,30h

    add bx,ax
    inc rsi
    dec rcx
    jnz next_byte
RET