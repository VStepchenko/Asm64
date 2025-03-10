OPTION DOTNAME                          ; required for masm64 sdk macro files
option casemap:none                     ; required for masm64 sdk macro files

;for the following includes change path to your installation of the masm 64 sdk
include ..\..\..\..\..\..\masm64\include64\win64.inc
include ..\..\..\..\..\..\masm64\include64\kernel32.inc
include ..\..\..\..\..\..\masm64\include64\user32.inc

include ..\..\..\..\..\..\masm64\macros64\vasily.inc
include ..\..\..\..\..\..\masm64\macros64\macros64.inc

.data
myText           dw 0041fh, 00440h, 00438h, 00432h, 00435h, 00442h, 0002ch, 00020h, 0043ch, 00438h, 00440h, 0 ;привет, мир
myCaption        dw 0042eh, 0043dh, 00438h, 0043ah, 0043eh, 00434h, 0 ;юникод

.code

STACKFRAME

mainHelloWorldSdk PROC

    invoke MessageBoxW, NULL, ADDR myText, ADDR myCaption, MB_OK

    invoke ExitProcess, 12345678 ; the exit code, means nothing 

    ret

mainHelloWorldSdk ENDP

END