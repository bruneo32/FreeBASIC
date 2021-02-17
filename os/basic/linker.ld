/*INPUT(entry.o, main.o)*/
OUTPUT_FORMAT("binary")
OUTPUT(core.bin)
ENTRY(_interpret)
SECTIONS
{
   . = 0x9e00;
   .text : { *(.boot) *(.text) }
   .rodata : { *(.rodata) }
   .data : { *(.data) }
   .bss : { *(.bss) }
}
