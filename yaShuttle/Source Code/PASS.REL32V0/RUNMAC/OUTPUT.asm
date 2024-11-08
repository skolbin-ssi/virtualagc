         MACRO                                                          00000100
         OUTPUT &X                                                      00000200
         GBLA  &ENTCNT                                                  00000300
         GBLB  &OUTPUT(20),&CCTYPE,&LIB                                 00000400
         AIF   (N'&SYSLIST EQ 0).EMPTY                                  00000500
&OUTPUT(&ENTCNT) SETB 1                                                 00000600
         AIF   ('&X' EQ 'NONE').SPACE                                   00000700
&I       SETA  1                                                        00000800
&LAST    SETA  N'&SYSLIST                                               00000900
.LOOP    AIF   (K'&SYSLIST(&I) NE 2).BADREG                             00001000
&R       SETC  '&SYSLIST(&I)'                                           00001100
         AIF   ('&R' EQ 'CC').CCTYPE                                    00001200
         AIF   ('&R'(1,1) NE 'F' AND '&R'(1,1) NE 'R').BADREG           00001300
         AIF   ('&R' EQ 'R0').BADREG                                    00001400
         AIF   (&LIB AND ('&R' EQ 'R1' OR '&R' EQ 'R3')).INVREG1        00001500
         AIF   (NOT &LIB AND '&R' EQ 'R4').INVREG2                      00001600
         AIF   (D'&R).NEXT                                              00001700
&N       SETC  '&R'(2,1)                                                00001800
&R       EQU   &N                                                       00001900
.NEXT    ANOP                                                           00002000
&I       SETA  &I+1                                                     00002100
         AIF   (&I LE &LAST).LOOP                                       00002200
.SPACE   SPACE                                                          00002210
         MEXIT                                                          00002300
.BADREG  MNOTE 4,' ILLEGAL REGISTER SPECIFICATION - &SYSLIST(&I)'       00002400
         AGO   .NEXT                                                    00002500
.CCTYPE  ANOP                                                           00002600
&CCTYPE  SETB  1                                                        00002700
         AGO   .NEXT                                                    00002800
.INVREG1 MNOTE 4,'&R INVALID OUTPUT FOR PROCEDURE ROUTINE'              00002900
         AGO   .NEXT                                                    00003000
.INVREG2 MNOTE 4,'R4 INVALID OUTPUT FOR INTRINSIC'                      00003100
         AGO   .NEXT                                                    00003200
.EMPTY   MNOTE 4,'OPERAND REQUIRED'                                     00003300
         MEND                                                           00003400
