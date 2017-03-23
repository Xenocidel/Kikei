       .text
       main:
0000   MOV  R0,#170		R0 = AA
0004   MOV  R1,#85			R1 = 55
0008   MOV  R2,#255		R2 = FF
000c   MOV  R9,#0			R9 = 0
       
       /*Fill	R3 with AAs */
       
0010   LSL  R3,R0,#8		R3 = AA00
0014   ORR  R3,R3,R0		R3 = AAAA
0018   LSL  R3,R3,#8		R3 = AAAA00
001c   ORR  R3,R3,R0		R3 = AAAAAA
0020   LSL  R3,R3,#8		R3 = AAAAAA00
0024   ORR  R3,R3,R0		R3 = AAAAAAAA
       
       /*Fill	r4 with FFs */
       
0028   LSL  R4,R2,#8				R4 = FF00
002c   ORR  R4,R4,R2				R4 = FFFF
0030   LSL  R4,R4,#8				R4 = FFFF00
0034   ORR  R4,R4,R2				R4 = FFFFFF
0038   LSL  R4,R4,#8				R4 = FFFFFF00
003c   ORR  R4,R4,R2				R4 = FFFFFFFF
       
       /*Fill	R5 with 55S */
       
0040   LSL  R5,R1,#8				R5 = 5500
0044   ORR  R5,R5,R1				R5 = 5555
0048   LSL  R5,R5,#8				R5 = 555500
004c   ORR  R5,R5,R1				R5 = 555555
0050   LSL  R5,R5,#8				R5 = 55555500
0054   ORR  R5,R5,R1				R5 = 55555555
       
       /*AND  check */
       
0058   AND  R6,R3,R5				R6 = 00000000
005c   TST  R6,R4 ;					Z = 1
0060   ADDEQ	R9,R9,#1   		 	R9 = 1					/*Increment pass count */
0064   AND  R6,R4,#0xFF000000		R6 = FF000000
0068   LSL  R7,R2,#24				R7 = FF000000                  
006c   CMP  R6,R7					Z = 1													
0070   ADDEQ	R9,R9,#1   		 	R9 = 2					/*Increment pass count */
       
       /*ORR  Check */
       
0074   ORR  R6,R3,R5		R6 = FFFFFFFF
0078   MOV  R0,#0			R0 = 0
007c   TEQ  R6,#0			N = 1
0080   ADDNE	R9,R9,#1 	R9 = 3					/*Incremnt the pass count */
0084   ORR  R6,R5,#231		R6 = 555555F7
0088   ADD  R7,R5,#162		R7 = 555555F7
008c   TEQ  R7,R6
0090   ADDEQ	R9,R9,#1 	R9 = 4					/*Incremnt the pass count */
       
       /*ADD  check */
       
0094   ADD  R6,R3,R5		R6 = FFFFFFFF
0098   ADDS R6,R6,R3  		R6 = AAAAAAA9  C = 1
009c   AND  R6,R6,R2		R6 = A9
00a0   TEQ  R6,#169		Z = 1														
00a4   ADDEQ	R9,R9,#1 	R9 = 5					/*Incremnt the pass count */
       
       /*ADDC  check */
       
00a8   ADDC  R6,R6,#3		R6 = AC
00ac   ADDS  R7, R4, #1    R7 = 0     C = 1
00b0   ADDC R6,R6,R7		R6 = AD
00b4   CMP R6, #173		Z = 1														
00b8   ADDEQ	R9,R9,#1 	R9 = 6					/*Incremnt the pass count */
       
       /*MVN  check */
       
00bc   MVN  R6,R3 			R6 = 55555555
00c0   CMP  R6,R5			Z =1
00c4   ADDEQ	R9,R9,#1 	R9= 7					/*Increment pass count */
       
       /*SUB  check */
       
00c8   ADD R6,R0,#0xFF000000	R6 = FF000000
00cc   ADDS  R7,R0,#0x0F000000	R7 = 0F000000
00d0   SUB R8,R6,R7			R8 = F0000000
00d4   LSL R8,R8,#4			r8 = 0
00d8   CMP R0,R8
00dc   ADDEQ	R9,R9,#1 	R9= 8					/*Increment pass count */
00e0   SUBC R8,R6,R7			R8 = EFFFFFFF
00e4   SUBS R8,R8,#2			R8 = EFFFFFFD    C=0						     	
00e8   ADDC R8,R8,#0x20000000	R8 = 0FFFFFFD
00ec   CMP R8, R4
00f0   ADDNE	R9,R9,#1 	R9= 9					/*Increment pass count */
       
       /*EOR  Check */
       
