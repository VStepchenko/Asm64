
ExitProcess PROTO
MessageBoxW PROTO

GetStdHandle   PROTO
SetConsoleMode PROTO
ReadConsoleW   PROTO
WriteConsoleW  PROTO

.data

inputStringBuffer db 1024 dup (?)
quitCommandString dw 00071h, 00075h, 00069h, 00074h, 0; quit
welcomeString     dw 00077h, 00072h, 00069h, 00074h, 00065h, 0003Eh, 00020h, 0; write>
repeatString      dw 00072h, 00065h, 00070h, 00065h, 00061h, 00074h, 00065h, 00064h, 0003Ah, 00020h, 0; repeated:
newLine           dw 13, 10, 0

myText			dw 0041fh, 00440h, 00438h, 00432h, 00435h, 00442h, 0002ch, 0 ;привет, мир
myCaption		dw 0042eh, 0043dh, 00438h, 0 ;юникод

.code
mainRepl PROC

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
	
mainRepl ENDP

ConsoleOut_ proc
ConsoleOut_ endp

GetStringLength_ proc

    mov r10, rcx

    mov rax, rcx
    sub rax, 2
    start:
      add rax, 2
      cmp WORD PTR [rax], 0
      jne start
      sub rax, r10
    shr rax, 1

    ret

GetStringLength_ endp

RemoveCrLf_ proc

    sub rdx, 2
    mov DWORD PTR [rcx+rdx*2], 0

    ret

RemoveCrLf_ endp

; the substring is in the rcx 
; the string to check is it starts with the sgiven substring is in the rdx
; if the 'rdx' string starts with the 'rcx' string, returns 1, otherwise 0
StartsWith_ proc
StartsWith_ endp

END