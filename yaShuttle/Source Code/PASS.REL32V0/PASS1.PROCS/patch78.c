{
  // File:      patch78.c
  // For:       STABuHDR.c
  // Notes:     1. Page references are from IBM "ESA/390 Principles of
  //               Operation", SA22-7201-08, Ninth Edition, June 2003.
  //            2. Labels are of the form p%d_%d, where the 1st number
  //               indicates the leading patch number of the block, and
  //               the 2nd is the byte offset of the instruction within
  //               within the block.
  //            3. Known-problematic translations are marked with the
  //               string  "* * * F I X M E * * *" (without spaces).
  // History:   2024-07-17 RSB  Auto-generated by XCOM-I --guess=....
  //                            Inspected.

p78_0: ;
  // (78)          CALL INLINE("48",1,0,SRNuINX);
  address360B = (mSTABuHDRxSRNuINX) & 0xFFFFFF;
  // Type RX, p. 7-80:		LH	1,mSTABuHDRxSRNuINX(0,0)
  detailedInlineBefore(78, "LH	1,mSTABuHDRxSRNuINX(0,0)");
  GR[1] = COREHALFWORD(address360B);
  detailedInlineAfter();

p78_4: ;
  // (79)          CALL INLINE("5A",1,0,NODEuH);
  address360B = (mSTABuHDRxNODEuH) & 0xFFFFFF;
  // Type RX, p. 7-12:		A	1,mSTABuHDRxNODEuH(0,0)
  detailedInlineBefore(79, "A	1,mSTABuHDRxNODEuH(0,0)");
  scratchd = GR[1] + COREWORD(address360B);
  setCC();
  GR[1] = scratch;
  detailedInlineAfter();

p78_8: ;
  // (80)          CALL INLINE("58",2,0,S);                                               
  address360B = (mS) & 0xFFFFFF;
  // Type RX, p. 7-7:		L	2,mS(0,0)
  detailedInlineBefore(80, "L	2,mS(0,0)");
  GR[2] = COREWORD(address360B);
  detailedInlineAfter();

p78_12: ;
  // (81)          CALL INLINE("D2",0,7,1,0,2,0);           /*CR12214*/                   
  address360A = (GR[1] + 0) & 0xFFFFFF;
  address360B = (GR[2] + 0) & 0xFFFFFF;
  // Type SS, p. 7-83:		MVC	0(7,1),0(2)
  detailedInlineBefore(81, "MVC	0(7,1),0(2)");
  mvc(address360A, address360B, 7);
  detailedInlineAfter();

p78_18: ;
}