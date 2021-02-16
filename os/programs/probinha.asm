[org 0x10000]

mov si, .str
call word [0x7f04] ; PrintStringLn
call word [0x7f0a] ; __ensure
jmp .end

.str:
	db 'Buenos días!',0

.end:
ret