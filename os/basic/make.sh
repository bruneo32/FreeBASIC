./perm.sh

echo intermediate
nasm -f elf32 					entry.asm -o 		entry.o
ia16-elf-gcc -Wall -fno-builtin -c		main.c -o 		main.o

echo elf
ia16-elf-gcc -T linkerelf.ld -nostartfiles 	entry.o main.o  #-o      interpret
echo bin
ia16-elf-gcc -T linker.ld -nostartfiles 	entry.o main.o 	#-o 	interpret.bin

