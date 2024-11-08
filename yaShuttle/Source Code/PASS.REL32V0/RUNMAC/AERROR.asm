         MACRO                                                          00000100
&NAME    AERROR &NUM,&GROUP=4                                           00000200
         GBLA  &ERRCNT,&ERRNUMS(10),&ERRGRPS(10)                        00000300
         LCLA  &I                                                       00000400
         AIF   (&NUM GT 62).BADNUM                                      00000500
&I       SETA  &ERRCNT                                                  00000600
.DUPLOOP AIF   (&I LE 0).NEWERR                                         00000700
         AIF   (&NUM EQ &ERRNUMS(&I) AND &GROUP EQ &ERRGRPS(&I)).DUP    00000800
&I       SETA  &I-1                                                     00000900
         AGO   .DUPLOOP                                                 00001000
.NEWERR  ANOP                                                           00001100
&ERRCNT  SETA  &ERRCNT+1                                                00001200
&I       SETA  &ERRCNT                                                  00001300
&ERRNUMS(&I) SETA &NUM                                                  00001400
&ERRGRPS(&I) SETA &GROUP                                                00001500
.DUP     ANOP                                                           00001600
*********ISSUE SEND ERROR SVC****************************************** 00001700
&NAME    SVC   AERROR&I       ISSUE SEND ERROR SVC                      00001800
*********SEND ERROR SVC RETURNS CONTROL FOR STANDARD FIXUP************* 00001900
         MEXIT                                                          00002000
.BADNUM  MNOTE 12,'ERROR NUMBER GREATER THAN 62'                        00002100
         MEND                                                           00002200
