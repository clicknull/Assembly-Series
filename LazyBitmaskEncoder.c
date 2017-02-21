#include <stdio.h>
#include <string.h>
#include <stdbool.h>

/*Wrote this quickly to get a specific task done. Please Don't use this in prod*/
/*
This program needs to take a fixed sized array of bytes , reverse the order, perform an XOR on them,
then print a pattern in assembly will De-XOR them back then place them on the stack.

*/


int main() {


int LengthOfShellCode = 332;// Please set this to meet your needs. I sometimes have 0x00 bytes in my code , 
int XOR_Byte = 0xEE;	//so getting a length isn't always easy. 


unsigned char ReversedByteArray[LengthOfShellCode];
//unsigned char Xor_Array[LengthOfShellCode];
unsigned char XOR_bytearray[LengthOfShellCode];


unsigned char bytearray[] = \
"SHELLCODE GOES HERE"






int XORShellcode(unsigned char ByteSequence[],int Array_Length , int Xor_Key, bool debug){
    for(int i = 0; i <= Array_Length; i++){
        XOR_bytearray[i] = (ReversedByteArray[i] ^ Xor_Key);// I am making a mistake here. I need to for each byte in reversedbyte array ,
                                                        //XOR it, then place it into the XOR_Array
        if(debug == true){ // Debug mode to print out results.
            printf("ORIG %02X :: ",  ReversedByteArray[i]);
            printf("%02X\n",   XOR_bytearray[i]);} // This seems to be correct for some reason.
    }
    return 0;
}



void MakeBackwardsArray(unsigned char Normal_Array[], bool debug){
	for (int j = 0 ,i = LengthOfShellCode; i >= 0;j++, i--){
		ReversedByteArray[j] = bytearray[i];
		if (debug == 1 ){
		printf("%02X", ReversedByteArray[j]);}
}
}

void Preamble(){ printf("mov edx, %X%X \n", XOR_Byte,XOR_Byte);}

void PrintShellPayload(bool debug){ // In general this function still requires some attention as it might not provide an complete amount of instructions in the end.
    if( debug == true) {for(int i = 0 ; i < LengthOfShellCode; i++){    printf("%02X",XOR_bytearray[i]); }}
    else{
        for(int i = 0; i <= LengthOfShellCode; i++){
        printf("mov eax, FFFF%02X%02X \n", XOR_bytearray[i],XOR_bytearray[i+1]);
        printf("xor ax, dx\n");
        printf("and eax, FFFF \n");
        printf("rol eax, 0x10 \n"); // this moves ax to the first 4 bits of EAX . like so 0000FFFF to FFFF0000;
        if( i == LengthOfShellCode){printf("push eax \n");break;} // This might not be needed

        i +=2;

        printf("mov ebx, FFFF%02X%02X \n", XOR_bytearray[i],XOR_bytearray[i+1]);
        printf("mov ax, bx \n");
        printf("xor ax, dx\n");
        printf("push eax \n");
        i++;
	}
}
}

/*
should start
ORIG D5 :: 3B
ORIG FF :: 11
ORIG 53 :: BD

...
...
...

should end with
ORIG E8 :: 06
ORIG FC :: 12

*/



void Finally(){ printf("jmp esp\n");}
void Warning(){/*if(LengthOfShellCode % 2 != 0)*/ printf(";[+] Warning --- Keep in mind that your shellcode needs to be the size of a DWORD . Fill the remaining bytes with (0x90 ^ XOR byte) \n In this case, it's %02X \n", (0x90 ^ XOR_Byte));}


MakeBackwardsArray(bytearray,false);
XORShellcode(ReversedByteArray,LengthOfShellCode,XOR_Byte, false);



Preamble();
PrintShellPayload(false);
Finally();
Warning();
return 0;

}
