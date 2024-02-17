
[ORG 0x7c00] ; im at 7c00 in meme

    jmp start
start:
    mov ah, 0x0e
    mov al, sec +0x7c00
    int 0x10


sec db 'X' 

times  510 - ($ -$$) db 0
dw 0xAA55 