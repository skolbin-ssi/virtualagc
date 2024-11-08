{
  // File:      patch60p.c
  // For:       OBJECT_GENERATORxEMIT_SYM_CARDSxEMIT_SYM.c
  // Notes:     1. Page references are from IBM "ESA/390 Principles of
  //               Operation", SA22-7201-08, Ninth Edition, June 2003.
  //            2. Labels are of the form p%d_%d, where the 1st number
  //               indicates the leading patch number of the block, and
  //               the 2nd is the byte offset of the instruction within
  //               within the block.
  //            3. Known-problematic translations are marked with the
  //               string  "* * * F I X M E * * *" (without spaces).
  // History:   2024-06-30 RSB  Auto-generated by XCOM-I --guess-inlines.
  //                            Fixed EX instruction, checked otherwise,
  //                            renamed "guess" to "patch".

p60_0: ;
  // (60)             CALL INLINE("58", 1, 0, TEMP);                                      
  address360B = (71352) & 0xFFFFFF;
  // Type RX, p. 7-7:		L	1,71352(0,0)
  detailedInlineBefore(60, "L	1,71352(0,0)");
  GR[1] = COREWORD(address360B);
  detailedInlineAfter();

p60_4: ;
  // (61)             CALL INLINE("58", 2, 0, NAME);                                      
  address360B = (73360) & 0xFFFFFF;
  // Type RX, p. 7-7:		L	2,73360(0,0)
  detailedInlineBefore(61, "L	2,73360(0,0)");
  GR[2] = COREWORD(address360B);
  detailedInlineAfter();

p60_8: ;
  // (62)             CALL INLINE("1B", 3, 3);                                            
  // Type RR, p. 7-127:		SR	3,3
  detailedInlineBefore(62, "SR	3,3");
  scratch = (int64_t) GR[3] - (int64_t) GR[3];
  setCC();
  GR[3] = (int32_t) scratch;
  detailedInlineAfter();

p60_10: ;
  // (63)             CALL INLINE("43", 3, 0, NAME);                                      
  address360B = (73360) & 0xFFFFFF;
  // Type RX, p. 7-76:		IC	3,73360(0,0)
  detailedInlineBefore(63, "IC	3,73360(0,0)");
  GR[3] = memory[address360B] | (GR[3] & 0xFFFFFF00);
  detailedInlineAfter();

p60_14: ;
  // (64)             CALL INLINE("18", 0, 4);                                            
  // Type RR, p. 7-77:		LR	0,4
  detailedInlineBefore(64, "LR	0,4");
  GR[0] = GR[4];
  detailedInlineAfter();

p60_16: ;
  // (65)             CALL INLINE("58", 4, 0, TEMPL);                                     
  address360B = (71356) & 0xFFFFFF;
  // Type RX, p. 7-7:		L	4,71356(0,0)
  detailedInlineBefore(65, "L	4,71356(0,0)");
  GR[4] = COREWORD(address360B);
  detailedInlineAfter();

p60_20: ;
  // (66)             CALL INLINE("44", 3, 0, 4, 0);                                      
  address360B = (GR[4] + 0) & 0xFFFFFF;
  // Type RX, p. 7-74:		EX	3,0(0,4)
  detailedInlineBefore(66, "EX	3,0(0,4)");
  // Here's the MVC instruction targeted by this EX:
  mvc(GR[1], GR[2], GR[3]);
  detailedInlineAfter();

p60_24: ;
  // (67)             CALL INLINE("18", 4, 0);                                            
  // Type RR, p. 7-77:		LR	4,0
  detailedInlineBefore(67, "LR	4,0");
  GR[4] = GR[0];
  detailedInlineAfter();

p60_26: ;
}
