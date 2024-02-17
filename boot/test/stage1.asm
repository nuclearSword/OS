[ORG 0x7c00]
    jmp start


start:
    mov ah, 0x0E  ; AH = 0x0E corresponds to the BIOS teletype output function
    mov al, dl   ; AL = the character to print
    int 0x10      ; Invoke interrupt 10h
    mov ah, 0x0E  ; AH = 0x0E corresponds to the BIOS teletype output function
    mov al, 'T'   ; AL = the character to print
    int 0x10  
    cli                    
 
    mov  ax, cs            
    mov  ds, ax            
    mov  es, ax            
    mov  ss, ax            
    mov  sp, 0x7C00        
    sti                    


sect_per_fat dq  0x000007d1
dw fflags 0x0
dw cluster_of_root_dir 0x02
dw fsInfo_sect 0x01
dw backup_boot 0x06
dd free_clust_count 0x03e828
cluster_number dq 0x18

reserved sector count + tablecount * fat_sie + rootdir sect
bytes_per_sect dw 0x200
sect_per_cluster db 0x1
reserv_sect dw 0x20
sect_per_track dw 0x20
heads dw 0x08
sect_count dd 0x03f800