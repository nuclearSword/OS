
[ORG 0x7c00]
    jmp start

    %include "print.inc"
start:xor ax,ax
    mov ds, ax
    mov ss, ax
    mov sp, 0x9c00

    push ds
    cli

    lgdt [gdt_info]

    mov eax, cr0 
    or al, 1
    mov cr0, eax 

    mov bx, 0x08
    mov ds, bx


    sti
    pop ds

    mov dl, 'A'    ; Move the character to print into the DL register
    mov ah, 02h    ; Set AH to 02h for the "Print Character" function of 
    int 21h

    mov esi, hello
    call sprint


    mov esi, ask
    call sprint
    call show_all_reg

    cli
hang:
    jmp hang


hello db "hey to my os", 0
ask  db " what do you wanna do?", 0

gdt_info:
    dw gdt_end - gdt_start - 1
    dd gdt_start

gdt_start:
    gdt dd 0x0000,0x0000
    data_entry:
        db 0xff             ;lower limit 
        db 0xff
        db 0x00
        db 0x00
        db 0x00
        db 10010010b
        db 11001111b
        db 0x00

gdt_end:
    times  510-($-$$) db 0
    dw 0xAA55 
