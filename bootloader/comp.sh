nasm -f bin bootloader.asm -o bootloader
dd conv=notrunc if=bootloader of=disk.img bs=512 count=1 seek=0
qemu-system-i386 -machine q35 -fda disk.img -gdb tcp::26000 -S

