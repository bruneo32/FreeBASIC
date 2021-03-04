/*INPUT(entry.o, main.o)*/
OUTPUT_FORMAT("elf32-i386")
OUTPUT(core)
ENTRY(_interpret)
SECTIONS
{
   . = 0x5000;
   .text : { *(.boot) *(.text) }
   .rodata : { *(.rodata) }
   .data : { *(.data) }
   .bss : { *(.bss) }
}
