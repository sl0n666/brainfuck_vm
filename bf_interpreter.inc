; --------------------------------------------------------------------------- ;
;
; 128 bytes brainfuck interpreter
;
; arguments:
;   rdx - input binary stream (used by ',' instruction, autoincremented)
;   rbx - output binary stream (used by '.' instruction, autoincremented)
;   rdi: memory buffer with, possibly, some data
;   rsi: brainfuck program terminated by 0 (can be changed in source code)
; kills:
;   rax, rbx, rcx, rdx, rsi, rdi, clears df
;
; --------------------------------------------------------------------------- ;
brainfuck:
		cld
.do:		lodsb
		cmp	al,'>'
		je	.right
		cmp	al,'<'
		je	.left
		cmp	al,'+'
		je	.plus
		cmp	al,'-'
		je	.minus
		cmp	al,'.'
		je	.dot
		cmp	al,','
		je	.comma
		cmp	al,'['
		je	.whilex
		cmp	al,']'
		je	.untilx
		cmp	al,0
		jne	.do
		ret

.right:
		inc edi
		jmp .do
.left:
		dec edi
		jmp .do
.minus:
		dec byte [edi]
		jmp .do
.plus:
		inc byte [edi]
		jmp .do
.dot:
		mov al,byte [edi]
		mov byte [edx],al
		inc edx
		jmp .do
.comma:
		mov al,byte [ebx]
		mov byte [edi],al
		inc ebx
		jmp .do
.whilex:
		cmp byte [edi],0
		jne .do
		mov ah,1
		mov cx,'[]'
		call .loop
		jmp .do
.untilx:
		cmp byte [edi],0
		je .do
		mov ah,0
		mov cx,']['
		std
		lodsb ; or "dec esi"
		call .loop
		cld
		lodsb ; or "inc esi"
		jmp .do
.loop:
		lodsb
		inc ah
		cmp al,cl
		je .loop
		dec ah
		cmp al,ch
		jne .loop
		dec ah
		cmp ah,0
		jne .loop
		ret
; --------------------------------------------------------------------------- ;