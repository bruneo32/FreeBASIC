nasm os/boot.asm -f bin -o os/boot.bin
nasm os/main.asm -f bin -o os/main.bin
nasm os/root.asm -f bin -o os/root.bin

cat os/boot.bin os/main.bin os/root.bin > bootloader.flp
