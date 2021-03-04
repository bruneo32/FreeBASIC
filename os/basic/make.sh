./perm.sh

echo intermediate
nasm -f elf32 					            src/entry.asm -o 		obj/entry.o
ia16-elf-gcc -Wall -fno-builtin -fstack-usage -c		    src/main.c -o 		    obj/main.o
ia16-elf-gcc -Wall -fno-builtin -fstack-usage -c		    src/aux.c -o 		    obj/aux.o

echo elf
ia16-elf-gcc -T linkerelf.ld -nostartfiles 	obj/entry.o obj/main.o obj/aux.o    #-o         interpret
echo bin
ia16-elf-gcc -T linker.ld -nostartfiles 	obj/entry.o obj/main.o obj/aux.o	#-o 	    interpret.bin
