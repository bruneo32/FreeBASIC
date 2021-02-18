@echo off
Setlocal EnableDelayedExpansion
echo.

cd os

cd data
nasm bootdisk.asm -f bin -o bootdisk.bin
cd ..

nasm boot.asm -f bin -o boot.bin
nasm main.asm -f bin -o main.bin
nasm bascore.asm -f bin -o bascore.bin
nasm root.asm -f bin -o root.bin



cd ..

copy /b os\boot.bin+os\main.bin+os\bascore.bin+os\root.bin bootloader.flp
objdump -D -Mintel,i8086 -b binary -m i386 bootloader.flp>bootloader.debug

del os\boot.bin
del os\main.bin
del os\bascore.bin
del os\root.bin
pause