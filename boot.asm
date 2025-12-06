bits 16
org 0x7c00 ; the first address to be loaded when a computer starts 

mov si, 0
mov ax, 0x1110
mov al, 20
int 0x10
print: 
  mov ah, 0x0e ;video interuppt , to display text 0x0e
  mov al, [hello + si]; print what ever is in al
  int 0x10 ;bios interuppt to do that 0x10
  add si, 1
  cmp byte [hello + si], 0
  jne print
mov si, 0 
input:
  mov ah, 0x00
  int 0x16
  cmp al, 0X0D; enter key
  je halt
  mov ah, 0x0e
  mov al, '0'
  int 0x10
  jmp input
halt:    
  jmp $ ; infinite loop $ means go to that line 
hello:
  db "hello world", 0 
times 510 - ($ - $$) db 0  ; fill the remaining bytes with 0 since we have to fill 512 bytes
dw 0xAA55 ; every program ends with this 2 bytes 
