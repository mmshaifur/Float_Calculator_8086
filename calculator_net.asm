                      name "calc2"
                      include emu8086.inc
; command prompt based simple calculator (+,-,*,/) for 8086.
; example of calculation:
; input 1 <- number: 10
; input 2 <- operator: -
; input 3 <- number: 5
; -------------------
; 10 - 5 = 5
; output -> number: 5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; this maro is copied from emu8086.inc ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this macro prints a char in AL and advances
; the current cursor position:
;PUTC MACRO char
PUSH AX
;MOV AL, char
MOV AH, 0Eh
INT 10h
POP AX
ENDM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
org 100h
jmp start
; define variables:
msg0 db "note: calculator works with integer values only.",0Dh,0Ah
db "to learn how to output the result of a float division see float.asm in examples",0Dh,0Ah,'$'
msg1 db 0Dh,0Ah, 0Dh,0Ah, 'enter first number: $'
msg2 db "enter the operator: + - * / : $"
msg3 db "enter second number: $"
msg4 db 0dh,0ah , 'the approximate result of my calculations is : $'
msg5 db 0dh,0ah ,'thank you for using the calculator! press any key... ', 0Dh,0Ah, '$'
err1 db "wrong operator!", 0Dh,0Ah , '$'
smth db " and something.... $"
; operator can be: '+','-','*','/' or 'q' to exit in the middle.
opr db '?'
; first and second number:
num1 dw ?
num2 dw ?
start:
mov dx, offset msg0
mov ah, 9
int 21h
lea dx, msg1
mov ah, 09h ; output string at ds:dx
int 21h
; get the multi-digit signed number
; from the keyboard, and store
; the result in cx register:
;call scan_num
; store first number:
mov num1, cx
; new line:
putc 0Dh
putc 0Ah
lea dx, msg2
mov ah, 09h ; output string at ds:dx
int 21h
; get operator:
mov ah, 1 ; single char input to AL.
int 21h
mov opr, al
; new line:
putc 0Dh
putc 0Ah
cmp opr, 'q' ; q - exit in the middle.
je exit
cmp opr, '*'
jb wrong_opr
cmp opr, '/'
ja wrong_opr
; output of a string at ds:dx
lea dx, msg3
mov ah, 09h
int 21h
; get the multi-digit signed number
; from the keyboard, and store
; the result in cx register:
;call scan_num
; store second number:
mov num2, cx
lea dx, msg4
mov ah, 09h ; output string at ds:dx
int 21h
; calculate:
cmp opr, '+'
;je do_plus
cmp opr, '-'
je do_minus
cmp opr, '*'
je do_mult
cmp opr, '/'
je do_div
; none of the above....
wrong_opr:
lea dx, err1
mov ah, 09h ; output string at ds:dx
int 21h
exit:
; output of a string at ds:dx
lea dx, msg5
mov ah, 09h
int 21h
; wait for any key...
mov ah, 0
int 16h
ret ; return back to os.
