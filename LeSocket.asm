;Le Socket
extern _exit,  _malloc , _free,_puts, _LoadLibraryA@4, _GetProcAddress@8

;import WSAStartup wsock32.dll

Section .data; initialized data
				 Wsa_Version 	dd 0x202 	 ; Version 202

				 WsockdllAddr 	dd 00000000
				 WSAStartupaddr dd 00000000
				 socketaddr 	  dd 00000000
				 inet_addraddr 	dd 00000000
				 htonsaddr 	  	dd 00000000
				 connectaddr 	  dd 00000000
				 sendaddr		    dd 00000000
				 recvaddr		    dd 00000000
				 
				 mallocptr		  dd 00000000
				 
				 Socket 		    dd 00000000
				 port_AF_INET   dd 0x50000002 ; 50 is 80 In Hex, 2 is the AF_INET family flag
				 IPAddressinHex dd 00000000
				 
				 

				 
				 
				 wsock32str 	  db "wsock32.dll",0
				 WSAStartupstr 	db "WSAStartup",0
				 socketstr 		  db "socket",0
				 inet_addrstr 	db "inet_addr",0
				 htonsstr 		  db "htons",0
				 connectstr 	  db "connect",0
				 sendstr 		    db "send",0
				 recvstr		    dd "recv",0
				 
				 Ipaddrstr 		db "216.58.217.14",0 ; Google's IP addr
				 GetString 		db "GET / HTTP/1.1",0x0d,0x0a,0x0d,0xa, 00,00



Section .bss ; Reserved Memory
			
Section .text ; .code section/ All instructions go here; 


global _main


	@GetFunctionAddress:
	push ebp
	mov  ebp,esp
	push eax
	push dword [WsockdllAddr] ; Made a change here
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
	push 2300		;I know... messed up! needs at least 440 bytes. Weird eh?
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
	

	;Send(sendaddr,Socket,GetString,18,0);
	push 0
	push 18
	push dword GetString
	push dword [Socket]call @GetFunctionAddress
	call dword [sendaddr]
	
	;recv()006C4140
	push 0
	push 2000 ; Bytes we want to recv
	push dword [mallocptr]
	push dword [Socket]
	call dword [recvaddr]
	
	
	push dword [mallocptr]
	call _puts
	add esp, 4
	
	push dword [mallocptr]
	call _free
	
	@Exit:

	mov esp,ebp
	pop ebp
	push 0
	call _exit
