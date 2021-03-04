echo cat
cat core.bin
echo
echo dump
hexdump core.bin
echo disasm bin
objdump -D -Mintel,i8086 -b binary -m i386 core.bin
echo disasm elf
objdump -d -Mintel,i8086 core
objdump -d -Mintel,i8086 core > listing.lst

