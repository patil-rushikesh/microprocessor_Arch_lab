;Assignment NO.: 6
;Assignment Name: Block Transfer overlapped with string Instruction
;--------------------------------------------------------------------------------------

section .data
    bmsg db 10, "Before Transfer: "  
    bmsg_len equ $ - bmsg    

    amsg db 10, "After Transfer: "
    amsg_len equ $ - amsg
   
    smsg db 10, "Source Block "
    smsg_len equ $ - smsg
   
    dmsg db 10, "Destination Block "
    dmsg_len equ $ - dmsg
   
    sblock db 11h, 22h, 33h, 44h, 55h
    dblock times 5 db 0
   
    space db " "
   
section .bss
    char_ans resb 2 ;char_ans is of 2byte because we have 2byte nos
;----------------------------------------------------------------------------------

%macro Print 2
    mov rax, 1              ; system call 1 is write
    mov rdi, 1          ; file handle 1 is STDOUT
    mov rsi, %1        
    mov rdx, %2         ; number of bytes
    syscall
%endmacro

%macro Read 2
    mov rax, 0             ; system call 0 is read
    mov rdi, 0          
    mov rsi, %1        
    mov rdx, %2        
    syscall
%endmacro

%macro Exit 0
    mov rax, 60            ; system call 1 is write
    mov rdi, 0         ; file handle 1 is STDOUT
        syscall
%endmacro
;--------------------------------------------------------------------------------
   
section .text
    global _start

_start:
       Print bmsg, bmsg_len ;Block Values before transfer
       
Print smsg, smsg_len
mov rsi, sblock ;As rsi is used to point source as well as destination block
call disp_block ;assign source and destination block separately before call
           
Print dmsg, dmsg_len
    mov rsi, dblock-2
    call disp_block
   
    call BT_OS ;call for actual block transfer
   
    Print amsg, amsg_len ;Block values after transfer
   
    Print smsg, smsg_len
    mov rsi, sblock
    call disp_block
   
    Print dmsg, dmsg_len
    mov rsi, dblock-2
    call disp_block
   
Exit
;-------------------------------------------------------------------------------
BT_OS:
mov rsi, sblock +4
mov rdi, dblock +2
mov rcx, 5

STD ;STD/dec rsi, dec rdi
REP MOVSB ;MOVSB/mov al,[rsi], mov [rdi],al
;REP/dec rcx, jnz back
ret            
;--------------------------------------------------------------------------------
disp_block:
mov rbp, 5 ;counter as 5 values

next_num:
mov al, [rsi] ;moves 1 value to rsi
push rsi ;push rsi on stack as it get modified in Disp_8

call Disp_8
Print space, 1

pop rsi ;again pop rsi that pushed on stack
inc rsi

dec rbp
jnz next_num

ret
;------------------------------------------------------------------------------------

Disp_8:
MOV RSI, char_ans+1
MOV RCX, 2
MOV RBX, 16

next_digit:
XOR RDX, RDX
DIV RBX

CMP DL, 9
JBE add30
ADD DL, 07H

add30:
ADD DL, 30h
MOV [RSI], DL
DEC RSI

DEC RCX
JNZ next_digit

Print char_ans, 2
ret
;-------------------------------------------------------------------------------        
