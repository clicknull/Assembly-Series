extern _exit, _LoadLibraryA@4, _GetProcAddress@8, _system

Section .data; initialized data
				PTRtoKeyGenWav 	db ".\KeyGenWav.wav",0
				SND_ASYNC   	dd 0x0020009
				SND_LOOP    	dd 000000000
				
				WINMMdllstr	db "WINMM.dll",0
				WINMMdllAddr	dd 000000000
				PlaySoundSTR 	db "PlaySoundA",0
				WINMMPlaySoundA dd 000000000

				command 	db "pause",0 
				
				
Section .bss ; Reserved Memory
			
Section .text ; .code section/ All instructions go here;

global _main

@GetFunctionAddress:  ;function used to get utilize get procaddress
	push ebp
	mov  ebp, esp
	push eax
	push dword [WINMMdllAddr]
	call _GetProcAddress@8
	add esp , 4
	mov esp,ebp
	pop ebp
	retn


_main:
@LoadDll:
	push dword WINMMdllstr
	call _LoadLibraryA@4 ; Cleans itself up!
	mov dword [WINMMdllAddr], eax
	
@GetAllFunctAddress:
	mov eax, PlaySoundSTR
	call @GetFunctionAddress
	mov dword [WINMMPlaySoundA], eax ;Retn here from GetFunctionAddress!
	
	
	push dword [SND_ASYNC]
	push dword [SND_LOOP]
	push PTRtoKeyGenWav
	call dword [WINMMPlaySoundA]  ; Play music!

	push dword command
	call dword _system
	
	push 000000000
	call _exit
