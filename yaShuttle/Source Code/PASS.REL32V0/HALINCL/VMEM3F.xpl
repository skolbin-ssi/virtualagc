 /*@
    Access:     Public Domain, no restrictions believed to exist.
    Filename:   VMEM3F.xpl
    Purpose:    Part of the HAL/S-FC compiler.
    Reference:  "HAL/S-FC & HAL/S-360 Compiler System Program Description", 
                section TBD.
    Language:   XPL.
    Contact:    The Virtual AGC Project (www.ibiblio.org/apollo).
    History:    2022-12-08 RSB  Suffixed the filename with ".xpl".
    Note:       Inline comments beginning with "/*@" were created by the 
                Virtual AGC Project. Inline comments beginning merely with 
                "/*" are from the original Space Shuttle development.
 */
 
   /* VIRTUAL MEMORY LOGIC FOR THE XPL PROGRAMMING SYSTEM                     */00100000
   /* EDIT LEVEL 002             23 AUGUST 1977         VERSION 1.1     */      00100100
                                                                                00100200
                                                                                00100300
MOVE:                                                                           00100400
   PROCEDURE (LEGNTH,FROM,INTO);                                                00100500
      DECLARE (FROM,INTO,ADDRTEMP) FIXED,                                       00100600
              MOVECHAR LABEL,                                                   00100700
              LEGNTH BIT(16);                                                   00100800
      IF LEGNTH <= 0 THEN RETURN;                                               00100900
      FROM = FROM & "00FFFFFF";                                                 00101000
      INTO = INTO & "00FFFFFF";                                                 00101100
      DO WHILE 1;                                                               00101200
         IF LEGNTH > 256 THEN DO;                                               00101300
            CALL INLINE("58",2,0,INTO);      /* L 2,INTO                      */00101400
            CALL INLINE("58",3,0,FROM);      /* L 3,FROM                      */00101500
            CALL INLINE("D2",15,15,2,0,3,0); /* MVC 0(255,2),0(3)             */00101600
            LEGNTH = LEGNTH - 256;                                              00101700
            FROM = FROM + 256;                                                  00101800
            INTO = INTO + 256;                                                  00101900
         END;                                                                   00102000
         ELSE DO;                                                               00102100
            ADDRTEMP = ADDR(MOVECHAR);                                          00102200
            CALL INLINE("18",0,4);           /* LR 0,4                        */00102300
            CALL INLINE("58",2,0,INTO);      /* L  2,INTO                     */00102400
            CALL INLINE("58",3,0,FROM);      /* L   3,FROM                    */00102500
            CALL INLINE("48",1,0,LEGNTH);    /* LH 1,LEGNTH                   */00102600
            CALL INLINE("06",1,0);           /* BCTR 1,0                      */00102700
            CALL INLINE("58",4,0,ADDRTEMP);  /* L 4,ADDRTEMP                  */00102800
            CALL INLINE("44",1,0,4,0);       /* EX 1,0(0,4)                   */00102900
            CALL INLINE("18",4,0);           /* LR 4,0                        */00103000
            RETURN;                                                             00103100
         END;                                                                   00103200
      END;                                                                      00103300
MOVECHAR:                                                                       00103400
      CALL INLINE("D2",0,0,2,0,3,0);  /* MVC 0(0,2),0(3)                      */00103500
   END MOVE;                                                                    00103600
                                                                                00103700
   /* ZERO 'COUNT' BYTES OF THE SPECIFIED CORE LOCATIONS                      */00103800
   /* NOTE: 1<= COUNT <= 256                                                  */00103900
                                                                                00104000
ZERO_256:                                                                       00104100
   PROCEDURE (CORE_ADDR,COUNT);                                                 00104200
      DECLARE (CORE_ADDR,MVCTEMP) FIXED,                                        00104300
              COUNT BIT(16),                                                    00104400
              MVC LABEL;                                                        00104500
      COUNT = COUNT - 2;                                                        00104600
      IF COUNT < 0 THEN DO;                                                     00104700
         CALL INLINE("58", 1, 0, CORE_ADDR);  /* L   1,CORE_ADDR              */00104800
         CALL INLINE("92", 0, 0, 1, 0);       /* MVI 0(1),X'00'               */00104900
      END;                                                                      00105000
      ELSE DO;                                                                  00105100
         MVCTEMP = ADDR(MVC);                                                   00105200
         CALL INLINE("58", 1, 0, CORE_ADDR);  /* L   1,CORE_ADDR              */00105300
         CALL INLINE("92", 0, 0, 1, 0);       /* MVI 0(1),X'00'               */00105400
         CALL INLINE("48", 2, 0, COUNT);      /* LH  2,COUNT                  */00105500
         CALL INLINE("58", 3, 0, MVCTEMP);    /* L   3,MVCTEMP                */00105600
         CALL INLINE("44", 2, 0, 3, 0);       /* EX  2,0(0,3)                 */00105700
      END;                                                                      00105800
      RETURN;                                                                   00105900
