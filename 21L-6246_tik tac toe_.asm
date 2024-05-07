[org 0x0100]
jmp start
str1:	db 'TIC TAC TOE',0
str2:	db 'Created by',0
name:   db 'Aroz Imran 21L-6246',0
P1_winning_msg: db 'Player 1 wins!!!',10,0
P2_winning_msg: db 'Player 2 wins!!!',10,0
draw_msg: db 'Game drawn!!!',10,0
menu: db 'Enter these numbers to fill the Grid(00,01,02,03,10,11,12,13,20,21,22,23,30,31,32,33) 00 for topLeft and 33 for bottom right and so on!!!',10,0
userInputRow: db 0
userInputCol: db 0
row1: db ' | | | ',10,0   
row2: db ' | | | ',10,0
row3: db ' | | | ',10,0
row4: db ' | | | ',10,0

separator:  db '--------',10,0
gridSeparator: db '------------------------',10,0

;SUBROUTINES
clear:
	pusha
	mov ax,0xb800
	mov es,ax
	mov di,0
clr:
	mov word[es:di],0xBB20
	add di,2
	cmp di,4000
	jl clr
	popa
	ret
info:;function for the intro page of game
	push bp
	mov bp, sp
	push 34
	push 8
	push 4
	push str1
call printstr3
call sleep
	push 35
	push 10
	push 5
	push str2	
call printstr3
call sleep
	push 28
	push 14
	push 2
	push name
call printstr3
call sleep

	pop bp
	ret 2


clrscr:
push es
push ax
push di
mov ax , 0xb800
mov es,ax
mov di,0
nextchar0:
mov word[es:di],0x0720
add di,2
cmp di,4000
jne nextchar0
pop di
pop ax
pop es
ret
strlen: push bp 
 mov bp,sp 
 push es 
 push cx 
 push di 
 les di, [bp+4] ; point es:di to string 
 mov cx, 0xffff ; load maximum number in cx 
 xor al, al ; load a zero in al 
 repne scasb ; find zero in the string 
 mov ax, 0xffff ; load maximum number in ax 
 sub ax, cx ; find change in cx 
 dec ax ; exclude null from length 
 pop di 
 pop cx 
 pop es 
 pop bp 
 ret 4 
sleep:
push cx
push dx
mov dx,10
sleep1:
mov cx,0xFFFF
delay:
loop delay
dec dx
cmp dx,0
jne sleep1
pop dx
pop cx
ret

printstr3: 
	push bp
	mov bp, sp
	push es
	push ax
	push cx
	push si
	push di
	push ds
	mov ax, [bp+4]
	push ax
	call strlen 
	cmp ax, 0
	jz exit2
	mov cx, ax
	mov ax, 0xb800
	mov es, ax
	mov al, 80
	mul byte [bp+8]
	add ax, [bp+10]
	shl ax, 1
	mov di,ax
	mov si, [bp+4]
	mov ah, [bp+6]
	cld 
nextchar1: 
	lodsb
	stosw
	loop nextchar1 
exit2: 
	pop di
	pop si
	pop cx
	pop ax
	pop es
	pop bp
	ret 8

print:
mov si,dx           
printLoop:
mov cl,[si]      
inc si           
cmp cl, 0 
jne printLoop
dec si  
sub si,dx
mov cx,si    

mov ah, 0x40	
mov bx, 0x01    
int 0x21
ret 

inputMove:
mov ah,0x07       
int 0x21            
sub al, 0x30 		 
mov [userInputRow],al

mov ah, 0x07			
int 0x21
sub al, 0x30
mov [userInputCol],al
ret 

updateBoard:
xor  ax,ax
xor  cx,cx
mov  al,[userInputCol]
mov  cl,[userInputRow]
cmp ax,0
jz j1
jmp j2
j1:
jmp c0
j2:
cmp ax,1
jz lops
jmp lops1
lops:
jmp c1
lops1:
cmp ax,2
jz c2
cmp ax,3
jz c3
;-------------------------------
c3:
cmp cx,0
jz a1
cmp cx,1
jz a2
cmp cx,2
jz a3
cmp cx,3
jz a4
a4:
mov si,33
add si,row1
mov [si],dl
ret

