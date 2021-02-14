@echo off
Setlocal EnableDelayedExpansion
echo.

objdump -D -Mintel,i8086 -b binary -m i386 core.bin>core.debug

REM pause