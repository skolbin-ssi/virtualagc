*/ Access:      Public Domain, no restrictions believed to exist.
*/ Filename:    VV4DN.asm
*/ Purpose:     This is a part of the HAL/S-FC compiler run-time library.
*/ Reference:   TBD.
*/ Language:    IBM AP-101S assembly language.
*/ Contact:     The Virtual AGC Project (www.ibiblio.org/apollo).
*/ History:     2024-06-18 RSB  Suffixed filename with ".asm".
*/ Note:        Comments beginning */ in column 1 are from the Virtual AGC 
*/              Project. Comments beginning merely with * are from the original 
*/              Space Shuttle development.

         TITLE 'VV4DN--VECTOR*SCALAR,LENGTH N,DBLE PREC'                00000100
*
* WHEN DATA_REMOTE IS IN EFFECT, THE LDM INSTRUCTIONS ARE NEEDED
* AROUND THE CALL TO THIS RTL ROUTINE BECAUSE R1/R3 IS USED AS
* A BASE REGISTER. (CR12620)
*
VV4DN    AMAIN INTSIC=YES                                               00000200
*                                                                       00000300
*   COMPUTES THE VECTOR SCALAR PRODUCT:                                 00000400
*                                                                       00000500
*    V(N)=V1(N) X S                                                     00000600
*                                                                       00000700
*   WHERE N NOT=3  V,V1 ARE DP                                          00000800
*                                                                       00000900
         INPUT R2,            VECTOR(N)   DP                           X00001000
               F0,            SCALAR    DP                             X00001100
               R5             INTEGER(N)  DP                            00001200
         OUTPUT R1            VECTOR(N)   DP                            00001300
         WORK  F2                                                       00001400
*                                                                       00001500
*  ALGORITHM :                                                          00001600
*   DO FOR I=N TO 1;                                                    00001700
*    V(I)=V1(I)*S;                                                      00001800
*   END;                                                                00001900
*                                                                       00002000
VV4DNX   LED   F2,0(R5,R2)   GET V1 ELE.                                00002100
         MEDR  F2,F0         MUL. BY S                                  00002200
         STED  F2,0(R5,R1)   PLACE V ELE.                               00002300
$TIM1    BCTB  R5,VV4DNX     I=N TO 1 COUNTER                           00002400
         AEXIT                                                          00002500
         ACLOSE                                                         00002600
