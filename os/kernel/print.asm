PrintLn:
	pusha
	mov al, 0x0d
	call PrintChar
	mov al, 0x0a
	call PrintChar
	popa
	ret

PrintString:
	pusha
	; SI: String adress
	mov ah, 0x0e
	.loop:
		cmp [si], byte 0
		jz .exitloop
		
		mov bh, 0x0d
		cmp bh, [si]
		jz .crlf
		
		jmp .print
		
		.crlf:
		mov al, 0x0a ; LF
		call PrintChar
		.print:
		mov al, [si]
		call PrintChar
		
		.next:
		call _ReflowCursor
		inc si
		jmp .loop
	.exitloop:
	popa
	ret
PrintStringLn:
	; SI: String adress
	call PrintString
	call PrintLn
	ret
PrintChar:
	; AL - Char
	pusha
	
	cmp al, byte 0x0d
	jz .CR
	cmp al, byte 0x0a
	jz .LF
	
	; Print
	xor bh,bh
	xor ch,ch
	mov cl, byte 1
	mov ah, 0x0a
	int 10h
	
	; Inc Cursor
	mov bx, 0x0001
	call MovCursorRel
	
	jmp .end
	
	.CR:
	call GetCursorPos
	push dx
	mov dh, [_CursorRow]
	xor dl,dl
	
	call SetCursorPos
	
	pop dx
	jmp .end
	
	.LF:
	mov bx, 0x0100
	call MovCursorRel
	
	.end:
	call _ReflowCursor
	popa
	ret

_ReflowCursor:
	pusha
	mov [_IntScroll], byte 0
	
	call GetCursorPos
	mov dh, [_CursorRow]
	mov dl, [_CursorCol]
	
	; Not check for up
	cmp dl, byte [SafeRect+1] ; Check COL-LEFT
	ja .next1
	; Repos
	mov dl, byte [SafeRect+1]
	
	.next1:
	cmp dl, byte [SafeRect+3] ; Check COL-RIGHT
	jbe .next2
	; Repos
	inc dh ; FIRES INTSCROLL
	mov [_IntScroll], byte 1
	mov dl, byte [SafeRect+1]
	
	.next2:
	cmp dh, byte [SafeRect+2] ; Check ROW-BOT
	jbe .next3
	; Repos
	mov dh, byte [SafeRect+2] ; FIRES INTSCROLL
	mov [_IntScroll], byte 1
	
	push dx
	mov ax, 0x0601 ; Clear screen
	mov bh, [COLOR]
	xor bl, bl
	mov ch, byte [SafeRect]
	mov cl, byte [SafeRect+1]
	mov dh, byte [SafeRect+2]
	mov dl, byte [SafeRect+3]
	int 10h
	pop dx
	
	.next3:
	call SetCursorPos
	popa
	ret

_AttrRect:
	; AL: Char (0 means same as previous).
	; BH: New color
	; CX: Top-Left
	;  - CH: Row
	;  - CL: Column
	; DX: Right-Bottom
	;  - DH: Row
	;  - DL: Column
	jmp .start
	
	.char:
		db 0
	.color:
		db 0
	
	.start:
	pusha
	
	mov byte [.char], al
	mov byte [.color], bh
	
	mov ax, cx
	mov bx, dx
	
	call GetCursorPos
	mov dh, [_CursorRow]
	mov dl, [_CursorCol]
	push dx
	
	mov ch, ah ; j
	.for_j:
		cmp ch, bh
		ja .exit_j
		
		mov cl, al ; i
		.for_i:
			cmp cl, bl
			ja .exit_i
			
			push ax
			push bx
			push cx
			
			mov dx, cx
			call SetCursorPos
			
			; Get attr and char
			cmp byte [.char], byte 0
			jz .geta
			
			mov al, [.char]
			
			jmp .seta
			
			.geta:
			mov ah, 0x08
			xor bh,bh
			int 10h
			; Return AH=Attr, AL=Char
			
			.seta:
			; Set attr and char
			mov ah, 0x09
			mov cx, word 1
			xor bh,bh
			mov bl, byte [.color]
			int 10h
			
			pop cx
			pop bx
			pop ax
			
			inc cl
			jmp .for_i
		.exit_i:
		inc ch
		jmp .for_j
	.exit_j:
	pop dx
	call SetCursorPos
	
	popa
	ret

SetCursorPos:
	; DH: Row
	; DL: Column
	pusha
	
	mov ax, 0x0200
	xor bx, bx ; Page
	int 10h
	; Registers destroyed:      AX, SP, BP, SI, DI
	
	popa
	ret
GetCursorPos:
	pusha
	
	mov ax, 0x0300
	xor bx, bx ; Page
	int 10h
	; Registers destroyed:      AX, SP, BP, SI, DI
	; Return DH:ROW, DL:COLUMN
	mov [_CursorRow], dh
	mov [_CursorCol], dl
	
	popa
	ret
MovCursorRel:
	; BH: Row more
	; BL: Column more
	push dx
	
	call GetCursorPos
	mov dh, [_CursorRow]
	mov dl, [_CursorCol]
	add dh, bh
	add dl, bl
	call SetCursorPos
	
	pop dx
	ret

_CursorRow: db 0
_CursorCol: db 0
_IntScroll: db 0