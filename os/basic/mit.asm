_MIT_LIST			equ 0x5000
_MIT_INTERPRET		equ 0x5002


MIT_LIST:
	call word [_MIT_LIST]
	ret

MIT_INTERPRET:
	call word [_MIT_INTERPRET]
	ret