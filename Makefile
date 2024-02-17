#/Users/scythe/Desktop/Projects/workstation/lowLearning/myBootloader

SYS_HEADERS_DIR := /mnt/c/cygwin64/home/scythe/myOS/sysroot/usr/include
SYS_LIB_DIR := /mnt/c/cygwin64/home/scythe/myOS/sysroot/usr/lib
MAIN_DIR := /mnt/c/cygwin64/home/scythe/myOS/sysroot/boot
CC = i686-elf-gcc.exe -ffreestanding -O2 -Wall -Wextra -c -g  -isystem=/usr/include
C_SRCS = $(wildcard kernel/*.c drivers/*.c)
C_OBJS = ${C_SRCS:.c=.o}
HEADERS = $(wildcard kernel/headers/*.h drivers/headers/*.h)

DISK_IMAGE := build/disk_image_gpt.img
BOOT_BIN := boot/boot.bin
KERNEL_BIN := build/kernel.bin

default: final


%.o : %.asm 
	nasm $< -f elf -o $@

%.o : %.c ${HEADERS}
	$(CC) $< -o $@

%.bin : %.asm
	nasm $< -f bin -I boot/include/ -o $@ 


$(KERNEL_BIN): kernel/entry.o ${C_OBJS}
	i686-elf-ld.exe -o build/kernel.elf -Ttext 0x1000 $^ 
	i686-elf-ld.exe -o $@ -Ttext 0x1000 $^ --oformat binary 
	
$(DISK_IMAGE):$(BOOT_BIN)  $(KERNEL_BIN) 
	dd if=/dev/zero of=$@ bs=1048576 count=128

	dd if=$< of=$@ conv=notrunc
	dd if=$(KERNEL_BIN) of=$@  obs=512 seek=1 conv=notrunc

debug: $(DISK_IMAGE) 
	qemu-system-i386.exe -s -drive format=raw,file=$< &
	gdb -ex "set disassembly-flavor intel" -ex "target remote localhost:1234" -ex "symbol-file build/kernel.elf"

final: $(DISK_IMAGE)
	qemu-system-i386.exe -s -drive format=raw,file=$<

clean:
	rm -f  boot/*.bin  kernel/*.o  drivers/*.o  build/*


#--------------compiling---linkin--------------#
#i686-elf-as .\boot\myBoot.s -o .\boot\boot.o
#
#i686-elf-gcc -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib .\boot\boot.o .\kernel\kernel.o -lgcc


#---------------bootabledisk---------------#

#PROJDIRS := boot includes internals
#BASE := 2
#EXP := 20

#FIRST_SECTOR := 2048
#last_sector := 262110
#sectorsPerTrack = 0x20
#nbrHeads = 0x8
#rootDirEntries = 0x200
#totalSectors_fat = 0x03f800

#create a gpt partitioni and adds a fat16 file system
#printf "g \n n\n \n \n \n t\n 1\n w\n " | fdisk $(DISK_IMAGE)
#mkfs.vfat -F 32 -n "EFI SYSTEM"  --offset=$(FIRST_SECTOR) $(DISK_IMAGE)
#b is offset 
#imdisk.exe -a -t file -f ./build/disk_image_gpt.img -b 1048576 -m X: -o rem
#cp.exe $(BIN_STAGE2) X:/
#imdisk.exe -D -m X:   
