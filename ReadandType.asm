extern _exit ,_fopen,_fgetc,_fclose,_toupper, _malloc , _free
extern _putchar, _system, _Sleep@4, _SendInput@12


Section .data; initialized data
				FileHandle: dd 00000000
				File db "Resume.txt",0
				ReadMode: db "rb",0 ; Read Binary
				Notepad: db "start notepad",0
				mallocptr: dd 00000000
				

				

Section .bss ; Reserved Memory
			
Section .text ; .code section/ All instructions go here;

global _main

_main: ; int main (){}

	push ebp
	mov ebp, esp	
 
	
	xor eax,eax
	xor ecx,ecx
	xor edx,edx
	xor ebx,ebx
	xor esi,esi
	xor edi,edi ; XOR 0 out all registers.
	
	push ReadMode
	push File
	call _fopen
	mov [FileHandle], eax
	add esp , 8
	
	push Notepad
	call _system
	add esp, 4
	
	
	push 0x3e8
	call _Sleep@4 ;auto cleans up :)
	
	push 20
	call _malloc
	mov [mallocptr], eax
	add esp , 4
	
	@ExecutionLoop:
	push dword [FileHandle]
	call _fgetc
	mov ebx, eax
	add esp ,4 
	
	push ebx
	call _toupper
	mov ebx ,eax
	add esp , 4
	
	@pushkey:
	push 28
	push dword[mallocptr]
	push 1
	
	mov edi, [mallocptr]
	mov dword [edi], 0x1
	add edi ,4
	mov [edi], ebx
	call _SendInput@12; autocleanup :) ; Presses char
	
	
	@ReleaseChar:
	sub esp , 12
	mov edi, [mallocptr]
	add edi , 8
	mov dword [edi], 2
	nop
	call _SendInput@12
	mov dword [edi], 0
	cmp bl , 0xff
	jne @ExecutionLoop
	
	push dword [FileHandle]
	call _fclose
	add esp , 4
	
	push dword [mallocptr]
	call _free
	

	
	@Exit:
	mov esp,ebp
	pop ebp
	ret	
	




