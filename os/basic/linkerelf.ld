OUTPUT_FORMAT("elf32-i386")
OUTPUT(interpret)
ENTRY(start)
SECTIONS
{
   . = 0x9000;
   .text : { *(.boot) *(.text) }
   .rodata : { *(.rodata) }
   .data : { *(.data) }
   .bss : { *(.bss) }
}
