_MIT_INTERPRET		equ 0x9000
_MIT_LIST			equ 0x9002

MIT_INTERPRET:
	call word [_MIT_INTERPRET]
	ret

MIT_LIST:
	call word [_MIT_LIST]
	ret
