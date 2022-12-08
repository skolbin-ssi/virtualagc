*/ Access:      Public Domain, no restrictions believed to exist.
*/ Filename:    VR1TN.bal
*/ Purpose:     This is a part of the HAL/S-FC compiler run-time library.
*/ Reference:   TBD.
*/ Language:    Basic Assembly Language (BAL), IBM System/360.
*/ Contact:     The Virtual AGC Project (www.ibiblio.org/apollo).
*/ History:     2022-12-08 RSB  Suffixed filename with ".bal".
*/ Note:        Comments beginning */ in column 1 are from the Virtual AGC 
*/              Project. Comments beginning merely with * are from the original 
*/              Space Shuttle development.

         TITLE 'VR1TN--REMOTE TO REMOVE VECTOR MOVE, DP TO SP'          00000100
*
* WHEN DATA_REMOTE IS IN EFFECT, THE LDM INSTRUCTIONS ARE NOT NEEDED
* AROUND THE CALL TO THIS RTL ROUTINE BECAUSE R1/R3 IS NOT USED AS
* A BASE REGISTER. (CR12620)
*
VR1TN    AMAIN                                                          00000200
*                                                                       00000300
* MOVE A PARTITION OR OR ALL OF V1 TO A PARTITION OF OR ALL OF V2 OR    00000400
*   A SUCCESSIVELY STORED PARTITION OR ALL OF M1 TO A SUCCESSIVELY      00000500
*   STORED PARTITION OR ALL OF M2, WHERE :                              00000600
*        V1 IS A DOUBLE PRECISION VECTOR,                               00000700
*        V2 IS A SINGLE PRECISION VECTOR,                               00000800
*        AT LEAST ONE OF THE ABOVE IS REMOTE,                           00000900
*        M1 IS A DOUBLE PRECISION MATRIX,                               00001000
*        M2 IS A SINGLE PRECISION MATRIX,                               00001100
*        AT LEAST ONE OF THE ABOVE IS REMOTE,                           00001200
*        AND WHERE THE SOURCE AND RECEIVERS ARE BOTH OF LENGTH N        00001300
*                                                                       00001400
         INPUT R4,            ZCON(VECTOR(N)) SP                       X00001500
               R5             INTEGER(N) SP                             00001600
         OUTPUT R2            ZCON(VECTOR(N)) DP                        00001700
         WORK  F0                                                       00001800
*                                                                       00001900
* ALGORITHM:                                                            00002000
*   SEE ALGORITHM DESCRIPTION IN VR1DN                                  00002100
*                                                                       00002200
VR1TNX   LED@# F0,ARG4(R5)                                              00002300
         STE@# F0,ARG2(R5)                                              00002400
         BCTB  R5,VR1TNX                                                00002500
         AEXIT                                                          00002600
         ACLOSE                                                         00002700
