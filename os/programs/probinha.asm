[org 0xda00]

start:

call word [0x7f02] ; PrintLn
mov si, .str
call word [0x7f04] ; PrintStringLn

call word [0x7f0c] ; __ensure
cmp bl, byte 0 ; ENTER?
jz start

jmp word [0x7f16] ; Exit

.str:
	db 'Buenos días!',0
