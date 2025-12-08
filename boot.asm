bits 16
org 0x7c00
diskNum:
 db 0
mov [diskNum], dl
call read_disk
mov ah, 0x0e
mov al, [0x7e00]
int 0x10
jmp $
start:
  call input
  call prime
  call print
  call loading
  jmp $
prime:
  mov di, 0 
  mov cx, 1
  .loop: 
    inc cx
    mov bx, cx
    call divide
    cmp cx, si
    jge .out 
    cmp dx, 0
    jne .loop
    inc di
    jmp .loop
  .out:
  cmp di, 0
  jg .notprime
  mov si, isprime
  mov dh, 11
  mov dl, 32
  call movcursor
  call clearscreen
  ret
  .notprime:
  mov si, isnotprime
  jmp start
  ret 
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
print:
  mov ah, 0x0e
  lodsb
  int 0x10
  cmp al, 0
  jne print
  ret
delay: 
  mov ah,0x86
  mov cx,0x0002    
  mov dx,0x86A0    
  int 0x15
  ret
divide:
  mov ax, si
  mov dx, 0 
  div bx 
  ret
halt:
  mov ah, 0x0e
  mov al, '@'
  int 0x10
  hlt
  jmp halt
isprime:
  db "Access Granted ", 0
isnotprime:
  db "Access Denied Restart", 0
read_disk:
  pusha
  mov ah, 2
  mov al, 1 ; no of secs to read
  mov ch, 0 ;cylinder number 0x7ee
  mov cl, 2 ; sector no
  mov dh, 0 ; headnumber
  mov dl, [diskNum] ;drive numver
  xor ax, ax
  mov es, ax
  mov bx, 0x7e00
  int 0x13
  popa
  jc halt
  ret
load:
  db "-\|/", 0
times 510-($-$$) db 0
dw 0xAA55
times 512 db 'A'


