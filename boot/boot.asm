[ORG 0x7c00] ; im at 7c00 in meme
[bits 16]

section .boot:
    jmp start
    %include "sprint.asm"
    %include "load_disk.asm"
start:

;-------- reading from disk--------
    
    call read_disk
    mov si, succ
    call sprint

    cli
    lgdt [gdt_desc]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    jmp CODE_SEG:protected_mode

[bits 32]

protected_mode:

    xor ebx, ebx
    mov ebx, 0x10
    mov ds, ebx
    mov ss, ebx
    mov es, ebx
    mov fs, ebx
    mov gs, ebx

    mov ebp, 0x90000
    mov esp, ebp
    call kernel_entry

kernel_entry:
    mov ebx , pmode
    call print_string_pm
    call 0x1000
    

    jmp $


gdt_start:
    dd 0x0
    dd 0x0
code_segment:
    dw 0xFFFF
    dw 0x0    ; base 
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0

data_segment:
    dw 0xFFFF 
    dw 0x0   
    db 0x0
    db 10010010b
    db 11001111b
    db  0x0
gdt_end:

gdt_desc:
    dw gdt_end - gdt_start - 1
    dd gdt_start
    

;hexstr db "0123456789ABCDEF", 0
;outstr32 db '00000000',0
;reg32 dd 0

; this is how constants are defined
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f ; the color byte for each character

print_string_pm:
    pusha
    mov edx, VIDEO_MEMORY

print_string_pm_loop:
    mov al, [ebx] ; [ebx] is the address of our character
    mov ah, WHITE_ON_BLACK

    cmp al, 0 ; check if end of string
    je print_string_pm_done

    mov [edx], ax ; store character + attribute in video memory
    add ebx, 1 ; next char
    add edx, 2 ; next video memory position

    jmp print_string_pm_loop

print_string_pm_done:
    popa
    ret


CODE_SEG equ 0x08

retrnd db " i returnd haha"
pmode db "welcome to pmode!",0
edisk db "disk error",0
esect db "sect error",0
succ  db "succesuful" , 0
times  510 - ($ -$$) db 0
dw 0xAA55 