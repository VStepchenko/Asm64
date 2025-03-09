# Asm64

Source code for the habr [article](https://habr.com/ru/articles/884240/) about 64-bit MASM assembler in Visual Studio

bare.zip - minimalistic way to assemble the 64 helloworld example without VS. Unpack the zip file and run makeit.bat. Tested on Win10 only

To choose the appropriate example to build it by VS please change Project properties - configuration properties - linker - advanced - entry point - mainHelloWorld/mainRepl/mainReplSdk

* HelloWorld.asm - hello world message box with unicode strings

* Repl.asm - console read/write unicode example, type anything to repeat, type 'quit' for quit

* ReplSdk.asm - the same functionality as Repl.asm, but using MASM 64 SDK macrosses, 
to build it you need to install [MASM 64 SDK](https://masm32.com/board/index.php?board=53.0) and modify ReplSdk.asm change paths to win64.inc, kernel32.inc, user32.inc, vasily.inc, macros64.inc 
according to your installation of MASM 64 SDK

* HelloWorldSdk.asm - the simple hello world message box with unicode strings, but using MASM 64 SDK macrosses, 
to build it you need to install [MASM 64 SDK](https://masm32.com/board/index.php?board=53.0) and modify HelloWorldSdk.asm  change paths to win64.inc, kernel32.inc, kernel32.inc, vasily.inc, macros64.inc 
according to your installation of MASM 64 SDK

The project template has been taken [here](https://github.com/nthana/SampleASM64/)
