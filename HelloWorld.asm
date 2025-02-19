
ExitProcess PROTO
MessageBoxW PROTO

.data
myText			dw 0041fh, 00440h, 00438h, 00432h, 00435h, 00442h, 0002ch, 00020h, 0043ch, 00438h, 00440h, 0 ;привет, мир
myCaption		dw 0042eh, 0043dh, 00438h, 0043ah, 0043eh, 00434h, 0 ;юникод

.code
main PROC

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
	
main ENDP

END