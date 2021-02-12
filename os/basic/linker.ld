OUTPUT_FORMAT("binary")
OUTPUT(interpret.bin)
ENTRY(start)
SECTIONS
{
   . = 0x9000;
   .text : { *(.boot) *(.text) }
   .rodata : { *(.rodata) }
   .data : { *(.data) }
   .bss : { *(.bss) }
}
