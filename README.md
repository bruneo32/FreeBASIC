# FreeBASIC
Modern implementantion of a BASIC operating system in Assembly and C.

## Build
Run `./make.sh` (or `/make.bat` in windows). Assembles and generates `/os/boot.bin`, `/os/main.bin` and `/os/root.bin` intermediate binaries.
Then concatenates into `/bootloader.flp` raw floppy image.

### Build BASIC functions submodule (under Linux only)
Run `./os/basic/make.sh`
Generates `/os/basic/interpret.bin` flat binary, and `/os/basic/interpret` elf32 to be included by the kernel

## Memory map
```
  0x00100000   Special          ===================================================
   384K                         = Reserved VRAM, memory mapped I/O                =
                                =                                                 =
                                =                                                 =
                                =                                                 =
                                =                                                 =
                                =                                                 =
  0x000A0000   Conventional far ===================================================
   640K
  
  0x0000FFFF      Near          ===================================================
        64K                     = BASIC program   22K 22015                       =
                                =                                                 =
                                =                                                 =
  0x0000AA00                    ===================================================
                                = OS  kernel 0x7e00 interpreter 0x9e00            =
                                =        KIT 0x7F00         MIT 0x9800            =
  0x00007E00                    ===================================================
                                = BOOT bootloader        1K     1024              =
  0x00007C00                    ===================================================
                                = BRFS   0x7A00  0x7BFF  0.5K   511               =
                                = Stack  0x0500  0x79FF  30K    29951             =
  0x00000500                    ===================================================
                                = BDA    0x0400  0x04FF  0.25K  255               =
  0x00000400                    ===================================================
                                = IVT    0x0000  0x03FF  1K     1023              =
  0x00000000                    ===================================================
                                
```
