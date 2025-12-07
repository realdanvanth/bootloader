bits 16
org 0xc700
mov al,'0'
mov si, 0
call input
call printsi
jmp halt
printsi:
  mov di, 0
  .loop1:
  inc di
  mov ax, si
  mov dx, 0 
  mov bx, 10
  div bx
  mov si, ax
  add dl, '0'
  mov ah, 0 
  mov al, dl 
  push ax
  cmp si, 0 
  jne .loop1
  .loop2:
  pop ax
  mov ah, 0x0e
  int 0x10
  dec di
  cmp di, 0
  jne .loop2
  ret
input:
  mov si, 0
  mov al, '0'       
  .loop:
    imul si, 10
    sub al, '0'
    movzx ax, al    ;si can only take 16 bits
    add si,ax
    mov ah, 0x00    ;input interrupt
    int 0x16
    mov ah, 0x0e
    int 0x10
    cmp al, 0x0D    ;check if its enter
    jne .loop
  mov al,0x0A       ;new line
  int 0x10
  ret
clearscreen:
    push bp
    mov bp, sp
    pusha

    mov ah, 0x07    ; tells BIOS to scroll down window
    mov al, 0x00    ; clear entire window
    mov bh, 0x1F    ; white on black
    mov cx, 0x00    ; specifies top left of screen as (0,0)
    mov dh, 0x50    ; 18h = 24 rows of chars
    mov dl, 0x4f    ; 4fh = 79 cols of chars
    int 0x10        ; calls video interrupt

    popa
    mov sp, bp
    pop bp
    ret
halt:
  mov ah, 0x0e
  mov al, '@'
  int 0x10
  hlt
  jmp halt
times 510-($-$$) db 0
dw 0xAA55

