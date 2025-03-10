
ExitProcess    PROTO
MessageBoxW    PROTO

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

ENABLE_PROCESSED_OUTPUT     equ 1h
ENABLE_WRAP_AT_EOL_OUTPUT   equ 2h
ENABLE_PROCESSED_INPUT      equ 1h

ENABLE_LINE_INPUT           equ 2h
ENABLE_ECHO_INPUT           equ 4h

STD_INPUT_HANDLE            equ -10
STD_OUTPUT_HANDLE           equ -11

NULL                        equ 0

Par5 equ qword ptr [rsp + 32]

.code
mainRepl PROC

    LOCAL hInput :QWORD
    LOCAL actuallyRead  :QWORD

    sub rsp, 28h

    mov rcx, STD_INPUT_HANDLE
    call GetStdHandle

    mov hInput, rax
    mov rcx, hInput
    mov rdx, ENABLE_LINE_INPUT or ENABLE_ECHO_INPUT or ENABLE_PROCESSED_INPUT
    call SetConsoleMode

    repl:
        lea rcx, welcomeString
        call ConsoleOut_

        mov rcx, hInput
        lea rdx, inputStringBuffer
        mov r8, 100
        lea r9, actuallyRead
        mov qword ptr [rsp + 32], NULL
        call ReadConsoleW

        lea rcx, inputStringBuffer
        mov rdx, actuallyRead
        call RemoveCrLf_

        ;check for quit
        lea rcx, quitCommandString
        lea rdx, inputStringBuffer
        call StartsWith_

        cmp rax, 1
        je endrepl

        ;repeat input
        lea rcx, repeatString
        call ConsoleOut_

        lea rcx, inputStringBuffer
        call ConsoleOut_

        lea rcx, newLine
        call ConsoleOut_

        jmp repl
    
    endrepl:


    mov rcx, 0
    call ExitProcess

    add rsp, 28h
    ret

mainRepl ENDP

ConsoleOut_ proc

    LOCAL charsWritten  :QWORD
    LOCAL hOutput :QWORD

    sub rsp, 28h

    mov r12, rcx

    call GetStringLength_
    mov r13, rax

    mov rcx, STD_OUTPUT_HANDLE
    call GetStdHandle
    mov hOutput, rax

    mov rcx, hOutput
    mov rdx, ENABLE_PROCESSED_OUTPUT or ENABLE_WRAP_AT_EOL_OUTPUT
    call SetConsoleMode

    mov rcx, hOutput
    mov rdx, r12
    mov r8, r13
    lea r9, charsWritten
    mov qword ptr [rsp + 32], NULL
    call WriteConsoleW

    mov rax, charsWritten

    add rsp, 28h
    ret

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
; the string to check is it starts with the given substring is in the rdx
; if the 'rdx' string starts with the 'rcx' string, returns 1, otherwise 0
StartsWith_ proc

    LOCAL patternLength : QWORD
    LOCAL sourceLength : QWORD
    LOCAL rcxReg : QWORD
    LOCAL rdxReg : QWORD

    mov rcxReg, rcx
    mov rdxReg, rdx

    call GetStringLength_
    mov patternLength, rax

    mov rcx, rdxReg
    call GetStringLength_
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
StartsWith_ endp

END