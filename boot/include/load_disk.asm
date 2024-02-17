read_disk:   
    mov bx, 0x1000
    mov AH, 0x02
    mov AL, 0x16
    mov CH, 0x0
    mov CL, 0x02
    int 0x13

    jc disk_error

    cmp al, 0x16
    jne sect_error
    ret
   
disk_error:
    mov si, edisk
    call sprint
    jmp $


sect_error:
    mov si, esect
    call sprint
    jmp $

