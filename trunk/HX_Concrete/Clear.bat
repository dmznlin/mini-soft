@echo off

cd .\Source
del /s /a *.~*;*.dcu;*.ddp

cd ..\Temp
del /s /a *.~*;*.dcu

cd ..\VCLs
del /s /a *.~*;*.dcu

cd ..\Bin
del /s /a *.~*;*.dcu;*.bak