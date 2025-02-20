OPTION DOTNAME                          ; required for masm64 sdk macro files
option casemap:none                     ; required for masm64 sdk macro files

;for the following includes change path to your installation of the masm 64 sdk
include ..\..\..\..\..\..\masm64\include64\win64.inc
include ..\..\..\..\..\..\masm64\include64\kernel32.inc
include ..\..\..\..\..\..\masm64\include64\user32.inc

include ..\..\..\..\..\..\masm64\macros64\vasily.inc
include ..\..\..\..\..\..\masm64\macros64\macros64.inc

.data
myText			dw 0041fh, 00440h, 00438h, 00432h, 0 ;привет, мир
myCaption		dw 0042eh, 0043dh, 0 ;юникод

.code
mainReplSdk PROC

	sub rsp, 28h		;	reserved as parameters' shadow area and align stack to 16

	mov rcx, 0 
	lea rdx, myText
	lea r8, myCaption
	mov r9, 0

	call MessageBoxW

	mov rcx, 12345678	; the exit code, means nothing 
	call ExitProcess

	add rsp, 28h
	ret
	
mainReplSdk ENDP

END