00f4   EOR  R7,R3,#7		R7 = AAAAAAAD
00f8   EOR  R6,R3,R7		R6 = 7
00fc   CMP  R6,#7			Z = 1
0100   ADDEQ	R9,R9,#1 	R9= 10					/*Increment pass count */
       
       /*RSB  check */
       
0104   ADD  R7, R0, #12 ; 			R6 = 12
0108   RSB  R6, R7, R6 ;    		R6 = 7 - 12 = -5 ,	C = 1
010c   RSB  R8, R7, #23 ;   		R8 = 23 - 12 = 11
0110   ADD  R6,R6,R8				R6 = 6
0114   TEQ R6,#6		
0118   ADDEQ	R9,R9,#1 	R9= 11					/*Increment pass count */
       
       /*SBC  check */
       
011c   ADD  R6, R0, #0x00000015 ; 	R6 = ‭21
0120   ADD  R7, R0, #0x00000017 ; 	R7 = 23
0124   SUBS R8, R6, R7 ; 			R8 = -2
0128   SBC	 R6, R7, R6 ; 			R6 = 23 - 21 - 0 = 2 //getting 4
012c   SBC	 R7, R6, #2 ; 			R7 = 2 - 2 - 0 = 0
0130   CMP R7,R0
0134   ADDEQ	R9,R9,#1 	R9= 12					/*Increment pass count */
       
       /*CMN  check */
       
0138   CMN R8, R6
013c   ADDEQ	R9,R9,#1 	R9= 13					/*Increment pass count */
0140   CMN R8,#20
0144   ADDEQ	R9,R9,#1 	R9= 13					/*dont Increment pass count */
       
       /*RSC  check */
       
0148   RSC	 R6, R8, R6 ;			R6 = 4
014c   RSC	 R7, R6, #12 ;			R7 = 8
0150   CMP R7,#8
0154   ADDEQ	R9,R9,#1 	R9= 14					/*Increment pass count */
       
       /*BIC  Check */
       
0158   BIC  R6,R3,R5		R6 = AAAAAAAA
015c   CMP  R6,R3			Z = 1
0160   ADDEQ	R9,R9,#1 	R9= 15					/*Increment pass count */
0164   BIC  R6, R3, #128 ; R6 = 128
0168   CMP  R6,#128			Z = 0
016c   ADDEQ	R9,R9,#1 	R9= 15					/*don't Increment pass count */
       
       /*Logical Shift	left	check */
       
0170   MOV r7, #8																	
0174   LSL  r6,r3,R7		R6 = AAAAAA00
0178   SUB  r6,r3,r6		R6 = AA
017c   CMP  r6,#170		Z = 1
0180   ADDEQ	R9,R9,#1 	R9 = 16					/*Increment pass count */
       
       /*; logical Shift	right check */
       
0184   ADD r7, R0, #16
0188   LSR  R6,R3,R7		AAAA
018c   LSR  R6,R6,#16		0000
0190   cmp  r6,#0
0194   ADDEQ	R9,R9,#1 	R9 = 17					/*;Increment pass count*/
       
       /*; Arithmetic Shift	right check */
       
0198   ADD R6,R0,#0xF000000D	    R6 = F000000D
019c   ASR R6, R6, #4 ;			R6 = FF000000
01a0   cmp r6,#0xFF000000													
01a4   ADDEQ	R9,R9,#1 	R9 = 18					/*;Increment pass count*/
01a8   mov r6, #3					R6 = 3
01ac   ASR R7, R7, R6 ;			R7 = 2
01b0   cmp r7,#2
01b4   ADDEQ	R9,R9,#1 	R9 = 19					/*;Increment pass count*/
       
       /*Rotate	right	check */
       
01b8   ROR  r6,r3,#1		R6 = 55555555
01bc   cmp  r6,r5			Z = 1
01c0   ADDEQ	R9,R9,#1 	R9 = 20					/*Increment pass count*/
01c4   MOV R8, #4			R8 = 4
01c8   ROR  r6,r3,R8		R6 = AAAAAAAA
01cc   cmp  r6,r3			Z = 1
01d0   ADDEQ	R9,R9,#1 	R9 = 21					/*Increment pass count*/
       
       /*Extend	rotate */
       
01d4   RRX  R6,R3			55555555
01d8   CMP r6, r5
01dc   ADDCS	R9,R9,#1 	R9 = 22					/*;Increment pass count */
       
       
       /*Pass counter is supposed to be 22 (0x16) at the end of the program
       Write the passcount to mem[252]
       End of program.
       */
01e0   mov r0,#252
01e4   str r9,[r0,#0]
       
       loop:
       B loop
       