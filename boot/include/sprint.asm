
dochar: 
    call cprint 
    jmp sloop

sprint: 
    pusha
    
sloop:
    mov eax , [esi]                  
    lea esi , [esi + 1]

    cmp al, 0                 
    jne dochar

    inc byte [xpos]
    popa
    ret

cprint: 
    mov ah, 0x0f
    mov ecx, eax 

    movzx eax, byte [ypos]
    mov edx, 160
    mul edx 
    movzx ebx, byte [xpos]
    shl ebx,1
    mov edi, 0x0b8000
    add edi, eax
    add edi, ebx

    mov eax, ecx
    mov word [es:edi], ax
    inc byte [xpos]
    ret

xpos db 0
ypos db 0