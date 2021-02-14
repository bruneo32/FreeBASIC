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
Total space              1MiB
  0x00100000   Special          ===================================================    *Each line 64K
   384K                         = Reserved VRAM, memory mapped I/O                =
                                =                                                 =
                                =                        384K   393215            =
                                =                                                 =
                                =                                                 =
                                =                                                 =
  0x000A0000   Conventional far ===================================================
   640K                         = Machine language program or                     =
                                = extra interpreter space                         =
                                =                        576K   589823            =
                                =                                                 =
                                =                                                 =
                                =                                                 =
                                =                                                 =
                                =                                                 =
                                =                                                 =
  0x00010000                    ===================================================
                                = Near space, described below                     =
  0x00000000                    ===================================================
                                
Near addressable space   64K
  0xFFFF                        ===================================================    *Each line 4K
                                = BASIC program          22K    22015             =
                                =                                                 =
                                =                                                 =
                                =                                                 =
                                =                                                 =
                                =                                                 =
  0xAA00                        ===================================================
                                = OS  kernel     0x7e00 interpreter 0x9e00        =
                                =        KIT     0x7F00         MIT 0x9800        =
                                =                        11K    11263             =
  0x7E00                        ===================================================
                                = BOOT bootloader        1K     1024              =
  0x7C00                        ===================================================
                                = BRFS   0x7A00  0x7BFF  0.5K   511               =
                                = Stack  0x0500  0x79FF  30K    29951             =
                                =                                                 =
                                =                                                 =
                                =                                                 =
                                =                                                 =
                                =                                                 =
                                =                                                 =
  0x0500                        ===================================================
                                = BDA    0x0400  0x04FF  0.25K  255               =
  0x0400                        ===================================================
                                = IVT    0x0000  0x03FF  1K     1023              =
  0x0000                        ===================================================
```
