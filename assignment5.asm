section .data
    nline       db  10,10
    nline_len   db  $-nline

    space       db  " "

    ano         db  10,"Assignment No. 6",
                db  10
                db  10,"Block transfer - Non Overlapped without String instruction.",
                db  10

    ano_len     equ $-ano
    
    bmsg        db  10,"Before transfer : "
    bmsg_len    equ $-bmsg

    amsg        db  10,"After transfer : "
    amsg_len    equ $-amsg

    smsg        db  10,"Source Block : "
    smsg_len    equ $-smsg

    dmsg        db  10,"Destination Block : "
    dmsg_len    equ $-dmsg

    sblock      db  11h,22h,33h,44h,55h
    sblock_len  equ $-sblock

    dblock      db  0,0,0,0,0 
    dblock_len  equ $-dblock


section .bss
    char_ans    resb   3  ; Buffer for hex display (2 digits + null terminator)

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
    Print ano,ano_len
    Print bmsg, bmsg_len
    
    Print smsg, smsg_len
    mov rsi,sblock
    call display_block

    Print dmsg,dmsg_len
    mov rsi,dblock
    call display_block

    call Bt_NO

    Print amsg,amsg_len

    Print smsg,smsg_len
    mov rsi,sblock
    call display_block

    Print dmsg,dmsg_len
    mov rsi,dblock
    call display_block
Exit

Bt_NO:
    mov rsi,sblock
    mov rdi,dblock
    mov rcx,5

back:
    mov al,[rsi]
    mov [rdi], al

    inc rsi
    inc rdi

    dec rcx
    jnz back
    ret

display_block:
    mov rbp, 5  ; Number of bytes to display
next_num:
    mov al,[rsi]
    push rsi

    call display
    Print space,1

    pop rsi
    inc rsi
    dec rbp
    jnz next_num
    ret


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
    Print char_ans, 2
ret