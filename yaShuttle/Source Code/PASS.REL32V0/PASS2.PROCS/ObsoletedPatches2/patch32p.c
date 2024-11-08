{
  // File:      patch32p.c
  // For:       GENERATExINTEGERIZABLE.c
  // Notes:     1. Page references are from IBM "ESA/390 Principles of
  //               Operation", SA22-7201-08, Ninth Edition, June 2003.
  //            2. Labels are of the form p%d_%d, where the 1st number
  //               indicates the leading patch number of the block, and
  //               the 2nd is the byte offset of the instruction within
  //               within the block.
  //            3. Known-problematic translations are marked with the
  //               string  "* * * F I X M E * * *" (without spaces).
  // History:   2024-06-30 RSB  Auto-generated by XCOM-I --guess-inlines.
  //                            Checked and renamed.

p32_0: ;
  // (32)          CALL INLINE("58", 1, 0, ADDR_FIXER);         /* L    1,ADDR_FIXER */   
  address360B = (2188) & 0xFFFFFF;
  // Type RX, p. 7-7:		L	1,2188(0,0)
  detailedInlineBefore(32, "L	1,2188(0,0)");
  GR[1] = COREWORD(address360B);
  detailedInlineAfter();

p32_4: ;
  // (33)          CALL INLINE("6E", 0, 0, 1, 0);               /* AW   0,0(0,1)     */   
  address360B = (GR[1] + 0) & 0xFFFFFF;
  // Type RX, p. 18-10:		AW	0,0(0,1)
  detailedInlineBefore(33, "AW	0,0(0,1)");
  aw(0, address360B);
  detailedInlineAfter();

p32_8: ;
  // (34)          CALL INLINE("58",1,0,FOR_DW);             /* L   1,DW   */             
  address360B = (1484) & 0xFFFFFF;
  // Type RX, p. 7-7:		L	1,1484(0,0)
  detailedInlineBefore(34, "L	1,1484(0,0)");
  GR[1] = COREWORD(address360B);
  detailedInlineAfter();

p32_12: ;
  // (35)          CALL INLINE("60", 0, 0, 1, 8);            /* STD 0,8(0,1)      */      
  address360B = (GR[1] + 8) & 0xFFFFFF;
  // Type RX, p. 9-11:		STD	0,8(0,1)
  detailedInlineBefore(35, "STD	0,8(0,1)");
  std(0, address360B);
  detailedInlineAfter();

p32_16: ;
  // (36)          CALL INLINE("70", 2, 0, 1, 8);             /* STE 2,8(0,1)     */      
  address360B = (GR[1] + 8) & 0xFFFFFF;
  // Type RX, p. 9-11:		STE	2,8(0,1)
  detailedInlineBefore(36, "STE	2,8(0,1)");
  toFloatIBM(&msw360, &lsw360, FR[2]);
  COREWORD2(address360B, msw360);
  detailedInlineAfter();

p32_20: ;
}
