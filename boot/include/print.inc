




show_all_reg:
    mov esi, eax_reg
    call sprint
    mov [reg32], eax
    call printreg32

    mov esi, ebx_reg
    call sprint
    mov [reg32], ebx
    call printreg32

    mov esi, ecx_reg
    call sprint
    mov [reg32], ecx
    call printreg32

    mov esi, edx_reg
    call sprint
    mov [reg32], edx
    call printreg32

    mov esi, esi_reg
    call sprint
    mov [reg32], edi
    call printreg32
    
    mov esi, edi_reg
    call sprint
    mov [reg32], esi
    call printreg32





msg db "aaaa youssef? ", 0
eax_reg db "eax: ", 0
ebx_reg db "ebx: ", 0
ecx_reg db "ecx: ", 0
edx_reg db "edx: ", 0
esi_reg db "esi: ", 0
edi_reg db "edi: ", 0
