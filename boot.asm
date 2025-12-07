bits 16 
org 0x7c00
mov si, 0 
print:
  mov ah, 0x0e
  mov al, [hello+si]
  int 0x10
  add si,1
  cmp byte [hello+si], 0 
  jne print
mov si, 0 
mov al, 0
jmp input
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
hlt
halt:
  hlt
hello:
  db "Enter the number to check: ", 0
hellow:
  db "hello world", 0

times 510-($-$$) db 0
dw 0xAA55


