   /*  FIRST WE INITIALIZE THE GLOBAL CONSTANTS THAT DEPEND UPON THE INPUT      
      GRAMMAR.  THE FOLLOWING CARDS ARE PUNCHED BY THE SYNTAX PRE-PROCESSOR  */ 
                                                                                
   /*  XPL PARSING TABLES  */                                                   
                                                                                
   DECLARE MAXTL LITERALLY '12' ;                                               
   DECLARE MAXNTL LITERALLY '26' ;                                              
   DECLARE STARTSTATE LITERALLY '112' ;                                         
   DECLARE NT LITERALLY '42' ;                                                  
   DECLARE NSY LITERALLY '92' ;                                                 
   DECLARE NSTATES LITERALLY '228' ;                                            
   DECLARE V(92) CHARACTER INITIAL ( '< DUMMY >', '<', '(', '+', '|',           
      '&', '*', ')', ';', '~', '-', '/', ',', '>', ':', '=', '||',              
      'BY', 'DO', 'GO', 'IF', 'TO', 'BIT', 'END', 'EOF', 'MOD', 'CALL',         
      'CASE', 'ELSE', 'GOTO', 'THEN', 'FIXED', 'LABEL', 'WHILE',                
      'RETURN', 'DECLARE', 'INITIAL', '<NUMBER>', '<STRING>',                   
      'CHARACTER', 'LITERALLY', 'PROCEDURE', '<IDENTIFIER>', '<TERM>',          
      '<TYPE>', '<GO TO>', '<GROUP>', '<ENDING>', '< START >',                  
      '<PRIMARY>', '<PROGRAM>', '<REPLACE>', '<BIT HEAD>',                      
      '<CONSTANT>', '<RELATION>', '<VARIABLE>', '<IF CLAUSE>',                  
      '<LEFT PART>', '<STATEMENT>', '<TRUE PART>', '<ASSIGNMENT>',              
      '<BOUND HEAD>', '<EXPRESSION>', '<GROUP HEAD>', '<IF STATEMENT>',         
      '<INITIAL HEAD>', '<INITIAL LIST>', '<WHILE CLAUSE>',                     
      '<CASE SELECTOR>', '<CALL STATEMENT>', '<LOGICAL FACTOR>',                
      '<PARAMETER HEAD>', '<PARAMETER LIST>', '<PROCEDURE HEAD>',               
      '<PROCEDURE NAME>', '<STATEMENT LIST>', '<SUBSCRIPT HEAD>',               
      '<BASIC STATEMENT>', '<GO TO STATEMENT>', '<IDENTIFIER LIST>',            
      '<LOGICAL PRIMARY>', '<STEP DEFINITION>', '<LABEL DEFINITION>',           
      '<RETURN STATEMENT>', '<TYPE DECLARATION>',                               
      '<ITERATION CONTROL>', '<LOGICAL SECONDARY>',                             
      '<STRING EXPRESSION>', '<DECLARATION ELEMENT>',                           
      '<PROCEDURE DEFINITION>', '<ARITHMETIC EXPRESSION>',                      
      '<DECLARATION STATEMENT>', '<IDENTIFIER SPECIFICATION>') ;                
   DECLARE VT_INDEX(13) BIT(8) INITIAL (0,  1, 16, 22, 26, 31, 34, 35,          
      37, 39, 42, 42, 42, 43) ;                                                 
   DECLARE STATESTART(228) BIT(16) INITIAL (0,   1,   1,   2,   1,   1,         
        2,   2,   2,   2,   2,   2,   2,   1,   2,   2,   3,   2,   3,          
        2,   2,   2,   3,   3,   3,   2,   4,   2,   4,   2,   2,   3,          
        2,   3,   3,   4,   2,   3,   1,   3,   1,   2,   2,   2,   1,          
        2,   2,   2,   2,   1,   2,   3,   1,   3,   2,   4,   2,   1,          
        1,   1,   3,   2,   2,   1,   3,   1,   3,   3,   2,   3,   3,          
        2,   1,   2,   1,   3,   1,   3,   1,   2,   1,   3,   1,   1,          
        1,   2,   2,   2,   2,   2,   1,   3,   1,   3,   3,   2,   2,          
        1,   3,   3,   3,   1,   1,   3,   1,   3,   2,   3,   1,   1,          
        3,   1,   2,  32, 351, 352, 372,   1, 394,   2, 435, 436, 437,          
      438, 460, 489, 522, 523, 554, 555, 584,   3,  98, 636, 678, 667,          
      668, 669,  41, 267,   4, 286, 348, 349, 350,  59,  77, 116, 130,          
        5,   6,   7,   8,   9, 264,  10,  90, 142, 150, 226,  11,  12,          
      168,  13, 172, 210,  14, 186, 198,  15,  16,  17, 229,  18, 247,          
       19, 288, 306, 309,  20, 329,  21, 370,  22,  23, 403, 414,  24,          
      426, 402, 404, 405, 411, 412, 413, 415, 420, 421, 424, 441,  25,          
      494,  26,  27, 637, 606, 594, 595, 598, 596, 605, 671, 375, 433,          
      707,  86, 158, 266, 263, 161, 224, 167, 171, 223, 327, 401, 417,          
      706, 553) ;                                                               
   DECLARE STATEMIDDLE(228) BIT(16) INITIAL (0,   0,   0,   0,   0,             
        0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,          
        0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,          
        0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,          
        0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,          
        0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,          
        0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,          
        0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,          
        0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,          
        0,   0,   2,  11,  36, 352, 359, 373,   0, 396,   0, 436, 437,          
      438, 440, 469, 490, 523, 533, 555, 564, 590,   0, 105, 637, 688,          
      668, 669, 671,  48, 274,   0, 287, 349, 350, 351,  66,  81, 122,          
      134,   0,   0,   0,   0,   0, 266,   0,  94, 146, 154, 229,   0,          
        0, 171,   0, 178, 216,   0, 190, 202,   0,   0,   0, 236,   0,          
      254,   0, 295, 308, 316,   0, 336,   0, 372,   0,   0, 404, 415,          
        0, 431, 403, 405, 409, 412, 413, 414, 417, 421, 423, 426, 448,          
        0, 503,   0,   0, 648, 616, 595, 596, 603, 598, 606, 673, 382,          
      435, 716,  87, 161, 267, 264, 166, 226, 168, 172, 224, 329, 402,          
      418, 707, 554) ;                                                          
   DECLARE STATEEND(228) BIT(16) INITIAL (0,  50,  75,  75,  58,  58,           
       77,  77,  77,  77,  77,  77,  77,  77,  77,  64,  64,  64,  56,          
       59,  46,  63,  63,  63,  63,  63,  81,  85,  85,  67,  68,  89,          
       73,  73,  73,  73,  74,  72,  71,  71,  47,  47,  47,  82,  83,          
       83,  69,  78,  45,  45,  91,  91,  88,  88,  84,  84,  84,  44,          
       44,  44,  44,  52,  61,  92,  92,  79,  79,  66,  65,  65,  60,          
       60,  51,  57,  62,  62,  70,  70,  86,  86,  80,  80,  54,  54,          
       54,  54,  54,  54,  54,  54,  87,  87,  90,  90,  90,  90,  90,          
       43,  43,  43,  43,  49,  49,  49,  55,  55,  76,  76,  53,  53,          
       48,   1,  31,  40, 351, 369, 374, 212, 400, 213, 435, 436, 437,          
      440, 488, 493, 522, 552, 554, 583, 593, 214, 115, 636, 705, 667,          
      668, 670,  58, 284, 215, 287, 348, 349, 350,  76,  85, 129, 138,          
      216, 217, 218, 219, 220, 265, 216,  97, 149, 157, 228, 216, 221,          
      170, 222, 183, 222, 220, 194, 206, 216, 216, 223, 245, 218, 262,          
      217, 305, 308, 326, 224, 346, 217, 371, 217, 225, 403, 414, 226,          
      432, 402, 404, 410, 411, 412, 413, 416, 420, 423, 425, 458, 217,          
      521, 227, 228, 666, 635, 594, 595, 604, 597, 605, 677, 392, 434,          
      734,  86, 160, 266, 263, 166, 225, 167, 171, 223, 328, 401, 419,          
      706, 553) ;                                                               
   DECLARE STATETOKEN(228) BIT(8) INITIAL (0, 75, 58, 58, 77, 64,  8,           
       8,  8,  8,  8,  8,  8,  8, 77, 58, 58, 64, 30, 28, 47,  8,  8,           
       8,  8, 58, 85, 62, 62, 62, 62, 47,  8,  8,  8,  8, 41,  7,  2,           
      12, 23, 42, 47, 14, 34, 62, 55, 42, 21, 29, 88, 88, 84, 38, 44,           
      44, 66, 31, 39, 32,  7,  2,  2, 42,  7,  2, 12,  7,  2, 12, 62,           
      60, 15, 12, 70, 70, 86, 86, 80, 80, 87, 87, 15,  1, 13, 15,  1,           
      13, 15, 15, 90, 90, 43, 43, 43, 43, 43, 49, 49, 49, 49, 53, 55,           
       7, 42,  7,  2, 12, 38, 37, 24,  0, 24, 18, 19, 20, 26, 34, 35,           
      42, 45, 46, 50, 55, 56, 57, 60, 63, 69, 73, 74, 75, 76, 78, 82,           
      83, 89, 91, 27, 33, 42, 55, 67, 68, 81,  2,  3,  9, 10, 43, 62,           
      70, 87, 90, 62, 43,  6, 11, 25, 62, 43,  1,  9, 13, 16, 54, 90,           
       3, 10, 43, 43, 87,  4, 70,  5, 62, 51, 62, 21, 62, 17, 62, 62,           
      62, 42, 61, 79, 84, 92, 40, 37,  7, 22, 52, 37, 42, 36, 65, 53,           
      51, 62, 59, 77, 23, 82, 75, 44, 71, 72, 42, 44, 12, 34, 42, 75,           
      42, 43, 62, 70, 87, 90,  1, 13, 87, 62, 42, 84, 77, 23) ;                 
   DECLARE STATETYPE(57) BIT(8) INITIAL ("(2)0111", "(2)1111",                  
      "(2)1111", "(2)1111", "(2)1111", "(2)1111", "(2)1111",                    
      "(2)1111", "(2)1111", "(2)1111", "(2)1111", "(2)1111",                    
      "(2)1111", "(2)1111", "(2)1111", "(2)1111", "(2)1111",                    
      "(2)1111", "(2)1111", "(2)1111", "(2)1111", "(2)1111",                    
      "(2)1111", "(2)1111", "(2)1111", "(2)1111", "(2)1111",                    
      "(2)1102", "(2)2222", "(2)2323", "(2)2222", "(2)2222",                    
      "(2)2223", "(2)2222", "(2)2222", "(2)3222", "(2)2222",                    
      "(2)2333", "(2)3323", "(2)2222", "(2)3323", "(2)2232",                    
      "(2)2333", "(2)2323", "(2)2223", "(2)2323", "(2)3223",                    
      "(2)2222", "(2)2222", "(2)2222", "(2)3233", "(2)2222",                    
      "(2)2222", "(2)2222", "(2)2222", "(2)2222", "(2)2222",                    
      "(2)2000") ;                                                              
   DECLARE SCANTOKENS(734) BIT(8) INITIAL (0, 24,  8, 18, 19, 20, 26,           
      29, 34, 35, 42, 45, 46, 50, 55, 56, 57, 58, 60, 63, 64, 69, 73,           
      74, 75, 76, 77, 78, 82, 83, 89, 91,  8, 27, 33, 42, 55, 67, 68,           
      76, 81,  2,  3,  9, 10, 37, 38, 42, 43, 49, 53, 55, 62, 70, 76,           
      80, 86, 87, 90,  2,  3,  9, 10, 37, 38, 42, 43, 49, 53, 55, 62,           
      70, 76, 80, 86, 87, 90,  2, 37, 38, 42, 43, 49, 53, 55, 76,  2,           
       6, 11, 25,  2, 37, 38, 42, 49, 53, 55, 76,  2,  3,  9, 10, 37,           
      38, 42, 43, 49, 53, 55, 62, 70, 76, 80, 86, 87, 90,  2,  3, 10,           
      37, 38, 42, 43, 49, 53, 55, 76, 80, 87, 90,  2, 37, 38, 42, 43,           
      49, 53, 55, 76,  6, 11, 25,  2, 37, 38, 42, 49, 53, 55, 76,  2,           
      37, 38, 42, 49, 53, 55, 76,  6, 11, 25,  1,  9, 13, 15, 16, 54,           
      15,  1, 13, 15, 15,  2,  3, 10, 37, 38, 42, 43, 49, 53, 55, 76,           
      90,  3, 10,  2, 37, 38, 42, 43, 49, 53, 55, 76,  6, 11, 25,  2,           
      37, 38, 42, 43, 49, 53, 55, 76,  6, 11, 25,  2,  3, 10, 37, 38,           
      42, 43, 49, 53, 55, 76, 87, 90, 16,  3, 10,  4,  7, 12,  2,  3,           
       9, 10, 37, 38, 42, 43, 49, 53, 55, 70, 76, 80, 86, 87, 90,  5,           
       2,  3,  9, 10, 37, 38, 42, 43, 49, 53, 55, 76, 80, 86, 87, 90,           
       5,  4,  7,  4,  2,  3,  9, 10, 37, 38, 42, 43, 49, 53, 55, 62,           
      70, 76, 80, 86, 87, 90,  4, 15, 51,  2,  3,  9, 10, 37, 38, 42,           
      43, 49, 53, 55, 62, 70, 76, 80, 86, 87, 90,  4, 21, 85,  2,  3,           
       9, 10, 37, 38, 42, 43, 49, 53, 55, 62, 70, 76, 80, 86, 87, 90,           
       4, 17,  2,  3,  9, 10, 37, 38, 42, 43, 49, 53, 55, 62, 70, 76,           
      80, 86, 87, 90,  4,  8,  8,  8, 21,  2,  3,  9, 10, 37, 38, 42,           
      43, 49, 53, 55, 62, 70, 76, 80, 86, 87, 90,  4, 30, 42, 55, 76,           
       2,  3,  9, 10, 37, 38, 42, 43, 49, 53, 55, 62, 70, 76, 80, 86,           
      87, 90,  4,  2, 42, 61, 79, 84, 88, 92, 40, 38, 37,  7, 22, 31,           
      32, 39, 44, 52,  2, 37,  7, 42,  7, 12, 36, 65, 66,  2, 37, 38,           
      53,  7, 12,  2, 22, 31, 32, 39, 44, 52,  2, 14, 42,  8, 24, 12,           
      15, 51,  2,  3,  9, 10, 37, 38, 42, 43, 49, 53, 55, 62, 70, 76,           
      80, 86, 87, 90,  4,  8, 18, 19, 20, 26, 29, 34, 35, 42, 45, 46,           
      55, 56, 57, 58, 59, 60, 63, 64, 69, 73, 74, 76, 77, 78, 82, 83,           
      89, 91, 42, 55, 57, 60, 76,  8, 18, 19, 20, 26, 29, 34, 35, 42,           
      45, 46, 55, 56, 57, 58, 60, 63, 64, 69, 73, 74, 76, 77, 78, 82,           
      83, 89, 91,  8,  8, 18, 19, 20, 23, 26, 29, 34, 35, 42, 45, 46,           
      47, 55, 56, 57, 58, 60, 63, 64, 69, 73, 74, 76, 77, 78, 82, 83,           
      89, 91, 42,  8,  8, 18, 19, 20, 26, 29, 34, 35, 42, 45, 46, 55,           
      56, 57, 58, 60, 63, 64, 69, 73, 74, 75, 76, 77, 78, 82, 83, 89,           
      91,  2,  8, 22, 31, 32, 39, 44, 52, 71, 72,  8, 42,  7, 12,  8,           
      22, 31, 32, 39, 44, 52,  8,  8, 18, 19, 20, 23, 26, 29, 34, 35,           
      42, 45, 46, 47, 55, 56, 57, 58, 60, 63, 64, 69, 73, 74, 76, 77,           
      78, 82, 83, 89, 91,  8,  8, 18, 19, 20, 23, 26, 29, 34, 35, 41,           
      42, 45, 46, 47, 55, 56, 57, 60, 63, 64, 69, 73, 74, 76, 77, 78,           
      82, 83, 89, 91,  8,  8,  8, 12,  2, 42, 61, 79, 84, 88, 92,  8,           
      18, 19, 20, 26, 29, 34, 35, 41, 42, 45, 46, 55, 56, 57, 60, 63,           
      64, 69, 73, 74, 76, 77, 78, 82, 83, 89, 91, 28,  8, 18, 19, 20,           
      26, 29, 34, 35, 42, 45, 46, 55, 56, 57, 58, 60, 63, 64, 69, 73,           
      74, 76, 77, 78, 82, 83, 89, 91) ;                                         
   DECLARE SCANGOTOS(734) BIT(8) INITIAL (0, 112,  13, 113, 114, 115,           
      116,  49, 117, 118, 119, 120, 121, 122, 123, 124, 125,   2, 126,          
      127,   5, 128, 129, 130, 131, 132,   4, 133, 134, 135, 136, 137,          
       21, 138, 139, 140, 141, 142, 143, 132, 144, 145, 146, 147, 148,          
      109, 108, 140, 149,  97, 101, 102, 150, 151, 132,  78,  76, 152,          
      153, 145, 146, 147, 148, 109, 108, 140, 149,  97, 101, 102, 154,          
      151, 132,  78,  76, 152, 153, 145, 109, 108, 140, 155,  97, 101,          
      102, 132, 106, 156, 157, 158, 145, 109, 108, 140,  98, 101, 102,          
      132, 145, 146, 147, 148, 109, 108, 140, 149,  97, 101, 102, 159,          
      151, 132,  78,  76, 152, 153, 145, 146, 148, 109, 108, 140, 149,          
       97, 101, 102, 132,  79, 152, 153, 145, 109, 108, 140, 160,  97,          
      101, 102, 132, 156, 157, 158, 145, 109, 108, 140,  99, 101, 102,          
      132, 145, 109, 108, 140, 100, 101, 102, 132, 156, 157, 158, 161,          
      162, 163,  82, 164, 165,  88,  86,  87,  85,  89, 145, 146, 148,          
      109, 108, 140, 149,  97, 101, 102, 132, 166, 167, 168, 145, 109,          
      108, 140, 169,  97, 101, 102, 132, 156, 157, 158, 145, 109, 108,          
      140, 170,  97, 101, 102, 132, 156, 157, 158, 145, 146, 148, 109,          
      108, 140, 149,  97, 101, 102, 132, 171, 153, 164, 167, 168, 172,          
      105, 107, 145, 146, 147, 148, 109, 108, 140, 149,  97, 101, 102,          
      173, 132,  78,  76, 152, 153, 174, 145, 146, 147, 148, 109, 108,          
      140, 149,  97, 101, 102, 132,  78,  77, 152, 153, 174, 172, 103,          
      172, 145, 146, 147, 148, 109, 108, 140, 149,  97, 101, 102, 175,          
      151, 132,  78,  76, 152, 153, 172,  72, 176, 145, 146, 147, 148,          
      109, 108, 140, 149,  97, 101, 102, 177, 151, 132,  78,  76, 152,          
      153, 172, 178,  26, 145, 146, 147, 148, 109, 108, 140, 149,  97,          
      101, 102, 179, 151, 132,  78,  76, 152, 153, 172, 180, 145, 146,          
      147, 148, 109, 108, 140, 149,  97, 101, 102, 181, 151, 132,  78,          
       76, 152, 153, 172,  23,  24,  22,  48, 145, 146, 147, 148, 109,          
      108, 140, 149,  97, 101, 102, 182, 151, 132,  78,  76, 152, 153,          
      172,  18, 140,  46, 132, 145, 146, 147, 148, 109, 108, 140, 149,          
       97, 101, 102, 183, 151, 132,  78,  76, 152, 153, 172,  65, 184,          
      185, 186, 187,  50, 188, 189,  53, 190, 191, 192,  57,  59,  58,          
       55, 193,  61, 194,  60, 195,  64,  66, 196, 197,  56,  68, 109,          
      108, 198,  67,  69,  62, 192,  57,  59,  58,  54, 193, 106,  43,          
       47,   7, 110,  73,  72, 199, 145, 146, 147, 148, 109, 108, 140,          
      149,  97, 101, 102, 200, 151, 132,  78,  76, 152, 153, 172,  13,          
      113, 114, 115, 116,  49, 117, 118, 119, 120, 121, 123, 124, 125,          
       15, 201, 126, 127,   5, 128, 129, 130, 132, 202, 133, 134, 135,          
      136, 137, 140, 123, 125,  71, 132,  13, 113, 114, 115, 116,  49,          
      117, 118, 119, 120, 121, 123, 124, 125,  16, 126, 127,   5, 128,          
      129, 130, 132,   4, 133, 134, 135, 136, 137,   6,  13, 113, 114,          
      115, 203, 116,  49, 117, 118, 119, 120, 121,  20, 123, 124, 125,          
       25, 126, 127,   5, 128, 129, 130, 132,   4, 133, 204, 135, 136,          
      137,  41,  10,  13, 113, 114, 115, 116,  49, 117, 118, 119, 120,          
      121, 123, 124, 125,   2, 126, 127,   5, 128, 129, 130, 205, 132,          
        4, 133, 134, 135, 136, 137,  38,  32, 192,  57,  59,  58, 206,          
      193, 207, 208,  33, 209,  37,  39,  34, 192,  57,  59,  58, 210,          
      193,  35,  13, 113, 114, 115, 203, 116,  49, 117, 118, 119, 120,          
      121,  31, 123, 124, 125,   3, 126, 127,   5, 128, 129, 130, 132,          
        4, 133, 204, 135, 136, 137,  11,  13, 113, 114, 115, 203, 116,          
       49, 117, 118,  36, 119, 120, 121,  42, 123, 124, 125, 126, 127,          
       17, 128, 129, 130, 132,  14, 133, 204, 135, 136, 137,   9,   8,          
       12, 211,  65, 184, 185, 186, 187,  51, 188,  13, 113, 114, 115,          
      116,  49, 117, 118,  36, 119, 120, 121, 123, 124, 125, 126, 127,          
       17, 128, 129, 130, 132,  14, 133, 134, 135, 136, 137,  19,  13,          
      113, 114, 115, 116,  49, 117, 118, 119, 120, 121, 123, 124, 125,          
        3, 126, 127,   5, 128, 129, 130, 132,   4, 133, 134, 135, 136,          
      137) ;                                                                    
   DECLARE LASTART(28) BIT(16) INITIAL (0,   1,   9,  29,  39,  58,             
       76,  78,  86,  99, 114, 132, 150, 157, 164, 179, 197, 215, 224,          
      232, 234, 237, 239, 241, 247, 250, 252, 264, 266) ;                       
   DECLARE LATOKENS(265) BIT(8) INITIAL (0,  2,  3,  8,  9, 10, 37, 38          
      , 42,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15          
      , 16, 17, 21, 25, 30,  8, 18, 19, 20, 24, 26, 29, 34, 35, 42,  1          
      ,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 15, 16, 17, 21          
      , 25, 30,  1,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 15, 16          
      , 17, 21, 25, 30,  4,  8,  4,  5,  7,  8, 12, 17, 21, 30,  1,  4          
      ,  5,  7,  8,  9, 12, 13, 15, 16, 17, 21, 30,  1,  3,  4,  5,  7          
      ,  8,  9, 10, 12, 13, 15, 16, 17, 21, 30,  1,  3,  4,  5,  6,  7          
      ,  8,  9, 10, 11, 12, 13, 15, 16, 17, 21, 25, 30,  1,  3,  4,  5          
      ,  6,  7,  8,  9, 10, 11, 12, 13, 15, 16, 17, 21, 25, 30,  2,  3          
      , 10, 15, 37, 38, 42,  2,  3, 10, 15, 37, 38, 42,  1,  3,  4,  5          
      ,  7,  8,  9, 10, 12, 13, 15, 16, 17, 21, 30,  1,  3,  4,  5,  6          
      ,  7,  8,  9, 10, 11, 12, 13, 15, 16, 17, 21, 25, 30,  1,  3,  4          
      ,  5,  6,  7,  8,  9, 10, 11, 12, 13, 15, 16, 17, 21, 25, 30,  4          
      ,  5,  7,  8, 12, 16, 17, 21, 30,  4,  5,  7,  8, 12, 17, 21, 30          
      ,  4,  8,  4,  8, 17,  4,  8,  4,  8,  2, 22, 31, 32, 39, 40,  8          
      , 12, 36,  4,  8,  8, 18, 19, 20, 23, 24, 26, 28, 29, 34, 35, 42          
      ,  8, 42) ;                                                               
   DECLARE LAGOTOS(265) BIT(8) INITIAL (0, 212, 212,  44, 212, 212              
      , 212, 212, 212, 104, 213, 104, 104, 104, 104, 104, 104, 104              
      , 104, 104, 104, 104, 213, 104, 104, 104, 104, 104, 104, 214              
      , 214, 214, 214,   1, 214, 214, 214, 214, 214, 104, 215, 104              
      , 104, 104, 104, 104, 104, 104, 104, 104, 104, 104, 104, 104              
      , 104, 104, 104, 104,  92,  92,  92,  92, 216,  92,  92,  92              
      ,  92, 216,  92,  92,  92,  92,  92,  92, 216,  92, 217,  30              
      ,  74, 218,  74,  74,  74,  74,  74,  74, 219,  80,  80,  80              
      ,  80, 219,  80, 219, 219, 219,  80,  80,  80,  90, 220,  90              
      ,  90,  90,  90,  90, 220,  90,  90,  90,  90,  90,  90,  90              
      ,  95,  95,  95,  95, 216,  95,  95,  95,  95, 216,  95,  95              
      ,  95,  95,  95,  95, 216,  95,  96,  96,  96,  96, 216,  96              
      ,  96,  96,  96, 216,  96,  96,  96,  96,  96,  96, 216,  96              
      ,  83,  83,  83, 221,  83,  83,  83,  84,  84,  84, 222,  84              
      ,  84,  84,  91, 220,  91,  91,  91,  91,  91, 220,  91,  91              
      ,  91,  91,  91,  91,  91,  93,  93,  93,  93, 216,  93,  93              
      ,  93,  93, 216,  93,  93,  93,  93,  93,  93, 216,  93,  94              
      ,  94,  94,  94, 216,  94,  94,  94,  94, 216,  94,  94,  94              
      ,  94,  94,  94, 216,  94,  81,  81,  81,  81,  81, 223,  81              
      ,  81,  81,  75, 218,  75,  75,  75,  75,  75,  75, 217,  29              
      , 224,  27, 224, 217,  28, 217,  45,  63,  63,  63,  63,  63              
      , 225,  52,  52, 226, 217,  70,   4,   4,   4,   4,   4,   4              
      ,   4, 227,   4,   4,   4,   4,  40, 228) ;                               
                                                                                
                                                                                
    DECLARE (GROUPHEAD,PROCHEAD) FIXED;                                         
   /*  DECLARATIONS FOR THE SCANNER                                        */   
                                                                                
   /* TOKEN IS THE INDEX INTO THE VOCABULARY V() OF THE LAST SYMBOL SCANNED,    
      CH IS THE LAST CHARACTER SCANNED (HEX CODE),                              
      CP IS THE POINTER TO THE LAST CHARACTER SCANNED IN THE CARDIMAGE,         
      BCD IS THE LAST SYMBOL SCANNED (LITERAL CHARACTER STRING). */             
   DECLARE (TOKEN, CH, CP) FIXED, BCD CHARACTER;                                
                                                                                
   /* SET UP SOME CONVENIENT ABBREVIATIONS FOR PRINTER CONTROL */               
   DECLARE EJECT_PAGE LITERALLY 'OUTPUT(1) = PAGE',                             
      PAGE CHARACTER INITIAL ('1'), DOUBLE CHARACTER INITIAL ('0'),             
      DOUBLE_SPACE LITERALLY 'OUTPUT(1) = DOUBLE',                              
      X70 CHARACTER INITIAL ('                                                  
                    ');                                                         
                                                                                
   /* LENGTH OF LONGEST SYMBOL IN V */                                          
   DECLARE (RESERVED_LIMIT, MARGIN_CHOP) FIXED;                                 
                                                                                
   /* CHARTYPE() IS USED TO DISTINGUISH CLASSES OF SYMBOLS IN THE SCANNER.      
      TX() IS A TABLE USED FOR TRANSLATING FROM ONE CHARACTER SET TO ANOTHER.   
      CONTROL() HOLDS THE VALUE OF THE COMPILER CONTROL TOGGLES SET IN $ CARDS. 
                                                                                
      ALL ARE USED BY THE SCANNER AND CONTROL() IS SET THERE.                   
   */                                                                           
   DECLARE (CHARTYPE, TX) (255) BIT(8),                                         
           CONTROL (255) BIT(1);                                                
                                                                                
   /* ALPHABET CONSISTS OF THE SYMBOLS CONSIDERED ALPHABETIC IN BUILDING        
      IDENTIFIERS     */                                                        
   DECLARE ALPHABET CHARACTER INITIAL ('ABCDEFGHIJKLMNOPQRSTUVWXYZ_$@#');       
                                                                                
   /* TRANSLATION TABLES NEEDED BY THE SCANNER */                               
   DECLARE (ALPHATABLE, BLANKTABLE, COMMENTABLE, STRINGTABLE) (63) FIXED;       
                                                                                
   /* BUFFER HOLDS THE LATEST CARDIMAGE,                                        
      TEXT HOLDS THE PRESENT STATE OF THE INPUT TEXT (INCLUDING MACRO           
      EXPANSIONS AND NOT INCLUDING THE PORTIONS DELETED BY THE SCANNER),        
      TEXT_LIMIT IS A CONVENIENT PLACE TO STORE THE POINTER TO THE END OF TEXT, 
      CARD_COUNT IS INCREMENTED BY ONE FOR EVERY XPL SOURCE CARD READ,          
      ERROR_COUNT TABULATES THE ERRORS AS THEY ARE DETECTED DURING COMPILE,     
      SEVERE_ERRORS TABULATES THOSE ERRORS OF FATAL SIGNIFICANCE.               
   */                                                                           
   DECLARE (BUFFER, TEXT, CURRENT_PROCEDURE, INFORMATION) CHARACTER,            
      (TEXT_LIMIT, CARD_COUNT, ERROR_COUNT, SEVERE_ERRORS, PREVIOUS_ERROR) FIXED
      ;                                                                         
                                                                                
   /* NUMBER_VALUE CONTAINS THE NUMERIC VALUE OF THE LAST CONSTANT SCANNED,     
      JBASE CONTAINS THE FIELD WIDTH IN BIT STRINGS (DEFAULT VALUE = 4),        
      BASE IS  2**JBASE   (I.E., SHL(1,JBASE) ).                                
   */                                                                           
   DECLARE (NUMBER_VALUE, JBASE, BASE) FIXED;                                   
                                                                                
   /* EACH OF THE FOLLOWING CONTAINS THE INDEX INTO V() OF THE CORRESPONDING    
      SYMBOL.   WE ASK:    IF TOKEN = IDENT    ETC.    */                       
   DECLARE (IDENT, STRING, NUMBER, DIVIDE, EOFILE, ORSYMBOL,                    
      CONCATENATE) FIXED;                                                       
                                                                                
   /* USED TO SAVE BRANCH ADDRESSES IN DO-LOOP CODE */                          
   DECLARE STEPK FIXED;                                                         
                                                                                
   /* THE FOLLOWING ARE USED IN THE MACRO EXPANDER.  CONSIDERABLE LOGIC         
      IS DEVOTED TO AVOIDING CREATING STRINGS OF LENGTH > 256, THE STRING LIMIT.
   */                                                                           
   DECLARE BALANCE CHARACTER, LB FIXED;                                         
   DECLARE MACRO_LIMIT FIXED INITIAL (40), MACRO_NAME(40) CHARACTER,            
      MACRO_TEXT(40) CHARACTER, MACRO_INDEX(256) BIT (8),                       
      TOP_MACRO FIXED INITIAL ("FFFFFFFF");                                     
   DECLARE EXPANSION_COUNT FIXED, EXPANSION_LIMIT LITERALLY '300';              
                                                                                
   /* STOPIT() IS A TABLE OF SYMBOLS WHICH ARE ALLOWED TO TERMINATE THE ERROR   
      FLUSH PROCESS.  IN GENERAL THEY ARE SYMBOLS OF SUFFICIENT SYNTACTIC       
      HIERARCHY THAT WE EXPECT TO AVOID ATTEMPTING TO START COMPILING AGAIN     
      RIGHT INTO ANOTHER ERROR PRODUCING SITUATION.  THE TOKEN STACK IS ALSO    
      FLUSHED DOWN TO SOMETHING ACCEPTABLE TO A STOPIT() SYMBOL.                
      FAILSOFT IS A BIT WHICH ALLOWS THE COMPILER ONE ATTEMPT AT A GENTLE       
      RECOVERY.   THEN IT TAKES A STRONG HAND.   WHEN THERE IS REAL TROUBLE     
      COMPILING IS SET TO FALSE, THEREBY TERMINATING THE COMPILATION.           
      MAINLOC IS THE SYMBOL TABLE LOCATION OF COMPACTIFY FOR USE IN ERROR().    
   */                                                                           
   DECLARE STOPIT(NT) BIT(1), COMPILING BIT(1), MAINLOC FIXED;                  
                                                                                
   DECLARE S CHARACTER;  /* A TEMPORARY USED VARIOUS PLACES */                  
                                                                                
   /* SUBSTR(HEXCODES, I, 1) IS THE HEXADECIMAL CODE LETTER FOR I  */           
   DECLARE HEXCODES CHARACTER INITIAL ('0123456789ABCDEF');                     
                                                                                
   /*THE PROPER SUBSTRING OF POINTER IS USED TO PLACE AN  |  UNDER THE POINT    
      OF DETECTION OF AN ERROR DURING COMPILATION.  IT MARKS THE LAST CHARACTER 
      SCANNED.  */                                                              
   DECLARE POINTER CHARACTER INITIAL ('                                         
                                           |');                                 
   DECLARE (COUNT#STACK, COUNT#SCAN, COUNT#RR, COUNT#RX, COUNT#FORCE,           
      COUNT#ARITH, COUNT#STORE, COUNT#FIXBFW, COUNT#FIXD, COUNT#FIXCHW,         
      COUNT#GETD, COUNT#GETC, COUNT#FIND) FIXED;                                
                                                                                
   /* RECORD THE TIMES OF IMPORTANT POINTS DURING COMPILATION */                
   DECLARE CLOCK(5) FIXED;                                                      
                                                                                
   /* COUNT THE NUMBER OF COMPARISONS OF IDENTIFIERS IN SYMBOL TABLE LOOK-UPS   
      THIS CAN, IN GENERAL, BE EXPECTED TO BE A SUBSTANTIAL PART OF RUN TIME.   
   */                                                                           
   DECLARE IDCOMPARES FIXED, STATEMENT_COUNT FIXED;                             
   DECLARE TRUELOC FIXED;  /* ADDRESS OF INTEGER 1 IN DATA AREA */              
   DECLARE COMPLOC FIXED; /*  THE ADDRESS OF ALL ONES MASK FOR COMPLEMENT */    
   DECLARE CATCONST FIXED;   /* ADDRESS OF 2**24  */                            
   DECLARE BASEDATA FIXED;   /*  BASE REGISTER INITIALIZATION ADDRESS */        
                                                                                
   /*  THE EMITTER  ARRAYS  */                                                  
                                                                                
                                                                                
 /******************************************************************************
                                                                                
      WARNING:  THE EMITTER ARRAYS "CODE", "DATA", AND "STRINGS" ARE            
   DEPENDENT ON THE HARDWARE DEVICES AVAILABLE FOR SCRATCH STORAGE.  THE        
   LITERAL CONSTANT "DISKBYTES" SHOULD BE EQUAL TO THE BLOCKSIZE OF THESE FILES 
   AS ESTABLISHED IN DCB'S IN THE SUBMONITOR.                                   
                                                                                
   SUGGESTED VALUES:                                                            
            FOR LARGE CORE:             FOR SMALL CORE DISKBYTES = 400.         
                                                                                
      2311     DISKBYTES = 3600                                                 
      2314     DISKBYTES = 7200                                                 
      2321     DISKBYTES = 2000                                                 
                                                                                
      THIS VERSION OF XCOM NEEDS THREE SCRATCH FILES:                           
      1        COMPILED CODE TEMPORARY                                          
      2        COMPILED DATA TEMPORARY                                          
      3        CHARACTER STRING TEMPORARY                                       
      1        BINARY PROGRAM OUTPUT                                            
                                                                                
 ******************************************************************************/
                                                                                
   DECLARE DISKBYTES LITERALLY '7200';   /*2314 DISKS */                        
      /* SIZE OF SCRATCH FILE BLOCKS IN BYTES */                                
   DECLARE CODEMAX FIXED;        /* FORCES CODE TO WORD BOUNDARY */             
   DECLARE CODE (DISKBYTES) BIT(8);                                             
   DECLARE DATAMAX FIXED;     /* FORCES DATA TO WORD BOUNDARY */                
   DECLARE DATA (DISKBYTES) BIT(8);                                             
   DECLARE STRNGMX FIXED;            /*  AND FORCE STRINGS TO BE ALIGNED  */    
   DECLARE STRINGS (DISKBYTES) BIT(8); /* BUFFER FOR COMPILED STRINGS  */       
                                                                                
                                                                                
   /*  CODEMAX  IS THE # OF RECORDS OF CODE GENERATED                           
       DATAMAX IS THE NUMBER OF RECORDS OF DATA GENERATED                       
   */                                                                           
                                                                                
   DECLARE CODEFILE FIXED INITIAL(1);    /* FILE FOR BINARY CODE, AND */        
   DECLARE BINARYFILE FIXED INITIAL(1);  /* COLLECTION OF ALL COMPILED OUTPUT */
   DECLARE DATAFILE FIXED INITIAL (2);    /* SCRATCH FILE FOR DATA */           
   DECLARE STRINGFILE FIXED INITIAL (3);                                        
      /* SCRATCH FILE FOR CHARACTER STRINGS */                                  
                                                                                
   DECLARE (PPORG, PPLIM, DPORG, DPLIM, CURCBLK, CURDBLK, CURSBLK, CHPORG,      
      CHPLIM, STRINGMAX, SHORTDFIX, SHORTCFIX, LONGDFIX, LONGCFIX, FCP) FIXED;  
                                                                                
      /* ARRAYS TO HOLD FIXUPS DURING COMPILATION */                            
                                                                                
   /* FCLIM IS THE NUMBER OF FIXUPS THAT CAN BE RECORDED BEFORE THEY ARE MADE */
   DECLARE FCLIM LITERALLY '100';                                               
   DECLARE FIXCADR (FCLIM) FIXED;      /* ADDRESS OF CODE FIXUP  */             
   DECLARE FIXCB1 (FCLIM) BIT(8);      /* 1ST BYTE OF CODE FIXUP  */            
   DECLARE FIXCB2 (FCLIM) BIT(8);      /* 2ND BYTE OF CODE FIXUP  */            
                                                                                
   DECLARE LIMITWORD FIXED;                                                     
   DECLARE STRING_RECOVER FIXED;                                                
                                                                                
   DECLARE CATENTRY FIXED;   /*  ENTRY TO CATENATE ROUTINE */                   
   DECLARE STRL FIXED;  /* ADDRESS OF LAST STRING COMPUTED FOR OPTIMIZING || */ 
   DECLARE STRN FIXED;  /* ADDRESS OF TEMP IN STRING TO NUMBER ROUTINE */       
   DECLARE DESCL FIXED;                                                         
   DECLARE IO_SAVE FIXED;                                                       
   DECLARE NMBRNTRY  FIXED;     /*  ENTRY TO BINARY TO CHAR. CONVERSION */      
   DECLARE TSA FIXED;  /* INTEGER ADDRESS OF TOP-OF-STRINGS  */                 
   DECLARE MOVER FIXED;   /*  ADDRESS OF MOVE TEMPLATE  */                      
   DECLARE BASES (15) FIXED;    /*  THE VALUE OF THE BASE REGISTERS */          
   DECLARE AVAIL FIXED INITIAL (2);                                             
   DECLARE INSTRUCT (255) BIT(16);  /*  INSTRUCTION USE COUNTERS */             
   DECLARE DESC(1024) FIXED;  /* STRING DESCRIPTORS, REG 13 RELATIVE */         
                                                                                
   /*  360 REGISTER ASSIGNMENTS:                                                
            0     SCRATCH                                                       
            1-3   ACCUMULATORS                                                  
            4-11  DATA ADDRESSING                                               
            12    BRANCH REGISTER                                               
            13    STRING DESCRIPTOR AREA BASE                                   
            14    PROGRAM BASE                                                  
            15    POINTS TO ENTRY OF I/O PACKAGE                                
   */                                                                           
                                                                                
   DECLARE IOREG LITERALLY '"F"';  /* REGISTER FOR IO ROUTINES OF SUBMONITOR */ 
   DECLARE PBR LITERALLY '"E"';  /* PROGRAM BASE REGISTER POINTS TO CODE  */    
   DECLARE SBR LITERALLY '"D"';  /* STRING BASE REGISTER TO ADDRESS DESCRIPT. */
   DECLARE BRCHREG LITERALLY '"C"';  /* REGISTER FOR BRANCHING  */              
   DECLARE DBR LITERALLY '"B"';  /* FIRST DATA BASE REGISTER  */                
   DECLARE PROGRAMSIZE LITERALLY '25';  /* NUMBER OF 4096 BYTE PAGES ALLOWED */ 
   DECLARE LASTBASE FIXED;   /*  KEEP TRACK OF ALLOCATION OF REG 11 - 4 */      
   DECLARE TARGET_REGISTER FIXED;                                               
   DECLARE MASKF000 BIT(32);                                                    
   DECLARE ADREG FIXED, ADRDISP FIXED;    /* GLOBALS FOR FINDADDRESS */         
   DECLARE RTNADR FIXED;  /*  WHERE THE PRESENT RETURN ADDRESS IS STORED */     
   DECLARE RETURNED_TYPE BIT (8);                                               
   DECLARE TEMP(3) FIXED ;         /*  STORAGE FOR SAVE_REGISTERS  */           
   DECLARE (DP, PP, CHP, DSP, NEWDP, NEWDSP) FIXED; /* EMITTER POINTERS */      
   DECLARE ITYPE FIXED;   /*  INITIALIZATION TYPE  */                           
   DECLARE STILLCOND FIXED;  /*  REMEMBER CONDITION CODE TEST FOR PEEPHOLE */   
                                                                                
   /*  COMMON  IBM  360  OP-CODES  */                                           
   DECLARE OPNAMES CHARACTER INITIAL ('    BALRBCTRBCR LPR LNR LTR LCR NR  CLR O
R  XR  LR  CR  AR  SR  MR  DR  ALR SLR LA  STC IC  EX  BAL BCT BC  CVD CVB ST  N
   CL  O   X   L   C   A   S   M   D   AL  SL  SRL SLL SRA SLA SRDLSLDLSRDASLDAS
TM TM  MVI NI  CLI OI  XI  LM  MVC STH LH  ');                                  
   DECLARE OPER(255) BIT(8) INITIAL(                                            
 /*0**/   0,  0,  0,  0,  0,  4,  8, 12,  0,  0,  0,  0,  0,  0,  0,  0,        
 /*1**/  16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 68, 72, 76,        
 /*2**/   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,        
 /*3**/   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,        
 /*4**/ 236, 80, 84, 88, 92, 96,100,104,240,  0,  0,  0,  0,  0,108,112,        
 /*5**/ 116,  0,  0,  0,120,124,128,132,136,140,144,148,152,156,160,164,        
 /*6**/   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,        
 /*7**/   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,        
 /*8**/   0,  0,  0,  0,  0,  0,  0,  0,168,172,176,180,184,188,192,196,        
 /*9**/ 200,204,208,  0,212,216,220,224,228,  0,  0,  0,  0,  0,  0,  0,        
 /*A**/   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,        
 /*B**/   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,        
 /*C**/   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,        
 /*D**/   0,  0,232,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,        
 /*E**/   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,        
 /*F**/   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0);       
 /*      *0  *1  *2  *3  *4  *5  *6  *7  *8  *9  *A  *B  *C  *D  *E  *F  */     
   DECLARE OP_CODE CHARACTER;  /* FOR DEBUG PRINTOUT */                         
   DECLARE COMMUTATIVE(63) BIT(1);  /* RECORD WHICH OPERATORS ARE COMMUTATIVE */
                                                                                
   /* COMMONLY USED /360 OPERATION CODES */                                     
   DECLARE BC FIXED INITIAL ("47"), BCR FIXED INITIAL ("07");                   
   DECLARE BAL FIXED INITIAL ("45"), BALR FIXED INITIAL ("05");                 
   DECLARE LOAD FIXED INITIAL ("58"), STORE FIXED INITIAL ("50");               
   DECLARE CMPR FIXED INITIAL ("59"), CMPRR FIXED INITIAL ("19");               
   DECLARE LA FIXED INITIAL ("41");                                             
                                                                                
   /* THE FOLLOWING ARE USED TO HOLD ADDRESS PAIRS IN THE EMITTER FOR || */     
   DECLARE (A1, A2, B1, B2, T1, T2) FIXED;                                      
                                                                                
   /* COMMONLY USED STRINGS */                                                  
   DECLARE X1 CHARACTER INITIAL(' '), X4 CHARACTER INITIAL('    ');             
   DECLARE EQUALS CHARACTER INITIAL (' = '), PERIOD CHARACTER INITIAL ('.');    
   DECLARE QUOTE CHARACTER INITIAL ('''');                                      
                                                                                
   /* TEMPORARIES USED THROUGHOUT THE COMPILER */                               
   DECLARE (I, J, K, L) FIXED;                                                  
                                                                                
   DECLARE TRUE LITERALLY '1', FALSE LITERALLY '0', FOREVER LITERALLY 'WHILE 1';
                                                                                
   /*  SYMBOL  TABLE  VARIABLES  */                                             
                                                                                
   DECLARE HALFWORD     LITERALLY  '1',                                         
           LABELTYPE    LITERALLY  '2',                                         
           ACCUMULATOR  LITERALLY  '3',                                         
           VARIABLE     LITERALLY  '4',                                         
           CONSTANT     LITERALLY  '5',                                         
           CONDITION    LITERALLY  '6',                                         
           CHRTYPE      LITERALLY  '7',                                         
           FIXEDTYPE    LITERALLY  '8',                                         
           BYTETYPE     LITERALLY  '9',                                         
           FORWARDTYPE  LITERALLY '10',                                         
           DESCRIPT     LITERALLY '11',                                         
           SPECIAL      LITERALLY '12',                                         
           FORWARDCALL  LITERALLY '13' ,                                        
           CHAR_PROC_TYPE LITERALLY '14'                                        
           ;                                                                    
   DECLARE TYPENAME(14) CHARACTER INITIAL ('', 'BIT(16)  ', 'LABEL    ', '', '',
      '', '', 'CHARACTER', 'FIXED    ', 'BIT(8)   ', '', '', '', '',            
      'CHARACTER PROCEDURE');                                                   
   DECLARE PROCMARK FIXED;  /* START OF LOCAL VARIABLES IN SYMBOL TABLE */      
   DECLARE PARCT FIXED;  /* NUMBER OF PARAMETERS TO CURRENT PROCEDURE */        
   DECLARE NDECSY FIXED;     /* CURRENT NUMBER OF DECLARED SYMBOLS */           
   /* MAXNDECSY IS THE MAXIMUM OF NDECSY OVER A COMPILATION.  IF MAXNDECSY      
      BEGINS TO APPROACH SYTSIZE THEN SYTSIZE SHOULD BE INCREASED */            
   DECLARE MAXNDECSY FIXED;                                                     
                                                                                
    DECLARE SYTSIZE LITERALLY '415';   /*   SYMBOL TABLE SIZE   */              
                                                                                
   /*  THE SYMBOL TABLE IS INITIALIZED WITH THE NAMES OF ALL                    
       BUILTIN FUNCTIONS AND PSEUDO VARIABLES.  THE PROCEDURE                   
       INITIALIZE DEPENDS ON THE ORDER AND PLACEMENT OF THESE                   
       NAMES.  DUE CAUTION SHOULD BE OBSERVED WHILE MAKING CHANGES .            
   */                                                                           
                                                                                
   DECLARE SYT (SYTSIZE) CHARACTER          /*  VARIABLE NAME */                
      INITIAL ('','','MONITOR_LINK','TIME_OF_GENERATION',                       
         'DATE_OF_GENERATION','COREWORD','COREBYTE','FREEPOINT',                
         'DESCRIPTOR','NDESCRIPT', 'LENGTH','SUBSTR','BYTE','SHL',              
         'SHR','INPUT','OUTPUT','FILE','INLINE','TRACE','UNTRACE',              
         'EXIT','TIME','DATE','CLOCK_TRAP','INTERRUPT_TRAP',                    
         'MONITOR','ADDR','COMPACTIFY', '','');                                 
   DECLARE SYTYPE (SYTSIZE) BIT (8)   /* TYPE OF THE VARIABLE */                
      INITIAL (0,0,FIXEDTYPE,FIXEDTYPE,FIXEDTYPE,FIXEDTYPE,                     
         BYTETYPE,FIXEDTYPE,FIXEDTYPE,FIXEDTYPE,SPECIAL,SPECIAL,                
         SPECIAL,SPECIAL,SPECIAL,SPECIAL,SPECIAL,SPECIAL,SPECIAL,               
         SPECIAL,SPECIAL,SPECIAL,SPECIAL,SPECIAL,SPECIAL,SPECIAL,               
         SPECIAL,SPECIAL,FORWARDCALL,0,0);                                      
   DECLARE SYBASE (SYTSIZE) BIT (4) INITIAL(0,0,DBR,DBR,DBR,0,0,                
      DBR,SBR,DBR,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,DBR,0,0);                 
   DECLARE SYDISP (SYTSIZE) BIT (12)  /* DISPLACEMENT FOR VARIABLE */           
      INITIAL (0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,  10,11,12,13,14,            
         15,16,17,18,19,0,0);                                                   
   DECLARE SYTCO(SYTSIZE) BIT (16);     /* COUNT OF REFERENCES TO SYMBOLS */    
   DECLARE DECLARED_ON_LINE(SYTSIZE) BIT(16);                                   
                                                                                
   DECLARE MAXNEST LITERALLY '32',                                              
           NULL LITERALLY '-1';                                                 
   DECLARE N_PREDECLARED_SYMB FIXED INITIAL (28);                               
   DECLARE (PROCEDURE_NUMBER, LEX_LEVEL) FIXED,                                 
            BUCKET(255) BIT(16),                                                
            SY_LINK(SYTSIZE) BIT(16);                                           
   DECLARE PROC_STACK(MAXNEST) BIT(16);                                         
                                                                                
   /*  THE COMPILER STACKS DECLARED BELOW ARE USED TO DRIVE THE SYNTACTIC       
      ANALYSIS ALGORITHM AND STORE INFORMATION RELEVANT TO THE INTERPRETATION   
      OF THE TEXT.  THE STACKS ARE ALL POINTED TO BY THE STACK POINTER SP.  */  
                                                                                
   DECLARE STACKSIZE LITERALLY '75';  /* SIZE OF STACK  */                      
   DECLARE TYPE (STACKSIZE) BIT(8);  /* OPERAND TYPE FOR EXPRESSIONS */         
   DECLARE REG (STACKSIZE) BIT(8);   /* ASSOCIATED GENERAL REGISTER */          
   DECLARE INX (STACKSIZE) BIT(8);   /* ASSOCIATED INDEX REGISTER */            
   DECLARE CNT (STACKSIZE) BIT(8);   /* ANNY COUNT, PARAMETERS, SUBSCRIPTS ...*/
   DECLARE VAR (STACKSIZE) CHARACTER;/* EBCDIC NAME OF ITEM */                  
   DECLARE FIXL (STACKSIZE) FIXED;   /* FIXUP LOCATION */                       
   DECLARE FIXV (STACKSIZE) FIXED;   /* FIXUP VALUE */                          
   DECLARE PPSAVE (STACKSIZE) FIXED; /* ASSOCIATED PROGRAM POINTER */           
                                                                                
   /* SP POINTS TO THE RIGHT END OF THE REDUCIBLE STRING IN THE PARSE STACK,    
      MP POINTS TO THE LEFT END, AND                                            
      MPP1 = MP+1.                                                              
   */                                                                           
   DECLARE (SP, MP, MPP1) FIXED;                                                
                                                                                
   /* DECLARE STATEMENTS AND CASE STATEMENTS REQUIRE AN AUXILIARY STACK */      
   DECLARE CASELIMIT LITERALLY '255', CASESTACK(CASELIMIT) FIXED;               
   DECLARE CASEP FIXED;   /* POINTS TO THE CURRENT POSITION IN CASESTACK */     
   DECLARE DCLRM CHARACTER INITIAL ('IDENTIFIER LIST TOO LONG');                
    DECLARE STATE_STACK (STACKSIZE) BIT(16);                                    
    DECLARE RECOV BIT(1) ;                                                      
    DECLARE (STATE#,NEXT) FIXED;                                                
 DECLARE NEWSTATE FIXED;                                                        
  DECLARE MCHAR CHARACTER INITIAL ('I');                                        
                                                                                
                                                                                
                                                                                
                                                                                
   /*               P R O C E D U R E S                                  */     
                                                                                
                                                                                
                                                                                
PAD:                                                                            
   PROCEDURE (STRING, WIDTH) CHARACTER;                                         
      DECLARE STRING CHARACTER, (WIDTH, L) FIXED;                               
                                                                                
      L = LENGTH(STRING);                                                       
      IF L >= WIDTH THEN RETURN STRING;                                         
      ELSE RETURN STRING || SUBSTR(X70, 0, WIDTH-L);                            
   END PAD;                                                                     
                                                                                
I_FORMAT:                                                                       
   PROCEDURE (NUMBER, WIDTH) CHARACTER;                                         
      DECLARE (NUMBER, WIDTH, L) FIXED, STRING CHARACTER;                       
                                                                                
      STRING = NUMBER;                                                          
      L = LENGTH(STRING);                                                       
      IF L >= WIDTH THEN RETURN STRING;                                         
      ELSE RETURN SUBSTR(X70, 0, WIDTH-L) || STRING;                            
   END I_FORMAT;                                                                
                                                                                
ERROR:                                                                          
   PROCEDURE(MSG, SEVERITY);                                                    
      /* PRINTS AND ACCOUNTS FOR ALL ERROR MESSAGES */                          
      /* IF SEVERITY IS NOT SUPPLIED, 0 IS ASSUMED */                           
      DECLARE (MSG, ST) CHARACTER, SEVERITY FIXED;                              
      ERROR_COUNT = ERROR_COUNT + 1;                                            
      /* IF LISTING IS SUPPRESSED, FORCE PRINTING OF THIS LINE */               
      IF ~ CONTROL(BYTE('L')) THEN                                              
         OUTPUT= I_FORMAT (CARD_COUNT,4) || X1 || MCHAR || BUFFER || MCHAR ;    
      OUTPUT = SUBSTR(POINTER, TEXT_LIMIT+LB-CP+MARGIN_CHOP);                   
      /* SEVERITY(-1) IS A PORNOGRAPHIC WAY OF OBTAINING THE RETURN ADDRESS */  
      ST = '***ERROR, ' || MSG || '.';                                          
      IF LENGTH(ST) > 100 THEN DO;                                              
         OUTPUT = ST;                                                           
         ST = X4;                                                               
      END;                                                                      
      ST = ST || '  LAST ERROR IN LINE ' || PREVIOUS_ERROR;                     
      OUTPUT = ST;                                                              
      PREVIOUS_ERROR = CARD_COUNT;                                              
      IF SEVERITY > 0 THEN                                                      
         IF SEVERE_ERRORS > 25 & ~CONTROL(BYTE('X')) THEN                       
            DO;                                                                 
               OUTPUT='***TOO MANY SEVERE ERRORS.  COMPILATION ABORTED.';       
               COMPILING = FALSE;                                               
            END;                                                                
         ELSE SEVERE_ERRORS = SEVERE_ERRORS + 1;                                
   END ERROR;                                                                   
                                                                                
                                                                                
   /*                      FILE HANDLING PROCEDURES                          */ 
                                                                                
                                                                                
                                                                                
GETDATA:                                                                        
   PROCEDURE;                                                                   
      /* HANDLE SCRATCH STORAGE ALLOCATION FOR THE DATA ARRAY  */               
      DECLARE I FIXED;                                                          
      COUNT#GETD = COUNT#GETD + 1;                                              
      FILE(DATAFILE,CURDBLK) = DATA;     /*  WRITE OUT CURRENT BLOCK */         
      CURDBLK = DP / DISKBYTES;          /* CALCULATE NEW BLOCK NUMBER */       
      DPORG = CURDBLK * DISKBYTES;                                              
      DPLIM = DPORG + DISKBYTES;                                                
      IF CURDBLK <= DATAMAX THEN                                                
            DATA = FILE(DATAFILE,CURDBLK);                                      
      ELSE                                                                      
         DO;                                                                    
            /*  ZERO OUT THE NEW DATA BLOCK  */                                 
            DO I = 1 TO SHR(DISKBYTES,2);                                       
               DATAMAX(I) = 0;                                                  
            END;                                                                
            DO DATAMAX = DATAMAX + 1 TO CURDBLK - 1;                            
               FILE(DATAFILE,DATAMAX)= DATA;                                    
            END;                                                                
         END;                                                                   
   END  GETDATA;                                                                
                                                                                
GETCODE:                                                                        
   PROCEDURE;                                                                   
      /*  HANDLE SCRATCH STORAGE ALLOCATION FOR THE CODE ARRAY */               
      DECLARE I FIXED;                                                          
      FILE(CODEFILE,CURCBLK) = CODE;                                            
      COUNT#GETC = COUNT#GETC + 1;                                              
      CURCBLK = PP / DISKBYTES;       /* CALCULATE NEW BLOCK NUMBER */          
      PPORG = CURCBLK * DISKBYTES;                                              
      PPLIM = PPORG + DISKBYTES;                                                
      IF CURCBLK <= CODEMAX THEN                                                
               CODE = FILE(CODEFILE,CURCBLK);                                   
      ELSE                                                                      
         DO;                                                                    
         /*  ZERO OUT THE NEW CODE BLOCK */                                     
            DO I = 1 TO SHR(DISKBYTES,2);                                       
               CODEMAX(I) = 0;                                                  
            END;                                                                
            DO CODEMAX = CODEMAX + 1 TO CURCBLK - 1;                            
               FILE(CODEFILE,CODEMAX) = CODE;                                   
            END;                                                                
         END;                                                                   
   END  GETCODE;                                                                
                                                                                
GETSTRINGS:                                                                     
   PROCEDURE;                                                                   
      /* HANDLE SCRATCH STORAGE ALLOCATION FOR STRING ARRAY */                  
      FILE(STRINGFILE, CURSBLK) = STRINGS;    /* WRITE INTO THE FILE */         
      CURSBLK = CHP / DISKBYTES;              /* COMPUTE NEW BLOCK NUMBER */    
      CHPORG = CURSBLK*DISKBYTES;             /* NEW BLOCK ORIGIN */            
      CHPLIM = CHPORG + DISKBYTES;            /* NEW UPPER BOUND */             
      IF CURSBLK <= STRINGMAX THEN                                              
         STRINGS = FILE(STRINGFILE,CURSBLK);  /* READ BACK FROM FILE */         
      ELSE                                                                      
         DO STRINGMAX = STRINGMAX+1 TO CURSBLK - 1;                             
            FILE(STRINGFILE,STRINGMAX) = STRINGS;                               
            /* FILL OUT FILE SO NO GAPS EXIST */                                
         END;                                                                   
   END GETSTRINGS;                                                              
                                                                                
                                                                                
                                                                                
  /*                   CARD IMAGE HANDLING PROCEDURE                      */    
                                                                                
                                                                                
GET_CARD:                                                                       
   PROCEDURE;                                                                   
      /* DOES ALL CARD READING AND LISTING                                 */   
      DECLARE I FIXED, (TEMP, TEMP0, REST) CHARACTER, READING BIT(1);           
      IF LB > 0 THEN                                                            
         DO;                                                                    
            TEXT = BALANCE;                                                     
            TEXT_LIMIT = LB - 1;                                                
            CP = 0;                                                             
            RETURN;                                                             
         END;                                                                   
      EXPANSION_COUNT = 0;   /* CHECKED IN SCANNER MACRO EXPANSION */           
      IF READING THEN                                                           
         DO; /* 'READING' IS FALSE DURING COMPILE OF LIBRARY FROM INPUT(2) */   
            BUFFER = INPUT;                                                     
            IF LENGTH(BUFFER) = 0 THEN                                          
               DO; /* SIGNAL FOR EOF */                                         
                  CALL ERROR ('EOF MISSING OR COMMENT STARTING IN COLUMN 1.',1);
                  BUFFER = PAD (' /*''/* */ EOF;END;EOF', 80);                  
               END;                                                             
            ELSE CARD_COUNT = CARD_COUNT + 1;  /* USED TO PRINT ON LISTING */   
         END;                                                                   
      ELSE                                                                      
         DO; /* WHILE READING LIBRARY FILE ONLY */                              
            BUFFER = INPUT(2);                                                  
            IF LENGTH(BUFFER) = 0 THEN                                          
               DO;  /* SIGNAL TO SWITCH TO SYSIN */                             
 CONTROL(BYTE('Q'))= FALSE ; /******************* OUT *****************/        
                  CONTROL(BYTE('L')), READING = TRUE;  /* TURN ON LISTING */    
                  CONTROL(BYTE('D')) = TRUE;    /* TURN ON SYMBOL DUMP  */      
                  CLOCK(1) = TIME;  /* KEEP TRACK OF TIME FOR COMPILE RATE */   
                  TEXT = X1;  /* INITIALIZE TEXT FOR SCAN */                    
                  /* STATEMENTS ARE COUNTED FOR STATISTICS */                   
                  STATEMENT_COUNT = -1;                                         
                  TEXT_LIMIT = 0;                                               
                  PROCMARK = NDECSY + 1;                                        
                  PROC_STACK(1) = 1;  /* SEPARATE THE GLOBAL SYMBOL TABLE       
                                         BLOCK FROM THE PREDECLARED BLOCK */    
                  RETURN;                                                       
               END;                                                             
         END;                                                                   
      IF MARGIN_CHOP > 0 THEN                                                   
         DO; /* THE MARGIN CONTROL FROM DOLLAR | */                             
            I = LENGTH(BUFFER) - MARGIN_CHOP;                                   
            REST = SUBSTR(BUFFER, I);                                           
            BUFFER = SUBSTR(BUFFER, 0, I);                                      
         END;                                                                   
      ELSE REST = '';                                                           
      TEXT = BUFFER;                                                            
      TEXT_LIMIT = LENGTH(TEXT) - 1;                                            
      IF CONTROL(BYTE('M')) THEN OUTPUT = BUFFER;                               
      ELSE IF CONTROL(BYTE('L')) THEN                                           
         DO;                                                                    
            REST = I_FORMAT (PP, 6) || REST;                                    
           OUTPUT=I_FORMAT(CARD_COUNT,4) || X1 || MCHAR || BUFFER || MCHAR ||   
               REST || CURRENT_PROCEDURE || INFORMATION;                        
         END;                                                                   
      INFORMATION = '';                                                         
      CP = 0;                                                                   
   END GET_CARD;                                                                
                                                                                
                                                                                
   /*                THE SCANNER PROCEDURES              */                     
                                                                                
                                                                                
CHAR:                                                                           
   PROCEDURE;                                                                   
      /* USED FOR STRINGS TO AVOID CARD BOUNDARY PROBLEMS */                    
      CP = CP + 1;                                                              
      IF CP <= TEXT_LIMIT THEN RETURN;                                          
      CALL GET_CARD;                                                            
   END CHAR;                                                                    
                                                                                
DEBLANK:                                                                        
   PROCEDURE;                                                                   
      /* USED BY BCHAR */                                                       
      CALL CHAR;                                                                
      DO WHILE BYTE(TEXT, CP) = BYTE(' ');                                      
         CALL CHAR;                                                             
      END;                                                                      
   END DEBLANK;                                                                 
                                                                                
BCHAR:                                                                          
   PROCEDURE;                                                                   
      /* USED FOR BIT STRINGS */                                                
      DO FOREVER;                                                               
         CALL DEBLANK;                                                          
         CH = BYTE(TEXT, CP);                                                   
         IF CH ~= BYTE('(') THEN RETURN;                                        
         /*  (BASE WIDTH)  */                                                   
         CALL DEBLANK;                                                          
         JBASE = BYTE(TEXT, CP) - "F0";  /* WIDTH */                            
         IF JBASE < 1 | JBASE > 4 THEN                                          
            DO;                                                                 
               CALL ERROR ('ILLEGAL BIT STRING WIDTH: ' || SUBSTR(TEXT, CP, 1));
               JBASE = 4;  /* DEFAULT WIDTH FOR ERROR */                        
            END;                                                                
         BASE = SHL(1, JBASE);                                                  
         CALL DEBLANK;                                                          
         IF BYTE(TEXT, CP) ~= BYTE(')') THEN                                    
            CALL ERROR ('MISSING ) IN BIT STRING', 0 );                         
      END;                                                                      
   END BCHAR;                                                                   
                                                                                
BUILD_BCD:                                                                      
   PROCEDURE (C);                                                               
      DECLARE C BIT(8);                                                         
      IF LENGTH(BCD) > 0 THEN                                                   
         BCD = BCD || X1;                                                       
      ELSE                                                                      
         BCD = SUBSTR(X1 || X1, 1);                                             
      /* FORCE BCD TO THE TOP OF FREE STRING AREA AND INCREASE LENGTH           
          BY ONE  */                                                            
      /* THIS LINE DEPENDS UPON THE IMPLEMENTATION OF XPL STRINGS */            
      COREBYTE(FREEPOINT-1) = C;                                                
   END BUILD_BCD;                                                               
                                                                                
SCAN:                                                                           
   PROCEDURE;                                                                   
                                                                                
SCAN_FINDS_END_OF:                                                              
   PROCEDURE (TABLE) BIT(1);                                                    
      DECLARE TABLE FIXED;                                                      
      DECLARE TRT (1) FIXED INITIAL ("DD003000", "10000000");                   
                                                                                
   /* THIS PROCEDURE ASSUMES CP = 0 WHEN IT IS CALLED */                        
      CALL INLINE ("58", 3, 0,TEXT); /*LOAD STRING DESCRIPTOR */                
      CALL INLINE ("1B", 2, 2);      /* CLEAR REG. 2 */                         
      CALL INLINE ("19", 3, 2);      /* CHECK FOR TEXT = NULL STRING */         
      CALL INLINE ("07", 8, 12);     /* RETURN FALSE IF TEXT IS NULL */         
      CALL INLINE ("8D", 2, 0,0,8);  /*  SHIFT LENGTH FIELD TO REG. 2 */        
      CALL INLINE ("88", 3, 0,0,8);  /* RESTORE STRING ADDRESS  */              
      CALL INLINE ("58", 1, 0,TABLE);/* LOAD BASE ADDRESS OF TRANS_TABLE */     
      CALL INLINE ("41", 12, 0,TRT); /* LOAD ADDRESS OF TRT INSTRUCTION */      
      CALL INLINE ("44", 2, 0,12,0); /* EXECUTE TRT INSTRUCTION */              
      CALL INLINE ("05",  12, 0);    /* LOAD BRANCH REGISTER  */                
      CALL INLINE ("47", 7, 0,12,18);/*  BRANCH ON CC~=0  */                    
      CALL INLINE ("18", 1, 2);      /* LOAD REG. 1 WITH LENGTH(\) - 1 */       
      CALL INLINE ("41", 0, 0,0,1);  /* LOAD REG. 0 WITH 1  */                  
      CALL INLINE ("1A", 1, 0);      /* ADD TO OBTAIN IDENTIFIER LNGTH*/        
      CALL INLINE ("1B", 3, 3);      /* PUT 0 INTO RETURN REGISTER */           
      CALL INLINE ("47", 15, 0,12,24); /* BRANCH AROUND NEXT TWO INSTR*/        
      CALL INLINE ("1B", 1, 3);      /* SUBTRACT TO OBTAIN IDENTIFIER LENGTH */ 
      CALL INLINE ("41", 3, 0,0,1);  /* LOAD 1 INTO RETURN REGISTER */          
      CALL INLINE ("50", 1, 0,CP);   /* STORE IDENTIFIER LENGTH */              
   END;                                                                         
                                                                                
      DECLARE (S1, S2) FIXED;                                                   
      DECLARE LSTRNGM CHARACTER INITIAL('STRING TOO LONG');                     
      COUNT#SCAN = COUNT#SCAN + 1;                                              
      BCD = '';  NUMBER_VALUE = 0;                                              
      DO FOREVER;                                                               
         IF CP > TEXT_LIMIT THEN CALL GET_CARD;                                 
   SCAN1:                                                                       
         /* DISCARD LAST SCANNED VALUE */                                       
         TEXT = SUBSTR (TEXT, CP);                                              
         TEXT_LIMIT = TEXT_LIMIT - CP;                                          
         CP = 0;                                                                
         /*  BRANCH ON NEXT CHARACTER IN TEXT                  */               
         DO CASE CHARTYPE(BYTE(TEXT));                                          
                                                                                
            /*  CASE 0  */                                                      
                                                                                
            /* ILLEGAL CHARACTERS FALL HERE  */                                 
            CALL ERROR ('ILLEGAL CHARACTER: ' || SUBSTR(TEXT, 0, 1));           
                                                                                
            /*  CASE 1  */                                                      
                                                                                
            /*  BLANK  */                                                       
            DO;                                                                 
               CP = 1;                                                          
               IF CP > TEXT_LIMIT THEN CALL GET_CARD;                           
               IF BYTE (TEXT) = BYTE (' ') THEN                                 
                  DO WHILE ~ SCAN_FINDS_END_OF(ADDR(BLANKTABLE));               
                     CALL GET_CARD;                                             
                  END;                                                          
               GOTO SCAN1;                                                      
            END;                                                                
                                                                                
            /*  CASE 2  */                                                      
                                                                                
            /*  STRING QUOTE ('):  CHARACTER STRING  */                         
            DO FOREVER;                                                         
                  CALL CHAR;                                                    
                  TOKEN = STRING;                                               
                  TEXT_LIMIT = TEXT_LIMIT - CP;                                 
                  TEXT = SUBSTR(TEXT, CP);                                      
                  DO WHILE ~SCAN_FINDS_END_OF (ADDR(STRINGTABLE));              
                     IF LENGTH(BCD) + LENGTH(TEXT) > 256 THEN DO;               
                              CALL ERROR(LSTRNGM  ,0);                          
                        RETURN;                                                 
                        END;                                                    
                     BCD = BCD || TEXT;                                         
                     CALL GET_CARD;                                             
                     END;                                                       
                  IF CP > 0 THEN BCD = BCD || SUBSTR(TEXT, 0, CP);              
                  CALL CHAR;                                                    
                  IF BYTE (TEXT, CP) ~= BYTE(QUOTE) THEN RETURN;                
                  BCD = BCD || QUOTE;                                           
            END;                                                                
                                                                                
            /*  CASE 3  */                                                      
                                                                                
            DO;      /*  BIT QUOTE("):  BIT STRING  */                          
               JBASE = 4;  BASE = SHL(1, JBASE);  /* DEFAULT WIDTH  */          
               TOKEN = NUMBER;  /* ASSUME SHORT BIT STRING */                   
               S1 = 0;                                                          
               CALL BCHAR;                                                      
               DO WHILE CH ~= BYTE('"');                                        
                  S1 = S1 + JBASE;                                              
                  IF CH >= "F0" THEN S2 = CH - "F0";  /* DIGITS */              
                  ELSE S2 = CH - "B7";                /* LETTERS */             
                  IF S2 >= BASE | S2 < 0 THEN                                   
                     CALL ERROR ('ILLEGAL CHARACTER IN BIT STRING: '            
                     || SUBSTR(TEXT, CP, 1));                                   
                  IF S1 > 32 THEN TOKEN = STRING;     /* LONG BIT STRING */     
                  IF TOKEN = STRING THEN                                        
                     DO WHILE S1 - JBASE >= 8;                                  
                        IF LENGTH(BCD) > "FF" THEN                              
                           DO;                                                  
                              CALL ERROR (LSTRNGM, 0);                          
                              RETURN;                                           
                           END;                                                 
                        S1 = S1 - 8;                                            
                        CALL BUILD_BCD (SHR(NUMBER_VALUE, S1-JBASE));           
                     END;                                                       
                  NUMBER_VALUE = SHL(NUMBER_VALUE, JBASE) + S2;                 
                  CALL BCHAR;                                                   
               END;     /* OF DO WHILE CH...  */                                
               CP = CP + 1;                                                     
               IF TOKEN = STRING THEN                                           
                  IF LENGTH(BCD) > "FF" THEN CALL ERROR (LSTRNGM, 0);           
                  ELSE CALL BUILD_BCD (SHL(NUMBER_VALUE, 8 - S1));              
               RETURN;                                                          
            END;                                                                
                                                                                
            /*  CASE 4  */                                                      
                                                                                
            DO FOREVER;  /* A LETTER:  IDENTIFIERS AND RESERVED WORDS */        
               IF SCAN_FINDS_END_OF (ADDR(ALPHATABLE)) THEN                     
                     DO;  /* END OF IDENTIFIER  */                              
                        IF CP > 0 THEN BCD = BCD || SUBSTR(TEXT, 0, CP);        
                        S1 = LENGTH(BCD);                                       
                        IF S1 > 1 THEN IF S1 <= RESERVED_LIMIT THEN             
                           /* CHECK FOR RESERVED WORDS */                       
                           DO I =VT_INDEX(S1) TO VT_INDEX(S1+1) -1;             
                              IF BCD = V(I) THEN                                
                                 DO;                                            
                                    TOKEN = I;                                  
                                    RETURN;                                     
                                 END;                                           
                           END;                                                 
                        DO I = MACRO_INDEX(S1-1) TO MACRO_INDEX(S1) - 1;        
                           IF BCD = MACRO_NAME(I) THEN                          
                              DO;                                               
                                 BCD = MACRO_TEXT(I);                           
                                 IF EXPANSION_COUNT < EXPANSION_LIMIT THEN      
                                    EXPANSION_COUNT = EXPANSION_COUNT + 1;      
                                 ELSE OUTPUT =                                  
                                    '*** WARNING, TOO MANY EXPANSIONS FOR ' ||  
                                    MACRO_NAME(I) || ' LITERALLY: ' || BCD;     
                                 TEXT = SUBSTR(TEXT, CP);                       
                                 TEXT_LIMIT = TEXT_LIMIT - CP;                  
                                 IF LENGTH(BCD) + TEXT_LIMIT > 255 THEN         
                                    DO;                                         
                                       IF LB + TEXT_LIMIT > 255 THEN            
                                         CALL ERROR('MACRO EXPANSION TOO LONG');
                                       ELSE                                     
                                          DO;                                   
                                             BALANCE = TEXT || BALANCE;         
                                             LB = LENGTH(BALANCE);              
                                             TEXT = BCD;                        
                                          END;                                  
                                    END;                                        
                                 ELSE TEXT = BCD || TEXT;                       
                                 BCD = '';                                      
                                 TEXT_LIMIT = LENGTH(TEXT) - 1;                 
                                 CP = 0;                                        
                                 GO TO SCAN1;                                   
                              END;                                              
                        END;                                                    
                        /*  RESERVED WORDS EXIT HIGHER: THEREFORE <IDENTIFIER>*/
                        TOKEN = IDENT;                                          
                        RETURN;                                                 
                     END;                                                       
               /*  END OF CARD  */                                              
               BCD = BCD || TEXT;                                               
               CALL GET_CARD;                                                   
            END;                                                                
                                                                                
            /*  CASE 5  */                                                      
                                                                                
            DO;      /*  DIGIT:  A NUMBER  */                                   
               TOKEN = NUMBER;                                                  
               DO FOREVER;                                                      
                  DO CP = CP TO TEXT_LIMIT;                                     
                     S1 = BYTE(TEXT, CP);                                       
                     IF S1 < "F0" THEN RETURN;                                  
                     NUMBER_VALUE = 10*NUMBER_VALUE + S1 - "F0";                
                  END;                                                          
                  CALL GET_CARD;                                                
               END;                                                             
            END;                                                                
                                                                                
            /*  CASE 6  */                                                      
                                                                                
            DO;      /*  A /:  MAY BE DIVIDE OR START OF COMMENT  */            
               CALL CHAR;                                                       
               IF BYTE(TEXT, CP) ~= BYTE('*') THEN                              
                  DO;                                                           
                     TOKEN = DIVIDE;                                            
                     RETURN;                                                    
                  END;                                                          
               /* WE HAVE A COMMENT  */                                         
               SCANCOMMENT:                                                     
                  TEXT = SUBSTR(TEXT, CP);                                      
                  TEXT_LIMIT = TEXT_LIMIT - CP;                                 
                  DO WHILE ~SCAN_FINDS_END_OF (ADDR(COMMENTABLE));              
                     CALL GET_CARD;                                             
                  END;                                                          
                  IF BYTE(TEXT, CP) = BYTE('$') THEN DO;                        
                     /* A CONTROL CHARACTER */                                  
                     CALL CHAR;                                                 
                     S2 = BYTE(TEXT, CP);                                       
                        CONTROL(S2) = ~ CONTROL(S2);                            
                        IF S2 = BYTE('T') THEN CALL TRACE;                      
                        ELSE IF S2=BYTE('Y') THEN MCHAR='|' ;                   
                        ELSE IF S2 = BYTE('U') THEN CALL UNTRACE;               
                        ELSE IF S2 = BYTE('|') THEN                             
                           IF CONTROL(S2) THEN                                  
                              MARGIN_CHOP = TEXT_LIMIT - CP + 1;                
                           ELSE                                                 
                              MARGIN_CHOP = 0;                                  
                        GOTO SCANCOMMENT;                                       
                     END;                                                       
                  /* ELSE FOUND AN ASTERISK */                                  
                  CALL CHAR;                                                    
                  IF BYTE(TEXT, CP) ~= BYTE('/') THEN                           
                     GOTO SCANCOMMENT;                                          
            END;                                                                
                                                                                
            /*  CASE 7  */                                                      
            DO;      /*  SPECIAL CHARACTERS  */                                 
               TOKEN = TX(BYTE(TEXT));                                          
               CP = 1;                                                          
               RETURN;                                                          
            END;                                                                
                                                                                
            /*  CASE 8  */                                                      
            DO;  /* A |:  MAY BE "OR" OR "CAT"  */                              
               CALL CHAR;                                                       
               IF BYTE(TEXT, CP) = BYTE('|') THEN                               
                  DO;                                                           
                     CALL CHAR;                                                 
                     TOKEN = CONCATENATE;                                       
                  END;                                                          
               ELSE TOKEN = ORSYMBOL;                                           
               RETURN;                                                          
            END;                                                                
                                                                                
         END;     /* OF CASE ON CHARTYPE  */                                    
         CP = CP + 1;  /* ADVANCE SCANNER AND RESUME SEARCH FOR TOKEN  */       
      END;                                                                      
   END SCAN;                                                                    
                                                                                
                                                                                
  /*             ADDRESS AND REGISTER COMPUTATIONS                       */     
                                                                                
                                                                                
CHECKBASES:                                                                     
   PROCEDURE;                                                                   
      IF ~ COMPILING THEN RETURN;                                               
      IF DP >= BASES(LASTBASE) + 4096 THEN                                      
         DO;                                                                    
            LASTBASE = LASTBASE - 1;  /* USE REG 11 DOWN TO REG 4 */            
            BASES(LASTBASE) = DP & "FFFFFC";                                    
            INFORMATION = INFORMATION || ' R' || LASTBASE || EQUALS ||          
               BASES(LASTBASE) || PERIOD;                                       
            IF LASTBASE = 3 THEN CALL ERROR('EXCEEDED DATA AREA',1);            
         END;                                                                   
   END  CHECKBASES;                                                             
                                                                                
CLEARREGS:                                                                      
   PROCEDURE;                                                                   
      /* FREE ALL THE ARITHMETIC REGISTERS  */                                  
      DO I = 0 TO 3;  BASES(I) = AVAIL;  END;                                   
      TARGET_REGISTER = -1;                                                     
   END  CLEARREGS;                                                              
                                                                                
FINDAC:                                                                         
   PROCEDURE FIXED;                                                             
      /*  FIND AN ACCUMULATOR FOR 32 BIT QUANTITY  */                           
      DECLARE I FIXED;                                                          
      IF TARGET_REGISTER > -1 THEN IF BASES(TARGET_REGISTER) = AVAIL THEN       
         DO;                                                                    
            BASES(TARGET_REGISTER) = ACCUMULATOR;                               
            RETURN TARGET_REGISTER;                                             
         END;                                                                   
      DO I = 1 TO 3;                                                            
         IF BASES(I) = AVAIL THEN                                               
            DO;                                                                 
               BASES(I) = ACCUMULATOR;                                          
               RETURN I;                                                        
            END;                                                                
      END;                                                                      
      CALL ERROR('USED ALL ACCUMULATORS',0);                                    
      RETURN 0;                                                                 
   END  FINDAC;                                                                 
                                                                                
                                                                                
FINDADDRESS:                                                                    
   PROCEDURE (ADR);                                                             
      /* FIND THE APPROPRIATE BASE AND DISPLACEMENT FOR THE ADDRESS  */         
      DECLARE (ADR, I) FIXED;                                                   
      COUNT#FIND = COUNT#FIND + 1;                                              
      IF ADR < 0 THEN                                                           
         DO;                                                                    
            ADRDISP = - ADR;                                                    
            ADREG = SBR;                                                        
            RETURN;                                                             
         END;                                                                   
      IF ADR = 0 THEN                                                           
         DO;                                                                    
            ADREG,ADRDISP = 0;                                                  
            RETURN;                                                             
         END;                                                                   
      DO I = LASTBASE TO DBR;                                                   
         IF BASES(I) <= ADR & BASES(I)+4096 > ADR THEN                          
            DO;                                                                 
               ADRDISP = ADR - BASES(I);                                        
               ADREG = I;                                                       
               RETURN;                                                          
            END;                                                                
      END;                                                                      
      CALL ERROR('FIND ADDRESS FAILED',1);                                      
      ADREG,ADRDISP = 0;                                                        
   END  FINDADDRESS;                                                            
                                                                                
                                                                                
                                                                                
                                                                                
  /*                    CODE EMISSION PROCEDURES                       */       
                                                                                
                                                                                
EMITCHAR:                                                                       
   PROCEDURE (C);                                                               
      DECLARE C BIT (8);                                                        
      /*  SEND ONE 8-BIT CHARACTER TO THE STRING AREA  */                       
      IF CONTROL(BYTE('E')) THEN                                                
         OUTPUT = X70 || CHP || ': CHARACTER = ' ||                             
            SUBSTR(HEXCODES, SHR(C,4), 1) || SUBSTR(HEXCODES, C & "F", 1);      
      IF CHP < CHPORG | CHP >= CHPLIM THEN CALL GETSTRINGS;                     
      STRINGS(CHP-CHPORG) = C;                                                  
      CHP = CHP + 1;                                                            
   END  EMITCHAR;                                                               
                                                                                
EMITBYTE:                                                                       
   PROCEDURE (B);                                                               
      DECLARE B FIXED;                                                          
      /*  EMIT ONE BYTE OF DATA  */                                             
      IF DP < DPORG | DP >= DPLIM THEN CALL GETDATA;                            
      DATA(DP-DPORG) = B;                                                       
      IF CONTROL(BYTE('E')) THEN                                                
         OUTPUT = X70 || DP || ': DATA = ' ||                                   
            SUBSTR(HEXCODES, SHR(B,4), 1) || SUBSTR(HEXCODES, B & "F", 1);      
      DP = DP + 1;                                                              
      CALL CHECKBASES;                                                          
   END EMITBYTE;                                                                
                                                                                
EMITCODEBYTES:                                                                  
   PROCEDURE (B1,B2);                                                           
      DECLARE (B1, B2) BIT(8), I FIXED;                                         
      /*  EMIT TWO BYTES OF CODE  */                                            
      STILLCOND = 0;                                                            
      IF PP < PPORG | PP >= PPLIM THEN CALL GETCODE;                            
      I = PP - PPORG;                                                           
      CODE(I) = B1;             /*  FIRST  BYTE  */                             
      CODE(I+1) = B2;           /*  SECOND  BYTE  */                            
      IF CONTROL(BYTE('B')) THEN                                                
         OUTPUT = X70 || PP || ': CODE = ' ||                                   
            SUBSTR(HEXCODES, SHR(B1,4), 1) || SUBSTR(HEXCODES, B1 & "F", 1)     
            || SUBSTR(HEXCODES, SHR(B2,4), 1) || SUBSTR(HEXCODES, B2 & "F",1);  
      PP =  PP + 2;                                                             
   END  EMITCODEBYTES ;                                                         
                                                                                
EMITDATAWORD:                                                                   
   PROCEDURE(W);                                                                
      DECLARE (W, I) FIXED;                                                     
      /*  SEND A 32-BIT WORD TO THE DATA ARRAY  */                              
      DP = (DP + 3) & "FFFFFC";                                                 
      IF DP < DPORG | DP >= DPLIM THEN CALL GETDATA;                            
      CALL CHECKBASES;                                                          
      IF CONTROL(BYTE('E')) THEN                                                
         OUTPUT = X70 || DP || ': DATA = ' || W;                                
      I = DP - DPORG;                                                           
      DATA(I) = SHR(W,24);                                                      
      DATA(I+1) = SHR(W,16);                                                    
      DATA(I+2) = SHR(W,8);                                                     
      DATA(I+3) = W;                                                            
      DP = DP + 4;                                                              
      CALL CHECKBASES;                                                          
   END EMITDATAWORD;                                                            
                                                                                
EMITDESC:                                                                       
   PROCEDURE (D);                                                               
      DECLARE D FIXED;                                                          
      /*  SEND 32-BIT DESCRIPTOR TO STRING DESCRIPTOR AREA  */                  
      IF DSP >= 4096 THEN                                                       
         DO;                                                                    
            CALL ERROR ('TOO MANY STRINGS', 1);                                 
            DSP = 0;                                                            
         END;                                                                   
      IF CONTROL(BYTE('E')) THEN                                                
         OUTPUT = X70 || DSP || ': DESC = ' || SHR(D,24) || ', ' ||             
            (D & "FFFFFF");                                                     
      DESC(SHR(DSP,2)) = D;                                                     
      DSP = DSP + 4;                                                            
   END EMITDESC;                                                                
                                                                                
EMITCONSTANT:                                                                   
   PROCEDURE(C);                                                                
      /* SEE IF C HAS ALREADY BEEN EMITED, AND IF NOT EMIT.  SET UP ADDRESS */  
      DECLARE CTAB(100) FIXED, CADD (100) BIT(16), (C, NC, I) FIXED;            
      DO I = 1 TO NC;                                                           
         IF CTAB(I) = C THEN                                                    
            DO;                                                                 
               ADREG = SHR(CADD(I),12);                                         
               ADRDISP = CADD(I) & "FFF";                                       
               RETURN;                                                          
            END;                                                                
      END;                                                                      
      CALL EMITDATAWORD (C);                                                    
      CTAB(I) = C;                                                              
      CALL FINDADDRESS(DP-4);                                                   
      CADD(I) = SHL(ADREG,12) + ADRDISP;                                        
      IF I < 100 THEN NC = I;                                                   
      INFORMATION = INFORMATION || ' C' || I || EQUALS || C || PERIOD;          
   END EMITCONSTANT;                                                            
EMITRR:                                                                         
   PROCEDURE (OP, R1, R2);                                                      
      DECLARE (OP, R1, R2) FIXED;                                               
      /* EMIT A 16-BIT RR FORMAT INSTRUCTION  */                                
      COUNT#RR = COUNT#RR + 1;                                                  
      IF CONTROL(BYTE('E')) THEN                                                
         DO;                                                                    
            OP_CODE = SUBSTR(OPNAMES, OPER(OP), 4);                             
            OUTPUT = X70 || PP || ': CODE = ' || OP_CODE || X1 || R1            
               || ',' || R2;                                                    
         END;                                                                   
      CALL EMITCODEBYTES(OP, SHL(R1,4)+R2);                                     
      INSTRUCT(OP) = INSTRUCT(OP) + 1;                                          
   END EMITRR;                                                                  
                                                                                
EMITRX:                                                                         
   PROCEDURE (OP, R1, R2, R3, DISP);                                            
      DECLARE (OP, R1, R2, R3, DISP) FIXED;                                     
      /*  EMIT A 32-BIT RX FORMAT INSTRUCTION */                                
      COUNT#RX = COUNT#RX + 1;                                                  
      IF CONTROL(BYTE('E')) THEN                                                
         DO;                                                                    
            OP_CODE = SUBSTR(OPNAMES, OPER(OP), 4);                             
            OUTPUT = X70 || PP || ': CODE = ' || OP_CODE || X1 || R1            
               || ',' || DISP || '(' || R2 || ',' || R3 || ')';                 
         END;                                                                   
      CALL EMITCODEBYTES(OP, SHL(R1,4)+R2);                                     
      CALL EMITCODEBYTES(SHL(R3,4)+SHR(DISP,8), DISP & "FF");                   
      INSTRUCT(OP) = INSTRUCT(OP) + 1;                                          
   END EMITRX;                                                                  
                                                                                
                                                                                
  /*                       FIXUP PROCEDURES                                  */ 
                                                                                
                                                                                
INSERT_CODE_FIXUPS:                                                             
   PROCEDURE;                                                                   
                                                                                
      DECLARE (I, J, L, FXLIM, T1, K) FIXED;                                    
      DECLARE T2 BIT(8), EXCHANGES BIT(1);                                      
                                                                                
      /* THE FIRST STEP IS TO SORT THE CODE FIXUP TABLE */                      
      K,FXLIM = FCP - 1;     EXCHANGES = TRUE;                                  
      DO WHILE EXCHANGES;  /* QUIT BUBBLE SORT AFTER TABLE QUIETS DOWN */       
         EXCHANGES = FALSE;  /* RESET ON EACH EXCHANGE BELOW */                 
         DO J = 0 TO K-1;                                                       
            I = FXLIM-J;                                                        
            L = I-1;                                                            
            IF FIXCADR(L) > FIXCADR(I) THEN                                     
               DO;  /* SWAP */                                                  
                  T1 = FIXCADR(L);  FIXCADR(L) = FIXCADR(I);  FIXCADR(I) = T1;  
                  T2 = FIXCB1(L);  FIXCB1(L) = FIXCB1(I);  FIXCB1(I) = T2;      
                  T2 = FIXCB2(L);  FIXCB2(L) = FIXCB2(I);  FIXCB2(I) = T2;      
                  EXCHANGES = TRUE;  K = J;                                     
               END;                                                             
         END;                                                                   
      END;                                                                      
                                                                                
      /* NOW WRITE OUT THE CURRENT BLOCK */                                     
      FILE(CODEFILE,CURCBLK) = CODE;                                            
                                                                                
      /* WRITE BINARY PROGRAM PATCHES INTO PROGRAM FILE */                      
                                                                                
      K,PPORG=0;  PPLIM = DISKBYTES;                                            
      DO J = 0 TO CODEMAX;                                                      
                                                                                
         I = K;  /* KEEP TRACK OF K SO THAT WE WILL KNOW WHEN TO READ IN */     
                                                                                
         DO WHILE (K <= FXLIM)  &  (FIXCADR(K) < PPLIM);                        
            /* IF THE FILE HAS NOT YET BEEN READ IN, DO SO */                   
            IF K = I THEN CODE = FILE(CODEFILE,J); /* ONLY IF A FIX IS NEEDED */
            L = FIXCADR(K) - PPORG;  /* RELATIVE ADDRESS WITHIN THIS BLOCK */   
            CODE(L) = FIXCB1(K);  CODE(L+1) = FIXCB2(K);                        
            K = K + 1;                                                          
         END;                                                                   
                                                                                
         IF K > I THEN    /* A FIXUP WAS DONE */                                
            FILE(CODEFILE,J) = CODE;  /* SO WRITE OUT THE CONTENTS */           
                                                                                
         PPORG=PPORG+DISKBYTES;                                                 
         PPLIM = PPLIM + DISKBYTES;                                             
      END;                                                                      
                                                                                
      FCP = 0;  /* RESET TABLE TO EMPTY */                                      
      CODE = FILE(CODEFILE,CURCBLK);  /* RESTORE FILE TO PREVIOUS STATE */      
      PPORG = CURCBLK*DISKBYTES;  PPLIM = PPORG + DISKBYTES;                    
   END INSERT_CODE_FIXUPS;                                                      
                                                                                
FIXCHW:                                                                         
   PROCEDURE (ADR, B1, B2);                                                     
      DECLARE ADR FIXED, (B1, B2) BIT(8);                                       
      /*  FIX UP ONE HALF WORD OF CODE  */                                      
      COUNT#FIXCHW = COUNT#FIXCHW + 1;                                          
      IF FCP >= FCLIM THEN                                                      
         CALL INSERT_CODE_FIXUPS;                                               
      IF PPORG <= ADR & ADR < PPLIM THEN                                        
         DO;                                                                    
            SHORTCFIX = SHORTCFIX + 1;                                          
            ADR = ADR - PPORG;                                                  
            CODE(ADR) = B1;                                                     
            CODE(ADR+1) = B2;                                                   
         END;                                                                   
      ELSE                                                                      
         DO;                                                                    
            LONGCFIX = LONGCFIX + 1;                                            
            FIXCADR(FCP) = ADR;                                                 
            FIXCB1(FCP) = B1;                                                   
            FIXCB2(FCP) = B2;                                                   
            FCP = FCP + 1;                                                      
         END;                                                                   
   END  FIXCHW;                                                                 
                                                                                
                                                                                
FIXBFW:                                                                         
   PROCEDURE (WHERE, VAL);                                                      
      DECLARE (WHERE, VAL, I, J, P) FIXED;                                      
      IF WHERE = 0 THEN RETURN;                                                 
      /* FIX UP A BRANCH WHOSE ADDRESS WE NOW KNOW */                           
      COUNT#FIXBFW = COUNT#FIXBFW + 1;                                          
      IF CONTROL(BYTE('E')) THEN OUTPUT = X70 || '     ' || WHERE || ': FIXUP ='
            || VAL;                                                             
      P = WHERE + 2;       /* THE ACTUAL ADDRESS FIELD  */                      
      IF WHERE >=  "1000" THEN                                                  
         DO;                                                                    
            CALL FIXCHW (P, SHL(DBR,4), SHR(VAL,10) & "FC");                    
            VAL = VAL & "FFF";                                                  
            P = P + 4;                                                          
         END;                                                                   
      ELSE IF VAL >= "1000" THEN                                                
         DO;                                                                    
            I = VAL & "FFF";                                                    
            J = SHR(VAL, 12);                                                   
            INSTRUCT(LOAD) = INSTRUCT(LOAD) + 1;                                
            INSTRUCT(BC) = INSTRUCT(BC) + 1;                                    
            CALL EMITDATAWORD (SHL(LOAD, 24) + SHL(BRCHREG, 20) + SHL(DBR, 12)  
                  + SHL(J, 2));                                                 
            CALL EMITDATAWORD("47F00000" +  SHL(BRCHREG,16) + SHL(PBR, 12) + I);
            CALL FINDADDRESS (DP-8);                                            
            CALL FIXCHW(P, SHL(ADREG,4)+SHR(ADRDISP,8), ADRDISP & "FF");        
            RETURN;                                                             
         END;                                                                   
      CALL FIXCHW(P, SHL(PBR,4)+SHR(VAL,8), VAL & "FF");                        
   END FIXBFW;                                                                  
                                                                                
                                                                                
FIXWHOLEDATAWORD:                                                               
   PROCEDURE (ADR, WORD);                                                       
      DECLARE (ADR, WORD) FIXED;                                                
      DECLARE (BLK, TEMP) FIXED, REREAD BIT(1);                                 
      IF CONTROL(BYTE('E')) THEN                                                
         OUTPUT = X70 || ADR || ':  FIXUP = ' || WORD;                          
      COUNT#FIXD = COUNT#FIXD + 1;                                              
      BLK = ADR/DISKBYTES;                                                      
      REREAD = (CURDBLK ~= BLK);                                                
      IF REREAD THEN                                                            
         DO;  /* MUST GET THE RIGHT BLOCK  */                                   
            LONGDFIX = LONGDFIX + 1;                                            
            TEMP = DP;                                                          
            DP = ADR;                                                           
            CALL GETDATA;                                                       
         END;                                                                   
      ELSE SHORTDFIX = SHORTDFIX + 1;                                           
      ADR = ADR MOD DISKBYTES;                                                  
      DATA(ADR) = SHR(WORD, 24);                                                
      DATA(ADR+1) = SHR(WORD, 16);                                              
      DATA(ADR+2) = SHR(WORD, 8);                                               
      DATA(ADR+3) = WORD;                                                       
      IF REREAD THEN DP = TEMP;                                                 
   END  FIXWHOLEDATAWORD;                                                       
                                                                                
                                                                                
   /*  S Y M B O L   T A B L E   E N T R Y   A N D   L O O K U P   */           
                                                                                
   NULLOUT:                                                                     
      PROCEDURE (MAXINDEX);                                                     
         DECLARE (I, MAXINDEX) FIXED;                                           
         DO I = 0 TO 255;                                                       
            IF BUCKET(I) >= MAXINDEX THEN                                       
               BUCKET(I) = NULL;                                                
            END;                                                                
         DO I = 1 TO MAXINDEX - 1;                                              
            IF SY_LINK(I) >= MAXINDEX THEN                                      
               SY_LINK(I) = NULL;                                               
            END;                                                                
      END NULLOUT;                                                              
                                                                                
                                                                                
ENTER:                                                                          
   PROCEDURE (SYMB, T, L, LINE);                                                
      /*  ENTER A SYMBOL IN THE SYMBOL TABLE  */                                
      DECLARE (SY_PTR, I, J, K, L, T, LINE) FIXED,                              
               SYMB CHARACTER;                                                  
                                                                                
      I = LENGTH(SYMB) -1;                                                      
      I = (BYTE(SYMB) + BYTE(SYMB, I) + I + PROC_STACK(LEX_LEVEL)) & "FF";      
      SY_PTR = BUCKET(I);                                                       
      IF SY_PTR ~= NULL THEN DO;                                                
SEARCH_SOMEMORE:  /* DO UNTIL SY_LINK(SY_PTR) = NULL  */                        
         IF SYT(SY_PTR) = SYMB THEN DO;                                         
               IDCOMPARES = IDCOMPARES + 1;                                     
               K = SYTYPE(SY_PTR);                                              
               IF T = LABELTYPE & (K = FORWARDTYPE | K = FORWARDCALL) THEN      
                  DO;                                                           
                     IF CONTROL(BYTE('E')) THEN                                 
                        OUTPUT = X70 || 'FIX REFERENCES TO: ' || SYMB;          
                     J = BASES(SYBASE(SY_PTR)) + SYDISP(SY_PTR);                
                     IF K = FORWARDCALL THEN                                    
                        IF L > "FFF" THEN                                       
                           L = L+8;                                             
                        ELSE                                                    
                           L = L+4;                                             
                     SYBASE(SY_PTR) = SHR(L, 12);                               
                     SYDISP(SY_PTR) = L & "FFF";                                
                     CALL FIXWHOLEDATAWORD(J,L);                                
                     SYTYPE(SY_PTR) = T;                                        
                     DECLARED_ON_LINE(SY_PTR) = LINE;                           
                  END;                                                          
               ELSE IF PROCMARK + PARCT < SY_PTR THEN                           
                  CALL ERROR('DUPLICATE DECLARATION FOR:  ' || SYMB, 0);        
               ELSE DECLARED_ON_LINE(SY_PTR) = LINE;                            
               RETURN SY_PTR;                                                   
            END;                                                                
         IDCOMPARES = IDCOMPARES + 1;                                           
         IF SY_LINK(SY_PTR) ~= NULL THEN DO;                                    
            SY_PTR = SY_LINK(SY_PTR);                                           
            GOTO SEARCH_SOMEMORE;                                               
            END;                                                                
         NDECSY,         SY_LINK(SY_PTR) = NDECSY + 1;                          
         END;                                                                   
      ELSE                                                                      
         NDECSY,         BUCKET(I) = NDECSY + 1;                                
      IF NDECSY > MAXNDECSY THEN                                                
         IF NDECSY > SYTSIZE THEN                                               
            DO;                                                                 
               CALL ERROR ('SYMBOL TABLE OVERFLOW', 1);                         
               NDECSY = NDECSY - 1;                                             
            END;                                                                
         ELSE MAXNDECSY = NDECSY;                                               
      SYT(NDECSY) = SYMB;                                                       
      SYTYPE(NDECSY) = T;                                                       
      DECLARED_ON_LINE(NDECSY) = LINE;                                          
      SYTCO(NDECSY) = 0;                                                        
      IF T = LABELTYPE THEN                                                     
         DO;                                                                    
            SYBASE(NDECSY) = SHR(L, 12);  /* PAGE  */                           
            SYDISP(NDECSY) = L & "FFF";                                         
         END;                                                                   
      ELSE                                                                      
         DO;                                                                    
            CALL FINDADDRESS(L);                                                
            SYBASE(NDECSY) = ADREG;                                             
            SYDISP(NDECSY) = ADRDISP;                                           
         END;                                                                   
      RETURN NDECSY;                                                            
   END  ENTER;                                                                  
                                                                                
ID_LOOKUP:                                                                      
   PROCEDURE (P);                                                               
       /* LOOKS UP THE IDENTIFIER AT P IN THE ANALYSIS STACK IN THE             
          SYMBOL TABLE AND INITIALIZES FIXL,CNT,TYPE,REG,INX                    
          APPROPRIATELY.  IF THE IDENTIFIER IS NOT FOUND, FIXL IS               
          SET TO -1                                                             
       */                                                                       
      DECLARE (P, I, L, SY_PTR) FIXED,                                          
              CHAR_TEMP CHARACTER;                                              
       CHAR_TEMP = VAR(P);                                                      
      L = LEX_LEVEL;                                                            
      I = LENGTH(CHAR_TEMP) -1;                                                 
      I = BYTE(CHAR_TEMP) + BYTE(CHAR_TEMP, I) + I;                             
      DO WHILE L >= 0;                                                          
          SY_PTR = BUCKET((I + PROC_STACK(L)) & "FF");                          
         DO WHILE SY_PTR ~= NULL;                                               
            IF SYT(SY_PTR) = CHAR_TEMP THEN DO;                                 
               IDCOMPARES = IDCOMPARES + 1;                                     
               FIXL(P) = SY_PTR;                                                
               CNT(P) = 0;   /* INITIALIZE SUBSCRIPT COUNT  */                  
               TYPE(P) = VARIABLE;                                              
               IF SYTYPE(SY_PTR) = SPECIAL THEN                                 
                  FIXV(P) = SYDISP(SY_PTR);     /* BUILTIN FUNCTION */          
               ELSE                                                             
                  FIXV(P) = 0;               /* ~ BUILTIN FUNCTION */           
               REG(P),INX(P) = 0;   /* INITIALIZE REGISTER POINTERS */          
               SYTCO(SY_PTR) = SYTCO(SY_PTR) + 1;  /* COUNT REFERENCES */       
               RETURN;                                                          
               END;                                                             
            SY_PTR = SY_LINK(SY_PTR);                                           
            IDCOMPARES = IDCOMPARES + 1;                                        
            END;                                                                
         L = L - 1;                                                             
         END;                                                                   
      FIXL(P) = -1;      /*  IDENTIFIER NOT  FOUND */                           
   END   ID_LOOKUP;                                                             
                                                                                
                                                                                
UNDECLARED_ID:                                                                  
   PROCEDURE (P);                                                               
      /* ISSUES AN ERROR MESSAGE FOR UNDECLARED IDENTIFIERS AND                 
         ENTERS THEM WITH DEFAULT TYPE IN THE SYMBOL TABLE                      
      */                                                                        
      DECLARE P FIXED;                                                          
      CALL ERROR('UNDECLARED IDENTIFIER:  ' || VAR(P) ,0);                      
      CALL EMITDATAWORD(0);                                                     
      CALL ENTER (VAR(P), FIXEDTYPE, DP-4, CARD_COUNT);                         
      CNT(P) = 0;                                                               
      FIXV(P) = 0;                                                              
      REG(P) = 0;                                                               
      INX(P) = 0;                                                               
      FIXL(P) = NDECSY;                                                         
      SYTCO(NDECSY) = 1;                /* COUNT FIRST REFERENCE */             
      TYPE(P) = VARIABLE;                                                       
   END  UNDECLARED_ID;                                                          
                                                                                
SETINIT:                                                                        
   PROCEDURE;                                                                   
      /*  PLACES INITIAL VALUES INTO DATA AREA */                               
                                                                                
      DECLARE (I, J) FIXED;                                                     
      IF ITYPE = CHRTYPE THEN                                                   
         DO;                                                                    
            IF TYPE(MPP1) ~= CHRTYPE THEN VAR(MPP1) = FIXV(MPP1);               
            S = VAR(MPP1);    /* THE STRING */                                  
            I = LENGTH(S) - 1;                                                  
                                                                                
            IF I < 0 THEN                                                       
               CALL EMITDESC(0);                                                
            ELSE                                                                
               CALL EMITDESC(SHL(I,24) + CHP);                                  
                                                                                
            DO J = 0 TO I;                                                      
               CALL EMITCHAR(BYTE(S,J));                                        
            END;                                                                
         END;                                                                   
      ELSE IF TYPE(MPP1) ~= CONSTANT THEN                                       
         CALL ERROR ('ILLEGAL CONSTANT IN INITIAL LIST');                       
      ELSE IF ITYPE = FIXEDTYPE THEN                                            
         CALL EMITDATAWORD(FIXV(MPP1));                                         
      ELSE IF ITYPE = HALFWORD THEN                                             
         DO;                                                                    
            /*  FIRST FORCE ALIGNMENT  */                                       
            DP = (DP + 1) & "FFFFFE";                                           
            CALL EMITBYTE (SHR(FIXV(MPP1), 8));                                 
            CALL EMITBYTE(FIXV(MPP1) & "FF");                                   
         END;                                                                   
      ELSE IF ITYPE = BYTETYPE THEN                                             
         CALL EMITBYTE(FIXV(MPP1));                                             
   END  SETINIT;                                                                
                                                                                
ALLOCATE :                                                                      
   PROCEDURE(P,DIM);                                                            
      /* ALLOCATES STORAGE FOR THE IDENTIFIER AT P IN THE ANALYSIS              
         STACK WITH DIMENSION DIM                                               
      */                                                                        
                                                                                
      DECLARE (P, DIM, J) FIXED;                                                
                                                                                
                                                                                
   CHECK_NEWDP:                                                                 
      PROCEDURE;                                                                
         DECLARE T FIXED;                                                       
         T = DP;                                                                
         DP = NEWDP;                                                            
         CALL CHECKBASES;                                                       
         DP = T;                                                                
      END  CHECK_NEWDP;                                                         
                                                                                
                                                                                
                                                                                
      DIM = DIM + 1;         /* ACTUAL NUMBER OF ITEMS  */                      
      DO CASE TYPE(P);                                                          
                                                                                
         ;     /*  CASE  0    DUMMY        */                                   
                                                                                
         DO;      /*   CASE 1    HALFWORD  */                                   
            NEWDP = (NEWDP + 1) & "FFFFFE";   /* ALIGN HALFWORD  */             
            CALL CHECK_NEWDP;                                                   
            J = NEWDP;                                                          
            NEWDP = NEWDP + SHL(DIM, 1);                                        
         END;                                                                   
                                                                                
                                                                                
         ;     /*  CASE  2    LABEL TYPE         */                             
                                                                                
                                                                                
          ;    /*  CASE  3    ACCUMULATOR        */                             
                                                                                
          ;    /*  CASE  4    VARIABLE           */                             
                                                                                
          ;    /*  CASE  5    CONSTANT           */                             
                                                                                
          ;    /*  CASE  6    CONDITION          */                             
                                                                                
          DO;  /*  CASE  7    CHARACTER TYPE     */                             
            J = -NEWDSP;                                                        
            NEWDSP = NEWDSP + SHL(DIM,2);                                       
          END;                                                                  
                                                                                
          DO;  /*  CASE  8    FIXED TYPE         */                             
            NEWDP = (NEWDP + 3) & "FFFFFC";    /* ALIGN TO WORD */              
            CALL CHECK_NEWDP;                                                   
            J = NEWDP;                                                          
            NEWDP = NEWDP + SHL(DIM,2);                                         
          END;                                                                  
                                                                                
          DO;  /*  CASE  9    BYTE TYPE          */                             
            CALL CHECK_NEWDP;                                                   
            J = NEWDP;                                                          
            NEWDP = NEWDP + DIM;                                                
          END;                                                                  
                                                                                
         DO;  /*  CASE 10    FORWARD TYPE  (LABEL)  */                          
            NEWDP = (NEWDP+3) & "FFFFFC";  /* WORD ALIGN */                     
            CALL CHECK_NEWDP;                                                   
            J = NEWDP;                                                          
            NEWDP = NEWDP + SHL(DIM,2);        /* SPACE FOR FIXUPS  */          
         END;                                                                   
                                                                                
          ;    /*  CASE 11    DESCRIPT           */                             
                                                                                
          ;    /*  CASE 12    SPECIAL            */                             
                                                                                
          ;    /*  CASE 13    FORWARD CALL       */                             
                                                                                
          ;    /*  CASE 14    CHAR_PROC_TYPE             */                     
                                                                                
          ;    /*  CASE 15    UNUSED             */                             
                                                                                
      END; /*  OF DO CASE TYPE(P)  */                                           
                                                                                
      SYTYPE(FIXL(P)) = TYPE(P);                                                
      CALL FINDADDRESS(J);                                                      
      SYBASE(FIXL(P)) = ADREG;                                                  
      SYDISP(FIXL(P)) = ADRDISP;                                                
                                                                                
   END  ALLOCATE;                                                               
                                                                                
                                                                                
TDECLARE:                                                                       
   PROCEDURE (DIM);                                                             
      /*  ALLOCATES STORAGE FOR IDENTIFIERS IN DECLARATIONS  */                 
      DECLARE DIM FIXED;                                                        
      NEWDP = DP;                                                               
      NEWDSP = DSP;                                                             
      TYPE(MP) = TYPE(SP);                                                      
      CASEP = FIXL(MP);                                                         
      DO I = 1 TO INX(MP);                                                      
         FIXL(MP) = CASESTACK(CASEP+I);      /* SYMBOL TABLE POINTER */         
         CALL ALLOCATE(MP, DIM);                                                
      END;                                                                      
   END  TDECLARE;                                                               
                                                                                
                                                                                
                                                                                
                                                                                
MOVESTACKS:                                                                     
   PROCEDURE (F,T);                                                             
      DECLARE F FIXED, T FIXED;                                                 
      /*  MOVE ALL THE COMPILER STACKS DOWN FROM F TO T  */                     
      TYPE(T) = TYPE(F);  VAR(T) = VAR(F);                                      
      FIXL(T) = FIXL(F);  FIXV(T) = FIXV(F);                                    
      INX(T) = INX(F);    REG(T) = REG(F);                                      
      PPSAVE(T) = PPSAVE(F);  CNT(T) = CNT(F);                                  
   END  MOVESTACKS;                                                             
                                                                                
                                                                                
                                                                                
                                                                                
  /*                        BRANCH PROCEDURES                                */ 
                                                                                
                                                                                
                                                                                
BRANCH_BD:                                                                      
   PROCEDURE(COND, B, D);                                                       
      DECLARE (COND, B, D) FIXED;                                               
      /*  BRANCHES ARE A SPECIAL CASE.  IF THEY ARE INTO THE 1ST  4096          
         BYTES OF PROGRAM A SINGLE BRANCH WILL SUFFICE.  OTHERWISE WE           
         MUST INDEX WITH A CONSTANT IN BRCHREG TO GET ANYWHERE.                 
      */                                                                        
      IF B = 0 THEN                                                             
         CALL EMITRX(BC, COND, 0, PBR, D);                                      
      ELSE                                                                      
    DO;                                                                         
            CALL EMITRX(LOAD,BRCHREG,0,DBR,SHL(B,2));                           
            CALL EMITRX(BC, COND, BRCHREG, PBR, D);                             
         END;                                                                   
   END  BRANCH_BD;                                                              
                                                                                
                                                                                
BRANCH:                                                                         
   PROCEDURE (COND, LOCATION);                                                  
      DECLARE (COND, LOCATION) FIXED;                                           
      IF LOCATION = 0 THEN LOCATION = PP;                                       
      /* ASSUME FIXUP WILL BE NEAR  */                                          
      CALL BRANCH_BD(COND, SHR(LOCATION,12), LOCATION & "FFF");                 
   END BRANCH;                                                                  
                                                                                
                                                                                
                                                                                
                                                                                
  /*                     EXPRESSIONS                                         */ 
                                                                                
                                                                                
CONDTOREG:                                                                      
   PROCEDURE (MP, CC);                                                          
      DECLARE (MP, CC, J) FIXED;                                                
      J = FINDAC;                                                               
      CALL EMITRX(LA, J, 0, 0, 0);                                              
      IF PP < 4084 THEN                                                         
         CALL BRANCH(CC, PP+8);                                                 
      ELSE                                                                      
         CALL BRANCH(CC, PP+12);                                                
      CALL EMITRX(LA, J, 0, 0, 1);                                              
      TYPE(MP) = ACCUMULATOR;                                                   
      REG(MP) = J;                                                              
      STILLCOND = CC;                                                           
   END CONDTOREG;                                                               
                                                                                
BRLINK_BD:                                                                      
   PROCEDURE (BASE,DISP);                                                       
      DECLARE (BASE, DISP) FIXED;                                               
      IF BASE = 0 THEN                                                          
         CALL EMITRX(BAL, BRCHREG, 0, PBR, DISP);                               
      ELSE                                                                      
         DO;                                                                    
            CALL EMITRX(LOAD, BRCHREG, 0, DBR, SHL(BASE,2));                    
            CALL EMITRX(BAL, BRCHREG, BRCHREG, PBR, DISP);                      
         END;                                                                   
    END BRLINK_BD;                                                              
                                                                                
                                                                                
   /*                  CODE FOR PROCEDURES                                   */ 
                                                                                
                                                                                
SAVE_REGISTERS:                                                                 
   PROCEDURE;                                                                   
      /* GENERATES CODE TO SAVE REGISTERS BEFORE A PROCEDURE OR                 
         FUNCTION CALL                                                          
      */                                                                        
      DECLARE I FIXED;                                                          
      DO I = 1 TO 3;                                                            
         IF BASES(I) ~= AVAIL THEN                                              
            DO;                                                                 
               CALL EMITDATAWORD(0);                                            
               CALL FINDADDRESS(DP-4);                                          
               TEMP(I) = SHL(ADREG,12)+ ADRDISP;                                
               CALL EMITRX(STORE,I,0,ADREG,ADRDISP);                            
            END;                                                                
         ELSE                                                                   
            TEMP(I) = 0;                                                        
      END;                                                                      
   END  SAVE_REGISTERS;                                                         
                                                                                
                                                                                
UNSAVE_REGISTERS:                                                               
   PROCEDURE (R,P);                                                             
      /*  GENERATES CODE TO RESTORE REGISTERS AFTER A FUNCTION                  
          OR PROCEDURE CALL AND ALSO DOES SOME HOUSEKEEPING                     
      */                                                                        
      DECLARE (R, P, I, J) FIXED;                                               
      IF BASES(R) ~= AVAIL THEN                                                 
         DO;                                                                    
            J = FINDAC;                                                         
            CALL EMITRR("18", J, R);                                            
         END;                                                                   
      ELSE                                                                      
         J = R;                                                                 
      DO I = 1 TO 3;                                                            
         IF TEMP(I) ~= 0 THEN                                                   
            CALL EMITRX(LOAD,I,0,SHR(TEMP(I),12), TEMP(I)&"FFF");               
      END;                                                                      
      TYPE(P) = ACCUMULATOR;                                                    
      REG(P) = J;                                                               
      BASES(J) = ACCUMULATOR;                                                   
   END  UNSAVE_REGISTERS;                                                       
                                                                                
                                                                                
                                                                                
                                                                                
CALLSUB:                                                                        
   PROCEDURE (SB,SD, R, P);                                                     
      DECLARE (SB, SD, R, P) FIXED;                                             
      CALL SAVE_REGISTERS;                                                      
      CALL BRLINK_BD(SB,SD);                                                    
      CALL UNSAVE_REGISTERS(R, P);                                              
   END  CALLSUB;                                                                
                                                                                
                                                                                
CALLSUB_FORWARD:                                                                
   PROCEDURE (SB,SD,R,P);                                                       
      DECLARE (SB, SD, R, P) FIXED;                                             
      CALL SAVE_REGISTERS;                                                      
      CALL EMITRX(LOAD, BRCHREG, 0, SB,SD);                                     
      CALL EMITRX(BAL, BRCHREG, BRCHREG, PBR, 0);                               
      CALL UNSAVE_REGISTERS(R, P);                                              
   END  CALLSUB_FORWARD;                                                        
                                                                                
                                                                                
                                                                                
FORCE_ADDRESS:                                                                  
   PROCEDURE (SP,R);                                                            
      /* GENERATES THE ADDRESS OF THE <VARIABLE> IN THE ANALYSIS                
         STACK AT SP IN REGISTER R.                                             
      */                                                                        
      DECLARE (SP, R, K, INXSP) FIXED;                                          
      IF SYTYPE(FIXL(SP)) = LABELTYPE THEN                                      
         DO;                                                                    
            K = FIXL(SP);                                                       
            IF SYBASE(K) = 0 THEN                                               
               CALL EMITRX(LA,R,0,PBR,SYDISP(K));                               
            ELSE                                                                
               DO;                                                              
                  CALL EMITRX(LOAD,R,0,DBR,SHL(SYBASE(K),2));                   
                  CALL EMITRX(LA,R,R,PBR,SYDISP(K));                            
               END;                                                             
         END;                                                                   
      ELSE                                                                      
         DO;                                                                    
            K = SYTYPE(FIXL(SP));                                               
            INXSP = INX(SP);                                                    
            IF INXSP ~= 0 THEN                                                  
               DO;                                                              
                  IF K ~= BYTETYPE THEN                                         
                     IF K = HALFWORD THEN                                       
                        CALL EMITRR ("1A", INXSP, INXSP);                       
                     ELSE                                                       
                        CALL EMITRX("89",INXSP,0,0,2);                          
               END;                                                             
                  BASES(INXSP) = AVAIL;                                         
            IF K = FORWARDTYPE | K = FORWARDCALL THEN                           
               DO;                                                              
                  K = FIXL(SP);                                                 
                  CALL EMITRX(LOAD,R,0,SYBASE(K),SYDISP(K));                    
                  CALL EMITRR("1A",R,PBR);                                      
               END;                                                             
            ELSE                                                                
               CALL EMITRX(LA,R,INXSP,SYBASE(FIXL(SP)),SYDISP(FIXL(SP)));       
         END;                                                                   
   END  FORCE_ADDRESS;                                                          
                                                                                
                                                                                
FILE_PSEUDO_ARRAY:                                                              
   PROCEDURE (VARP,FILEP, DIRECTION);                                           
      /* PROCEDURE TO GENERATE CODE FOR THE FILE PSEUDO ARRAY.                  
         TWO FORMS ARE HANDLED:                                                 
                                                                                
               <VARIABLE>  =  FILE(I,J);                                        
                                                                                
               FILE(I,J)  =  <VARIABLE>;                                        
                                                                                
         VARP IS A POINTER TO THE <VARIABLE> IN THE ANALYSIS STACKS.            
         FILEP IS A POINTER TO THE ANALYSIS STACK WHERE FILE(I,J)               
         HAS BEEN ASSIMILATED UNDER THE GUISE OF A SUBSCRIPTED                  
         VARIABLE.  DIRECTION = 0 FOR THE FIRST CASE (READ) AND                 
         DIRECTION = 4 FOR THE SECOND CASE (WRITE).  I IS THE FILE              
         INDEX (I = 1,2,3) AND J IS THE RELATIVE RECORD WITHIN THE              
         FILE.  THE GENERATED CODE SHOULD HAVE THE SAME EFFECT AS;              
                                                                                
               LA   0,<VARIABLE>                                                
               L    1,I                                                         
               SLL  1,3                 I*8                                     
               LA   1,DIRECTION+44(,1)                                          
               L    2,J                                                         
               BALR BRCHREG,IOREG                                               
                                                                                
         REGISTERS 0-3 ARE NOT PRESERVED ACROSS THE MONITOR CALL,               
         HENCE ALL REGISTERS ARE FREED,                                         
                                                                                
      */                                                                        
      DECLARE (VARP, DIRECTION, FILEP, R) FIXED;                                
      IF TYPE(VARP) = VARIABLE THEN                                             
         DO;                                                                    
            CALL FORCE_ADDRESS(VARP,0);                                         
            CALL EMITRX("89",REG(FILEP),0,0,3);   /*  I*8  */                   
            R = FINDAC;                                                         
            IF INX(FILEP) = 1 THEN                                              
               DO;                      /*  JUGGLE REGISTERS  */                
                  CALL EMITRR("18",R,1);                                        
                  INX(FILEP) = R;                                               
               END;                                                             
            CALL EMITRX(LA,1,0,REG(FILEP),44+DIRECTION);                        
            IF INX(FILEP) ~= 2 THEN                                             
               CALL EMITRR("18",2,INX(FILEP));    /*  J    */                   
            CALL EMITRR(BALR,BRCHREG,IOREG);                                    
            TYPE(FILEP) = SPECIAL;      /*  NO MORE ASSIGNMENTS  */             
            CALL CLEARREGS;            /*  FREE ALL REGISTERS  */               
         END;                                                                   
      ELSE                                                                      
         CALL ERROR('ILLEGAL USE OF FILE PSEUDO ARRAY',1);                      
   END  FILE_PSEUDO_ARRAY;                                                      
                                                                                
                                                                                
EMIT_INLINE:                                                                    
   PROCEDURE;                                                                   
                                                                                
      /* GENERATES CODE FOR THE PSEUDO FUNCTION INLINE                */        
                                                                                
      DECLARE BINLM CHARACTER INITIAL ('BAD ARGUMENT TO INLINE');               
                                                                                
      IF CNT(MP) < 4 THEN                                                       
         DO;                                                                    
            IF TYPE(MPP1) = CONSTANT THEN                                       
               DO CASE CNT(MP);                                                 
                                                                                
                  ;                              /* NO CASE 0 */                
                                                                                
                  FIXL(MP) = FIXV(MPP1);         /* SAVE OP CODE */             
                                                                                
                  DO;                            /* SAVE R1  */                 
                     TYPE(MP) = ACCUMULATOR;                                    
                     REG(MP) = FIXV(MPP1);                                      
                  END;                                                          
                                                                                
                  CALL EMITCODEBYTES(FIXL(MP), SHL(REG(MP), 4) +                
                     FIXV(MPP1));                                               
                                                 /* EMIT  OP R1 X  */           
               END;                                                             
            ELSE                                                                
               CALL ERROR(BINLM,1);                                             
         END;                                                                   
      ELSE IF TYPE(MPP1) = CONSTANT THEN                                        
         DO;                                                                    
            IF CNT(MP) & 1 THEN                                                 
               CALL EMITCODEBYTES(INX(MP)+SHR(FIXV(MPP1), 8),                   
                  FIXV(MPP1));                                                  
                                       /* EMIT  B DDD  */                       
            ELSE                                                                
               INX(MP) = SHL(FIXV(MPP1), 4);      /* SAVE BASE REG  */          
         END;                                                                   
      ELSE IF TYPE(MPP1) = VARIABLE THEN                                        
         DO;                                                                    
            CNT(MP) = CNT(MP) + 1;                                              
            IF CNT(MP) & 1 THEN                                                 
               CALL EMITCODEBYTES(SHL(SYBASE(FIXL(MPP1)), 4) +                  
                                  SHR(SYDISP(FIXL(MPP1)), 8) ,                  
                                  SYDISP(FIXL(MPP1)));                          
            ELSE                                                                
               CALL ERROR(BINLM, 1);                                            
         END;                                                                   
      ELSE                                                                      
         CALL ERROR(BINLM, 1);                                                  
                                                                                
   END  EMIT_INLINE;                                                            
                                                                                
                                                                                
                                                                                
                                                                                
PROC_START:                                                                     
   PROCEDURE;                                                                   
      /*  GENERATES CODE FOR THE HEAD OF A PROCEDURE */                         
                                                                                
      DECLARE I FIXED;                                                          
      I = FIXL(MP);                                                             
      FIXL(MP) = PP;                                                            
      CALL BRANCH("F",0);    /*  BRANCH AROUND  */                              
      CALL EMITDATAWORD(0);  /*  PLACE TO STORE RETURN ADDRESS */               
      PPSAVE(MP) = RTNADR;                                                      
      RTNADR = DP - 4;                                                          
      CALL FINDADDRESS(RTNADR);                                                 
      SYBASE(I) = SHR(PP,12);          /* ADDRESS OF THE PROCEDURE  */          
      SYDISP(I) = PP & "FFF";                                                   
      CALL EMITRX(STORE, BRCHREG,0,ADREG,ADRDISP);                              
   END  PROC_START;                                                             
                                                                                
STUFF_PARAMETER:                                                                
   PROCEDURE;                                                                   
      /* GENERATES CODE TO SEND AN ACTUAL PARAMETER TO A PROCEDURE */           
      I = FIXL(MP) + CNT(MP);                                                   
      IF LENGTH(SYT(I)) = 0 THEN                                                
         DO;                                                                    
            IF SYTYPE(I) = BYTETYPE THEN                                        
               J = "42";           /*  STC  */                                  
            ELSE IF SYTYPE(I) = HALFWORD THEN                                   
               J = "40";                                                        
            ELSE                                                                
               J = STORE;         /*  ST  */                                    
            CALL EMITRX(J, REG(MPP1), 0, SYBASE(I), SYDISP(I));                 
            BASES(REG(MPP1)) = AVAIL;                                           
         END;                                                                   
      ELSE                                                                      
         CALL ERROR('TOO MANY ACTUAL PARAMETERS', 1);                           
   END  STUFF_PARAMETER;                                                        
                                                                                
                                                                                
CHECK_STRING_OVERFLOW:                                                          
   PROCEDURE;                                                                   
      DECLARE (I, BR_SAVE) FIXED;                                               
      CALL EMITRX (LOAD, 0, 0, DBR, TSA);                                       
      CALL EMITRX (CMPR, 0, 0, DBR, LIMITWORD);                                 
      I = PP;                                                                   
      CALL BRANCH (4, 0);                                                       
      CALL EMITDATAWORD(0);  BR_SAVE = DP - 4;                                  
      CALL FINDADDRESS(BR_SAVE);                                                
      CALL EMITRX(STORE, BRCHREG, 0, ADREG, ADRDISP);                           
      IF SYTYPE (STRING_RECOVER) = LABELTYPE THEN                               
         CALL CALLSUB(SYBASE(STRING_RECOVER),SYDISP(STRING_RECOVER), 0,         
            STACKSIZE);                                                         
      ELSE                                                                      
         CALL CALLSUB_FORWARD(SYBASE(STRING_RECOVER),                           
            SYDISP(STRING_RECOVER), 0, STACKSIZE);                              
      BASES(REG(STACKSIZE)) = AVAIL;                                            
      CALL FINDADDRESS (BR_SAVE);                                               
      CALL EMITRX(LOAD,BRCHREG,0,ADREG,ADRDISP);                                
      SYTCO(STRING_RECOVER) = SYTCO(STRING_RECOVER) + 1;                        
      CALL EMITRR ("1B", 0, 0);                                                 
      CALL FINDADDRESS (STRL);                                                  
      CALL EMITRX (STORE, 0, 0, ADREG, ADRDISP);                                
      CALL FIXBFW (I, PP);                                                      
   END CHECK_STRING_OVERFLOW;                                                   
                                                                                
                                                                                
FORCEACCUMULATOR:                                                               
   PROCEDURE (P);                                                               
      DECLARE P FIXED;                                                          
      /* FORCE THE OPERAND AT P INTO AN ACCUMULATOR */                          
      DECLARE (R, SB, SD, TP, SFP) FIXED, T1 CHARACTER;                         
      COUNT#FORCE = COUNT#FORCE + 1;                                            
      TP = TYPE(P);                                                             
      IF TP = CONDITION THEN CALL CONDTOREG (P, REG(P));                        
      ELSE IF TP = VARIABLE THEN                                                
         DO;                                                                    
            SB = SYBASE(FIXL(P));                                               
            SD = SYDISP(FIXL(P));                                               
            SFP = SYTYPE(FIXL(P));                                              
            IF SFP = LABELTYPE | SFP = CHAR_PROC_TYPE THEN                      
               DO;                                                              
                  CALL CALLSUB(SB,SD,3,P);                                      
                  IF LENGTH(SYT(FIXL(P)+CNT(P)+1)) = 0 THEN                     
                     IF CONTROL(BYTE('N')) THEN                                 
                        OUTPUT = '** WARNING--NOT ALL PARAMETERS SUPPLIED';     
                  IF SFP = CHAR_PROC_TYPE THEN                                  
                     TYPE(P) = DESCRIPT;                                        
               END;                                                             
            ELSE IF SFP = FORWARDTYPE | SFP = FORWARDCALL THEN                  
               DO;                                                              
                  CALL CALLSUB_FORWARD(SB,SD,3,P);                              
                  SYTYPE(FIXL(P)) = FORWARDCALL;                                
               END;                                                             
            ELSE  IF SFP = SPECIAL THEN                                         
               DO;                                                              
                  CALL EMITRX("90", 1, 3, DBR, IO_SAVE);                        
                  IF SD = 6 THEN                                                
                     DO;  /*  INPUT */                                          
                        CALL CHECK_STRING_OVERFLOW;                             
                        IF REG(P) = 0 THEN CALL EMITRR ("1B", 2, 2);            
                        ELSE IF REG(P)~=2 THEN CALL EMITRR("18", 2, REG(P));    
                        BASES(REG(P)) = AVAIL;                                  
                        CALL FINDADDRESS (TSA);                                 
                        CALL EMITRX (LOAD, 0, 0, ADREG, ADRDISP);               
                        /* THIS IS A POINTER TO THE FIRST FREE STRING AREA*/    
                        CALL EMITRX (LA, 1, 0, 0, 4); /* 4 IS READ CARD  */     
                        CALL EMITRR (BALR, BRCHREG, IOREG); /* MONITOR CALL*/   
                        /* MOVE FREE STRING AREA POINTER */                     
                        CALL EMITRX (STORE, 1, 0, ADREG, ADRDISP);              
                        CALL FINDADDRESS (STRL);/* LAST COMPUTED STRING */      
                        CALL EMITRX (STORE, 0, 0, ADREG, ADRDISP);              
                        REG(P) = 0;                                             
                        TYPE(P) = DESCRIPT;                                     
                     END;                                                       
                  ELSE IF SD = 8 THEN                                           
                     CALL FILE_PSEUDO_ARRAY(P-2,P,0);                           
                  ELSE IF SD >= 11 & SD <= 18 THEN                              
                     DO;                                                        
                        /* TRACE, UNTRACE, EXIT, TIME, DATE, ETC.         */    
                        IF SD = 15 THEN R = 1; ELSE R = 0;                      
                        IF SD > 15 THEN                                         
                           DO;                                                  
                              IF REG(P) ~= 0 THEN                               
                                 CALL EMITRR ("18", 0, REG(P));                 
                              BASES(REG(P)) = AVAIL;                            
                              IF INX(P) ~= 2 THEN                               
                                 CALL EMITRR ("18", 2, INX(P));                 
                              BASES(INX(P)) = AVAIL;                            
                           END;                                                 
                        /* SET UP MONITOR REQUEST CODE */                       
                        CALL EMITRX(LA,1,0,0,SHL(SD-R,2)-32);                   
                        /* MONITOR CALL */                                      
                        CALL EMITRR (BALR, BRCHREG, IOREG);                     
                        TYPE(P) = ACCUMULATOR;                                  
                        IF R ~= 0 THEN                                          
                           CALL EMITRR ("18", 0, R);                            
                        REG(P) = 0;                                             
                     END;                                                       
                  ELSE CALL ERROR (' ILLEGAL USE OF ' || SYT(FIXL(P)));         
                  CALL EMITRX ("98", 1, 3, DBR, IO_SAVE);                       
               END;                                                             
            ELSE                                                                
               DO;  /* FETCH THE VARIABLE (ALL ELSE HAS FAILED) */              
                  IF SFP ~= BYTETYPE THEN                                       
                     DO;                                                        
                        IF INX(P) ~= 0 THEN                                     
                          DO;                                                   
                           IF SFP = HALFWORD THEN                               
                              CALL EMITRR ("1A", INX(P), INX(P));               
                           ELSE                                                 
                              CALL EMITRX ("89", INX(P), 0, 0, 2);              
                           /* SHIFT INDEX FOR WORD-TYPE ARRAY */                
                          R = INX(P);                                           
                          END;                                                  
                        ELSE R = FINDAC;                                        
                        IF SFP = HALFWORD THEN TP = "48";                       
                        ELSE TP = LOAD;                                         
                           CALL EMITRX(TP,R,INX(P),SYBASE(FIXL(P)),             
                        SYDISP(FIXL(P)));                                       
                     END;                                                       
                  ELSE                                                          
                     DO;                                                        
                        R = FINDAC;                                             
                        CALL EMITRR ("1B", R, R); /* CLEAR R */                 
                           CALL EMITRX("43",R,INX(P),SYBASE(FIXL(P)),           
                        SYDISP(FIXL(P)));                                       
                        /* INSERT CHARACTER */                                  
                        BASES(INX(P)) = AVAIL;                                  
                     END;                                                       
                  IF SFP = CHRTYPE THEN TYPE(P) = DESCRIPT;                     
                     ELSE TYPE(P) = ACCUMULATOR;                                
                  REG(P) = R;                                                   
               END;                                                             
         END;                                                                   
            ELSE IF TP = CONSTANT THEN                                          
               DO;                                                              
                  R = FINDAC;                                                   
                  /* FETCH A CONSTANT INTO AN ACCUMULATOR */                    
                  IF FIXV(P) = 0 THEN CALL EMITRR("1B", R, R);                  
                  ELSE IF FIXV(P) < "1000" & FIXV(P) >= 1 THEN                  
                     CALL EMITRX(LA, R, 0, 0, FIXV(P));                         
                     ELSE                                                       
                        DO;                                                     
                           CALL EMITCONSTANT (FIXV(P));                         
                           CALL EMITRX (LOAD, R, 0, ADREG, ADRDISP);            
                        END;                                                    
                  TYPE(P) = ACCUMULATOR;                                        
                  REG(P) = R;                                                   
               END;                                                             
            ELSE IF TP = CHRTYPE THEN                                           
               DO;                                                              
                  R = FINDAC;                                                   
                  TYPE(P) = DESCRIPT;                                           
                  REG(P) = R;                                                   
                  T1 = VAR(P);                                                  
                  SD = LENGTH(T1) - 1;                                          
                  IF SD < 0 THEN                                                
                     CALL EMITRR("1B",R,R); /* CLEAR  REG R, NULL STRING */     
                  ELSE                                                          
                     DO;                                                        
                        CALL FINDADDRESS (-DSP);                                
                        /* MAKE UP A DESCRIPTOR */                              
                        CALL EMITDESC(SHL(SD,24)+CHP);                          
                        DO I = 0 TO SD;                                         
                           CALL EMITCHAR(BYTE(T1, I));                          
                        END;                                                    
                        CALL EMITRX (LOAD, R, 0, ADREG, ADRDISP);               
                     END;                                                       
               END;                                                             
            ELSE IF TP ~= ACCUMULATOR THEN IF TP ~= DESCRIPT THEN               
               CALL ERROR ('FORCEACCUMULATOR FAILED ***', 1);                   
   END FORCEACCUMULATOR;                                                        
                                                                                
FORCEDESCRIPT:                                                                  
   PROCEDURE (P);                                                               
      /* GET A DESCRIPTOR FOR THE OPERAND P */                                  
      DECLARE P FIXED;                                                          
      CALL FORCEACCUMULATOR (P);                                                
      IF TYPE(P) ~= DESCRIPT THEN                                               
         DO;                                                                    
            CALL EMITRX (STORE, REG(P), 0, DBR, STRN);                          
            /* STORE IN PARAMETER LOCATION FOR NUMBER-TO -DECIMAL-STRING */     
            BASES(REG(P)) = AVAIL;                                              
            CALL CALLSUB(0,NMBRNTRY,3,P);                                       
            /* ASSUMES NUMBER-TO-STRING IS IN THE 1ST PAGE */                   
            TYPE(P) = DESCRIPT;                                                 
         END;                                                                   
   END FORCEDESCRIPT;                                                           
                                                                                
GENSTORE:                                                                       
   PROCEDURE (MP, SP);                                                          
      DECLARE (MP, SP, SFP, SB, SD) FIXED;                                      
      COUNT#STORE = COUNT#STORE + 1;                                            
      IF TYPE(SP) = SPECIAL THEN RETURN;                                        
      /* GENERATE TYPE CONVERSION (IF NECESSARY) & STORAGE CODE --              
            ALSO HANDLES OUTPUT AND FILE ON LEFT OF REPLACE OPERATOR */         
      SB = SYBASE(FIXL(MP));                                                    
      SD = SYDISP(FIXL(MP));                                                    
      SFP = SYTYPE(FIXL(MP));                                                   
      IF SFP = SPECIAL THEN                                                     
         DO;                                                                    
            IF SD = 3 THEN      /*  FUNCTION BYTE ON THE LEFT */                
               DO;                                                              
                  CALL FORCEACCUMULATOR(SP);                                    
                  CALL EMITRX("42",REG(SP),INX(MP),REG(MP),0);                  
               END;                                                             
            ELSE IF SD = 7 THEN                                                 
               DO;      /* OUTPUT   */                                          
                  CALL EMITRX("90",1,3,DBR,IO_SAVE);                            
                  TARGET_REGISTER = 0;                                          
                  CALL FORCEDESCRIPT (SP);                                      
                  TARGET_REGISTER = -1;                                         
                  IF REG(SP) ~= 0 THEN CALL EMITRR ("18", 0, REG(SP));          
                  IF REG(MP) = 0 THEN CALL EMITRR ("1B", 2, 2);                 
                  ELSE IF REG(MP) ~= 2 THEN CALL EMITRR ("18", 2, REG(MP));     
                  BASES(REG(MP)) = AVAIL;                                       
                  CALL EMITRX (LA, 1, 0, 0, 8);  /* 8 = PRINT CODE */           
                  CALL EMITRR (BALR, BRCHREG, IOREG); /* MONITOR CALL */        
                  CALL EMITRX("98",1,3,DBR,IO_SAVE);                            
               END;                                                             
            ELSE IF SD = 8 THEN                                                 
               CALL FILE_PSEUDO_ARRAY(SP,MP,4);                                 
            ELSE CALL ERROR ('ILLEGAL USE OF ' || SYT(FIXL(MP)));               
         END;                                                                   
      ELSE                                                                      
         DO;                                                                    
            CALL FORCEACCUMULATOR (SP);                                         
            IF TYPE(SP) ~= SPECIAL THEN                                         
               DO;                                                              
                  IF SFP=FIXEDTYPE & TYPE(SP)=ACCUMULATOR | SFP=CHRTYPE THEN    
                     DO;                                                        
                        IF SFP = CHRTYPE THEN CALL FORCEDESCRIPT (SP);          
                        /* SHIFT INDEX FOR WORD ARRAY */                        
                        IF INX(MP) ~= 0 THEN CALL EMITRX ("89", INX(MP),0,0,2); 
                        CALL EMITRX(STORE,REG(SP),INX(MP),SB,SD);               
                     END;                                                       
                  ELSE IF SFP = HALFWORD & TYPE(SP) = ACCUMULATOR THEN          
                     DO;                                                        
                        IF INX(MP) ~= 0 THEN CALL EMITRR ("1A",INX(MP),INX(MP));
                        CALL EMITRX ("40", REG(SP), INX(MP), SB, SD);           
                     END;                                                       
                  ELSE IF SFP = BYTETYPE & TYPE(SP) = ACCUMULATOR THEN          
                     CALL EMITRX("42",REG(SP),INX(MP),SB,SD); /* STC */         
                  ELSE CALL ERROR('ASSIGNMENT NEEDS ILLEGAL TYPE CONVERSION');  
               END;                                                             
         END;                                                                   
      BASES(INX(MP)) = AVAIL;                                                   
      BASES(REG(SP)) = AVAIL;                                                   
      CALL MOVESTACKS (SP, MP);                                                 
   END GENSTORE;                                                                
                                                                                
STRINGCOMPARE:                                                                  
   PROCEDURE;                                                                   
      /* GENERATES THE CODE TO COMPARE THE STRINGS AT SP & MP */                
      DECLARE (I, J, K) FIXED;                                                  
      CALL FORCEDESCRIPT (SP);  /* GET THE DESCRIPTOR FOR THE SECOND OPERAND */ 
      I = 6 - REG(MP) - REG(SP);  /* FIND THE THIRD REGISTER */                 
      CALL EMITRR ("18", 0, REG(MP));  /* WE CAN USE 0 FOR SCRATCH */           
      CALL EMITRR ("17", 0, REG(SP));     /* EXCL. | TO COMPARE  */             
      CALL EMITRX ("8A", 0, 0, 0, 24);  /* CHECK HIGH ORDER 8 BITS FOR ZERO */  
      IF REG(MPP1) = 6 | REG(MPP1) = 8 THEN                                     
         DO;          /* IF WE ONLY NEED TO TEST EQUALITY, CODE IS SIMPLER  */  
            K = PP;                                                             
            CALL BRANCH (6, 0);                                                 
         END;                                                                   
      ELSE                                                                      
         DO;                                                                    
            J = PP;                                                             
            CALL BRANCH (8, 0);     /*  SKIP IF EQUAL LENGTH */                 
            CALL EMITRR ("15", REG(MP), REG(SP));     /* SET CONDITION CODE  */ 
            K = PP;  /* SAVE FOR FIXUP */                                       
            CALL BRANCH ("F", 0);  /* BRANCH AROUND STRING COMPARE CODE  */     
            CALL FIXBFW (J, PP);                                                
         END;                                                                   
      IF BASES(I) ~= AVAIL THEN CALL EMITRR ("18", 0, I);  /* SAVE REG I */     
      CALL EMITRR ("18", I, REG(MP));                                           
      CALL EMITRX ("88", I, 0, 0, 24);  /* SCALE LENGTH FOR EXECUTE COMMAND  */ 
      CALL EMITDATAWORD ("D5000000" + SHL(REG(MP), 12));                        
      CALL EMITBYTE (SHL(REG(SP), 4));                                          
      CALL EMITBYTE (0);                                                        
      CALL FINDADDRESS (DP-6);                                                  
      CALL EMITRX ("44", I, 0, ADREG, ADRDISP);                                 
      IF BASES(I) ~= AVAIL THEN CALL EMITRR ("18", I, 0);/* RESTORE REG I*/     
      BASES(REG(SP)) = AVAIL;                                                   
      CALL FIXBFW (K, PP);  /* BRING OTHER BRANCH IN HERE */                    
   END STRINGCOMPARE;                                                           
                                                                                
SHOULDCOMMUTE:                                                                  
   PROCEDURE BIT(1);                                                            
      IF TYPE(SP) = VARIABLE THEN                                               
         IF SYTYPE(FIXL(SP)) = FIXEDTYPE THEN RETURN FALSE;                     
      IF TYPE(MP) = CONSTANT THEN RETURN TRUE;                                  
      IF TYPE(MP) = VARIABLE THEN                                               
         IF SYTYPE(FIXL(MP)) = FIXEDTYPE THEN RETURN TRUE;                      
      RETURN FALSE;                                                             
   END;                                                                         
                                                                                
ARITHEMIT:                                                                      
   PROCEDURE (OP);                                                              
      /* EMIT AN INSTRUCTION FOR AN INFIX OPERATOR -- CONNECTS MP & SP */       
                                                                                
      DECLARE (OP, TP, T1) FIXED;                                               
      COUNT#ARITH = COUNT#ARITH + 1;                                            
      TP = 0;  /* REMEMBER IF COMMUTED */                                       
      IF COMMUTATIVE(OP) THEN                                                   
            IF SHOULDCOMMUTE THEN                                               
               DO;                                                              
                  TP = MP; MP = SP; SP = TP;                                    
               END;                                                             
      CALL FORCEACCUMULATOR (MP);  /* GET THE LEFT ONE INTO AN ACCUMULATOR */   
      /* FIXL(SP) IS GARBAGE IF TYPE ~= VARIABLE, WE GET 0C5 IF WE TEST IT */   
      T1 = "0";                                                                 
      IF TYPE(SP) = VARIABLE THEN IF SYTYPE(FIXL(SP)) = FIXEDTYPE THEN T1 = "1";
      IF TYPE(MP) = DESCRIPT THEN                                               
         DO;                                                                    
            IF OP = CMPRR THEN CALL STRINGCOMPARE;                              
            ELSE CALL ERROR ('ARITHMETIC WITH A STRING DESCRIPTOR');            
         END;                                                                   
      ELSE IF T1 THEN                                                           
            DO;  /* OPERATE DIRECTLY FROM STORAGE  */                           
               IF INX(SP) ~= 0 THEN CALL EMITRX ("89", INX(SP), 0, 0, 2);       
               /* SHIFT TO  WORD INDEXING */                                    
               CALL EMITRX(OP+64,REG(MP),INX(SP),SYBASE(FIXL(SP)),              
                  SYDISP(FIXL(SP)));                                            
               /* REG OPCODE + 64 = RX OPCODE */                                
               BASES(INX(SP)) = AVAIL;                                          
            END;                                                                
      ELSE IF TYPE(SP) = CONSTANT THEN                                          
            DO;                                                                 
               CALL EMITCONSTANT (FIXV(SP));                                    
               CALL EMITRX (OP+64, REG(MP), 0, ADREG, ADRDISP);                 
            END;                                                                
      ELSE                                                                      
            DO;                                                                 
               CALL FORCEACCUMULATOR (SP);                                      
               IF TYPE(SP) ~= ACCUMULATOR THEN                                  
                  CALL ERROR ('ARITHMETIC BETWEEN STRING DESCRIPTORS', 1);      
               CALL EMITRR (OP, REG(MP), REG(SP));                              
               BASES(REG(SP)) = AVAIL;                                          
            END;                                                                
      IF TP ~= 0 THEN                                                           
         DO;  /* COMMUTED */                                                    
            SP = MP;  MP = TP;                                                  
            CALL MOVESTACKS (SP, MP);                                           
         END;                                                                   
         /* BY THE ALGORITHM, TYPE(MP) IS ALREADY ACCUMULATOR */                
   END ARITHEMIT;                                                               
                                                                                
BOOLBRANCH:                                                                     
   PROCEDURE (SP, MP);                                                          
      DECLARE (SP, MP, T1) FIXED;                                               
      T1 = "0";                                                                 
      IF TYPE(SP) = VARIABLE THEN IF SYTYPE(FIXL(SP)) = BYTETYPE THEN T1 = "1"; 
      /* GENERATE A CONDITIONAL BRANCH FOR A DO WHILE OR AN IF STATEMENT */     
      IF STILLCOND ~= 0 THEN                                                    
         DO;                                                                    
            BASES(REG(SP)) = AVAIL;                                             
               IF PP < "1008" THEN PP = PP - 12; ELSE PP = PP - 16;             
            IF CONTROL(BYTE('E')) THEN                                          
                  OUTPUT = X70 || '               BACK UP CODE EMITTER';        
            INSTRUCT(BC) = INSTRUCT(BC) - 1;  /* KEEP STATISTICS ACCURATE */    
            INSTRUCT(LA) = INSTRUCT(LA) - 2;                                    
            REG(SP) = STILLCOND;                                                
         END;                                                                   
      ELSE IF T1 THEN                                                           
         DO;                                                                    
            IF INX(SP) ~= 0 THEN                                                
               DO;                                                              
                  CALL EMITRR("1A",INX(SP),SYBASE(FIXL(SP)));                   
                  CALL EMITRX("91",0,1,INX(SP),SYDISP(FIXL(SP)));               
                  /*  TEST UNDER MASK  */                                       
                  BASES(INX(SP)) = AVAIL;                                       
               END;                                                             
            ELSE CALL EMITRX("91",0,1,SYBASE(FIXL(SP)),SYDISP(FIXL(SP)));       
                  /*  TEST UNDER MASK  */                                       
            REG(SP) = 8;                                                        
         END;                                                                   
      ELSE IF TYPE(SP) = CONSTANT THEN                                          
         DO;                                                                    
            IF FIXV(SP) THEN                                                    
               DO;  FIXL(MP) = 0;  RETURN; END;                                 
            ELSE REG(SP) = 15;                                                  
         END;                                                                   
      ELSE IF TYPE(SP) ~= CONDITION THEN                                        
         DO;                                                                    
            CALL FORCEACCUMULATOR (SP);                                         
            CALL EMITRX ("54", REG(SP), 0, DBR, TRUELOC);/* TEST LS BIT */      
            BASES(REG(SP)) = AVAIL;                                             
            REG(SP) = 8;                                                        
         END;                                                                   
      FIXL(MP) = PP;  /* SAVE ADDRESS FOR FUTURE FIXUP */                       
      CALL BRANCH (REG(SP), 0);  /* REG(SP) HAS THE CC TO BE TESTED FOR */      
   END BOOLBRANCH;                                                              
                                                                                
                                                                                
SET_LIMIT:                                                                      
   PROCEDURE;                                                                   
      /*  SETS DO LOOP LIMIT FOR <ITERATION CONTROL>   */                       
      IF TYPE(MPP1) = CONSTANT THEN                                             
         CALL EMITCONSTANT(FIXV(MPP1));                                         
      ELSE                                                                      
         DO;                                                                    
            CALL FORCEACCUMULATOR(MPP1);                                        
            CALL EMITDATAWORD(0);                                               
            CALL FINDADDRESS(DP-4);                                             
            CALL EMITRX(STORE,REG(MPP1),0,ADREG,ADRDISP);                       
            BASES(REG(MPP1)) = AVAIL;                                           
         END;                                                                   
      INX(MP) = ADREG;                                                          
      FIXV(MP) = ADRDISP;                                                       
   END  SET_LIMIT;                                                              
                                                                                
                                                                                
DIVIDE_CODE:                                                                    
   PROCEDURE;                                                                   
      /*  GENERATES THE CODE FOR DIVISION  */                                   
                                                                                
      TARGET_REGISTER = 0;                                                      
      CALL FORCEACCUMULATOR(MP);                                                
      TARGET_REGISTER = -1;                                                     
      IF REG(MP) ~= 0 THEN                                                      
         DO;                                                                    
            CALL EMITRR("18",0,REG(MP));         /*  LR    0,REG(MP)  */        
            BASES(REG(MP)) = AVAIL;                                             
            REG(MP) = 0;                                                        
         END;                                                                   
      IF BASES(1) = AVAIL THEN                                                  
         DO;                                                                    
            /*  MUST "SMEAR"  THE SIGN  */                                      
            CALL EMITRX("8E",0,0,0,32);          /*  SRDA  0,32       */        
            BASES(1) = ACCUMULATOR;                                             
            CALL ARITHEMIT("1D");                /*  DIVIDE  */                 
            REG(MP) = 1;                         /*  RESULT  */                 
         END;                                                                   
      ELSE                                                                      
         CALL ERROR('DIVISION OR MOD REQUIRES BUSY REGISTER',1);                
                                                                                
   END  DIVIDE_CODE;                                                            
                                                                                
                                                                                
SHIFT_CODE:                                                                     
   PROCEDURE (OP);                                                              
      /*  GENERATES CODE FOR THE BUILT IN FUNCTIONS  SHL  AND  SHR  */          
      DECLARE OP BIT (8);                                                       
      IF CNT(MP) ~= 2 THEN                                                      
         CALL ERROR('SHIFT REQUIRES TWO ARGUMENTS',0);                          
      ELSE IF TYPE(MPP1) = CONSTANT THEN                                        
         DO;                                                                    
            IF OP = "89" & FIXV(MPP1) = 1 THEN                                  
               CALL EMITRR ("1A", REG(MP), REG(MP));                            
            ELSE CALL EMITRX (OP, REG(MP), 0, 0, FIXV(MPP1));                   
         END;                                                                   
      ELSE                                                                      
         DO;                                                                    
            CALL FORCEACCUMULATOR(MPP1);                                        
            CALL EMITRX(OP, REG(MP), 0, REG(MPP1), 0);                          
            BASES(REG(MPP1)) = AVAIL;                                           
         END;                                                                   
      TYPE(MP) = ACCUMULATOR;                                                   
   END  SHIFT_CODE;                                                             
                                                                                
                                                                                
                                                                                
  /*                    BUILT-IN FUNCTIONS                              */      
                                                                                
                                                                                
REGISTER_SETUP_CODE:                                                            
   PROCEDURE;                                                                   
      CALL EMITRR("18",PBR,2);  /* SET BASE */                                  
      CALL EMITRR("18",DBR,3);                                                  
      CALL EMITRX(STORE,BRCHREG,0,DBR,RTNADR);                                  
      CALL EMITCONSTANT (256);                                                  
      CALL EMITRX ("5B", 1, 0, ADREG, ADRDISP);                                 
      LIMITWORD = DP;                                                           
      CALL EMITRX (STORE, 1, 0, DBR, DP);                                       
      CALL ENTER ('FREELIMIT', FIXEDTYPE, DP, 0);                               
      CALL EMITDATAWORD (0);                                                    
      BASEDATA = DP;                                                            
      DP = DP+16;                                                               
      CALL EMITRX ("98", 4, DBR-1, DBR, DP);  /* LOAD MULTIPLE  */              
      DO I = 4 TO DBR-1;                                                        
         CALL EMITRR("1A",I,DBR);                                               
      END;                                                                      
      DP = DP + SHL(DBR-4, 2);                                                  
   END REGISTER_SETUP_CODE;                                                     
                                                                                
RELOCATE_DESCRIPTORS_CODE:                                                      
   PROCEDURE;                                                                   
      /* EMIT CODE TO RELOCATE DESCRIPTORS TO ABSOLUTE ADDRESSES */             
                                                                                
      CALL EMITRX(LOAD,0,0,DBR,BASEDATA+8);                                     
      CALL EMITRR("1A",0,DBR);                                                  
      CALL EMITRX(STORE,0,0,DBR,TSA);                                           
      CALL EMITRX (STORE, 0, 0, DBR, DP);                                       
      CALL ENTER ('FREEBASE', FIXEDTYPE, DP, 0);                                
      CALL EMITDATAWORD (0);                                                    
      CALL EMITRX("91",0,1,DBR,BASEDATA+12);                                    
      K = PP;                                                                   
      CALL BRANCH (1, 0);                                                       
      CALL EMITRX("96",0,1,DBR,BASEDATA+12);                                    
      CALL EMITRX(LOAD,1,0,DBR,BASEDATA);                                       
      CALL EMITRX (LA,SBR,1,DBR,0);                                             
      CALL EMITRX(LOAD,2,0,DBR,BASEDATA+4);                                     
      CALL EMITRR ("1A",2,DBR);                                                 
      J = PP;                             /* SAVE DESTINATION FOR LOOP */       
      CALL EMITRX (LOAD,3,1,DBR,0);                                             
      CALL EMITRR ("12",3,3);                                                   
      CALL BRANCH (8,PP+10);              /* ESCAPE */                          
      CALL EMITRR ("1A",3,2);                                                   
      CALL EMITRX (STORE,3,1,DBR,0);                                            
      CALL EMITRX (LA,1,0,1,4);                                                 
      CALL EMITRX(CMPR,1,0,DBR,BASEDATA+4);                                     
      CALL BRANCH (4,J);                  /* LOOP */                            
      CALL FIXBFW (K,PP);                                                       
      CALL BRANCH (15,0);      /*  JUMP TO FIRST COMPILED CODE */               
   END RELOCATE_DESCRIPTORS_CODE;                                               
                                                                                
CATENATE_CODE:                                                                  
   PROCEDURE;                                                                   
      /* BUILD A CATENATE SUBROUTINE  */                                        
                                                                                
      CATENTRY = PP;                                                            
      CALL CHECK_STRING_OVERFLOW;                                               
      CALL EMITRX (LOAD,1,0,A1,A2);  /*  LOAD FIRST DESCRIPTOR */               
      CALL EMITRR ("18", 3, 1);  /* COPY INTO REG(3)  */                        
      CALL EMITRX ("5E", 3, 0, B1, B2);  /* COMBINE DESCRIPTORS  */             
      CALL EMITRR ("12", 1, 1);  /* TEST FOR NULL FIRST OPERAND  */             
      CALL EMITRR (BCR, 8, BRCHREG);  /* RETURN WITH RESULT IN REG(3)  */       
      CALL EMITRR (CMPRR, 3, 1);  /* IS SECOND OPERAND NULL?  */                
      CALL EMITRR (BCR, 8, BRCHREG);  /* RETURN WITH RESULT IN REG(3)  */       
      CALL FINDADDRESS (MASKF000);                                              
      CALL EMITRX ("54", 3, 0, ADREG, ADRDISP);  /* MASK OUT ADDRESS  */        
      CALL EMITRX ("5E", 3, 0, DBR, CATCONST);  /* CORRECT LENGTH OF RESULT  */ 
      CALL FINDADDRESS (MOVER);  /* FIND MOVE INSTRUCTION */                    
      T1 = ADREG;  T2 = ADRDISP;                                                
      CALL EMITRR ("18", 0, 3);  /* SAVE LENGTH IN REG(0)  */                   
      CALL FINDADDRESS (TSA);  /* FIND CURRENT TOP OF STR AREA  */              
      CALL EMITRX (LOAD,2,0,ADREG,ADRDISP);                                     
      CALL FINDADDRESS (STRL);  /* LAST STRING MADE IN STRING AREA */           
      CALL EMITRX (CMPR, 1, 0, ADREG, ADRDISP); /* SKIP MOVE IF AT TOP */       
      J = PP;                                                                   
      CALL BRANCH (6, 0);       /* FAKE MOVE */                                 
      CALL EMITRX (LA, 1, 0, 1, 0);                                             
      CALL EMITRR ("16", 0, 1);                                                 
      K = PP;                                                                   
      CALL BRANCH ("F", 0);                                                     
      CALL FIXBFW (J, PP);                                                      
      CALL EMITRR ("16",0,2);  /* OR IN CORRECT ADDRESS */                      
      CALL EMITRX ("43",3,0,A1,A2);  /* INSERT LENGTH FIELD */                  
      CALL EMITRX ("44",3,0,T1,T2);   /* EXECUTE THE MOVE */                    
      CALL EMITRX ("41",2,3,2,1);  /* UPDATE TSA */                             
      CALL FIXBFW (K, PP);                                                      
      CALL EMITRX (LOAD,1,0,B1,B2);  /* LOAD SECOND DESCRIPTOR */               
      CALL EMITRX ("43", 3,0,B1,B2);  /* INSERT LENGTH FIELD  */                
      CALL EMITRX ("44",3,0,T1,T2);  /* EXECUTE THE MOVE */                     
      CALL EMITRX ("41",2,3,2,1);   /*  UPDATE TSA  */                          
      CALL EMITRX (STORE, 0, 0, ADREG, ADRDISP);  /* STORE INTO STRL */         
      CALL FINDADDRESS (TSA);                                                   
      CALL EMITRX (STORE,2,0,ADREG,ADRDISP);   /* SAVE TOP OF STR. A.  */       
      CALL EMITRR ("18", 3, 0);  /* RESULT TO REG(3)  */                        
      CALL EMITRR (BCR, 15, BRCHREG);  /* RETURN  */                            
   END CATENATE_CODE;                                                           
                                                                                
CONVERT_CODE:                                                                   
   PROCEDURE;                                                                   
      /*  THE NUMBER-TO-STRING CONVERSION SUBROUTINE */                         
                                                                                
      NMBRNTRY = PP;                                                            
      CALL CHECK_STRING_OVERFLOW;         /* CALL COMPACTIFY */                 
      CALL EMITRX (LOAD, 3,0, DBR, STRN);                                       
      CALL EMITRR ("10",3,3);             /* SET POSITIVE FOR CONVERT */        
      CALL EMITRX (LOAD, 1,0,DBR,TSA);    /* FREE SOME STRING AREA */           
      CALL EMITRX  (LA,1,0,1,11);         /* 11 IS THE MAXIMUM NUMBER OF DIGITS 
                                             IN A CONVERTED 32 BIT INTEGER */   
      CALL EMITRX (STORE,1,0,DBR,TSA);                                          
      CALL EMITRX (LA,0,0,0,10);          /* BASE 10 FOR DIVISION */            
      I = PP;                                                                   
      CALL EMITRR ("06",1,0);             /* COUNT THE DIGIT */                 
      CALL EMITRR ("1B",2,2);             /* CLEAR REGISTER 2 */                
      CALL EMITRR ("1D",2,0);             /* DIVIDE BY 10 */                    
      CALL EMITRX (LA,2,0,2,"F0");        /* ADD IN THE EBCDIC CODE */          
      CALL EMITRX ("42",2,0,1,0);                                               
      CALL EMITRR ("12",3,3);             /* TEST FOR ZERO */                   
      CALL BRANCH (6,I);                  /* GET NEXT DIGIT */                  
      CALL EMITRX (LOAD,3,0,DBR,STRN);                                          
      CALL EMITRR ("12",3,3);             /* TEST FOR NEGATIVE */               
      I = PP;                                                                   
      CALL BRANCH (10,0);                                                       
      CALL EMITRX (LA,2,0,0,"60");        /* "60" = '-' */                      
      CALL EMITRR ("06",1,0);                                                   
      CALL EMITRX ("42",2,0,1,0);                                               
      CALL FIXBFW (I,PP);                                                       
      CALL EMITRX (LOAD,3,0,DBR,TSA);     /* MAKE UP RESULT DESCRIPTOR */       
      CALL EMITRR ("1B",3,1);                                                   
      CALL EMITRR ("06",3,0);                                                   
      CALL EMITRX ("89",3,0,0,24);        /* SHIFT LENGTH FIELD LEFT */         
      CALL EMITRR ("1A",3,1);             /* ADD IN ADDRESS */                  
      CALL FINDADDRESS (STRL);            /* UPDATE POINTER TO NEWEST STRING */ 
      CALL EMITRX (STORE, 3, 0, ADREG, ADRDISP);                                
      CALL EMITRR (BCR,15,BRCHREG);       /* RETURN */                          
      CALL FIXBFW (CATENTRY-4, PP);                                             
   END CONVERT_CODE;                                                            
                                                                                
                                                                                
  /*                       TIME AND DATE                                 */     
                                                                                
                                                                                
PRINT_TIME:                                                                     
   PROCEDURE (MESSAGE, T);                                                      
      DECLARE MESSAGE CHARACTER, T FIXED;                                       
      MESSAGE = MESSAGE || T/360000 || ':' || T MOD 360000 / 6000 || ':'        
         || T MOD 6000 / 100 || '.';                                            
      T = T MOD 100;  /* DECIMAL FRACTION  */                                   
      IF T<10 THEN MESSAGE= MESSAGE || '0';                                     
      OUTPUT = MESSAGE || T || '.';                                             
   END PRINT_TIME;                                                              
                                                                                
PRINT_DATE_AND_TIME:                                                            
   PROCEDURE (MESSAGE, D, T);                                                   
      DECLARE MESSAGE CHARACTER, (D, T, YEAR, DAY, M) FIXED;                    
      DECLARE MONTH(11) CHARACTER INITIAL ('JANUARY', 'FEBRUARY', 'MARCH',      
         'APRIL', 'MAY', 'JUNE', 'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER',      
         'NOVEMBER', 'DECEMBER'),                                               
      DAYS(12) FIXED INITIAL (0, 31, 60, 91, 121, 152, 182, 213, 244, 274,      
         305, 335, 366);                                                        
      YEAR = D/1000 + 1900;                                                     
      DAY = D MOD 1000;                                                         
      IF (YEAR & "3") ~= 0 THEN IF DAY > 59 THEN DAY = DAY + 1; /* ~ LEAP YEAR*/
      M = 1;                                                                    
      DO WHILE DAY > DAYS(M);  M = M + 1;  END;                                 
      CALL PRINT_TIME(MESSAGE || MONTH(M-1) || X1 || DAY-DAYS(M-1) ||  ', '     
         || YEAR || '.  CLOCK TIME = ', T);                                     
   END PRINT_DATE_AND_TIME;                                                     
                                                                                
  /*                       INITIALIZATION                                     */
                                                                                
                                                                                
                                                                                
INITIALIZATION:                                                                 
   PROCEDURE;                                                                   
                                                                                
SET_ALPHANUMERIC:                                                               
   PROCEDURE (J);                                                               
      DECLARE (J, TEMP, M) FIXED;                                               
      TEMP = ALPHATABLE(J/4);                                                   
      M = SHL (J&3, 3);   /*  8*(J MOD 4)  */                                   
      TEMP = (SHR ("00FFFFFF", M) | SHL ("FFFFFF00", 24-M)) & TEMP;             
      ALPHATABLE(J/4) = TEMP;                                                   
   END;                                                                         
                                                                                
      EJECT_PAGE;                                                               
  CALL PRINT_DATE_AND_TIME (' XPL COMPILATION---SUNY STONYBROOK---XCOM4.5 VERSIO
N OF  ',DATE_OF_GENERATION, TIME_OF_GENERATION);                                
      DOUBLE_SPACE;                                                             
      CALL PRINT_DATE_AND_TIME ('TODAY IS ', DATE, TIME);                       
      DOUBLE_SPACE;                                                             
                                                                                
      /* INITIALIZE THE CHARACTER TRANSLATION TABLES */                         
      DO I = 0 TO 63;                                                           
         ALPHATABLE(I) = "FFFFFFFF";                                            
         END;                                                                   
      DO I = 0 TO 63;                                                           
         BLANKTABLE(I) = "FFFFFFFF";                                            
         END;                                                                   
      BLANKTABLE(16) = "00FFFFFF";                                              
      DO I = 0 TO 63;                                                           
         COMMENTABLE(I) = 0;                                                    
         END;                                                                   
      DO I = 0 TO 1;                                                            
         J = BYTE('*$', I);                                                     
         COMMENTABLE (SHR(J, 2)) = SHR("FF000000", SHL(J&3, 3)) |               
                                   COMMENTABLE (SHR(J, 2));                     
         END;                                                                   
      DO I = 0 TO 63;                                                           
         STRINGTABLE(I) = 0;                                                    
         END;                                                                   
      J = BYTE(QUOTE);                                                          
      STRINGTABLE (SHR(J, 2)) = SHR ("FF000000", SHL(J&3, 3));                  
                                                                                
      DO I = 1 TO NT;                                                           
         S = V(I);                                                              
         IF S = '<NUMBER>' THEN NUMBER = I;  ELSE                               
         IF S = '<IDENTIFIER>' THEN IDENT = I;  ELSE                            
         IF S = '<STRING>' THEN STRING = I;  ELSE                               
         IF S = '/' THEN DIVIDE = I;  ELSE                                      
         IF S = 'EOF' THEN EOFILE = I;  ELSE                                    
         IF S = 'DECLARE' THEN STOPIT(I) = TRUE;  ELSE                          
         IF S = 'PROCEDURE' THEN STOPIT(I) = TRUE;  ELSE                        
         IF S = 'END' THEN STOPIT(I) = TRUE;  ELSE                              
         IF S = 'DO' THEN STOPIT(I) = TRUE;  ELSE                               
         IF S = ';' THEN STOPIT(I) = TRUE;  ELSE                                
         IF S = '|' THEN ORSYMBOL = I; ELSE                                     
         IF S = '||' THEN CONCATENATE = I; ELSE                                 
         ;                                                                      
      END;                                                                      
       DO  I= NT+1 TO NSY;                                                      
          S=V(I);                                                               
          IF S='<PROCEDURE HEAD>' THEN PROCHEAD=I; ELSE                         
      IF S='<GROUP HEAD>' THEN GROUPHEAD=I;                                     
       END;                                                                     
      IF IDENT = NT THEN RESERVED_LIMIT = LENGTH(V(NT-1));                      
      ELSE RESERVED_LIMIT = LENGTH(V(NT));                                      
      STOPIT(EOFILE) = TRUE;                                                    
      CHARTYPE(BYTE(' ')) = 1;                                                  
      CHARTYPE(BYTE('''')) = 2;                                                 
      CHARTYPE(BYTE('"')) = 3;                                                  
      DO I = 0 TO LENGTH(ALPHABET) - 1;                                         
         J = BYTE(ALPHABET, I);                                                 
         TX(J) = I;                                                             
         CHARTYPE(J) = 4;                                                       
         CALL SET_ALPHANUMERIC (J);                                             
      END;                                                                      
      DO I = 0 TO 9;                                                            
         J = BYTE('0123456789', I);                                             
         CHARTYPE(J) = 5;                                                       
         CALL SET_ALPHANUMERIC (J);                                             
      END;                                                                      
      DO I = VT_INDEX(1) TO VT_INDEX(2) - 1;                                    
         J = BYTE(V(I));                                                        
         TX(J) = I;                                                             
         CHARTYPE(J) = 7;                                                       
      END;                                                                      
      CHARTYPE(BYTE('|')) = 8;                                                  
      CHARTYPE(BYTE('/')) = 6;                                                  
      COMMUTATIVE("14") = TRUE;                                                 
      COMMUTATIVE("16") = TRUE;                                                 
      COMMUTATIVE("1A") = TRUE;                                                 
      RETURNED_TYPE = FIXEDTYPE;          /* DEFAULT RETURN TYPE */             
                                                                                
      LASTBASE = DBR;  BASES(LASTBASE) = 0;                                     
      /*              INITIALIZE SYMBOL TABLE VARIABLES */                      
      PP = 60;   /*  OFFSET  CODE  FOR  CONTROL  RECORD (SEE LOADER) */         
      DP = 0;    /*  DATA ORIGIN  */                                            
      DSP = 4;                                                                  
      CHP = 1;                                                                  
      PPLIM, DPLIM, CHPLIM = DISKBYTES;                                         
         /* UPPER BOUND FOR EMITTER ARRAYS */                                   
      PPORG, DPORG, CHPORG = 0;                                                 
         /* LOWER BOUND FOR EMITTER ARRAYS */                                   
      CURCBLK, CURDBLK, CURSBLK = 0;                                            
         /* CURRENT BLOCK OCCUPYING EMITTER ARRAYS */                           
      SHORTCFIX, SHORTDFIX, LONGCFIX, LONGDFIX = 0;                             
         /* STATISTICAL COUNTERS FOR FIXUPS */                                  
      FCP = 0;  /* POINTER INTO FIXUP ARRAY */                                  
      NDECSY ,PROCMARK = 1;   PARCT = 0;                                        
      /* INTEGERS FOR BRANCH ADDRESSING */                                      
      DO I = 0 TO PROGRAMSIZE;  CALL EMITDATAWORD(SHL(I,12)); END;              
                                                                                
      /*  WARNING, THE FOLLOWING SECTION OF INITIALIZE DEPENDS ON               
          THE INITIALIZATION OF THE BUILTIN FUNCTION AND PSEUDO                 
          VARIABLE NAMES AND ATTRIBUTES IN THE SYMBOL TABLE ARRAYS.             
      */                                                                        
                                                                                
      SYDISP(2) = DP;                     /*  MONITOR_LINK               */     
      DP = DP + 16;  /* RESERVE 4 WORDS FOR COMMUNICATION WITH MONITOR  */      
      MASKF000 = DP;  CALL EMITDATAWORD("FF000000");                            
      IO_SAVE = DP;  DP = DP + 12;  /* REGISTER SAVE FOR INPUT/OUTPUT  */       
                                                                                
      /*  SET UP THE MOVE TEMPLATE IN DATA AREA */                              
                                                                                
      MOVER = DP;                                                               
      CALL EMITBYTE("D2");  /* MVC */                                           
      CALL EMITBYTE(0);                                                         
      CALL EMITBYTE("20");                                                      
      CALL EMITBYTE(0);                                                         
      CALL EMITBYTE("10");                                                      
      CALL EMITBYTE(0);                                                         
      CALL EMITDATAWORD(0);  TSA = DP-4;                                        
      SYDISP(3) = DP;                     /*  TIME_OF_GENERATION         */     
      CALL EMITDATAWORD(TIME);                                                  
      SYDISP(4) =  DP;                    /*  DATE_OF_GENERATION         */     
      CALL EMITDATAWORD(DATE);                                                  
      SYDISP(5) = 0;                      /*  COREWORD                   */     
      SYDISP(6) = 0;                      /*  COREBYTE                   */     
      SYDISP(7) = TSA;                    /*  FREEPOINT                  */     
      SYDISP(8) = DSP;                    /*  DESCRIPTOR                 */     
      SYDISP(9) = DP;                     /*  NDESCRIPT                  */     
      DESCL = DP;                                                               
      CALL EMITDATAWORD (0);                                                    
      A1, B1 = SBR;  /* A1,A2 IS THE FIRST PARAMETER TO ||, */                  
      A2 = DSP;       /* B1,B2 IS THE SECOND */                                 
      CALL EMITDESC (0);                                                        
      B2 = DSP;                                                                 
      CALL EMITDESC (0);                                                        
      STRL = -DSP;  CALL EMITDESC(0);                                           
      STRN = DP; CALL EMITDATAWORD(0);                                          
      TRUELOC = DP; CALL EMITDATAWORD(TRUE);                                    
      COMPLOC = DP; CALL EMITDATAWORD("FFFFFFFF");                              
      CATCONST = DP; CALL EMITDATAWORD ("1000000");                             
      RTNADR = DP; CALL EMITDATAWORD (0);                                       
                                                                                
      DO I = 0 TO 255;                                                          
         BUCKET(I) = NULL;                                                      
         END;                                                                   
      DO I = 0 TO SYTSIZE;                                                      
         SY_LINK(I) = NULL;                                                     
         END;                                                                   
      LEX_LEVEL, PROCEDURE_NUMBER = 1;                                          
      IDCOMPARES = 0;                                                           
      DO NDECSY = 2 TO N_PREDECLARED_SYMB;                                      
         S = SYT(NDECSY);                                                       
         I = LENGTH(S) -1;                                                      
         I =(BYTE(S) + BYTE(S, I) + I) & "FF";                                  
         IF BUCKET(I) = NULL THEN BUCKET(I) = NDECSY;                           
         ELSE DO;                                                               
            I = BUCKET(I);                                                      
            DO WHILE SY_LINK(I) ~= NULL;                                        
               I = SY_LINK(I);                                                  
               END;                                                             
            SY_LINK(I) = NDECSY;                                                
            END;                                                                
         END;                                                                   
      NDECSY = N_PREDECLARED_SYMB;                                              
                                                                                
      CALL EMITDATAWORD (0);                                                    
      SYDISP(NDECSY) = DP-4;            /*  COMPACTIFY                 */       
      STRING_RECOVER = NDECSY;                                                  
      CALL CLEARREGS;                                                           
                                                                                
                                                                                
      /*         EMIT CODE FOR BUILT_IN FUNCTIONS                        */     
                                                                                
      CALL REGISTER_SETUP_CODE;                                                 
                                                                                
      CALL RELOCATE_DESCRIPTORS_CODE;                                           
                                                                                
      CALL CATENATE_CODE;                                                       
                                                                                
      CALL CONVERT_CODE;                                                        
                                                                                
      MAINLOC = PP;                                                             
      CALL CLEARREGS;                                                           
      /* FIRST SET UP GLOBAL VARIABLES CONTROLLING SCAN, THEN CALL IT */        
      CP = 0;  TEXT_LIMIT = -1;                                                 
      TEXT, CURRENT_PROCEDURE = '';                                             
 STATE#,STATE_STACK(0)=STARTSTATE ; /*INITIALIZE STATE STACK WITH START STATE*/ 
    RECOV = FALSE ;   NEXT = 0;                                                 
 SP=0;  /* INITIALIZE TOP OF STATE STACK POINTER */                             
      CALL SCAN;                                                                
 COMPILING=TRUE;   /* YOU CAN ABORT COMPILATION BY SETTING FALSE */             
   END INITIALIZATION;                                                          
                                                                                
                                                                                
                                                                                
  /*               SYMBOL AND STATISTICS PRINTOUT                         */    
                                                                                
                                                                                
SYMBOLDUMP:                                                                     
   PROCEDURE;                                                                   
      /* LISTS THE SYMBOLS IN THE PROCEDURE THAT HAS JUST BEEN                  
         COMPILED IF $S OR $D IS ENABLED                                        
         MAINTAIN PARITY ON $D AND $S                                           
      */                                                                        
      DECLARE (LPM, I, J, K, L, M) FIXED;                                       
      DECLARE (BUFFER, BLANKS) CHARACTER;                                       
      DECLARE EXCHANGES BIT(1), SYTSORT(SYTSIZE) BIT(16);                       
                                                                                
      OUTLINE:                                                                  
         PROCEDURE (NAME, P) CHARACTER;                                         
            DECLARE NAME CHARACTER, (P, B, D) FIXED;                            
            IF SYTYPE(P) = LABELTYPE | SYTYPE(P) = CHAR_PROC_TYPE THEN          
               DO;                                                              
                  B = PBR;                                                      
                  D = SHL(SYBASE(P), 12) + SYDISP(P);                           
               END;                                                             
            ELSE                                                                
               DO;                                                              
                  B = SYBASE(P);                                                
                  D = SYDISP(P);                                                
               END;                                                             
                                                                                
            BUFFER = PAD (D || '(' || B || '),', 11);                           
            RETURN NAME || ': ' || TYPENAME(SYTYPE(P)) || ' AT ' || BUFFER ||   
               ' DECLARED ON LINE ' || DECLARED_ON_LINE(P) ||                   
               ' AND REFERENCED ' || SYTCO(P) || ' TIMES.';                     
         END  OUTLINE;                                                          
                                                                                
   BUCKET_CHAIN_STATISTICS:                                                     
      PROCEDURE;                                                                
         DECLARE (NUMBER_FULL, MAXCHAIN, CHAIN_LENGTH, SY_PTR, I) FIXED;        
         NUMBER_FULL, MAXCHAIN = 0;                                             
         DO I = 0 TO 255;                                                       
            IF BUCKET(I) ~= NULL THEN DO;                                       
               CHAIN_LENGTH = 1;  SY_PTR = BUCKET(I);                           
               NUMBER_FULL = NUMBER_FULL + 1;                                   
               DO WHILE SY_LINK(SY_PTR) ~= NULL;                                
                  CHAIN_LENGTH = CHAIN_LENGTH + 1;                              
                  SY_PTR = SY_LINK(SY_PTR);                                     
                  END;                                                          
               IF CHAIN_LENGTH > MAXCHAIN THEN                                  
                  MAXCHAIN = CHAIN_LENGTH;                                      
               END;                                                             
            END;                                                                
         DOUBLE_SPACE;                                                          
         OUTPUT = 'THE SYMBOL TABLE PRESENTLY CONTAINS ' ||NDECSY|| ' SYMBOLS'; 
         OUTPUT = NUMBER_FULL || ' OF THE 255 HASH BUCKETS ARE OCCUPIED';       
         OUTPUT = 'THE MAXIMUM BUCKET CHAIN LENGTH IS ' || MAXCHAIN;            
      END BUCKET_CHAIN_STATISTICS;                                              
                                                                                
                                                                                
      IF PROCMARK <= NDECSY THEN                                                
         DO;                                                                    
            DOUBLE_SPACE;                                                       
            OUTPUT = 'SYMBOL  TABLE  DUMP';                                     
            DOUBLE_SPACE;                                                       
            LPM = LENGTH(SYT(PROCMARK));                                        
            L = 15;                                                             
            DO I = PROCMARK TO NDECSY;                                          
               IF LENGTH(SYT(I)) > L THEN                                       
                  L = LENGTH(SYT(I));                                           
            END;                                                                
            IF L > 70 THEN L = 70;                                              
            BLANKS = SUBSTR(X70, 0, L);                                         
            DO I = PROCMARK TO NDECSY;                                          
               SYTSORT(I) = I;                                                  
               K = LENGTH(SYT(I));                                              
               IF K > 0 THEN                                                    
                  IF K < L THEN                                                 
                     DO;                                                        
                        BUFFER = SUBSTR(BLANKS,K);                              
                        SYT(I) = SYT(I) || BUFFER;                              
                     END;                                                       
                  ELSE                                                          
                     DO;                                                        
                        BUFFER = SUBSTR (SYT(I), 0, L);                         
                        SYT(I) = BUFFER;                                        
                     END;                                                       
            END;                                                                
                                                                                
            EXCHANGES = TRUE;                                                   
            K = NDECSY - PROCMARK;                                              
                                                                                
            DO WHILE EXCHANGES;                                                 
               EXCHANGES = FALSE;                                               
               DO J = 0 TO K - 1;                                               
                  I = NDECSY - J;                                               
                  L = I - 1;                                                    
                  IF SYT(SYTSORT(L)) > SYT(SYTSORT(I)) THEN                     
                     DO;                                                        
                        M = SYTSORT(I);                                         
                        SYTSORT(I) = SYTSORT(L);                                
                        SYTSORT(L) = M;                                         
                        EXCHANGES = TRUE;                                       
                        K = J;         /* RECORD LAST SWAP */                   
                     END;                                                       
               END;                                                             
            END;                                                                
                                                                                
            I = PROCMARK;                                                       
            DO WHILE LENGTH(SYT(SYTSORT(I))) = 0;                               
               I = I + 1;              /* IGNORE NULL NAMES */                  
            END;                                                                
                                                                                
            DO I = I TO NDECSY;                                                 
               K = SYTSORT(I);                                                  
               OUTPUT = OUTLINE(SYT(K), K);                                     
                                                                                
               K = K + 1;                                                       
               DO WHILE (LENGTH(SYT(K)) = 0) & (K <= NDECSY);                   
                  J = K - SYTSORT(I);                                           
                  OUTPUT =                                                      
                     OUTLINE('  PARAMETER  ' || J || SUBSTR(BLANKS, 14), K);    
                  K = K + 1;                                                    
               END;                                                             
                                                                                
            END;                                                                
                                                                                
            CALL BUCKET_CHAIN_STATISTICS;                                       
                                                                                
            BUFFER = SUBSTR(SYT(PROCMARK), 0 , LPM);                            
            SYT(PROCMARK) = BUFFER;                                             
            EJECT_PAGE;                                                         
         END;                                                                   
                                                                                
   END  SYMBOLDUMP;                                                             
                                                                                
                                                                                
                                                                                
DUMPIT:                                                                         
   PROCEDURE;    /* DUMP OUT THE COMPILED CODE & DATA AREAS  */                 
      CALL SYMBOLDUMP;                                                          
      OUTPUT = 'MACRO DEFINITIONS:';                                            
      DOUBLE_SPACE;                                                             
      DO I = 0 TO TOP_MACRO;                                                    
         OUTPUT = PAD(MACRO_NAME(I), 20) || ' LITERALLY: ' || MACRO_TEXT(I);    
      END;                                                                      
      DOUBLE_SPACE;                                                             
      /*  PUT OUT THE ENTRY COUNT FOR IMPORTANT PROCEDURES */                   
                                                                                
      OUTPUT = 'IDCOMPARES        = ' || IDCOMPARES;                            
      OUTPUT = 'SYMBOL TABLE SIZE = ' || MAXNDECSY;                             
      OUTPUT = 'MACRO DEFINITIONS = ' || TOP_MACRO + 1;                         
      OUTPUT = 'PRODUCTIONS APPLIED ' || COUNT#STACK;                           
      OUTPUT = 'SCAN              = ' || COUNT#SCAN;                            
      OUTPUT = 'EMITRR            = ' || COUNT#RR;                              
      OUTPUT = 'EMITRX            = ' || COUNT#RX;                              
      OUTPUT = 'FORCEACCUMULATOR  = ' || COUNT#FORCE;                           
      OUTPUT = 'ARITHEMIT         = ' || COUNT#ARITH;                           
      OUTPUT = 'GENSTORE          = ' || COUNT#STORE;                           
      OUTPUT = 'FIXBFW            = ' || COUNT#FIXBFW;                          
      OUTPUT = 'FIXDATAWORD       = ' || COUNT#FIXD;                            
      OUTPUT = 'FIXCHW            = ' || COUNT#FIXCHW;                          
      OUTPUT = 'GETDATA           = ' || COUNT#GETD;                            
      OUTPUT = 'GETCODE           = ' || COUNT#GETC;                            
      OUTPUT = 'FINDADDRESS       = ' || COUNT#FIND;                            
      OUTPUT = 'SHORTCFIX         = ' || SHORTCFIX;                             
      OUTPUT = 'LONGCFIX          = ' || LONGCFIX;                              
      OUTPUT = 'SHORTDFIX         = ' || SHORTDFIX;                             
      OUTPUT = 'LONGDFIX          = ' || LONGDFIX;                              
      OUTPUT = 'FREE STRING AREA  = ' || FREELIMIT - FREEBASE;                  
      DOUBLE_SPACE;                                                             
      OUTPUT = 'REGISTER VALUES (RELATIVE TO R11):';                            
      DO I = 4 TO 13;                                                           
         OUTPUT = 'R' || I || ' = ' || BASES(I);                                
      END;                                                                      
                                                                                
      OUTPUT = ''; OUTPUT = ' INSTRUCTION FREQUENCIES:';                        
      OUTPUT = '';                                                              
      DO I = 0 TO 255;                                                          
         IF INSTRUCT(I) ~ = 0 THEN                                              
             OUTPUT = SUBSTR(OPNAMES,OPER(I),4) || X4 || INSTRUCT(I);           
      END;                                                                      
   END DUMPIT;                                                                  
                                                                                
                                                                                
DUMP:                                                                           
   PROCEDURE;                                                                   
      DECLARE LINE CHARACTER, J FIXED;                                          
      LINE = 'PARTIAL PARSE TO THIS POINT IS: ';                                
      IF SP > 0 THEN DO J = 1 TO SP;                                            
         IF LENGTH(LINE) > 110 THEN DO;                                         
            OUTPUT = LINE;  LINE = X4;                                          
         END;                                                                   
         LINE = LINE || X1 || V(STATETOKEN(STATE_STACK(J)));                    
      END;                                                                      
      OUTPUT = LINE;                                                            
   END DUMP;                                                                    
                                                                                
                                                                                
TRANS: PROCEDURE(I,J,K) BIT(1) ;                                                
  /*  SET NEWSTATE TO TRANSITION (IF ANY) FROM STATE I UNDER TOKEN J            
       IF NO TRANSITION , RETURN FALSE;     */                                  
DECLARE (I,J,K,A) BIT(16);                                                      
 DO A= I TO J BY 2 ;                                                            
      IF SCANTOKENS(A) >= K THEN IF SCANTOKENS(A) = K THEN DO ;                 
           NEWSTATE= SCANGOTOS(A);                                              
           RETURN TRUE;                                                         
      END;                                                                      
      ELSE IF SCANTOKENS(A-1) = K THEN DO ;                                     
           NEWSTATE = SCANGOTOS(A-1) ;                                          
           RETURN TRUE ;                                                        
           END ;                                                                
      ELSE RETURN FALSE ;                                                       
 END;                                                                           
 IF SCANTOKENS(J) = K THEN DO ;                                                 
      NEWSTATE = SCANGOTOS(J) ;                                                 
      RETURN TRUE ;                                                             
      END ;                                                                     
 RETURN FALSE;                                                                  
END TRANS;                                                                      
                                                                                
FIXIT: PROCEDURE BIT(1);                                                        
 DECLARE T CHARACTER;                                                           
 CALL ID_LOOKUP(SP);                                                            
 IF FIXL(SP)= -1 THEN RETURN FALSE;                                             
 T=VAR(SP);     /* THE END NAME  */                                             
 SEVERE_ERRORS=SEVERE_ERRORS +1;                                                
 S= SUBSTR( CURRENT_PROCEDURE,1);                                               
 DO I= 0 TO MP-1;                                                               
    J=MP-I;                                                                     
    IF STATETOKEN(STATE_STACK(J))= PROCHEAD THEN DO;                            
       IF T=S THEN DO;                                                          
          MP=J+2;                                                               
          STATE_STACK(MP)=31;  /* SET UP A PROCEDURE DEF PRODUCTION */          
          CURRENT_PROCEDURE= X1 || S;                                           
          VAR(MP)=T;                                                            
          OUTPUT= '***ASSUMED END OF PROCEDURE ' || T;                          
          RETURN TRUE;                                                          
       END;                                                                     
       ELSE S=SUBSTR(VAR(J),1);                                                 
    END;   /* OF DO PROCEDURE MATCH */                                          
    ELSE IF J>1 & STATETOKEN(STATE_STACK(J)) = GROUPHEAD THEN                   
    IF T= VAR(J-1) & STATETOKEN(STATE_STACK(J-1)) ~= PROCHEAD THEN DO ;         
       MP=J+1;                                                                  
       STATE_STACK(MP)=20;                                                      
       VAR(MP)=T;                                                               
       OUTPUT='***ASSUMED END OF GROUP ' || T;                                  
       RETURN TRUE;                                                             
    END;   /* OF GROUP MATCH  */                                                
 END;  /* OF STACK SEARCH */                                                    
 SP=SP-1;   /* EXTRA END CAUSED PREMATURE POP OF HEAD */                        
 OUTPUT='***EXTRA "END" DETECTED ';                                             
 RETURN TRUE;                                                                   
END FIXIT;                                                                      
                                                                                
                                                                                
  /*                  THE SYNTHESIS ALGORITHM FOR XPL                      */   
                                                                                
SYNTHESIZE:                                                                     
PROCEDURE(PRODUCTION_NUMBER);                                                   
   DECLARE PRODUCTION_NUMBER FIXED;                                             
                                                                                
   /*  ONE STATEMENT FOR EACH PRODUCTION OF THE GRAMMAR*/                       
                                                                                
                                                                                
DO CASE PRODUCTION_NUMBER;                                                      
   ;      /*  CASE 0 IS A DUMMY, BECAUSE WE NUMBER PRODUCTIONS FROM 1  */       
                                                                                
 /*  <PROGRAM>  ::=  <STATEMENT LIST>    */                                     
   DO;   /* FINAL CODE FOR XPLSM INTERFACE & SETUP  */                          
      IF MP ~= 1 THEN  /* WE DIDN'T GET HERE LEGITEMATELY */                    
         DO;                                                                    
            CALL ERROR ('EOF AT INVALID POINT', 1);                             
            CALL DUMP;                                                          
         END;                                                                   
      DO I = 1 TO NDECSY;                                                       
         IF SYTYPE(I) = FORWARDTYPE | SYTYPE(I) = FORWARDCALL THEN              
          IF SYTCO(I) > 0 THEN                                                  
            CALL ERROR ('UNDEFINED LABEL OR PROCEDURE: ' || SYT(I), 1);         
      END;                                                                      
      CALL EMITRR ("1B", 3, 3);  /* RETURN CODE OF ZERO  */                     
      CALL EMITRX(LOAD, BRCHREG, 0, DBR, RTNADR);                               
      CALL EMITRR(BCR, "F", BRCHREG);  /* SET UP BASE REGISTERS */              
      BASES(SBR) = (DP + 3) & "FFFFFC";                                         
      DO I = 4 TO DBR-1;                                                        
         CALL FIXWHOLEDATAWORD(BASEDATA+SHL(I,2), BASES(I));                    
      END;                                                                      
      CALL FIXWHOLEDATAWORD(DESCL, SHR(DSP,2)-1);                               
      COMPILING = FALSE;                                                        
   END;                                                                         
                                                                                
 /*  <STATEMENT LIST> ::= <STATEMENT>    */                                     
   ;                                                                            
 /*  <STATEMENT LIST> ::= <STATEMENT LIST> <STATEMENT>    */                    
   ;                                                                            
 /*  <STATEMENT> ::= <BASIC STATEMENT>    */                                    
   DO;                                                                          
      CALL CLEARREGS;                                                           
      STATEMENT_COUNT = STATEMENT_COUNT + 1;                                    
   END;                                                                         
                                                                                
 /*  <STATEMENT> ::= <IF STATEMENT>    */                                       
   CALL CLEARREGS;                                                              
                                                                                
 /*  <BASIC STATEMENT> ::= <ASSIGNMENT> ;    */                                 
   ;                                                                            
 /*  <BASIC STATEMENT> ::= <GROUP> ;    */                                      
   ;                                                                            
 /*  <BASIC STATEMENT> ::= <PROCEDURE DEFINITION> ;    */                       
   ;                                                                            
 /*  <BASIC STATEMENT> ::= <RETURN STATEMENT> ;    */                           
   ;                                                                            
 /*  <BASIC STATEMENT> ::= <CALL STATEMENT> ;    */                             
   ;                                                                            
 /*  <BASIC STATEMENT> ::= <GO TO STATEMENT> ;    */                            
   ;                                                                            
 /*  <BASIC STATEMENT> ::= <DECLARATION STATEMENT> ;    */                      
   ;                                                                            
                                                                                
 /*  <BASIC STATEMENT> ::= ;    */                                              
      ;                                                                         
 /*  <BASIC STATEMENT> ::= <LABEL DEFINITION> <BASIC STATEMENT>    */           
      ;                                                                         
 /*  <IF STATEMENT> ::= <IF CLAUSE> <STATEMENT>    */                           
   CALL FIXBFW(FIXL(MP), PP); /* FIX THE ESCAPE BRANCH NOW THAT STMT IS DONE */ 
                                                                                
 /*  <IF STATEMENT> ::= <IF CLAUSE> <TRUE PART> <STATEMENT>    */               
   DO;  /* THERE ARE TWO BRANCHES TO BE FILLED IN WITH ADDRESSES HERE */        
      CALL FIXBFW(FIXL(MPP1), PP); /* ESCAPE FROM TRUE PART */                  
      CALL FIXBFW(FIXL(MP), FIXV(MPP1)); /* HOP AROUND TRUE PART */             
   END;                                                                         
                                                                                
 /*  <IF STATEMENT> ::= <LABEL DEFINITION> <IF STATEMENT>    */                 
   ;                                                                            
                                                                                
 /*  <IF CLAUSE> ::= IF <EXPRESSION> THEN    */                                 
   CALL BOOLBRANCH(MPP1, MP); /* BRANCH ON FALSE OVER TRUE PART */              
                                                                                
  /*  <TRUE PART> ::= <BASIC STATEMENT> ELSE   */                               
   DO;  /* SAVE THE PROGRAM POINTER & EMIT THE CONDITIONAL BRANCH */            
      FIXL(MP) = PP;                                                            
      CALL BRANCH("F", 0); /* "F" MEANS UNCONDITIONAL BRANCH */                 
      FIXV(MP) = PP;                                                            
   END;                                                                         
                                                                                
 /*  <GROUP> ::= <GROUP HEAD> <ENDING>    */                                    
   DO;  /* BRANCH BACK TO LOOP & FIX ESCAPE JUMP */                             
       IF LENGTH(VAR(SP))>0 & VAR(MP-1)~=VAR(SP) THEN DO;                       
          S='END ' || VAR(SP) || ' DOESN''T MATCH GROUP LABEL ';                
          IF V(STATETOKEN(STATE_STACK(MP-1))) = '<LABEL DEFINITION>'            
               THEN S=S || VAR(MP-1) ;                                          
          CALL ERROR(S,0);                                                      
          CALL DUMP;                                                            
       IF FIXIT THEN RETURN;                                                    
       END;                                                                     
      IF INX(MP) = 1 | INX(MP) = 2 THEN                                         
         DO; /* STEP OR WHILE LOOP FIX UP */                                    
            CALL BRANCH("F", PPSAVE(MP));                                       
            CALL FIXBFW(FIXL(MP), PP);                                          
         END;                                                                   
      ELSE IF  INX(MP) = 3 THEN                                                 
         DO;  /* COMMENT  CASE GROUP */                                         
            /* JUSTIFY TO WORD BOUNDARY */                                      
            DP = (DP + 3) & "FFFFFC";                                           
            CALL FINDADDRESS(DP);                                               
            CALL FIXCHW(FIXL(MP)+2, SHL(ADREG,4)+SHR(ADRDISP,8), ADRDISP);      
            DO I = PPSAVE(MP) TO CASEP-1; CALL EMITDATAWORD(CASESTACK(I)); END; 
            CASEP = PPSAVE(MP) - 1;                                             
            CALL FIXBFW(FIXV(MP), PP);                                          
         END;                                                                   
   END;                                                                         
                                                                                
 /*  <GROUP HEAD> ::= DO ;    */                                                
   INX(MP) = 0;                                                                 
                                                                                
 /*  <GROUP HEAD> ::= DO <STEP DEFINITION> ;    */                              
   DO;                                                                          
      CALL MOVESTACKS(MPP1, MP);                                                
      INX(MP) = 1;  /* 1 DENOTES STEP */                                        
   END;                                                                         
                                                                                
 /*  <GROUP HEAD> ::= DO <WHILE CLAUSE> ;    */                                 
   DO;                                                                          
      PPSAVE(MP) = PPSAVE(MPP1);                                                
      FIXL(MP) = FIXL(MPP1);                                                    
      INX(MP) = 2;  /* 2 DENOTES WHILE */                                       
   END;                                                                         
                                                                                
 /*  <GROUP HEAD> ::= DO <CASE SELECTOR> ;    */                                
   DO;                                                                          
      CALL MOVESTACKS(MPP1, MP);                                                
      INX(MP) = 3;  /* 3 DENOTES CASE  */                                       
      INFORMATION = INFORMATION || ' CASE 0.';                                  
   END;                                                                         
                                                                                
 /*  <GROUP HEAD> ::= <GROUP HEAD> <STATEMENT>    */                            
   IF  INX(MP) = 3 THEN                                                         
      DO;  /* CASE GROUP, MUST RECORD STATEMENT ADDRESSES */                    
         CALL BRANCH ("F", FIXV(MP));                                           
      IF CASEP >= CASELIMIT THEN CALL ERROR ('TOO MANY CASES', 1);              
         ELSE CASEP = CASEP + 1;  CASESTACK(CASEP) = PP;                        
      IF BCD ~= 'END' THEN                                                      
            INFORMATION = INFORMATION || ' CASE ' || CASEP-PPSAVE(MP) || PERIOD;
      END;                                                                      
                                                                                
 /*  <STEP DEFINITION> ::= <VARIABLE> <REPLACE> <EXPRESSION> <ITERATION CONTROL>
         */                                                                     
   DO; /* EMIT CODE FOR STEPPING DO LOOPS */                                    
      CALL FORCEACCUMULATOR(MP+2);                                              
      IF INX(MP) ~ = 0 THEN                                                     
         CALL ERROR ('SUBSCRIPTED DO VARIABLE', 0);                             
      STEPK = PP;                                                               
      CALL BRANCH("F", 0);                                                      
      PPSAVE(MP) = PP;                                                          
      L = FIXL(MP);                                                             
      ADREG = SYBASE(L);                                                        
      ADRDISP = SYDISP(L);                                                      
      IF SYTYPE(L) = BYTETYPE THEN                                              
         DO;                                                                    
            CALL EMITRR("1B", REG(MP+2), REG(MP+2));                            
            CALL EMITRX ("43", REG(MP+2), 0, ADREG, ADRDISP);                   
         END;                                                                   
      ELSE IF SYTYPE(L) = HALFWORD THEN                                         
         CALL EMITRX ("48", REG(MP+2), 0, ADREG, ADRDISP);                      
      ELSE                                                                      
         CALL EMITRX (LOAD, REG(MP+2), 0, ADREG, ADRDISP);                      
      CALL EMITRX ("5A", REG(MP+2), 0, REG(MP+3), FIXL(MP+3));                  
      CALL FIXBFW(STEPK, PP);                                                   
      IF SYTYPE(L) = BYTETYPE THEN I = "42";                                    
      ELSE IF SYTYPE(L) = HALFWORD THEN I = "40";                               
      ELSE I = STORE;                                                           
      CALL EMITRX (I, REG(MP+2), 0, ADREG, ADRDISP);                            
      CALL EMITRX (CMPR, REG(MP+2), 0, INX(MP+3), FIXV(MP+3));                  
      FIXL(MP) = PP;                                                            
      CALL BRANCH("2", 0);                                                      
        BASES(INX(MP)) = AVAIL;                                                 
      BASES(REG(MP+2)) = AVAIL;                                                 
   END;                                                                         
                                                                                
 /*  <ITERATION CONTROL> ::= TO <EXPRESSION>    */                              
   DO;                                                                          
      REG(MP) = DBR;                                                            
      FIXL(MP) = TRUELOC;  /* POINT AT THE CONSTANT ONE FOR STEP  */            
      CALL SET_LIMIT;                                                           
   END;                                                                         
                                                                                
 /*  <ITERATION CONTROL> ::= TO <EXPRESSION> BY <EXPRESSION>    */              
   DO;                                                                          
      IF TYPE(SP) = CONSTANT THEN CALL EMITCONSTANT (FIXV(SP));                 
      ELSE                                                                      
         DO;                                                                    
            CALL FORCEACCUMULATOR (SP);                                         
            CALL EMITDATAWORD (0);                                              
            CALL FINDADDRESS (DP-4);                                            
            CALL EMITRX (STORE, REG(SP), 0, ADREG, ADRDISP);                    
            BASES(REG(SP)) = AVAIL;                                             
         END;                                                                   
      REG(MP) = ADREG;                                                          
      FIXL(MP) = ADRDISP;                                                       
      CALL SET_LIMIT;                                                           
   END;                                                                         
                                                                                
 /*  <WHILE CLAUSE> ::= WHILE <EXPRESSION>    */                                
   CALL BOOLBRANCH(SP, MP);                                                     
                                                                                
 /*  <CASE SELECTOR> ::= CASE <EXPRESSION>    */                                
   DO;                                                                          
      CALL FORCEACCUMULATOR(SP);                                                
      CALL EMITRX("89", REG(SP), 0, 0, 2);                                      
      FIXL(MP) = PP;                                                            
      CALL EMITRX(LOAD, REG(SP), REG(SP), 0, 0);                                
      CALL EMITRX(BC, "F", REG(SP), PBR, 0);                                    
      BASES(REG(SP)) = AVAIL;                                                   
      FIXV(MP) = PP;                                                            
      CALL BRANCH("F", 0);                                                      
      IF CASEP >= CASELIMIT THEN CALL ERROR ('TOO MANY CASES', 1);              
      ELSE CASEP = CASEP + 1;                                                   
      CASESTACK(CASEP) = PP;                                                    
      PPSAVE(MP) = CASEP;                                                       
   END;                                                                         
                                                                                
 /*  <PROCEDURE DEFINITION> ::= <PROCEDURE HEAD> <STATEMENT LIST> <ENDING>    */
   DO; /* PROCEDURE IS DEFINED, RESTORE SYMBOL TABLE */                         
       LEX_LEVEL = LEX_LEVEL - 1;                                               
       CALL NULLOUT(PROCMARK);                                                  
       IF LENGTH(VAR(SP)) >0 & VAR(SP)~= SUBSTR(CURRENT_PROCEDURE,1) THEN DO;   
            CALL ERROR ('PROCEDURE' || CURRENT_PROCEDURE || ' CLOSED BY END ' ||
               VAR(SP), 0);                                                     
          CALL DUMP;                                                            
          IF FIXIT THEN RETURN;                                                 
       END;                                                                     
      IF CONTROL(BYTE('S')) THEN CALL SYMBOLDUMP;                               
      DO I = PROCMARK TO NDECSY;                                                
         IF SYTYPE(I) = FORWARDTYPE | SYTYPE(I) = FORWARDCALL THEN              
          IF SYTCO(I) > 0 THEN                                                  
            CALL ERROR ('UNDEFINED LABEL OR PROCEDURE: ' || SYT(I), 1);         
      END;                                                                      
      DO I = PROCMARK + PARCT  TO  NDECSY + 1;                                  
         SYT(I) = X1;   SY_LINK(I) = NULL;                                      
      END;                                                                      
      NDECSY = PROCMARK + PARCT - 1;                                            
      /* PARAMETER ADDRESS MUST BE SAVED BUT NAMES DISCARDED */                 
      DO I = PROCMARK TO NDECSY;                                                
         IF SYTYPE(I) = 0 THEN                                                  
            DO;                                                                 
               CALL ERROR('UNDECLARED PARAMETER:' || SYT(I));                   
               SYTYPE(I) = FIXEDTYPE;                                           
               CALL EMITDATAWORD(0);                                            
               CALL FINDADDRESS(DP-4);                                          
               SYBASE(I) = ADREG;                                               
               SYDISP(I) = ADRDISP;                                             
            END;                                                                
         SYT(I) = '';                                                           
      END;                                                                      
      CURRENT_PROCEDURE = VAR(MP);                                              
      PROCMARK = FIXV(MP);  PARCT = CNT(MP);                                    
      RETURNED_TYPE = TYPE(MP) ;                                                
      /* EMIT A GRATUITOUS RETURN */                                            
      CALL FINDADDRESS(RTNADR);                                                 
      CALL EMITRX(LOAD, BRCHREG, 0, ADREG, ADRDISP);                            
      CALL EMITRR(BCR, "F", BRCHREG);                                           
      RTNADR = PPSAVE(MP);                                                      
      CALL FIXBFW(FIXL(MP), PP); /* COMPLETE JUMP AROUND PROCEDURE DEFINITION */
   END;                                                                         
                                                                                
 /*  <PROCEDURE HEAD> ::= <PROCEDURE NAME> ;    */                              
   DO;  /* MUST POINT AT FIRST PARAMETER EVEN IF NONEXISTENT  */                
      /* SAVE OLD PARAMETER COUNT */                                            
      CNT(MP) = PARCT; PARCT = 0;                                               
      /* SAVE OLD PROCEDURE MARK IN SYMBOL TABLE */                             
      FIXV(MP) = PROCMARK;  PROCMARK = NDECSY + 1;                              
      TYPE(MP) = RETURNED_TYPE;                                                 
      RETURNED_TYPE = 0;                                                        
      LEX_LEVEL = LEX_LEVEL + 1;                                                
      PROCEDURE_NUMBER, PROC_STACK(LEX_LEVEL) = PROCEDURE_NUMBER + 1;           
      CALL PROC_START;                                                          
   END;                                                                         
                                                                                
                                                                                
 /*  <PROCEDURE HEAD> ::= <PROCEDURE NAME> <TYPE> ;    */                       
   DO;                                                                          
      CNT(MP) = PARCT;                                                          
      PARCT = 0;                                                                
      FIXV(MP) = PROCMARK;                                                      
      PROCMARK = NDECSY + 1;                                                    
      TYPE(MP) = RETURNED_TYPE;                                                 
      RETURNED_TYPE = TYPE(SP-1);                                               
      IF RETURNED_TYPE = CHRTYPE THEN                                           
         SYTYPE(FIXL(MP)) = CHAR_PROC_TYPE ;                                    
      LEX_LEVEL = LEX_LEVEL + 1;                                                
      PROCEDURE_NUMBER, PROC_STACK(LEX_LEVEL) = PROCEDURE_NUMBER + 1;           
      CALL PROC_START;                                                          
   END;                                                                         
                                                                                
 /*  <PROCEDURE HEAD> ::= <PROCEDURE NAME> <PARAMETER LIST> ;    */             
   DO;                                                                          
      CNT(MP) = CNT(MPP1);  /* SAVE PARAMETER COUNT */                          
      FIXV(MP) = FIXV(MPP1);                                                    
      TYPE(MP) = RETURNED_TYPE;                                                 
      RETURNED_TYPE = 0;                                                        
      CALL PROC_START;                                                          
   END;                                                                         
                                                                                
                                                                                
 /*  <PROCEDURE HEAD> ::= <PROCEDURE NAME> <PARAMETER LIST> <TYPE> ;       */   
   DO;                                                                          
      CNT(MP) = CNT(MPP1);                                                      
      FIXV(MP) = FIXV(MPP1);                                                    
      TYPE(MP) = RETURNED_TYPE;                                                 
      RETURNED_TYPE = TYPE(SP-1);                                               
      IF RETURNED_TYPE = CHRTYPE THEN                                           
         SYTYPE(FIXL(MP)) = CHAR_PROC_TYPE ;                                    
      CALL PROC_START;                                                          
   END;                                                                         
                                                                                
 /*  <PROCEDURE NAME> ::= <LABEL DEFINITION> PROCEDURE    */                    
   DO;                                                                          
      S = CURRENT_PROCEDURE;                                                    
      CURRENT_PROCEDURE = X1 || VAR(MP);                                        
      VAR(MP) = S;                                                              
   END;                                                                         
                                                                                
 /*  <PARAMETER LIST> ::= <PARAMETER HEAD> <IDENTIFIER> )    */                 
   DO;                                                                          
      PARCT = PARCT + 1;                                                        
      CALL ENTER (VAR(MPP1), 0, 0, 0);                                          
   END;                                                                         
                                                                                
 /*  <PARAMETER HEAD> ::= (   */                                                
   DO;  /* POINT AT THE FIRST PARAMETER FOR SYMBOL TABLE */                     
      FIXV(MP) = PROCMARK;  PROCMARK = NDECSY + 1;                              
      CNT(MP) = PARCT;                                                          
      PARCT = 0;                                                                
      LEX_LEVEL = LEX_LEVEL + 1;                                                
      PROCEDURE_NUMBER, PROC_STACK(LEX_LEVEL) = PROCEDURE_NUMBER + 1;           
   END;                                                                         
                                                                                
 /*  <PARAMETER HEAD> ::= <PARAMETER HEAD> <IDENTIFIER> ,    */                 
   DO;                                                                          
      PARCT = PARCT + 1;                                                        
      CALL ENTER (VAR(MPP1), 0, 0, 0);                                          
   END;                                                                         
                                                                                
 /*  <ENDING> ::= END    */                                                     
   VAR(MP) = '';                                                                
                                                                                
 /*  <ENDING> ::= END <IDENTIFIER>    */                                        
   VAR(MP) = VAR(SP);                                                           
                                                                                
 /*  <ENDING> ::= <LABEL DEFINITION> <ENDING>    */                             
   VAR(MP) = VAR(SP);                                                           
                                                                                
 /*  <LABEL DEFINITION> ::= <IDENTIFIER> :    */                                
   FIXL(MP) = ENTER (VAR(MP), LABELTYPE, PP, FIXL(MP));                         
                                                                                
                                                                                
 /*  <RETURN STATEMENT> ::= RETURN    */                                        
   DO;  /* EMIT A RETURN BRANCH */                                              
      CALL FINDADDRESS(RTNADR);                                                 
      CALL EMITRX(LOAD, BRCHREG,0,ADREG,ADRDISP);                               
      CALL EMITRR(BCR,"F",BRCHREG);                                             
   END;                                                                         
                                                                                
 /*  <RETURN STATEMENT> ::= RETURN <EXPRESSION>    */                           
   DO;  /* EMIT A RETURN BRANCH & PASS VALUE IN REGISTER 3 */                   
      /* NOW FORCE IT INTO REGISTER 3 */                                        
      TARGET_REGISTER = 3;                                                      
      IF RETURNED_TYPE = CHRTYPE THEN                                           
         CALL FORCEDESCRIPT(MPP1);                                              
      ELSE                                                                      
         CALL FORCEACCUMULATOR(MPP1);                                           
      TARGET_REGISTER = -1;                                                     
      IF REG(MPP1) ~ = 3 THEN CALL EMITRR("18",3,REG(MPP1));                    
      CALL FINDADDRESS(RTNADR);                                                 
      CALL EMITRX(LOAD, BRCHREG, 0, ADREG, ADRDISP);                            
      CALL EMITRR(BCR, "F", BRCHREG);                                           
      CALL CLEARREGS;                                                           
   END;                                                                         
                                                                                
 /*  <CALL STATEMENT> ::= CALL <VARIABLE>    */                                 
   DO;                                                                          
      CALL FORCEACCUMULATOR(SP);                                                
      CALL CLEARREGS;                                                           
   END;                                                                         
                                                                                
 /*  <GO TO STATEMENT> ::= <GO TO> <IDENTIFIER>    */                           
   DO;                                                                          
      CALL ID_LOOKUP(SP);                                                       
      J = FIXL(SP);                                                             
      IF J < 0 THEN          /*  1ST OCURRANCE OF THE LABEL */                  
         DO;                                                                    
            CALL EMITDATAWORD(0);      /* SPACE FOR FIXUP */                    
            J = ENTER (VAR(SP), FORWARDTYPE, DP-4, FIXL(SP));                   
            SYTCO(J) = 1;                                                       
         END;                                                                   
      IF SYTYPE(J) = LABELTYPE THEN                                             
         CALL BRANCH_BD("F",SYBASE(J),SYDISP(J));                               
      ELSE IF SYTYPE(J) = FORWARDTYPE THEN                                      
         DO;                                                                    
            CALL EMITRX(LOAD,BRCHREG,0,SYBASE(J),SYDISP(J));                    
            CALL EMITRX(BC,"F",BRCHREG,PBR,0);                                  
         END;                                                                   
      ELSE                                                                      
         DO;                                                                    
            CALL ERROR('TARGET OF GO TO IS NOT A LABEL',0);                     
            CALL EMITRX(BC,"F",0,SYBASE(J),SYDISP(J));                          
         END;                                                                   
   END;                                                                         
                                                                                
 /*  <GO TO> ::= GO TO    */                                                    
      ;                                                                         
 /*  <GO TO> ::= GOTO    */                                                     
      ;                                                                         
 /*  <DECLARATION STATEMENT> ::= DECLARE <DECLARATION ELEMENT>    */            
      ;                                                                         
                                                                                
 /*  <DECLARATION STATEMENT> ::= <DECLARATION STATEMENT> , <DECLARATION ELEMENT>
          */                                                                    
      ;                                                                         
                                                                                
 /*  <DECLARATION ELEMENT> ::= <TYPE DECLARATION>    */                         
   DO;                                                                          
      IF TYPE(MP) = CHRTYPE THEN                                                
         DSP = NEWDSP ;                                                         
      ELSE                                                                      
         DO;                                                                    
            DP = NEWDP ;                                                        
            CALL CHECKBASES ;                                                   
         END;                                                                   
   END;                                                                         
                                                                                
 /*  <DECLARATION ELEMENT> ::= <IDENTIFIER> LITERALLY <STRING>    */            
      IF TOP_MACRO >= MACRO_LIMIT THEN                                          
         CALL ERROR('MACRO TABLE OVERFLOW',1);                                  
      ELSE                                                                      
         DO;                                                                    
            TOP_MACRO = TOP_MACRO + 1;                                          
            I = LENGTH(VAR(MP));                                                
            J = MACRO_INDEX(I);                                                 
            DO L = 1 TO TOP_MACRO - J;                                          
               K = TOP_MACRO - L;                                               
               MACRO_NAME(K+1) = MACRO_NAME(K);                                 
               MACRO_TEXT(K+1) = MACRO_TEXT(K);                                 
            END;                                                                
            MACRO_NAME(J) = VAR(MP);                                            
            MACRO_TEXT(J) = VAR(SP);                                            
            DO J = I TO 255;                                                    
               MACRO_INDEX(J) = MACRO_INDEX(J)+1;                               
            END;                                                                
         END;                                                                   
                                                                                
 /*  <TYPE DECLARATION> ::= <IDENTIFIER SPECIFICATION> <TYPE>    */             
   CALL TDECLARE(0);                                                            
                                                                                
 /*  <TYPE DECLARATION> ::= <BOUND HEAD> <NUMBER> ) <TYPE>    */                
   CALL TDECLARE(FIXV(MPP1));                                                   
                                                                                
 /*  <TYPE DECLARATION> ::= <TYPE DECLARATION> <INITIAL LIST>    */             
      ;                                                                         
                                                                                
 /*  <TYPE> ::= FIXED    */                                                     
   TYPE(MP) = FIXEDTYPE ;                                                       
                                                                                
 /*  <TYPE> ::= CHARACTER    */                                                 
   TYPE(MP) = CHRTYPE ;                                                         
                                                                                
 /*  <TYPE> ::= LABEL    */                                                     
   TYPE(MP) = FORWARDTYPE ;                                                     
                                                                                
 /*  <TYPE> ::= <BIT HEAD> <NUMBER> )    */                                     
      IF FIXV(MPP1) <= 8 THEN TYPE(MP) = BYTETYPE;                              
      ELSE IF FIXV(MPP1) <= 16 THEN TYPE(MP) = HALFWORD;                        
      ELSE IF FIXV(MPP1) <= 32 THEN TYPE(MP) = FIXEDTYPE;                       
      ELSE TYPE(MP) = CHRTYPE;                                                  
                                                                                
 /*  <BIT HEAD> ::= BIT (   */                                                  
      ;                                                                         
                                                                                
 /*  <BOUND HEAD> ::= <IDENTIFIER SPECIFICATION> (   */                         
      ;                                                                         
                                                                                
 /*  <IDENTIFIER SPECIFICATION> ::= <IDENTIFIER>    */                          
   DO;                                                                          
      INX(MP) = 1;                                                              
      I = FIXL(MP);                                                             
      FIXL(MP) = CASEP;                                                         
      IF CASEP >= CASELIMIT THEN                                                
         CALL ERROR(DCLRM,1);                                                   
      ELSE                                                                      
         CASEP = CASEP + 1;                                                     
      CASESTACK(CASEP) = ENTER (VAR(MP), 0, 0, I);                              
   END;                                                                         
                                                                                
 /*  <IDENTIFIER SPECIFICATION> ::= <IDENTIFIER LIST> <IDENTIFIER> )    */      
   DO;                                                                          
      INX(MP) = INX(MP) + 1;                                                    
      IF CASEP >= CASELIMIT THEN                                                
         CALL ERROR(DCLRM, 1);                                                  
      ELSE                                                                      
         CASEP = CASEP + 1;                                                     
      CASESTACK(CASEP) = ENTER (VAR(MPP1), 0, 0, FIXL(MPP1));                   
   END;                                                                         
                                                                                
 /*  <IDENTIFIER LIST> ::= (   */                                               
   DO;                                                                          
      INX(MP) = 0;                                                              
      FIXL(MP) = CASEP;                                                         
   END;                                                                         
                                                                                
 /*  <IDENTIFIER LIST> ::= <IDENTIFIER LIST> <IDENTIFIER> ,    */               
   DO;                                                                          
      INX(MP) = INX(MP) + 1;                                                    
       IF CASEP >= CASELIMIT THEN CALL ERROR(DCLRM,1);                          
       ELSE                                                                     
         CASEP = CASEP + 1;                                                     
      CASESTACK(CASEP) = ENTER (VAR(MPP1), 0, 0, FIXL(MPP1));                   
   END;                                                                         
                                                                                
 /*  <INITIAL LIST> ::= <INITIAL HEAD> <CONSTANT> )    */                       
   CALL SETINIT ;                                                               
                                                                                
 /*  <INITIAL HEAD> ::= INITIAL (   */                                          
   IF INX(MP-1) = 1 THEN                                                        
      ITYPE = TYPE(MP-1);    /*  INFORMATION FROM  <TYPE DECLARATION>  */       
   ELSE                                                                         
      DO;                                                                       
         CALL ERROR('INITIAL MAY NOT BE USED WITH IDENTIFIER LIST',0);          
         ITYPE = 0;                                                             
      END;                                                                      
                                                                                
                                                                                
 /*  <INITIAL HEAD> ::= <INITIAL HEAD> <CONSTANT> ,    */                       
   CALL SETINIT;                                                                
                                                                                
 /*  <ASSIGNMENT> ::= <VARIABLE> <REPLACE> <EXPRESSION>    */                   
   CALL GENSTORE(MP,SP);                                                        
                                                                                
 /*  <ASSIGNMENT> ::= <LEFT PART> <ASSIGNMENT>    */                            
   CALL GENSTORE(MP,SP);                                                        
                                                                                
 /*  <REPLACE> ::= =    */                                                      
   ;                                                                            
                                                                                
 /*  <LEFT PART> ::= <VARIABLE> ,    */                                         
   ;                                                                            
                                                                                
 /*  <EXPRESSION> ::= <LOGICAL FACTOR>    */                                    
      ;                                                                         
 /*  <EXPRESSION> ::= <EXPRESSION> | <LOGICAL FACTOR>    */                     
   /* "16" = OR, "56" = O */                                                    
   CALL ARITHEMIT("16");                                                        
                                                                                
 /*  <LOGICAL FACTOR> ::= <LOGICAL SECONDARY>    */                             
      ;                                                                         
                                                                                
 /*  <LOGICAL FACTOR> ::= <LOGICAL FACTOR> & <LOGICAL SECONDARY>    */          
   /* "14" = NR, "54" = N */                                                    
   CALL ARITHEMIT("14");                                                        
                                                                                
 /*  <LOGICAL SECONDARY> ::= <LOGICAL PRIMARY>    */                            
   IF TYPE(MP) = CONDITION THEN CALL CONDTOREG(MP, REG(MP));                    
                                                                                
 /*  <LOGICAL SECONDARY> ::= ~ <LOGICAL PRIMARY>    */                          
   DO;                                                                          
      CALL MOVESTACKS (SP, MP);                                                 
      IF TYPE(MP) = CONDITION THEN                                              
         CALL CONDTOREG (MP, "E" - REG(MP));                                    
      ELSE                                                                      
         DO;                                                                    
            CALL FORCEACCUMULATOR (MP);                                         
              /* "57" = X */                                                    
            CALL EMITRX ("57", REG(MP), 0, DBR, COMPLOC);                       
         END;                                                                   
   END;                                                                         
                                                                                
 /*  <LOGICAL PRIMARY> ::= <STRING EXPRESSION>    */                            
      ;                                                                         
                                                                                
   /*              CONDITION CODES     MASK                                     
                   0  OPERANDS EQUAL   BIT 8                                    
                   1  FIRST OPERAND LO BIT 9                                    
                   2  FIRST OPERAND HI BIT 10                                 */
                                                                                
 /*  <LOGICAL PRIMARY> ::= <STRING EXPRESSION> <RELATION> <STRING EXPRESSION>   
         */                                                                     
   DO;                                                                          
      CALL ARITHEMIT(CMPRR);                                                    
      BASES(REG(MP)) = AVAIL;                                                   
      REG(MP) = REG(MPP1);                                                      
      TYPE(MP) = CONDITION;                                                     
   END;                                                                         
                                                                                
 /*  <RELATION> ::= =    */                                                     
   REG(MP) = 6;                                                                 
                                                                                
 /*  <RELATION> ::= <    */                                                     
   REG(MP) = 10;                                                                
                                                                                
 /*  <RELATION> ::= >    */                                                     
   REG(MP) = 12;                                                                
                                                                                
 /*  <RELATION> ::= ~ =    */                                                   
   REG(MP) = 8;                                                                 
                                                                                
 /*  <RELATION> ::= ~ <    */                                                   
   REG(MP) = 4;                                                                 
                                                                                
 /*  <RELATION> ::= ~ >    */                                                   
   REG(MP) = 2;                                                                 
                                                                                
 /*  <RELATION> ::= < =    */                                                   
   REG(MP) = 2;                                                                 
                                                                                
 /*  <RELATION> ::= > =    */                                                   
   REG(MP) = 4;                                                                 
                                                                                
 /*  <STRING EXPRESSION> ::= <ARITHMETIC EXPRESSION>    */                      
      IF TYPE(SP) = VARIABLE THEN                                               
         IF SYTYPE(FIXL(SP)) = CHAR_PROC_TYPE THEN                              
            CALL FORCEDESCRIPT(SP);                                             
                                                                                
 /*  <STRING EXPRESSION> ::= <STRING EXPRESSION> || <ARITHMETIC EXPRESSION>     
         */                                                                     
   DO; /* CATENATE TWO STRINGS */                                               
      CALL FORCEDESCRIPT(SP);                                                   
      CALL EMITRX(STORE,REG(SP),0,B1,B2);                                       
      BASES(REG(SP)) = AVAIL;                                                   
      CALL FORCEDESCRIPT(MP);                                                   
      CALL EMITRX(STORE,REG(MP),0,A1,A2);                                       
      BASES(REG(MP)) = AVAIL;                                                   
      CALL CALLSUB(0,CATENTRY,3,MP);                                            
      /* ASSUME CATENATE IS IN THE 1ST PAGE */                                  
                                                                                
      TYPE(MP) = DESCRIPT;                                                      
   END;                                                                         
                                                                                
 /*  <ARITHMETIC EXPRESSION> ::= <TERM>    */                                   
      ;                                                                         
 /*  <ARITHMETIC EXPRESSION> ::= <ARITHMETIC EXPRESSION> + <TERM>    */         
   /* "1A" = AR, "5A" = A  */                                                   
   CALL ARITHEMIT("1A");                                                        
                                                                                
 /*  <ARITHMETIC EXPRESSION> ::= <ARITHMETIC EXPRESSION> - <TERM>    */         
   /* "1B" = SR, "5B" = S */                                                    
   CALL ARITHEMIT("1B");                                                        
                                                                                
 /*  <ARITHMETIC EXPRESSION> ::= + <TERM>    */                                 
   CALL MOVESTACKS(MPP1,MP);                                                    
                                                                                
 /*  <ARITHMETIC EXPRESSION> ::= - <TERM>    */                                 
   DO;                                                                          
      CALL MOVESTACKS(MPP1, MP);                                                
      IF TYPE(MP) = CONSTANT THEN FIXV(MP) = - FIXV(MP);                        
      ELSE                                                                      
         DO;                                                                    
            CALL FORCEACCUMULATOR(MP);                                          
            CALL EMITRR("13", REG(MP), REG(MP));  /* LCR = COMPLEMENT */        
         END;                                                                   
   END;                                                                         
                                                                                
 /*  <TERM> ::= <PRIMARY>    */                                                 
      ;                                                                         
                                                                                
 /*  <TERM> ::= <TERM> * <PRIMARY>    */                                        
   /* "1C" = MR, "5C" = M */                                                    
   DO;                                                                          
      CALL FORCEACCUMULATOR(MP);                                                
      IF REG(MP) = 1 THEN                                                       
         DO;  /* MULTIPLY IS FUNNY ON A 360--SORRY */                           
            REG(MP) = 0;                                                        
            CALL ARITHEMIT("1C");                                               
            REG(MP) = 1;                                                        
         END;                                                                   
      ELSE                                                                      
         DO;                                                                    
            CALL FORCEACCUMULATOR(SP);                                          
             IF REG(SP) = 1 THEN                                                
               DO;                                                              
                  CALL EMITRR("1C",0,REG(MP));                                  
                  BASES(REG(MP)) = AVAIL;                                       
                  REG(MP) = 1;                                                  
               END;                                                             
               ELSE IF REG(MP) + REG(SP) = 5 THEN                               
                  DO;   /*  OPERANDS ARE IN 2 & 3  */                           
                      CALL EMITRR("1C",2,2);                                    
                      BASES(2) = AVAIL;                                         
                      REG(MP) = 3;                                              
                  END;                                                          
            ELSE CALL ERROR ('MULTIPLY FAILED ***', 1);                         
         END;                                                                   
   END;                                                                         
                                                                                
 /*  <TERM> ::= <TERM> / <PRIMARY>    */                                        
   CALL DIVIDE_CODE;                                                            
   /*  DIVIDE IS EVEN FUNNIER THAN MULTIPLY  */                                 
                                                                                
 /*  <TERM> ::= <TERM> MOD <PRIMARY>    */                                      
   DO;                                                                          
      CALL DIVIDE_CODE;                                                         
      CALL EMITRR("18",1,0);                     /*  LR    1,0        */        
   END;                                                                         
                                                                                
 /*  <PRIMARY> ::= <CONSTANT>    */                                             
      ;                                                                         
 /*  <PRIMARY> ::= <VARIABLE>    */                                             
      IF FIXV(MP) = 3 THEN   /*  FINISH OFF THE FUNCTION  BYTE        */        
         IF CNT(MP) = 1 THEN                                                    
            DO;                                                                 
               IF TYPE(MP) = CHRTYPE THEN                                       
                  DO;                                                           
                     TYPE(MP) = CONSTANT;                                       
                     FIXV(MP) = BYTE(VAR(MP));                                  
                  END;                                                          
               ELSE                                                             
                  DO;                                                           
                     I = FINDAC;                                                
                     CALL EMITRR("1B",I,I);      /*  SR    I,I        */        
                     CALL EMITRX("43",I,0,REG(MP),0);                           
                                                 /*  IC               */        
                     BASES(REG(MP)) = AVAIL;                                    
                     REG(MP) = I;                                               
                     TYPE(MP) = ACCUMULATOR;                                    
                  END;                                                          
            END;                                                                
         ELSE IF CNT(MP) = 2 THEN                                               
            DO;                                                                 
               I = INX(MP);                                                     
                     CALL EMITRX("43",I,I,REG(MP),0);                           
                     BASES(REG(MP)) = AVAIL;                                    
                     REG(MP) = I;                                               
               TYPE(MP) = ACCUMULATOR;                                          
            END;                                                                
                                                                                
 /*  <PRIMARY> ::= ( <EXPRESSION> )    */                                       
   CALL MOVESTACKS(MPP1, MP);                                                   
                                                                                
 /*  <VARIABLE> ::= <IDENTIFIER>    */                                          
   DO;      /* FIND THE IDENTIFIER IN THE SYMBOL TABLE */                       
      CALL ID_LOOKUP(MP);                                                       
      IF FIXL(MP) = -1 THEN                                                     
         CALL UNDECLARED_ID(MP);                                                
   END;                                                                         
                                                                                
 /*  <VARIABLE> ::= <SUBSCRIPT HEAD> <EXPRESSION> )    */                       
   DO;  /* EITHER A PROCEDURE CALL OR ARRAY OR BUILT IN FUNCTION */             
      CNT(MP) = CNT(MP) + 1;                                                    
      I = FIXV(MP);                                                             
                                                                                
      IF I < 6 THEN                                                             
      DO CASE I;                                                                
                                                                                
         /* CASE  0  */                                                         
                                                                                
         DO;      /* SUBS | CALL */                                             
            CALL FORCEACCUMULATOR (MPP1);                                       
            IF SYTYPE(FIXL(MP)) = LABELTYPE |                                   
               SYTYPE(FIXL(MP)) = CHAR_PROC_TYPE  THEN DO;                      
               CALL STUFF_PARAMETER;                                            
               CALL FORCEACCUMULATOR (MP);                                      
               END;                                                             
            ELSE                                                                
               DO;      /* SUBSCRIPTED VARIABLE */                              
                  IF CNT(MP) > 1 THEN                                           
                     CALL ERROR ('MULTIPLE SUBSCRIPTS NOT ALLOWED', 0);         
                  INX(MP) = REG(MPP1);                                          
               END;                                                             
         END;                                                                   
                                                                                
         /* CASE  1  */                                                         
                                                                                
         DO;  /* BUILT IN FUNCTION: LENGTH */                                   
            CALL FORCEDESCRIPT (MPP1);                                          
            CALL EMITRR ("12", REG(MPP1), REG(MPP1));  /* LTR TO CHECK FOR NUL*/
            CALL EMITRX ("88", REG(MPP1), 0, 0, 24);  /* SHIFT TO CHARACTER */  
            I = PP;                                                             
            CALL BRANCH (8, 0);   /* DON'T INCREMENT LENGTH ON NULL STRING */   
            CALL EMITRX (LA, REG(MPP1), 0, REG(MPP1), 1); /*ADD 1, TRUE LENGTH*/
            CALL FIXBFW (I, PP);  /* DESTINATION OF NULL STRING JUMP */         
            REG(MP) = REG(MPP1);  /* RECORD CONTAINING ACCUMULATOR */           
            TYPE(MP) = ACCUMULATOR;                                             
         END;                                                                   
                                                                                
         /* CASE  2  */                                                         
                                                                                
         /* BUILT-IN FUNCTION SUBSTR */                                         
         DO;                                                                    
            IF CNT(MP) = 2 THEN                                                 
               DO;                                                              
                  IF TYPE(MPP1) = CONSTANT THEN                                 
                     DO;                                                        
                        CALL EMITCONSTANT (SHL(FIXV(MPP1), 24) - FIXV(MPP1));   
                        CALL EMITRX ("5F", REG(MP), 0, ADREG, ADRDISP);         
                     END;                                                       
                  ELSE                                                          
                     DO;                                                        
                        CALL FORCEACCUMULATOR (MPP1);                           
                        CALL EMITRR ("1E", REG(MP), REG(MPP1)); /* ALR BASE */  
                        CALL EMITRX ("89", REG(MPP1), 0, 0, 24);                
                        CALL EMITRR ("1F", REG(MP), REG(MPP1));                 
                        BASES(REG(MPP1)) = AVAIL;                               
                     END;                                                       
                  I = PP;                                                       
                  CALL BRANCH (1, 0);     /* WE MAY NOW HAVE NEGATIVE LENGTH */ 
                  CALL EMITRR ("1B", REG(MP), REG(MP));  /* NULL DESCRIPTOR */  
                  CALL FIXBFW (I, PP);                                          
               END;                                                             
            ELSE                                                                
               DO;         /* THREE ARGUMENTS */                                
                  CALL EMITRX (LA, REG(MP), INX(MP), REG(MP), PPSAVE(MP));      
                  BASES(INX(MP)) = AVAIL;                                       
                  IF TYPE(MPP1) ~= CONSTANT THEN                                
                     DO;                                                        
                        CALL FORCEACCUMULATOR (MPP1);                           
                        CALL EMITRX (LA, REG(MPP1), 0, REG(MPP1), "FF");        
                                /* DECREMENT LENGTH BY 1  */                    
                        CALL EMITRX ("89", REG(MPP1), 0, 0, 24);                
                        CALL EMITRR ("16", REG(MP), REG(MPP1));  /* | INTO D */ 
                        BASES(REG(MPP1)) = AVAIL;                               
                     END;                                                       
                  ELSE                                                          
                     DO;                                                        
                        CALL EMITCONSTANT (SHL(FIXV(MPP1)-1, 24));              
                        CALL EMITRX ("56", REG(MP), 0, ADREG, ADRDISP);         
                     END;                                                       
               END;                                                             
            TYPE(MP) = DESCRIPT;                                                
         END;                                                                   
                                                                                
         /* CASE  3  */                                                         
                                                                                
         DO;      /* BUILT IN FUNCTION BYTE */                                  
            IF CNT(MP) = 1 THEN                                                 
               DO;                                                              
                  IF TYPE(MPP1) = CHRTYPE THEN                                  
                     DO;                                                        
                        TYPE(MP) = CHRTYPE;                                     
                        VAR(MP) = VAR(MPP1);                                    
                     END;                                                       
                  ELSE                                                          
                     DO;                                                        
                        CALL FORCEDESCRIPT(MPP1);                               
                        IF REG(MPP1) = 0 THEN                                   
                           DO;                                                  
                              REG(MP) = FINDAC;                                 
                              CALL EMITRR("18",REG(MP),0);                      
                                                 /*  LR    REG(MP),0  */        
                           END;                                                 
                        ELSE                                                    
                           REG(MP) = REG(MPP1);                                 
                        TYPE(MP) = DESCRIPT;                                    
                        INX(MP) = 0;                                            
                    END;                                                        
               END;                                                             
            ELSE IF CNT(MP) = 2 THEN                                            
               DO;                                                              
                  CALL FORCEACCUMULATOR(MPP1);                                  
                  INX(MP) = REG(MPP1);                                          
               END;                                                             
            ELSE                                                                
               CALL ERROR('BYTE CALLED WITH MORE THAN TWO ARGUMENTS',0);        
         END;                                                                   
                                                                                
         /* CASE  4  */                                                         
                                                                                
         CALL SHIFT_CODE("89");        /*  SLL  */                              
                                                                                
         /* CASE  5  */                                                         
                                                                                
         CALL SHIFT_CODE("88");        /*  SRL  */                              
      END;     /* OF CASE STATEMENT */                                          
                                                                                
      ELSE IF I = 10 THEN                                                       
         CALL EMIT_INLINE;                                                      
      ELSE IF I = 19 THEN    /*  BUILTIN  FUNCTION  ADDR   */                   
         DO;                                                                    
            REG(MP) = FINDAC;                                                   
            CALL FORCE_ADDRESS(MPP1,REG(MP));                                   
            TYPE(MP) = ACCUMULATOR;                                             
         END;                                                                   
      ELSE                                                                      
         DO;                                                                    
            CALL FORCEACCUMULATOR (MPP1);                                       
            IF CNT(MP) = 1 THEN REG(MP) = REG(MPP1);                            
            ELSE INX(MP) = REG(MPP1);                                           
         END;                                                                   
                                                                                
   END;     /* OF PRODUCTION */                                                 
                                                                                
 /*  <SUBSCRIPT HEAD> ::= <IDENTIFIER> (   */                                   
   DO;                                                                          
      CALL ID_LOOKUP(MP);                                                       
      IF FIXL(MP) < 0 THEN                                                      
         CALL UNDECLARED_ID(MP);                                                
   END;                                                                         
                                                                                
 /*  <SUBSCRIPT HEAD> ::= <SUBSCRIPT HEAD> <EXPRESSION> ,    */                 
   DO;      /* BUILT IN FUNCTION OR PROCEDURE CALL */                           
      CNT(MP) = CNT(MP) + 1;                                                    
      IF FIXV(MP) = 0 THEN                                                      
         DO;      /* ~ BUILT IN FUNCTION */                                     
            CALL FORCEACCUMULATOR (MPP1);                                       
            IF SYTYPE(FIXL(MP)) = LABELTYPE |                                   
               SYTYPE(FIXL(MP)) = CHAR_PROC_TYPE  THEN                          
               CALL STUFF_PARAMETER;                                            
         END;                                                                   
      ELSE IF FIXV(MP) = 2 | FIXV(MP) = 3 THEN                                  
         DO;      /* SUBSTR OR BYTE */                                          
            IF CNT(MP) = 1 THEN                                                 
               DO;                                                              
                  CALL FORCEDESCRIPT (MPP1);                                    
                  IF REG(MPP1) = 0 THEN                                         
                     DO;                                                        
                        REG(MP) = FINDAC;                                       
                        CALL EMITRR ("18", REG(MP), 0);                         
                     END;                                                       
                  ELSE REG(MP) = REG(MPP1);                                     
               END;                                                             
            ELSE IF CNT(MP) = 2 THEN                                            
               DO;                                                              
                  IF TYPE(MPP1) = CONSTANT THEN PPSAVE(MP) = FIXV(MPP1);        
                  ELSE                                                          
                     DO;                                                        
                        CALL FORCEACCUMULATOR (MPP1);                           
                        INX(MP) = REG(MPP1);                                    
                        PPSAVE(MP) = 0;                                         
                     END;                                                       
               END;                                                             
            ELSE CALL ERROR ('TOO MANY ARGUMENTS TO SUBSTR | BYTE');            
         END;                                                                   
      ELSE IF FIXV(MP) = 4 | FIXV(MP) = 5 THEN                                  
         DO;  /*  SHR  |  SHL  */                                               
            CALL FORCEACCUMULATOR(MPP1);                                        
            REG(MP) = REG(MPP1);                                                
         END;                                                                   
      ELSE IF FIXV(MP) = 10 THEN                                                
         CALL EMIT_INLINE;                                                      
      ELSE IF FIXV(MP) >= 8 THEN                                                
         DO;      /* SOME SORT OF MONITOR CALL */                               
            CALL FORCEACCUMULATOR (MPP1);                                       
            IF CNT(MP) = 1 THEN REG(MP) = REG(MPP1);                            
            ELSE CALL ERROR ('TOO MANY ARGUMENTS FOR ' || SYT(FIXL(MP)));       
         END;                                                                   
      ELSE;      /* RESERVED FOR OTHER BUILT IN FUNCTIONS */                    
   END;                                                                         
                                                                                
 /*  <CONSTANT> ::= <STRING>    */                                              
   TYPE(MP) = CHRTYPE;                                                          
                                                                                
 /*  <CONSTANT> ::= <NUMBER>    */                                              
   TYPE(MP) = CONSTANT;                                                         
                                                                                
   END;  /* OF CASE SELECTION ON PRODUCTION NUMBER */                           
END SYNTHESIZE;                                                                 
                                                                                
RECOVER: PROCEDURE;                                                             
 IF ~ RECOV THEN DO;                                                            
      RECOV=TRUE;                                                               
      IF NEXT > 0 THEN DO;                                                      
         TOKEN = NEXT;                                                          
         NEXT = 0;                                                              
         END;                                                                   
      DO WHILE ~STOPIT(TOKEN);                                                  
           CALL SCAN;                                                           
      END;                                                                      
 END;                                                                           
 ELSE IF SP>1 THEN DO;  /* RESTORE LOOK AHEAD STATE IF POSSIBLE */              
      SP=SP-1;                                                                  
      I = STATE_STACK(SP-1) ;                                                   
      IF TRANS(STATESTART(I),STATEEND(I),STATETOKEN(STATE_STACK(SP)))           
           THEN STATE_STACK(SP)= NEWSTATE ;                                     
      ELSE CALL ERROR(' FAILURE IN STATE RECOVERY',1);                          
 END;                                                                           
 ELSE IF NEXT > 0 THEN DO;                                                      
         TOKEN = NEXT;                                                          
         NEXT = 0;                                                              
         END;                                                                   
 ELSE CALL SCAN;                                                                
 OUTPUT= 'RESUME:' || SUBSTR(POINTER, TEXT_LIMIT+LB-CP+MARGIN_CHOP+7);          
 STATE#= STATE_STACK(SP) ;                                                      
END RECOVER;                                                                    
                                                                                
                                                                                
                                                                                
 COMPILATION_LOOP: PROCEDURE;                                                   
   DECLARE SYNTAX_ERROR CHARACTER INITIAL                                       
      (' IS NOT ACCEPTED AS A SCAN TOKEN: SYNTAX ERROR');                       
                                                                                
 DO WHILE COMPILING;                                                            
    DO CASE SHR( STATETYPE( SHR(STATE#,2)),SHL(3-STATE# &3,1)) &3;              
      COMPILING=FALSE; /* CASE 0 IS ACCEPT STATE. QUIT */                       
      DO;   /* CASE 1 IS REDUCE STATE.APPLY PRODUCTION STATE# */                
           COUNT#STACK = COUNT#STACK + 1;                                       
           MP= SP - STATESTART(STATE#) + 1 ; /* POINT TO LEFT END OF            
                                                 REDUCE STRING*/                
           MPP1=MP+1;                                                           
           CALL SYNTHESIZE(STATE#);                                             
           SP=MP;                                                               
           I= STATE_STACK(SP-1) ;                                               
           IF TRANS(STATEMIDDLE(I),STATEEND(I),STATEEND(STATE#)) THEN           
                   STATE_STACK(SP),STATE#= NEWSTATE;                            
              ELSE DO;                                                          
                   IF ~RECOV THEN DO;                                           
                   CALL ERROR(' SCANNED TOKEN ' || V(STATEEND(STATE#))          
                     || ' IS ILLEGAL IN STATE #' || STATE_STACK(SP-1),1);       
                   CALL DUMP ;                                                  
                   END;                                                         
                   CALL RECOVER;                                                
                   END;                                                         
      END;   /* OF CASE 1 */                                                    
      DO;   /* CASE 2. SCAN SCANSTOKEN TILL MATCH TOKEN */                      
           IF SP=STACKSIZE THEN DO;                                             
                CALL ERROR('*** STACK OVERFLOW. COMPILATION ABORTED',1);        
                RETURN;                                                         
           END;                                                                 
           IF TRANS(STATESTART(STATE#),STATEMIDDLE(STATE#)-1,TOKEN) THEN DO ;   
                     SP=SP+1;                                                   
                     VAR(SP)=BCD;                                               
                     FIXV(SP)= NUMBER_VALUE;                                    
                     FIXL(SP)=CARD_COUNT;                                       
                     PPSAVE(SP)=PP;                                             
                     RECOV=FALSE;                                               
                     IF NEXT = 0 THEN CALL SCAN;                                
                     ELSE DO;                                                   
                          TOKEN = NEXT;                                         
                          NEXT= 0;                                              
                          END ;                                                 
                     STATE_STACK(SP),STATE#= NEWSTATE;                          
           END;                                                                 
           ELSE DO;                                                             
                IF ~ RECOV THEN DO;                                             
                  CALL ERROR (V(TOKEN) || SYNTAX_ERROR, 1);                     
                  CALL DUMP;                                                    
                  END;                                                          
                CALL RECOVER;                                                   
           END;                                                                 
      END;   /* OF DO CASE 2.   */                                              
      DO;  /* CASE 3   LOOK-AHEAD STATE  */                                     
           J= STATESTART(STATE#);                                               
           /*  I IS LOOK-AHEAD TABLE POINTER  */                                
           DO I= LASTART(J) TO LASTART(J+1)-1;                                  
              IF TOKEN= LATOKENS(I) THEN DO ; /* MATCH FOUND */                 
                STATE#= LAGOTOS(I) ;                                            
                IF STATESTART(STATE#)= 0 THEN DO ;                              
                     COUNT#STACK = COUNT#STACK + 1;                             
                     MP = SP + 1 ;                                              
                     MPP1= MP + 1;                                              
                     CALL SYNTHESIZE(STATE#);                                   
                     NEXT= TOKEN ;                                              
                     TOKEN= STATEEND(STATE#);                                   
                     STATE#= STATE_STACK(SP) ;                                  
                     END ;                                                      
                ELSE STATE_STACK(SP)= STATE# ;                                  
                RECOV=FALSE;                                                    
                GO TO OUTLOOK;                                                  
           END;                                                                 
           END;                                                                 
           IF ~RECOV THEN DO;                                                   
                  CALL ERROR (V(TOKEN) || SYNTAX_ERROR, 1);                     
              CALL DUMP;                                                        
           END;                                                                 
           CALL RECOVER;                                                        
OUTLOOK: END;/* OF CASE 3 */                                                    
    END;   /* OF DO CASE STATEMIX(STATE#)  */                                   
 END;   /* OF DO WHILE COMPILING */                                             
 END COMPILATION_LOOP;                                                          
                                                                                
                                                                                
                                                                                
                                                                                
                                                                                
LOADER:                                                                         
   PROCEDURE;                                                                   
                                                                                
      /*  WRITE OUT A LOAD FILE OF COMPILED CODE & DATA                         
         ASSUMES CODE ON  FILE(CODEFILE, J)    J = 0 TO CODEMAX                 
         ASSUMES DATA ON  FILE(DATAFILE, J)   J = 0 TO DATAMAX                  
         ASSUMES STRINGS ON FILE(STRINGFILE,J)                                  
         OUTPUT  ON FILE(BINARYFILE, J)  J = 0 TO CODEMAX+DATAMAX+1             
         ASSUMES THAT BINARYFILE = CODEFILE    */                               
                                                                                
                                                                                
      /*  PUT SOME CONTROL INFORMATION IN THE FIRST 60 BYTES OF THE             
         FIRST BLOCK OF CODE.  CONSECUTIVE WORDS OF THIS CONTROL                
         INFORMATION CONTAIN:                                                   
                                                                                
            1  # OF BYTES OF PROGRAM                                            
            2  # OF BYTES OF DATA                                               
            3  # OF BLOCKS OF PROGRAM                                           
            4  # OF BLOCKS OF DATA                                              
            5  # OF BYTES PER BLOCK                                             
            6  # OF BYTES ACTUALLY FILLED IN THE LAST CODE BLOCK                
            7  # OF BYTES ACTUALLY FILLED IN THE LAST DATA BLOCK                
                                                                                
         THE FILE IS FORMATTED:                                                 
                                                                                
            1  CODEMAX+1 BLOCKS OF PROGRAM                                      
               (AND CONTROL INFORMATION AT HEAD OF FIRST BLOCK)                 
            2  DATAMAX+1 BLOCKS OF DATA AND STRINGS                             
      */                                                                        
                                                                                
      DECLARE (I, J) FIXED;                                                     
      DECLARE BLOCKCNT FIXED;  /* CUMMULATIVE BLOCK COUNTER DURING LOAD */      
                                                                                
      CONTROL(BYTE('E')) = FALSE;                                               
      EJECT_PAGE;                                                               
      DP = BASES(SBR);                                                          
      CALL FIXWHOLEDATAWORD (BASEDATA, DP);                                     
      DO I = 0 TO SHR(DSP,2);                                                   
         CALL EMITDATAWORD (DESC(I));                                           
      END;                                                                      
      CALL FIXWHOLEDATAWORD(BASEDATA+4, DP);                                    
                                                                                
      /* COPY COMPILED CHARACTER STRINGS TO THE PROGRAM DATA AREA */            
      CHPORG = 0;                                                               
      CHPLIM = DISKBYTES;                                                       
      FILE(STRINGFILE,CURSBLK) = STRINGS;    /* WRITE OUT CURRENT BLOCK */      
      CURSBLK = 0;                                                              
      STRINGS = FILE(STRINGFILE,CURSBLK);    /* READ IN FIRST BLOCK */          
                                                                                
      DO I = 0 TO CHP;                                                          
         IF I >= CHPLIM THEN                                                    
            DO;                                                                 
               CURSBLK = CURSBLK + 1;                                           
               STRINGS = FILE(STRINGFILE,CURSBLK);   /* READ IN NEXT BLOCK */   
               CHPORG = CHPORG + DISKBYTES;                                     
               CHPLIM = CHPLIM + DISKBYTES;                                     
            END;                                                                
         CALL EMITBYTE(STRINGS(I-CHPORG));                                      
      END;                                                                      
                                                                                
      CALL FIXWHOLEDATAWORD(BASEDATA+8, DP);                                    
                                                                                
      CALL INSERT_CODE_FIXUPS;                                                  
                                                                                
      CODE = FILE(CODEFILE,0);        /*  READ IN FIRST CODE RECORD  */         
                                                                                
      CODEMAX(1) = DISKBYTES*(CODEMAX+1);                                       
      CODEMAX(2) = DISKBYTES*(DATAMAX+1);                                       
      CODEMAX(3) = CODEMAX + 1;                                                 
      CODEMAX(4) = DATAMAX + 1;                                                 
      CODEMAX(5) = DISKBYTES;                                                   
      IF SEVERE_ERRORS > 0 THEN IF ~ CONTROL(BYTE('Z')) THEN                    
         DO;                                                                    
            CODE(60) = "07";                                                    
            CODE(61) = "FC";                                                    
            OUTPUT = '########  EXECUTION OF THIS PROGRAM WILL BE INHIBITED.';  
         END;                                                                   
      J = PP - CODEMAX(1) + DISKBYTES;    /*  PORTION ACTUALLY  USED  */        
      /* FORCES REMAINDER TO WORD BOUNDARY  */                                  
      J = (J + 3) & "FFFFFC";                                                   
      CODEMAX(6) = J;                                                           
        /* PORTION OF THE LAST DATA RECORD WHICH WAS ACTUALLY USED  */          
      CODEMAX(7) = (DP - CODEMAX(2) + DISKBYTES + 3) & "FFFFFC" ;               
                                                                                
                                                                                
      OUTPUT = '*  FILE CONTROL BLOCK  ' || CODEMAX(1) || X4 ||                 
         CODEMAX(2) || X4 || CODEMAX(3) || X4 || CODEMAX(4) || X4 ||            
         CODEMAX(5) || X4 || CODEMAX(6) || X4 || CODEMAX(7);                    
                                                                                
      FILE(BINARYFILE,0) = CODE;   /* WRITE FIRST RECORD TO BINARY FILE */      
                                                                                
      BLOCKCNT = CODEMAX + 1;                                                   
                                                                                
      FILE(DATAFILE,CURDBLK) = DATA;  /* WRITE OUT CURRENT DATA ARRAY */        
                                                                                
                                                                                
      /*  WRITE OUT THE COMPILE DATA ARRAY  */                                  
                                                                                
      DO J = 0 TO DATAMAX;                                                      
         DATA = FILE(DATAFILE,J);                                               
         FILE(BINARYFILE, BLOCKCNT)  =  DATA ;                                  
         BLOCKCNT = BLOCKCNT + 1;                                               
      END;                                                                      
                                                                                
      OUTPUT = '*  LOAD FILE WRITTEN.';                                         
                                                                                
   END LOADER;                                                                  
                                                                                
                                                                                
PRINT_SUMMARY:                                                                  
   PROCEDURE;                                                                   
      DECLARE I FIXED;                                                          
      CALL PRINT_DATE_AND_TIME ('END OF COMPILATION ', DATE, TIME);             
      OUTPUT = '';                                                              
      OUTPUT = CARD_COUNT || ' CARDS CONTAINING ' || STATEMENT_COUNT            
         || ' STATEMENTS WERE COMPILED.';                                       
      IF ERROR_COUNT = 0 THEN OUTPUT = 'NO ERRORS WERE DETECTED.';              
      ELSE IF ERROR_COUNT > 1 THEN                                              
         OUTPUT = ERROR_COUNT || ' ERRORS (' || SEVERE_ERRORS                   
            || ' SEVERE) WERE DETECTED.';                                       
      ELSE IF SEVERE_ERRORS = 1 THEN OUTPUT = 'ONE SEVERE ERROR WAS DETECTED.'; 
         ELSE OUTPUT = 'ONE ERROR WAS DETECTED.';                               
      IF PREVIOUS_ERROR > 0 THEN                                                
         OUTPUT = 'THE LAST DETECTED ERROR WAS ON LINE ' || PREVIOUS_ERROR      
            || PERIOD;                                                          
      OUTPUT = PP || ' BYTES OF PROGRAM, ' || DP-DSP-CHP || ' OF DATA, ' || DSP 
         || ' OF DESCRIPTORS, ' || CHP || ' OF STRINGS.  TOTAL CORE REQUIREMENT'
         || X1 || PP + DP || ' BYTES.';                                         
      IF CONTROL(BYTE('D')) THEN CALL DUMPIT;                                   
      DOUBLE_SPACE;                                                             
      CLOCK(3) = TIME;                                                          
      DO I = 1 TO 3;   /* WATCH OUT FOR MIDNIGHT */                             
         IF CLOCK(I) < CLOCK(I-1) THEN CLOCK(I) = CLOCK(I) +  8640000;          
      END;                                                                      
      CALL PRINT_TIME ('TOTAL TIME IN COMPILER   ', CLOCK(3) - CLOCK(0));       
      CALL PRINT_TIME ('SET UP TIME              ', CLOCK(1) - CLOCK(0));       
      CALL PRINT_TIME ('ACTUAL COMPILATION TIME  ', CLOCK(2) - CLOCK(1));       
      CALL PRINT_TIME ('POST-COMPILATION TIME    ', CLOCK(3) - CLOCK(2));       
      IF CLOCK(2) > CLOCK(1) THEN   /* WATCH OUT FOR CLOCK BEING OFF */         
      OUTPUT = 'COMPILATION RATE: ' || 6000*CARD_COUNT/(CLOCK(2)-CLOCK(1))      
         || ' CARDS PER MINUTE.';                                               
   END PRINT_SUMMARY;                                                           
                                                                                
MAIN_PROCEDURE:                                                                 
   PROCEDURE;                                                                   
      CLOCK(0) = TIME;  /* KEEP TRACK OF TIME IN EXECUTION */                   
      CALL INITIALIZATION;                                                      
                                                                                
      /* CLOCK(1) GETS SET IN GETCARD */                                        
      CALL COMPILATION_LOOP;                                                    
                                                                                
      CLOCK(2) = TIME;                                                          
      CALL LOADER;                                                              
                                                                                
      /* CLOCK(3) GETS SET IN PRINT_SUMMARY */                                  
      CALL PRINT_SUMMARY;                                                       
                                                                                
   END MAIN_PROCEDURE;                                                          
                                                                                
                                                                                
CALL MAIN_PROCEDURE;                                                            
RETURN SEVERE_ERRORS;                                                           
                                                                                
EOF EOF EOF                                                                     
