         MACRO                                                          00000010
&L       QDEDR  &R,&A                                                   00000020
         GBLB  &QDEDOK                                                  00000030
         AIF   (&QDEDOK).DOIT                                           00000040
         MNOTE 12,'QDED OPTION NOT SPECIFIED IN AMAIN OR INTSIC=YES SPEX00000050
               CIFIED'                                                  00000060
         MEXIT                                                          00000070
.DOIT    ANOP                                                           00000080
&L       STED  &R,QARGA                                                 00000090
         STED  &A,QARGB                                                 00000100
         DER   &R,&A                                                    00000110
.*MOD??* SER   &R+1,&R+1    DWE 9/28/77                                 00000115
         LER   &A,&R                                                    00000120
         LER   &A+1,&R+1                                                00000130
         MED   &A,QARGB                                                 00000140
         SED   &A,QARGA                                                 00000150
         DE    &A,QARGB                                                 00000160
         SEDR  &R,&A                                                    00000170
         LED   &A,QARGB                                                 00000180
         MEND                                                           00000190
