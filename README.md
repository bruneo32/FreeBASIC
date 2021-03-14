![version](https://img.shields.io/badge/version-0.1-tomato.svg)
![version](https://img.shields.io/badge/license-GPL3-orangered.svg)

Nowadays, it have many errors and problems. Please wait for version `>0.5` to clone this repo.
<br><br>


# FreeBASIC
Modern implementantion of a BASIC operating system in Assembly and C.

## Build
Run `./make.sh` (or `/make.bat` in windows). Assembles and generates `/os/boot.bin`, `/os/main.bin` and `/os/root.bin` intermediate binaries.
Then concatenates into `/bootloader.flp` raw floppy image.

### Build BASIC functions submodule (under Linux only)
Run `./os/basic/make.sh`
Generates `/os/basic/interpret.bin` flat binary, and `/os/basic/interpret` elf32 to be included by the kernel

## Limitations
```
Maximum BASIC line length:            300     characters
Maximum BASIC line number:            65536
Maximum BASIC program length:         12287   characters (with NUL)
```

## Memory map
```
                    /\  /\  /\  /\  /\  /\  /\  /\  /\  /\  /\  /\  
Total space        /  \/  \/  \/  \/  \/  \/  \/  \/  \/  \/  \/  \
  0x000FFFFF      =================================================== 1MiB
   384K           = Reserved VRAM, memory mapped I/O,               =
                  = more BIOS stuff                                 =
                  =                                                 =
  0x9fc00         ===================================================
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                      FREE                       =
                  =                 (Unreacheable)                  =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
  0x1FFFE         =================================================== <--  Maximum accessible with FreeBASIC extended addresing.
                  = Extended space: General purpose                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                  64K : 65534    =
  0x10000         ===================================================
  
  0xFFFF          =================================================== <--  Maximum accessible in 16-bits addressing.
                  = Program Space                    12K : 12709     =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
  0xCE00          ===================================================
                  = BASIC program                    32K : 32356    =
                  = (plain text)                                    =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
  0x7E00          ===================================================
                  = Bootloader                      0.5K : 512      =
  0x7C00          ===================================================
                  = BRFS_TRS       0x7A00  0x7BFF   0.5K : 512      =
  0x7A00          ===================================================
                  = BRFS_TWS       0x7800  0x79FF   0.5K : 512      =
  0x7800          ===================================================
                  = BASIC Module   0x5000  0x77FF    10K : 10240    =
                  =                                                 =
                  =                                                 =
                  =                                                 =
  0x5000          =================================================== --> MIT: 0x5000 (length: 32 bytes)
                  = OS  kernel     0x1000  0x4FFF    16K : 16384    =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 = --> KIT: 0x1100 (length: 64 bytes)
  0x1000          ===================================================
                  = Stack          0x0500  0x0FFF     2K : 2816     =
                  =                                                 =
  0x0500          ===================================================
                  = BDA            0x0400  0x04FF  0.25K : 256      =
  0x0400          ===================================================
                  = IVT            0x0000  0x03FF     1K : 1024     =
  0x0000          ===================================================
```
