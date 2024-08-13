section .data                       ; (data section)
    msg1 db 10,"welcome",10         ; define byte: msg1 stores string welcome and 10 is used to new line
    msg1_len: equ $-msg1            ; msg1_len stores length of string which is stored in msg1
    msg2 db 10,"Wassup!",10,10      ; define byte: msg2 stores string Wassup! 
    msg2_len: equ $-msg2            ; msg2_len stores length of string which is stored in msg2


                                    ; (functions)

%macro print 2                      ; function fucntion_name no_of_params
    mov rax, 1                      ; write permission for accumulator (syscall)
        mov rdi, 1                  ; destination index
        mov rsi, %1                 ; soruce index stores 1st parameter
        mov rdx, %2                 ; data register
        syscall                     ; (syscall end)
%endmacro

%macro exit 0                       
    mov rax, 60                     ; exit permission for accumulator (syscall)
        mov rdi, 0                  ; file handle 1 is stdout
        syscall                     ; (syscall end)
%endmacro

section .text                       ; (entry point)
    Global _start

_start:
        print msg1, msg1_len        ; (calling of print function and passing args)
        print msg2, msg2_len        ; (calling of print function and passing args)
    exit                            ; (calling of print function and passing no args)
