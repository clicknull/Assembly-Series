
#include <stdio.h>
#include <string.h>
/*Wrote this quickly to get a specific task done. Please Don't use this in prod*/


int main() {

int LengthOfShellCode = 335;
unsigned char ReversedByteArray[335] = {0};
int XOR_Byte = 0xEE;
unsigned char bytearray[] = \



unsigned char Xor_Array[335];

int XORShellcode(unsigned char ByteSequence[],int Array_Length , int Xor_Key){


    for(int i = 0; i < Array_Length; i++){
            printf("%02X   ",ByteSequence[i]);
        bytearray[i] = ByteSequence[i] ^ Xor_Key;


        printf("%02X\n",bytearray[i]);
    }


    return 0; // I would like this to return an array , but that isn't allowed in 
              //C perhaps a pointer to an allocated array will do. 

}



void MakeBackwardsArray(){ // I want this to take in an array....
	for (int j = 0 ,i = LengthOfShellCode; i >= 0;j++, i--){
		ReversedByteArray[j] = bytearray[i];
//		printf("%02X", ReversedByteArray[j]);
}
}

void Preamble(){ printf("mov edx, %x%x \n", XOR_Byte,XOR_Byte);}

void PrintShellPayload(){ //This is where our grand finally should be.
	for(int i = 0; i < LengthOfShellCode; i++){
	printf("mov eax, FFFF%02X%02X \n", ReversedByteArray[i],ReversedByteArray[i+1]);
	printf("xor ax, dx\n");
	printf("and eax, FFFF \n");
	printf("rol eax, 0x10 \n");


        i +=2;
	//i++;
	//i++; //Yes I know, this is dumb.
	printf("mov ebx, FFFF%02X%02X \n", ReversedByteArray[i],ReversedByteArray[i+1]);
        printf("mov ax, bx \n");
        printf("xor ax, dx\n");
        printf("push eax \n");
	i++;
}
}



void PrintBackShell(){
for ( int i = LengthOfShellCode; i >= 0; --i){
	printf("%02X%02X  \n",bytearray[i] , bytearray[i - 1]);
}
}

void Finally(){ printf("jmp esp\n");}



//XORShellcode(bytearray,LengthOfShellCode,XOR_Byte);
Preamble();
MakeBackwardsArray();
PrintShellPayload();
Finally();
return 0;

}
