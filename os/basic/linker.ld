OUTPUT_FORMAT("binary")
OUTPUT(interpret.bin)
ENTRY(_interpret)
SECTIONS
{
   . = 0x9e00;
   .text : { *(.boot) *(.text) }
   .rodata : { *(.rodata) }
   .data : { *(.data) }
   .bss : { *(.bss) }
}
