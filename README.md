# FreeBASIC
Modern implementantion of a BASIC operating system in Assembly and C.

## Build
Run `./make.sh` (or `/make.bat` in windows). Assembles and generates `/os/boot.bin`, `/os/main.bin` and `/os/boot.bin` intermediate binaries.
Then concatenates into `/bootloader.flp` raw floppy image.

### Build BASIC interpreter submodule (under Linux only)
Run `./os/basic/make.sh`
Generates `/os/basic/interpret.bin` flat binary, and `/os/basic/interpret` elf32 to be included by the kernel
