OUTPUT_FORMAT("elf32-i386")
OUTPUT(interpret)
ENTRY(_interpret)
SECTIONS
{
   . = 0x9e00;
   .text : { *(.boot) *(.text) }
   .rodata : { *(.rodata) }
   .data : { *(.data) }
   .bss : { *(.bss) }
}