a3:
mov si,24
add si,row1
mov [si],dl
ret
a2:
mov si,15
add si,row1
mov [si],dl
ret
a1:
mov si,6
add si,row1
mov [si],dl
ret
	
;-----------------------
c2:
cmp cx,0
jz lop1
cmp cx,1
jz lop2
cmp cx,2
jz lop3
cmp cx,3
jz lop4
lop4:
mov si,31
add si,row1
mov [si],dl
ret

lop3:
mov si,22
add si,row1
mov [si],dl
ret
lop2:
mov si,13
add si,row1
mov [si],dl
ret
lop1:
mov si,4
add si,row1
mov [si],dl
ret

;-----------------------
c1:
cmp cx,0
jz b
cmp cx,1
jz c
cmp cx,2
jz d
cmp cx,3
jz e
e:
mov si,29
add si,row1
mov [si],dl
ret

d:
mov si,20
add si,row1
mov [si],dl
ret
c:
mov si,11
add si,row1
mov [si],dl
ret
b:
mov si,2
add si,row1
mov [si],dl
ret
;------------------------------
c0:
cmp cx,0
jz q2
cmp cx,1
jz q3
cmp cx,2
jz q4
cmp cx,3
jz q5
q5:
mov si,27
add si,row1
mov [si],dl
ret

q4:
mov si,18
add si,row1
mov [si],dl
ret
q3:
mov si,9
add si,row1
mov [si],dl
ret
q2:
mov si,0
add si,row1
mov [si],dl
ret


printBoard:
push dx
mov dx,row1
call print
mov dx,separator
call print

mov dx,row2
call print
mov dx,separator
call print

mov dx,row3
call print
mov dx,separator
call print

mov dx,row4
call print


pop dx
ret 

;MAIN PROGRAM



start:
call clrscr
call clear
call info
call sleep
call sleep
call sleep
call sleep
call sleep
call sleep
call sleep
call sleep

mov dx, menu 
call print  
mov cx,16
mov dl,'1'
looop:
push cx
push dx
mov dx, gridSeparator
call print
call inputMove
pop dx

call updateBoard
call clrscr
call printBoard

cmp dl,'1'
je  l1
mov dl,'1'
jmp en
l1:
mov dl,'2'
en:
push dx

checkWin:
mov si,row1
mov cx,4
rowLoop:
push cx       
xor cx,cx     
mov cl,[si]   
mov ax,cx     
mov cl,[si+2] 
add ax,cx     
mov cl,[si+4] 
add ax,cx
mov cl,[si+6] 
add ax,cx     
cmp ax,4*'2'  
je f1
jmp f2
f1:
jmp found
f2:	
cmp ax,4*'1'  
je f3
jmp f4
f3:
jmp found
f4:
add si,9   
pop cx        
dec cx      
jne rowLoop 
mov si,row1
mov cx,4

colLoop:

push cx       
xor cx,cx     
mov cl,[si]   
mov ax,cx     
mov cl,[si+9] 
add ax,cx     
mov cl,[si+2*9] 
add ax,cx    
mov cl,[si+3*9] 
add ax,cx 
cmp ax,4*'2' 
je found
cmp ax,4*'1'  
je found
add si,2      
pop cx        
dec cx        
jne colLoop 

mov si,row1
xor cx,cx     
mov cl,[si]   
mov ax,cx     
mov cl,[si+10+1]
add ax,cx     
mov cl,[si+2*10+2]
add ax,cx    
mov cl,[si+3*10+3]
add ax,cx    
cmp ax,4*'2'  
je found
cmp ax,4*'1'  
je found

mov si,row1
xor cx,cx     
mov cl,[si+6] 
mov ax,cx     
mov cl,[si+10+3]
add ax,cx     
mov cl,[si+2*10]
add ax,cx   
mov cl,[si+3*9]
add ax,cx    
cmp ax,4*'2'  
je found
cmp ax,4*'1'  
je found

pop dx
pop cx
dec cx
jne looop
found:
cmp ax,4*'2'
je P2_wins
cmp ax,4*'1'
jne draw
mov dx, P1_winning_msg
call print
jmp exit
P2_wins:
mov dx, P2_winning_msg
call print
jmp exit
draw:
mov dx, draw_msg
call print

exit:
mov ax, 0x4c00
int 0x21