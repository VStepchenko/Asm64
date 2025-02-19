# Asm64

Source code for the habr [article](https://habr.com/ru/articles/763636/) 64-bit MASM assembler in Visual Studio

bare.zip - minimalistic way to assemble the 64 helloworld example without VS. Unpack the zip file and run makeit.bat. Tested on Win10 only

To choose the appropriate project to build change Project properties - configuration properties - linker - advanced - entry point - mainHelloWorld/mainRepl/mainReplSdk

* HelloWorld.asm - hello world message box with unicode strings

* Repl.asm - console read/write unicode example, type anything to repeat, type 'quit' for quit

* ReplSdk.asm - the same functionality as Repl.asm but using MASM 64 SDK macrosses, to build it provide path to XXX XXX XXX from MASM 64 SDK in the beginning of the ReplSdk.asm file

The project template has been taken [here](https://github.com/nthana/SampleASM64/)