echo cat
cat interpret.bin
echo
echo dump
hexdump interpret.bin
echo disasm bin
objdump -D -Mintel,i8086 -b binary -m i386 interpret.bin
echo disasm elf
objdump -d -Mintel,i8086 interpret > listing.lst

