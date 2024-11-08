.*********************************************************************/ 00000109
.*-------------------------------------------------------------------*/ 00000209
.*                                                                   */ 00000309
.*   NAME:       AENTRY                                              */ 00000409
.*                                                                   */ 00000509
.*-------------------------------------------------------------------*/ 00000609
.*                                                                   */ 00000709
.*   FUNCTION:   DEFINES "NAME" AS A SECONDARY ENTRY POINT           */ 00000809
.*                                                                   */ 00000909
.*-------------------------------------------------------------------*/ 00001009
.*                                                                   */ 00001109
.*   INVOKED BY: <NAME>   ENTRY                                      */ 00001209
.*                                                                   */ 00001309
.*-------------------------------------------------------------------*/ 00001409
.*                                                                   */ 00001509
.*   PARAMETERS: NAME   - ROUTINE NAME DEFINED AS SECONDARY          */ 00001609
.*                                                                   */ 00001709
.*      NAME     ROUTINE NAME DEFINES AS SECONDARY ENTRY POINT.      */ 00001809
.*               NAME IS IN THE LABEL POSITION.                      */ 00002009
.*                                                                   */ 00002209
.*-------------------------------------------------------------------*/ 00002309
.*                                                                   */ 00002409
.*   COMMENTS:  &SYSPARM IS A SYSTEM PARAMETER WHICH IS SET IN       */ 00002509
.*              IN THE CLIST THAT ASSEMBLES THE RUNTIME LIBRARY      */ 00002609
.*              ROUTINE.  THE VALID VALUES OF &SYSPARM ARE 'BFS'     */ 00002709
.*              OR 'PASS'. &SYSPARM INDICATES IF THE COMPILATION     */ 00002809
.*              IS FOR BFS OR PASS.                                  */ 00002909
.*                                                                   */ 00003009
.*-------------------------------------------------------------------*/ 00003109
.*                                                                   */ 00003209
.*   REVISION HISTORY:                                               */ 00003309
.*                                                                   */ 00003409
.*     DATE      CCR#/CDR#  NAME  DESCRIPTION                        */ 00003509
.*     --------  ---------  ----  ---------------------------------- */ 00003609
.*     09/09/89  CCR00006   JAC   MERGE BFS AND PASS MACROS          */ 00003709
.*                                                                   */ 00003909
.*********************************************************************/ 00004009
.*                                                                      00004109
         MACRO                                                          00004200
&NAME    AENTRY                                                         00004300
         GBLA  &ENTCNT                                                  00004400
         GBLB  &CALLOK,&NOEXTRA,&LIB                                    00004500
         GBLC  &NAMES(20)                                               00004600
*********************************************************************** 00004700
*                                                                       00004800
*        SECONDARY ENTRY POINT                                          00004900
*                                                                       00005000
*********************************************************************** 00005100
&ENTCNT  SETA  &ENTCNT+1                                                00005200
&NAMES(&ENTCNT) SETC '&NAME'                                            00005300
&NAME    DS    0H                                                       00005400
         ENTRY &NAME                                                    00005500
         AIF   (NOT &LIB).SPACE                                         00005600
         AIF   (&NOEXTRA OR NOT &CALLOK).NIST                           00005700
         IAL   0,STACKEND-STACK SET STACK SIZE                          00005800
.*                                              /*********************/ 00005905
.NIST    AIF   ('&SYSPARM' EQ 'BFS').SPACE      /* CR#CCR00006 - INS */ 00006005
.*                                              /* NIST NOT REQUIRED */ 00006105
.*                                              /*  FOR BOS          */ 00006205
         AIF   ('&SYSPARM' EQ 'PASS').PASS      /*                   */ 00006305
         MNOTE 4,'INVALID SYSPARM - VALID VALUES ARE BFS AND PASS'   */ 00006405
         MEXIT                                  /*                   */ 00006505
.*                                              /*********************/ 00006605
.PASS    NIST  9(0),0         CLEAR ERROR VECTOR POINTER                00006705
.SPACE   SPACE                                                          00006800
         MEND                                                           00007000
