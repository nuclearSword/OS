
[ORG 0x1000]
    jmp start
    %include "boot/sprint.asm"
start:
    ret 


printreg32:
    pusha

    mov edi, outstr32
    mov eax, [reg32]
    mov esi, hexstr
    mov ecx , 8
hexloop: 
    rol eax, 4
    mov ebx, eax
    and ebx, 0x0f
    mov bl, [esi + ebx]
    mov [edi], bl
    inc edi 
    dec ecx 
    jnz hexloop

    mov esi, outstr32
    call sprint

    popa
    ret 


stage2 db "hey im instage2", 0
pmode db "hey im in pmode",0
hexstr db "0123456789ABCDEF", 0
outstr32 db '00000000',0
reg32 dd 0
code_seg equ 0x8




    