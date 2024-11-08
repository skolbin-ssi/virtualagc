         MACRO                                                          00000010
&L       I2DEDR &F0,&F2,&F4,&F6                                         00000020
&L       LER   &F4,&F0                                                  00000022
         LER   &F4+1,&F0+1                                              00000024
*  ROUGH APPROXIMATION IS X/Y
         DER   &F0,&F2                                                  00000030
*  FIRST ITERATION
         LFLI  &F0+1,0            RAH 1/5/93
         LER   &F6,&F0                                                  00000050
         LER   &F6+1,&F0+1                                              00000060
         MEDR  &F6,&F2                                                  00000070
         SEDR  &F6,&F4                                                  00000080
         DER   &F6,&F2                                                  00000090
         LFLI  &F6+1,0            RAH 1/5/93
         SEDR  &F0,&F6                                                  00000100
*  SECOND ITERATION
         LER   &F6,&F0            RAH 1/5/93
         LER   &F6+1,&F0+1        RAH 1/5/93
         MEDR  &F6,&F2            RAH 1/5/93                            00000070
         SEDR  &F6,&F4            RAH 1/5/93                            00000080
         DER   &F6,&F2            RAH 1/5/93                            00000090
         LFLI  &F6+1,0            RAH 1/5/93
         SEDR  &F0,&F6            RAH 1/5/93                            00000100
         MEND                                                           00000110
