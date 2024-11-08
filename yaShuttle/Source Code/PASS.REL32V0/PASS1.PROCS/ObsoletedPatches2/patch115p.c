{
  // File:    patch115p.c
  // For:     HALMAT_INIT_CONSTxROUND_SCALAR.c
  // Notes:   1. Page references are from IBM "ESA/390 Principles of
  //             Operation", SA22-7201-08, Ninth Edition, June 2003.
  //          2. Labels are of the form p%d_%d, where the 1st number
  //             indicates the leading patch number of the block, and
  //             the 2nd is the byte offset of the instruction within
  //             within the block.
  //          3. Known-problematic translations are marked with the
  //             string  "* * * F I X M E * * *" (without spaces).
  // History: 2024-06-25 RSB  Auto-generated by XCOM-I --guess-inlines.
  //                          Checked and changed name from "guess" to "patch".

p115_0: ;
  // (115)             CALL INLINE("58",1,0,DW_AD);                                        
  address360B = 33700;
  // Type RX, p. 7-7:		L	1,33700(0,0)
  GR[1] = COREWORD(address360B);

p115_4: ;
  // (116)             CALL INLINE("97",8,0,1,0);                                          
  address360A = GR[1] + 0;
  // Type SI, p. 7-74:		XI	0(1),128
  scratch = 128 ^ memory[address360A];
  CC = (scratch != 0);
  memory[address360A] = scratch;

p115_8: ;
}
