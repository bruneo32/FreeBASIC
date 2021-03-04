[org 0xce00]

start:

call word [0x1102] ; PrintLn
mov si, .str
call word [0x1104] ; PrintStringLn

call word [0x110c] ; __ensure
cmp bl, byte 0 ; ENTER?
jz start

jmp word [0x1116] ; Exit

.str:
	db 'Buenos dias!',0
