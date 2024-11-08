{
  // File:      patch121b.c
  // For:       INITIALIZATION.c
  // Notes:     1. Page references are from IBM "ESA/390 Principles of
  //               Operation", SA22-7201-08, Ninth Edition, June 2003.
  //            2. Labels are of the form p%d_%d, where the 1st number
  //               indicates the leading patch number of the block, and
  //               the 2nd is the byte offset of the instruction within
  //               within the block.
  //            3. Known-problematic translations are marked with the
  //               string  "* * * F I X M E * * *" (without spaces).
  // History:   2024-07-17 RSB  Auto-generated by XCOM-I --guess.
  //                            Inspected.

p121_0: ;
  // (121)       CALL INLINE("58",1,0,LIT_NDX);                                            
  address360B = (1456) & 0xFFFFFF;
  // Type RX, p. 7-7:		L	1,1456(0,0)
  detailedInlineBefore(121, "L	1,1456(0,0)");
  GR[1] = COREWORD(address360B);
  detailedInlineAfter();

p121_4: ;
  // (122)       CALL INLINE("50",1,0,LIT_CHAR_AD);           /* ST  1,LIT_CHAR_AD */      
  address360B = (2200) & 0xFFFFFF;
  // Type RX, p. 7-122:		ST	1,2200(0,0)
  detailedInlineBefore(122, "ST	1,2200(0,0)");
  COREWORD2(address360B, GR[1]);
  detailedInlineAfter();

p121_8: ;
  // (123)       CALL INLINE("58",1,0,FOR_DW);                                             
  address360B = (1484) & 0xFFFFFF;
  // Type RX, p. 7-7:		L	1,1484(0,0)
  detailedInlineBefore(123, "L	1,1484(0,0)");
  GR[1] = COREWORD(address360B);
  detailedInlineAfter();

p121_12: ;
  // (124)       CALL INLINE("50",1,0,DW_AD);                   /* ST  1,DW_AD       */    
  address360B = (33700) & 0xFFFFFF;
  // Type RX, p. 7-122:		ST	1,33700(0,0)
  detailedInlineBefore(124, "ST	1,33700(0,0)");
  COREWORD2(address360B, GR[1]);
  detailedInlineAfter();

p121_16: ;
}