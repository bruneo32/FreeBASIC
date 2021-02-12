@echo off
Setlocal EnableDelayedExpansion
echo.

cd os

nasm boot.asm -f bin -o boot.bin
copy /b boot.bin ..\boot.bin
del boot.bin

nasm main.asm -f bin -o main.bin
copy /b main.bin ..\main.bin
del main.bin

nasm root.asm -f bin -o root.bin
copy /b root.bin ..\root.bin
del root.bin

cd ..

copy /b boot.bin+main.bin+root.bin bootloader.flp
del boot.bin
del main.bin
del root.bin

pause