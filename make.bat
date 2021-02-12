@echo off
Setlocal EnableDelayedExpansion
echo.

cd os

nasm boot.asm -f bin -o boot.bin
nasm main.asm -f bin -o main.bin
nasm root.asm -f bin -o root.bin

cd ..

copy /b os\boot.bin+os\main.bin+os\root.bin bootloader.flp

pause
