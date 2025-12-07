bits 16 
org 0x7c00
mov si, 0
call clearscreen
print:
  mov ah, 0x0e
  mov al, [hello+si]
  int 0x10
  add si,1
  cmp byte [hello+si], 0 
  jne print
mov si, 0 
mov al, 0
call input
jmp prime
input: 
  mov ah, 0x00
  int 0x16
  cmp al,0x0D
  je prime
  imul si, 10
  mov ah, 0x0e
  int 0x10
  sub al, '0'
  movzx ax, al
  add si, ax
  jmp input
prime: 
  mov di, 0
  mov cx, 1 
  .loop:
  mov ax, si
  mov dx,0
  mov bx,cx
  div bx
  cmp dx, 0
  je incdi
  .continue:
  inc cx
  cmp cx, si
  jle .loop
  jmp output
output:
  cmp di, 2
  jg print0
  jle print1
print1:
  mov si, 1
  jmp printnumber
  hlt
print0:
  mov si, 0 
  jmp printnumber
incdi:
  inc di
  jmp prime.continue
reverse:
  imul di, 10
  mov ax,si
  mov dx,0
  mov bx,10
  div bx
  mov si, ax
  add di, dx
  cmp si, 0 
  jne reverse
  mov si, di
  jmp printnumber
printnumber:
  mov ax,si
  mov dx,0
  mov bx,10
  div bx
  mov si, ax
  add dl, '0'
  mov al, dl 
  mov ah, 0x0e 
  int 0x10
  cmp si, 0
  jne printnumber
jmp $
halt:
  hlt
hello:
  db "Enter the number to check: ", 0
hellow:
  db "hello world", 0
clearscreen:
    push bp
    mov bp, sp
    pusha

    mov ah, 0x07        ; tells BIOS to scroll down window
    mov al, 0x00           ; clear entire window
    mov bh, 0x1F            ; white on black
    mov cx, 0x00        ; specifies top left of screen as (0,0)
    mov dh, 0x50        ; 18h = 24 rows of chars
    mov dl, 0x4f        ; 4fh = 79 cols of chars
    int 0x10        ; calls video interrupt

    popa
    mov sp, bp
    pop bp
    ret
times 510-($-$$) db 0
dw 0xAA55


