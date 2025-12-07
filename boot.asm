bits 16
org 0x7c00
loading:
  mov si, 0
  .loop:
  call delay       
  mov dh, 12       
  mov dl, 40 
  call movcursor
  mov ah, 0x0e
  mov al, [load+si]
  int 0x10
  inc si
  cmp byte [load+si],0
  jne .loop
  mov si, 0
  jmp .loop
movcursor:
  mov ah,2
  mov bh, 0
  int 0x10
  ret
delay: 
  mov ah,0x86
  mov cx,0x0002    
  mov dx,0x86A0    
  int 0x15
  ret
load:
  db "-\|/", 0
times 510-($-$$) db 0
dw 0xAA55


