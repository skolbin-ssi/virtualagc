{
  /*
   * File:      patch19.c
   * For:       DUMPuSDFxINTEGERIZABLE.c
   * Notes:     1. Page references are from IBM "ESA/390 Principles of
   *               Operation", SA22-7201-08, Ninth Edition, June 2003.
   *            2. Labels are of the form p%d_%d, where the 1st number
   *               indicates the leading patch number of the block, and
   *               the 2nd is the byte offset of the instruction within
   *               within the block.
   *            3. Known-problematic translations are marked with the
   *               string  "* * * F I X M E * * *" (without spaces).
   * History:   2024-07-18 RSB  Auto-generated by XCOM-I --guess=....
   *                            Inspected.
   */

p19_0: ;
  // (19)          CALL INLINE("28", 2, 0);                    /* LDR 2,0     */          
  // Type RR, p. 9-10:		LDR	2,0
  detailedInlineBefore(19, "LDR	2,0");
  FR[2] = FR[0];
  detailedInlineAfter();

p19_2: ;
  // (20)          CALL INLINE("20", 0, 0);                    /* LPDR 0,0    */          
  // Type RR, p. 18-17:		LPDR	0,0
  detailedInlineBefore(20, "LPDR	0,0");
  scratchd = fabs(FR[0]);
  setCCd();
  FR[0] = scratchd;
  detailedInlineAfter();

p19_4: ;
  // (21)          CALL INLINE("2B", 4, 4);                    /* SDR 4,4     */          
  // Type RR, p. 18-23:		SDR	4,4
  detailedInlineBefore(21, "SDR	4,4");
  scratchd = FR[4] - FR[4];
  setCCd();
  FR[4] = scratchd;
  detailedInlineAfter();

p19_6: ;
  // (22)          CALL INLINE("78", 4, 0, FLTuNEGMAX);        /* LE 4,FLTuNEGMAX */
  address360B = (mDUMPuSDFxINTEGERIZABLExFLTuNEGMAX) & 0xFFFFFF;
  // Type RX, p. 9-10:		LE	4,mDUMPuSDFxINTEGERIZABLExFLTuNEGMAX(0,0)
  detailedInlineBefore(22, "LE	4,mDUMPuSDFxINTEGERIZABLExFLTuNEGMAX(0,0)");
  FR[4] = fromFloatIBM(COREWORD(address360B), 0);
  detailedInlineAfter();

p19_10: ;
  // (23)          CALL INLINE("58", 2, 0, TEMP1);             /* L 2,TEMP1   */          
  address360B = (mDUMPuSDFxINTEGERIZABLExTEMP1) & 0xFFFFFF;
  // Type RX, p. 7-7:		L	2,mDUMPuSDFxINTEGERIZABLExTEMP1(0,0)
  detailedInlineBefore(23, "L	2,mDUMPuSDFxINTEGERIZABLExTEMP1(0,0)");
  GR[2] = COREWORD(address360B);
  detailedInlineAfter();

p19_14: ;
  // (24)          CALL INLINE("29", 4, 2);                    /* CDR 4,2     */          
  // Type RR, p. 18-10:		CDR	4,2
  detailedInlineBefore(24, "CDR	4,2");
  scratchd = FR[4] - FR[2];
  setCCd();
  detailedInlineAfter();

p19_16: ;
  // (25)          CALL INLINE("07", 8, 2);                    /* BCR 8,2     */          
  // Type RR, p. 7-17:		BCR	8,2
  detailedInlineBefore(25, "BCR	8,2");
  mask360 = 8;
  if ((CC == 0 && (mask360 & 8) != 0) || (CC == 1 && (mask360 & 4) != 0) || 
      (CC == 2 && (mask360 & 2) != 0) || (CC == 3 && (mask360 & 1) != 0))
    switch (GR[2]) {
      case -1: goto LITuNEGMAX;
      case -2: goto NOuINTEGER;
      default: abend("Branch address must be a label in this procedure");
    }
  detailedInlineAfter();

p19_18: ;
  // (26)          CALL INLINE("58", 1, 0, ADDRuROUNDER);      /* L 1,ADDRuROUNDER */
  address360B = (mADDRuROUNDER) & 0xFFFFFF;
  // Type RX, p. 7-7:		L	1,mADDRuROUNDER(0,0)
  detailedInlineBefore(26, "L	1,mADDRuROUNDER(0,0)");
  GR[1] = COREWORD(address360B);
  detailedInlineAfter();

p19_22: ;
  // (27)          CALL INLINE("6A", 0, 0, 1, 0);              /* AD 0,0(0,1) */          
  address360B = (GR[1] + 0) & 0xFFFFFF;
  // Type RX, p. 18-8:		AD	0,0(0,1)
  detailedInlineBefore(27, "AD	0,0(0,1)");
  scratchd = FR[0];
  scratchd += fromFloatIBM(COREWORD(address360B), COREWORD(address360B + 4));
  setCCd();
  FR[0] = scratchd;
  detailedInlineAfter();

p19_26: ;
  // (28)          CALL INLINE("58", 1, 0, ADDRuFIXEDuLIMIT);  /* L 1,ADDR__LIMIT */
  address360B = (mADDRuFIXEDuLIMIT) & 0xFFFFFF;
  // Type RX, p. 7-7:		L	1,mADDRuFIXEDuLIMIT(0,0)
  detailedInlineBefore(28, "L	1,mADDRuFIXEDuLIMIT(0,0)");
  GR[1] = COREWORD(address360B);
  detailedInlineAfter();

p19_30: ;
  // (29)          CALL INLINE("58", 2, 0, TEMP);              /* L 2,TEMP    */          
  address360B = (mDUMPuSDFxINTEGERIZABLExTEMP) & 0xFFFFFF;
  // Type RX, p. 7-7:		L	2,mDUMPuSDFxINTEGERIZABLExTEMP(0,0)
  detailedInlineBefore(29, "L	2,mDUMPuSDFxINTEGERIZABLExTEMP(0,0)");
  GR[2] = COREWORD(address360B);
  detailedInlineAfter();

p19_34: ;
  // (30)          CALL INLINE("69", 0, 0, 1, 0);              /* CD 0,0(0,1) */          
  address360B = (GR[1] + 0) & 0xFFFFFF;
  // Type RX, p. 18-10:		CD	0,0(0,1)
  detailedInlineBefore(30, "CD	0,0(0,1)");
  scratchd = FR[0];
  scratchd -= fromFloatIBM(COREWORD(address360B), COREWORD(address360B + 4));
  setCCd();
  detailedInlineAfter();

p19_38: ;
  // (31)          CALL INLINE("07", 2, 2);                    /* BCR 2,2     */          
  // Type RR, p. 7-17:		BCR	2,2
  detailedInlineBefore(31, "BCR	2,2");
  mask360 = 2;
  if ((CC == 0 && (mask360 & 8) != 0) || (CC == 1 && (mask360 & 4) != 0) || 
      (CC == 2 && (mask360 & 2) != 0) || (CC == 3 && (mask360 & 1) != 0))
    switch (GR[2]) {
      case -1: goto LITuNEGMAX;
      case -2: goto NOuINTEGER;
      default: abend("Branch address must be a label in this procedure");
    }
  detailedInlineAfter();

p19_40: ;
}
