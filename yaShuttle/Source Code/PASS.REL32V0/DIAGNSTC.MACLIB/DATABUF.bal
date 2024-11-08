*/ Access:      Public Domain, no restrictions believed to exist.
*/ Filename:    DATABUF.bal
*/ Purpose:     This is a part of the HAL/S-FC compiler program.
*/ Reference:   TBD.
*/ Language:    Basic Assembly Language (BAL), IBM System/360.
*/ Contact:     The Virtual AGC Project (www.ibiblio.org/apollo).
*/ History:     2022-12-08 RSB  Suffixed filename with ".bal".
*/ Note:        Comments beginning */ in column 1 are from the Virtual AGC 
*/              Project. Comments beginning merely with * are from the original 
*/              Space Shuttle development.

         MACRO
         DATABUF
DATABUF  DSECT COMMON DATA BUFFER
LOCCNT   DS    F    CURRENT LOCATE COUNTER
AVULN    DS    A    ADDRESS OF VULNERABLE PAD ENTRY
CURFCB   DS    A    ADDRESS OF CURRENT FCB
PADADDR  DS    A    STARTING ADDRESS OF PAD
ACOMMTAB DS    A    ADDRESS OF COMMUNICATION AREA
ACURNTRY DS    A    ADDRESS OF CURRENT PAD ENTRY
ROOT     DS    A    ADDRESS OF ROOT FCB OF FCB TREE
SAVEXTPT DS    F    POINTER TO SYMBOL NODE EXTENT CELL
SAVFSYMB DS    H    FIRST SYMBOL OF BLOCK
SAVLSYMB DS    H    LAST SYMBOL OF BLOCK
NUMGETM  DS    H    NUMBER OF ENTRIES IN GETMAIN STACKS
NUMOFPGS DS    H    NUMBER OF PAGES IN CURRENT PAGING AREA
BASNPGS  DS    H    INITIAL NUMBER OF PAGES IN PAGING AREA
FCBSTKLN DS    H    NUMBER OF ENTRIES IN FCB STACKS
IOFLAG   DS    C    I/O IN PROGRESS INDICATOR
GETMFLAG DS    C    > 0 IMPLIES AUTO GETMAINS FOR FCBS
GOFLAG   DS    C    > 0 IMPLIES SUCCESSFUL INITIALIZATION
MODFLAG  DS    C    1   IMPLIES UPDAT MODE ACTIVE
ONEFCB   DS    C    > 0 IMPLIES ONLY ONE FCB KEPT
FIRST    DS    C    1   IMPLIES TAKE FIRST SYMBOL FOUND
         DS    2C   SPARE
TOTFCBLN DS    F    TOTAL AMOUNT OF FCB SPACE IN USE
RESERVES DS    F    GLOBAL (TOTAL) COUNT OF RESERVES
READS    DS    F    TOTAL NUMBER OF READS
WRITES   DS    F    TOTAL NUMBER OF WRITES
SLECTCNT DS    F    TOTAL NUMBER OF 'REAL' SELECTS
FCBCNT   DS    F    TOTAL NUMBER OF FCBS IN EXISTENCE
GETMSTK1 DS    A    ADDRESS OF GETMAIN ADDRESS STACK
GETMSTK2 DS    A    ADDRESS OF GETMAIN LENGTH STACK
FCBSTK1  DS    A    ADDRESS OF FCB AREA ADDRESS STACK
FCBSTK2  DS    A    ADDRESS OF FCB AREA LENGTH STACK
MAXSTACK DS    H    MAXIMUM NUMBER OF STACK ENTRIES
SDFVERS  DS    H    SDF VERSION NUMBER (OF SELECTED SDF)
APGEBUFF DS    A    ADDRESS OF PAGE BUFFER
ADECB    DS    A    ADDRESS OF DECB
ECB      DS    F    EVENT CONTROL BLOCK (DECB)
IOTYPE   DS    H    I/O TYPE (DECB)
IOLENGTH DS    H    NUMBER OF BYTES TO TRANSFER (DECB)
DCBADDR  DS    A    ADDRESS OF HALSDF DCB (DECB)
BUFLOC   DS    A    ADDRESS OF BUFFER AREA (DECB)
IOBADDR  DS    A    ADDRESS OF IOB (DECB)
         MEND
