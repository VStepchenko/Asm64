OPTION DOTNAME                          ; required for masm64 sdk macro files
option casemap:none                     ; required for masm64 sdk macro files

;for the following includes change path to your installation of the masm 64 sdk
include ..\..\..\..\..\..\masm64\include64\win64.inc
include ..\..\..\..\..\..\masm64\include64\kernel32.inc
include ..\..\..\..\..\..\masm64\include64\user32.inc

include ..\..\..\..\..\..\masm64\macros64\vasily.inc
include ..\..\..\..\..\..\masm64\macros64\macros64.inc

.data

inputStringBuffer db 1024 dup (?)
quitCommandString dw 00071h, 00075h, 00069h, 00074h, 0; quit
welcomeString     dw 00077h, 00072h, 00069h, 00074h, 00065h, 0003Eh, 00020h, 0; write>
repeatString      dw 00072h, 00065h, 00070h, 00065h, 00061h, 00074h, 00065h, 00064h, 0003Ah, 00020h, 0; repeated:
newLine           dw 13, 10, 0

.code

STACKFRAME

mainReplSdk PROC

    LOCAL hInput :QWORD
    LOCAL actuallyRead  :QWORD

    invoke GetStdHandle, STD_INPUT_HANDLE
    mov hInput, rax
    invoke SetConsoleMode, hInput, ENABLE_LINE_INPUT or ENABLE_ECHO_INPUT or ENABLE_PROCESSED_INPUT

    repl:
        invoke ConsoleOut, ADDR welcomeString
        invoke ReadConsoleW, hInput, ADDR inputStringBuffer, 100, ADDR actuallyRead, NULL

        invoke RemoveCrLf, ADDR inputStringBuffer, actuallyRead

        ;check for quit
        invoke StartsWith, ADDR quitCommandString, ADDR inputStringBuffer

        cmp rax, 1
        je endrepl

        ;repeat input
        invoke ConsoleOut, ADDR repeatString
        invoke ConsoleOut, ADDR inputStringBuffer
        invoke ConsoleOut, ADDR newLine

        jmp repl
    
    endrepl:

    mov rcx, 0	; the exit code
    call ExitProcess

    ret

mainReplSdk ENDP

ConsoleOut proc

    LOCAL charsWritten  :QWORD
    LOCAL hOutput :QWORD

    mov r12, rcx

    invoke GetStringLength, rcx
    mov r13, rax

    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov hOutput, rax

    invoke SetConsoleMode, hOutput, ENABLE_PROCESSED_OUTPUT or ENABLE_WRAP_AT_EOL_OUTPUT
    invoke WriteConsoleW, hOutput, r12, r13, ADDR charsWritten, NULL

    mov rax, charsWritten

    ret

ConsoleOut endp

GetStringLength proc

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

GetStringLength endp

RemoveCrLf proc

    sub rdx, 2
    mov DWORD PTR [rcx+rdx*2], 0

    ret

RemoveCrLf endp

; the substring is in the rcx 
; the string to check is it starts with the sgiven substring is in the rdx
; if the 'rdx' string starts with the 'rcx' string, returns 1, otherwise 0
StartsWith proc

    LOCAL patternLength : QWORD
    LOCAL sourceLength : QWORD
    LOCAL rcxReg : QWORD
    LOCAL rdxReg : QWORD

    mov rcxReg, rcx
    mov rdxReg, rdx

    invoke GetStringLength, rcxReg
    mov patternLength, rax

    invoke GetStringLength, rdxReg
    mov sourceLength, rax

    mov r10, rcxReg
    mov r11, rdxReg

    mov r8, patternLength
    mov r9, sourceLength
    cmp r8, r9
    jg notmatch

    mov rcx, -1

    mainloop:
        inc rcx
        cmp rcx, r8
        jg match
        mov ax, WORD PTR [r10+rcx*2]
        cmp ax, WORD PTR [r11+rcx*2]
        jne notmatch
        jmp mainloop

    match:
        mov rax, 1
        ret

    notmatch:
        mov rax, 0

    ret

StartsWith endp

END