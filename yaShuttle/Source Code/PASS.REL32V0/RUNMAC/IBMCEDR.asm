         MACRO                                                          00001300
&L       IBMCEDR &A,&B                                                  00001403
         GBLA  &CNT                                                     00001500
&CNT     SETA  &CNT+1                                                   00001600
&L       CER   &A,&B                                                    00001703
         BNE   SKIP&CNT                                                 00001800
         CEDR  &A,&B                                                    00001900
         BNE   SKIP&CNT                                                 00002000
         CER   &A+1,&B+1                                                00002100
         BE    SKIP&CNT                                                 00002200
         LER   &A,&A           IF NOT EQUAL THEN SET CC                 00002300
         BN    NEGA&CNT                                                 00002400
         C     0,=X'7FFFFFFF'  COMPARE TO STACK ADDRESS TO SET CC=11    00002500
         B     SKIP&CNT                                                 00002600
NEGA&CNT C     0,=X'80000000'  COMPARE TO STACK ADDRESS TO SET CC=01    00002700
SKIP&CNT DS    0H                                                       00002800
         MEND                                                           00002900
