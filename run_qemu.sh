#!/bin/bash
qemu-system-i386.exe -s -drive format=raw,file=build/disk_image_gpt.img
qemu-system-i386.exe -drive format=raw,file=build/disk_image_gpt.img -S -gdb tcp::1234