MVC:                                                                            00106000
      CALL INLINE("D2", 0, 0, 1, 1, 1, 0);    /* MVC 1(0,1),0(1)              */00106100
   END ZERO_256;                                                                00106200
                                                                                00106300
   /* ZERO 'COUNT' BYTES OF THE SPECIFIED CORE LOCATIONS.                     */00106400
   /* NOTE: THERE IS NO LIMIT TO THE SIZE OF 'COUNT'!                         */00106500
                                                                                00106600
ZERO_CORE:                                                                      00106700
   PROCEDURE (CORE_ADDR,COUNT);                                                 00106800
      DECLARE (CORE_ADDR,COUNT,#BYTES) FIXED;                                   00106900
      DO WHILE COUNT ^= 0;                                                      00107000
         IF COUNT > 256 THEN #BYTES = 256;                                      00107100
         ELSE #BYTES = COUNT;                                                   00107200
         CALL ZERO_256(CORE_ADDR,#BYTES);                                       00107300
         CORE_ADDR = CORE_ADDR + #BYTES;                                        00107400
         COUNT = COUNT - #BYTES;                                                00107500
      END;                                                                      00107600
      RETURN;                                                                   00107700
   END ZERO_CORE;                                                               00107800
                                                                                00107900
                                                                                00108800
   /* ROUTINE TO SET VIRTUAL MEMORY PAGE DISPOSITION PARAMETERS               */00108900
                                                                                00109000
DISP:                                                                           00109100
   PROCEDURE (FLAGS);                                                           00109200
      DECLARE FLAGS BIT(8), TEMP BIT(16);                                       00109300
      TEMP = VMEM_PAD_DISP(VMEM_OLD_NDX);                                       00109400
      IF (FLAGS&MODF) ^= 0 THEN                                                 00109500
         TEMP = TEMP|"4000";                                                    00109600
      IF (FLAGS&RESV) ^= 0 THEN DO;                                             00109700
         TEMP = TEMP + 1;                                                       00109800
         VMEM_RESV_CNT = VMEM_RESV_CNT + 1;                                     00109900
      END;                                                                      00110000
      ELSE IF (FLAGS&RELS) ^= 0 THEN DO;                                        00110100
         TEMP = TEMP - 1;                                                       00110200
         VMEM_RESV_CNT = VMEM_RESV_CNT - 1;                                     00110300
      END;                                                                      00110400
      VMEM_PAD_DISP(VMEM_OLD_NDX) = TEMP;                                       00110500
   END DISP;                                                                    00110600
                                                                                00110700
   /* ROUTINE TO 'LOCATE' VIR. MEM. DATA BY POINTER                           */00110800
                                                                                00110900
PTR_LOCATE:                                                                     00111000
   PROCEDURE (PTR,FLAGS);                                                       00111100
      DECLARE  (BUFF_ADDR,PREV_CNT,PTR) FIXED,                                  00111200
               (I,J,PAGE,PAGE_TMP,OFFSET,CUR_NDX) BIT(16),                      00111300
               FLAGS BIT(8);                                                    00111400
      BASED    VMEM_PAGE BIT(8);                                                00111500
                                                                                00111600
PAGING_STRATEGY:                                                                00111700
   PROCEDURE;                                                                   00111800
   DECLARE SET_INDEX LITERALLY 'DO; CUR_NDX=I; PREV_CNT=VMEM_PAD_CNT(I); END';  00111900
      CUR_NDX = -1;                                                             00112000
      DO I = 0 TO VMEM_MAX_PAGE;                                                00112100
         IF (VMEM_PAD_DISP(I) & "3FFF") = 0 THEN DO;                            00112200
            IF CUR_NDX < 0 THEN SET_INDEX;                                      00112300
            ELSE IF (VMEM_PAD_CNT(I) < PREV_CNT) THEN SET_INDEX;                00112400
         END;                                                                   00112500
      END;                                                                      00112600
      IF CUR_NDX < 0 THEN DO;                                                   00112700
         OUTPUT = '*** VIRTUAL MEMORY PAGING AREA DEPLETED ***';                00112800
         CALL EXIT;                                                             00112900
      END;                                                                      00113000
      PAGE_TMP = VMEM_PAD_PAGE(CUR_NDX);                                        00113100
      IF PAGE_TMP ^= -1 THEN DO;                                                00113105
         VMEM_PAGE_TO_NDX(PAGE_TMP) = -1;                                       00113200
         IF PAGE_TMP = VMEM_LOOK_AHEAD_PAGE THEN DO;                            00113300
            CALL MONITOR(31,0,-1);                                              00113400
            VMEM_LOOK_AHEAD_PAGE = -1;                                          00113500
         END;                                                                   00113600
      END;                                                                      00113605
      IF (VMEM_PAD_DISP(CUR_NDX)&"4000") ^= 0 THEN DO;                          00113700
         IF VMEM_LOOK_AHEAD_PAGE >= 0 THEN DO;                                  00113800
            CALL MONITOR(31,0,-1);                                              00113900
            VMEM_LOOK_AHEAD_PAGE = -1;                                          00114000
         END;                                                                   00114100
         COREWORD(ADDR(VMEM_PAGE)) = VMEM_PAD_ADDR(CUR_NDX);                    00114200
         FILE(VMEM_FILE#,PAGE_TMP) = VMEM_PAGE;                                 00114300
         VMEM_WRITE_CNT = VMEM_WRITE_CNT + 1;                                   00114400
      END;                                                                      00114500
   END PAGING_STRATEGY;                                                         00114600
                                                                                00114700
BAD_PTR:                                                                        00114800
    PROCEDURE;                                                                  00114900
      OUTPUT = '*** BAD POINTER DETECTED BY PTR_LOCATE ***';                    00115000
      CALL EXIT;                                                                00115100
   END BAD_PTR;                                                                 00115200
                                                                                00115300
      PAGE = SHR(PTR,16) & "FFFF";                                              00115400
      OFFSET = PTR & "FFFF";                                                    00115500
      IF OFFSET >= VMEM_PAGE_SIZE THEN CALL BAD_PTR;                            00115600
      IF PAGE = VMEM_PRIOR_PAGE THEN DO;                                        00115700
         VMEM_LOC_PTR = PTR;                                                    00115800
         VMEM_LOC_ADDR = VMEM_PAD_ADDR(VMEM_OLD_NDX) + OFFSET;                  00115900
         IF FLAGS ^= 0 THEN CALL DISP(FLAGS);                                   00116000
         RETURN;                                                                00116100
      END;                                                                      00116200
      VMEM_PRIOR_PAGE = PAGE;                                                   00116300
      VMEM_LOC_CNT = VMEM_LOC_CNT + 1;                                          00116400
      IF PAGE > VMEM_LAST_PAGE THEN DO;                                         00116500
         IF (PAGE-1)^=VMEM_LAST_PAGE THEN CALL BAD_PTR;                         00116600
         VMEM_LAST_PAGE = PAGE;                                                 00116700
         VMEM_PAGE_AVAIL_SPACE(VMEM_LAST_PAGE) = VMEM_PAGE_SIZE;                00116800
         IF VMEM_LAST_PAGE <= VMEM_MAX_PAGE THEN DO;                            00116900
            CUR_NDX = VMEM_LAST_PAGE;                                           00117000
         END;                                                                   00117100
         ELSE DO;                                                               00117200
            IF VMEM_LAST_PAGE > VMEM_TOTAL_PAGES THEN DO;                       00117300
               OUTPUT = '*** VIRTUAL MEMORY CAPACITY EXHAUSTED ***';            00117400
               CALL EXIT;                                                       00117500
            END;                                                                00117600
            CALL PAGING_STRATEGY;                                               00117700
         END;                                                                   00117800
         FLAGS = FLAGS|MODF;                                                    00117900
         CALL ZERO_CORE(VMEM_PAD_ADDR(CUR_NDX),VMEM_PAGE_SIZE);                 00118000
         GO TO LOC_COMMON1;                                                     00118100
      END;                                                                      00118200
      ELSE DO;                                                                  00118300
         CUR_NDX = VMEM_PAGE_TO_NDX(PAGE);                                      00118400
         IF CUR_NDX = -1 THEN DO;                                               00118500
            CALL PAGING_STRATEGY;                                               00118600
            IF VMEM_LOOK_AHEAD_PAGE >= 0 THEN DO;                               00118700
               CALL MONITOR(31,0,-1);                                           00118800
               VMEM_LOOK_AHEAD_PAGE = -1;                                       00118900
            END;                                                                00119000
            COREWORD(ADDR(VMEM_PAGE)) = VMEM_PAD_ADDR(CUR_NDX);                 00119100
            VMEM_PAGE = FILE(VMEM_FILE#,PAGE);                                  00119200
            VMEM_READ_CNT = VMEM_READ_CNT + 1;                                  00119300
LOC_COMMON1:                                                                    00119400
            VMEM_PAGE_TO_NDX(PAGE) = CUR_NDX;                                   00119500
            VMEM_PAD_PAGE(CUR_NDX) = PAGE;                                      00119600
            VMEM_PAD_DISP(CUR_NDX) = 0;                                         00119700
         END;                                                                   00119800
         ELSE DO;                                                               00119900
            IF PAGE = VMEM_LOOK_AHEAD_PAGE THEN DO;                             00120000
               CALL MONITOR(31,0,-1);                                           00120100
               VMEM_LOOK_AHEAD_PAGE = -1;                                       00120200
            END;                                                                00120300
         END;                                                                   00120400
         VMEM_PAD_CNT(CUR_NDX) = VMEM_LOC_CNT;                                  00120500
      END;                                                                      00120600
      VMEM_OLD_NDX = CUR_NDX;                                                   00120700
      VMEM_LOC_PTR = PTR;                                                       00120800
      VMEM_LOC_ADDR = VMEM_PAD_ADDR(CUR_NDX) + OFFSET;                          00120900
      IF FLAGS ^= 0 THEN CALL DISP(FLAGS);                                      00121000
      IF VMEM_LOOK_AHEAD THEN DO;                                               00121100
         IF PAGE < VMEM_LAST_PAGE THEN DO;                                      00121200
            PAGE = PAGE + 1;                                                    00121300
            CUR_NDX = VMEM_PAGE_TO_NDX(PAGE);                                   00121400
            IF CUR_NDX = -1 THEN DO;                                            00121500
               VMEM_PAD_DISP(VMEM_OLD_NDX) =                                    00121600
                  VMEM_PAD_DISP(VMEM_OLD_NDX) + 1;                              00121700
               IF VMEM_LAST_PAGE <= VMEM_MAX_PAGE THEN CUR_NDX = VMEM_LAST_PAGE;00121800
               ELSE CALL PAGING_STRATEGY;                                       00121900
               VMEM_PAD_DISP(VMEM_OLD_NDX) =                                    00122000
                  VMEM_PAD_DISP(VMEM_OLD_NDX) - 1;                              00122100
               BUFF_ADDR = VMEM_PAD_ADDR(CUR_NDX);                              00122200
               IF VMEM_LOOK_AHEAD_PAGE >= 0 THEN                                00122300
                  BUFF_ADDR = BUFF_ADDR | "80000000";                           00122400
               CALL MONITOR(31,BUFF_ADDR,PAGE);                                 00122500
               VMEM_LOOK_AHEAD_PAGE = PAGE;                                     00122600
               VMEM_READ_CNT = VMEM_READ_CNT + 1;                               00122700
               VMEM_PAGE_TO_NDX(PAGE) = CUR_NDX;                                00122800
               VMEM_PAD_PAGE(CUR_NDX) = PAGE;                                   00122900
               VMEM_PAD_DISP(CUR_NDX) = 0;                                      00123000
               VMEM_PAD_CNT(CUR_NDX) = VMEM_LOC_CNT - 1;                        00123100
            END;                                                                00123200
         END;                                                                   00123300
      END;                                                                      00123400
   END PTR_LOCATE;                                                              00123500
                                                                                00123600
                                                                                00135800
   /* ROUTINE TO 'LOCATE' A VIRTUAL MEMORY POINTER AND ...                    */00135900
   /* ASSIGN IT TO A BASED VARIABLE                                           */00136000
                                                                                00136100
LOCATE:                                                                         00136200
   PROCEDURE (PTR,BVAR,FLAGS);                                                  00136300
      DECLARE (PTR,BVAR) FIXED,                                                 00136400
              FLAGS BIT(8);                                                     00136500
      CALL PTR_LOCATE(PTR,FLAGS);                                               00136600
      COREWORD(BVAR) = VMEM_LOC_ADDR;                                           00136700
   END LOCATE;                                                                  00136800
                                                                                00136900
