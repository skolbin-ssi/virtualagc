'''
License:    The author (Ronald S. Burkey) declares that this program
            is in the Public Domain (U.S. law) and may be used or 
            modified for any purpose whatever without licensing.
Filename:   asciiToEbcdic.py
Purpose:    A table for converting ASCII characters to EBCDIC.  Only
            printable characters are converted
Requires:   Python 3.6 or later.
Reference:  http://www.ibibio.org/apollo/Shuttle.html
Mods:       2024-04-27 RSB  Began

I had perfectly satisfactorily (I thought!) been using the string method
`encode` for this conversion, a la
    ebcdicBytearray = asciiString.encode("cp1140");
However, there are boundary cases that don't work -- the ASCII character '~'
is one I know about -- that get translated wrong, at least for my purposes.
(I want it to be translated to 0x5F, "logical NOT", but it gets translated to
0xA1.)  Rather than trapping these individual cases as I discover them, it 
seems easier to me to just use the `asciiToEbcdic` conversion table from my
runtimeC.c file.  At least, I'm guaranteed that the compiler is doing the same
thing as the runtime.
'''

# Make sure this table remains identical to the table of the same name in 
# runtimeC.c!
asciiToEbcdic = [
  0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, #              
  0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, #              
  0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, #              
  0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, #              
  0x40, 0x5A, 0x7F, 0x7B, 0x5B, 0x6C, 0x50, 0x7D, #  !"#$%&'     
  0x4D, 0x5D, 0x5C, 0x4E, 0x6B, 0x60, 0x4B, 0x61, # ()*+,-./     
  0xF0, 0xF1, 0xF2, 0xF3, 0xF4, 0xF5, 0xF6, 0xF7, # 01234567     
  0xF8, 0xF9, 0x7A, 0x5E, 0x4C, 0x7E, 0x6E, 0x6F, # 89:;<=>?     
  0x7C, 0xC1, 0xC2, 0xC3, 0xC4, 0xC5, 0xC6, 0xC7, # @ABCDEFG     
  0xC8, 0xC9, 0xD1, 0xD2, 0xD3, 0xD4, 0xD5, 0xD6, # HIJKLMNO     
  0xD7, 0xD8, 0xD9, 0xE2, 0xE3, 0xE4, 0xE5, 0xE6, # PQRSTUVW     
  0xE7, 0xE8, 0xE9, 0xBA, 0xE0, 0xBB, 0x5F, 0x6D, # XYZ[\]^_     
  0x4A, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87, # `abcdefg     
  0x88, 0x89, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, # hijklmno     
  0x97, 0x98, 0x99, 0xA2, 0xA3, 0xA4, 0xA5, 0xA6, # pqrstuvw     
  0xA7, 0xA8, 0xA9, 0xC0, 0x4F, 0xD0, 0x5F, 0x40  # xyz{|}~      
]
