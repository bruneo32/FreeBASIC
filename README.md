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
                  = General purpose space                           =
                  =                                                 =
                  = Used by the interpreter, *.prg programs and     =
                  = similar stuff.                                  =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                  64K : 65534    =
  0x10000         ===================================================
  
  0xFFFF          =================================================== <--  Maximum accessible in 16-bits addressing.
                  = Program Space                     9K : 9727     =
                  =                                                 =
  0xDA00          ===================================================
                  = BASIC program                    12K : 12288    =
                  = (plain text)                                    =
                  =                                                 =
                  =                                                 =
  0xAA00          ===================================================
                  = OS  kernel                                      =
                  =                                                 =
                  =                                                 =
                  =                                                 = --> KIT: 0x7F00 (length: 32 bytes)
                  =                                  11K : 11264    =
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
                  = Stack          0x0500  0x4FFF    19K : 29440    =
                  =                                                 =
                  =                                                 =
                  =                                                 =
                  =                                                 =
  0x0500          ===================================================
                  = BDA            0x0400  0x04FF  0.25K : 256      =
  0x0400          ===================================================
                  = IVT            0x0000  0x03FF     1K : 1024     =
  0x0000          ===================================================
```
