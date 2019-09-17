;------------------------------------------------------------------------------;
format PE64 console 5.0
entry start

include 'win64a.inc'
;------------------------------------------------------------------------------;
section '.text' code readable executable
;------------------------------------------------------------------------------;
proc		start

		invoke	GetStdHandle,-11
		mov	[stdout],rax
		invoke	GetStdHandle,-10
		mov	[stdin],rax
		invoke	WriteConsole,[stdout],xMsg_,[xSize],NULL,NULL
		invoke	ReadConsole,[stdin],password_buff,16,chars_read,NULL

		mov	rsi,bf_code
		mov	rdi,tmp_buff
		mov	rdx,bf_output
		mov	rbx,rdx
		call	brainfuck

		xor	rdx,rdx
		mov	rcx,0x1f
		cld
xcalc:
		xor	rax,rax
		mov	rdi,bf_output
		mov	rsi,password_buff
		lodsb
		mov	ah,byte [rdi]
		inc	rdi
		xor	ah,al
		xor	al,al
		add	rdx,rax
		loop	xcalc

		or	rax,rax
		jnz	exit_

		invoke	WriteConsole,[stdout],ok_Msg,[okSize],NULL,NULL

exit_:
		invoke	ExitProcess,0
endp
;------------------------------------------------------------------------------;
include 	'bf_interpreter.inc'
;------------------------------------------------------------------------------;
section '.data' data readable writeable
;------------------------------------------------------------------------------;
stdout		dq	0
stdin		dq	0
chars_read	dq	0

ok_Msg		db	"[+] Password is correct",0
okSize		dq	$-ok_Msg

xMsg_		db	'Enter password: ',0
xSize		dq	$-xMsg_
;------------------------------------------------------------------------------;

tmp_buff	rb	0x200
in_buff 	rb	0x200

password_buff	rb	0x20
bf_output	rb	0x20
;------------------------------------------------------------------------------;
bf_code:
		db	"+[----->+++<]>+.---.+++++++..+++.+[----->++<]>-.+++"
		db	".[--->+<]>----.---.[--->+<]>----.",0
;------------------------------------------------------------------------------;
section 	'.idata' import data readable writeable
 
library 	kernel32,'KERNEL32.DLL'
 
import		kernel32,\ 
		GetStdHandle,'GetStdHandle',\ 
		WriteConsole,'WriteConsoleA',\
		ReadConsole,'ReadConsoleA',\
		ExitProcess,'ExitProcess'
;------------------------------------------------------------------------------;