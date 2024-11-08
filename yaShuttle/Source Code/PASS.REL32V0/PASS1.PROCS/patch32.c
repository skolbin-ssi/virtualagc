{
  // File:      patch32.c
  // For:       BLANK.c
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

p32_0: ;
  // (32)       CALL INLINE("D2", 0, 0, 1, 1, 1, 0);  /* MVC 1(0,1),0(1)       */         
  address360A = (GR[1] + 1) & 0xFFFFFF;
  address360B = (GR[1] + 0) & 0xFFFFFF;
  // Type SS, p. 7-83:		MVC	1(0,1),0(1)
  detailedInlineBefore(32, "MVC	1(0,1),0(1)");
  mvc(address360A, address360B, 0);
  detailedInlineAfter();

p32_6: ;
}
