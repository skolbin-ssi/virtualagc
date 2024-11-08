.*********************************************************************/
.*-------------------------------------------------------------------*/
.*                                                                   */
.*   NAME:       ACALL                                               */
.*                                                                   */
.*-------------------------------------------------------------------*/
.*                                                                   */
.*   FUNCTION:   CALLS THE PROCEDURE ROUTINE "NAME"   VALID ONLY     */
.*               IN A PROCEDURE ROUTINE DEFINED WITH ACALL=YES       */
.*                                                                   */
.*-------------------------------------------------------------------*/
.*                                                                   */
.*   INVOKED BY: ACALL <NAME>                                        */
.*                                                                   */
.*-------------------------------------------------------------------*/
.*                                                                   */
.*   PARAMETERS:                                                     */
.*                                                                   */
.*      NAME     ROUTINE NAME TO CALL                                */
.*                                                                   */
.*-------------------------------------------------------------------*/
.*                                                                   */
.*   COMMENTS:  IF ACALL <NAME> IS USED IN <ROUTINE>, THEN           */
.*              <ROUTINE> MUST HAVE THE OPTION:                      */
.*                                                                   */
.*                 <ROUTINE>    AMAIN  ACALL=YES                     */
.*                                                                   */
.*-------------------------------------------------------------------*/
.*                                                                   */
.*   REVISION HISTORY:                                               */
.*                                                                   */
.*     DATE      CCR#/CDR#  NAME  DESCRIPTION                        */
.*     --------  ---------  ----  -------------------------------    */
.*     09/08/89  CCR00006   JAC   MERGE BFS AND PASS MACROS          */
.*     12/29/96  CCR11148   JCS   CHANGE RTL TO RTL CALLING STRUCTURE*/
.*                                                                   */
.*********************************************************************/
.*
         MACRO                                                          00000100
&NAME    ACALL &P                                                       00000200
         GBLB  &CALLOK                                                  00000300
&QCON    SETC  '#Q'.'&P'                                                00000310
         AIF   (&CALLOK).CALL                                           00000400
         MNOTE 12,'ACALL OPTION NOT SPECIFIED IN AMAIN OR INTSIC=YES SPX00000500
               ECIFIED'                                                 00000600
         MEXIT                                                          00000700
.CALL    AIF   (D'&QCON).SKIP                                           00000800
         EXTRN #Q&P                                                     00000900
.SKIP    ANOP                                                           00001000
&NAME    DC  X'D0FF'          CALL PROCEDURE ROUTINE                    00001100
         DC  Y(#Q&P+X'3800')  INDIRECTLY THRU QCON                      00001110
         MEND                                                           00001200
