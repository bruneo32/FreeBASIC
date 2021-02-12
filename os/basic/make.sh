./perm.sh
nasm -f elf32 					entry.asm -o 		entry.o
ia16-elf-gcc -Wall -c	 			main.c -o 		main.o

ia16-elf-gcc -T linkerelf.ld -nostartfiles 	entry.o main.o  -o      interpret
ia16-elf-gcc -T linker.ld -nostartfiles 	entry.o main.o 	-o 	interpret.bin

