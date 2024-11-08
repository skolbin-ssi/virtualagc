         MACRO                                                          00000100
         INPUT &X                                                       00000200
         GBLA  &ENTCNT                                                  00000300
         GBLB  &INPUT(20),&LIB                                          00000400
         AIF   (N'&SYSLIST EQ 0).EMPTY                                  00000500
&INPUT(&ENTCNT) SETB 1                                                  00000600
         AIF   ('&X' EQ 'NONE').SPACE                                   00000700
&I       SETA  1                                                        00000800
&LAST    SETA  N'&SYSLIST                                               00000900
.LOOP    AIF   (K'&SYSLIST(&I) NE 2).BADREG                             00001000
&R       SETC  '&SYSLIST(&I)'                                           00001100
         AIF   ('&R'(1,1) NE 'F' AND '&R'(1,1) NE 'R').BADREG           00001200
         AIF   ('&R' EQ 'R0').BADREG                                    00001300
         AIF   (&LIB AND ('&R' EQ 'R1' OR '&R' EQ 'R3')).INVREG1        00001400
         AIF   (NOT &LIB AND '&R' EQ 'R4').INVREG2                      00001500
         AIF   (D'&R).NEXT                                              00001600
&N       SETC  '&R'(2,1)                                                00001700
&R       EQU   &N                                                       00001800
.NEXT    ANOP                                                           00001900
&I       SETA  &I+1                                                     00002000
         AIF   (&I LE &LAST).LOOP                                       00002100
.SPACE   SPACE                                                          00002110
         MEXIT                                                          00002200
.BADREG  MNOTE 4,' ILLEGAL REGISTER SPECIFICATION - &SYSLIST(&I)'       00002300
         AGO   .NEXT                                                    00002400
.INVREG1 MNOTE 4,'&R INVALID INPUT FOR PROCEDURE ROUTINE'               00002500
         AGO   .NEXT                                                    00002600
.INVREG2 MNOTE 4,'R4 INVALID INPUT FOR INTRINSIC'                       00002700
         AGO   .NEXT                                                    00002800
.EMPTY   MNOTE 4,'OPERAND REQUIRED'                                     00002900
         MEND                                                           00003000
