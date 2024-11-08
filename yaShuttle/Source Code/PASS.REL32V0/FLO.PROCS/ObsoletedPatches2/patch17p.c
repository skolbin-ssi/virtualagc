{
  // File:      patch17p.c
  // For:       ZERO_256.c
  // Notes:     1. Page references are from IBM "ESA/390 Principles of
  //               Operation", SA22-7201-08, Ninth Edition, June 2003.
  //            2. Labels are of the form p%d_%d, where the 1st number
  //               indicates the leading patch number of the block, and
  //               the 2nd is the byte offset of the instruction within
  //               within the block.
  //            3. Known-problematic translations are marked with the
  //               string  "* * * F I X M E * * *" (without spaces).
  // History:   2024-06-30 RSB  Auto-generated by XCOM-I --guess-inlines.
  //                            Checked, changed "guess" to "patch".

p17_0: ;
  // (17)          CALL INLINE("58", 1, 0, CORE_ADDR);  /* L   1,CORE_ADDR              */
  address360B = (26292) & 0xFFFFFF;
  // Type RX, p. 7-7:		L	1,26292(0,0)
  detailedInlineBefore(17, "L	1,26292(0,0)");
  GR[1] = COREWORD(address360B);
  detailedInlineAfter();

p17_4: ;
  // (18)          CALL INLINE("92", 0, 0, 1, 0);       /* MVI 0(1),X'00'               */
  address360A = (GR[1] + 0) & 0xFFFFFF;
  // Type SI, p. 7-83:		MVI	0(1),0
  detailedInlineBefore(18, "MVI	0(1),0");
  memory[address360A] = 0;
  detailedInlineAfter();

p17_8: ;
}
