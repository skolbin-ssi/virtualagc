### FILE="Main.annotation"
## Copyright:   Public domain.
## Filename:    ALARM_AND_ABORT.agc
## Purpose:     A section of Comanche revision 044.
##              It is part of the reconstructed source code for the
##              original release of the flight software for the Command
##              Module's (CM) Apollo Guidance Computer (AGC) for Apollo 10.
##              The code has been recreated from a copy of Comanche 055. It
##              has been adapted such that the resulting bugger words
##              exactly match those specified for Comanche 44 in NASA drawing
##              2021153D, which gives relatively high confidence that the
##              reconstruction is correct.
## Assembler:   yaYUL
## Contact:     Ron Burkey <info@sandroid.org>.
## Website:     www.ibiblio.org/apollo/index.html
## Mod history: 2020-12-03 MAS  Created from Comanche 51. Removed clearing of
##                              STATEFLG, REINTFLG, and NODOFLAG from POODOO.
##		2020-12-08 RSB	Added justifying annotation related to the change 
##				mentioned above.
##		2020-12-13 RSB	Incorporated feedback about the annotations.

## Page 1493
# THE FOLLOWING SUBROUTINE MAY BE CALLED TO DISPLAY A NON-ABORTIVE ALARM CONDITION.  IT MAY BE CALLED
# EITHER IN INTERRUPT OR UNDER EXECUTIVE CONTROL.
#
# CALLING SEQUENCE IS AS FOLLOWS:
#		TC	ALARM
#		OCT	NNNNN
#					(RETURNS HERE)

		BLOCK	02
		SETLOC	FFTAG7
		BANK

		EBANK=	FAILREG

		COUNT	02/ALARM

# ALARM TURNS ON THE PROGRAM ALARM LIGHT, BUT DOES NOT DISPLAY.

ALARM		INHINT

		CA	Q
ALARM2		TS	ALMCADR
		INDEX	Q
		CA	0
BORTENT		TS	L

PRIOENT		CA	BBANK
 +1		EXTEND
		ROR	SUPERBNK	# ADD SUPER BITS.
		TS	ALMCADR +1

LARMENT		CA	Q		# STORE RETURN FOR ALARM
		TS	ITEMP1

		CA	LOC
		TS	LOCALARM
		CA	BANKSET
		TS	BANKALRM

CHKFAIL1	CCS	FAILREG		# IS ANYTHING IN FAILREG
		TCF	CHKFAIL2	# YES TRY NEXT REG
		LXCH	FAILREG
		TCF	PROGLARM	# TURN ALARM LIGHT ON FOR FIRST ALARM

CHKFAIL2	CCS	FAILREG +1
		TCF	FAIL3
		LXCH	FAILREG +1
		TCF	MULTEXIT
		
FAIL3		CA	FAILREG +2
## Page 1494
		MASK	POSMAX
		CCS	A
		TCF	MULTFAIL
		LXCH	FAILREG +2
		TCF	MULTEXIT
		
PROGLARM	CS	DSPTAB +11D
		MASK	OCT40400
		ADS	DSPTAB +11D

MULTEXIT	XCH	ITEMP1		# OBTAIN RETURN ADDRESS IN A
		RELINT
		INDEX	A
		TC	1

MULTFAIL	CA	L
		AD	BIT15
		TS	FAILREG +2
		
		TCF	MULTEXIT

# PRIOLARM DISPLAYS V05N09 VIA PRIODSPR WITH 3 RETURNS TO THE USER FROM THE ASTRONAUT AT CALL LOC +1,+2,+3 AND
# AN IMMEDIATE RETURN TO THE USER AT CALL LOC +4.  EXAMPLE FOLLOWS,
#		CAF	OCTXX		ALARM CODE
#		TC	BANKCALL
#		CADR	PRIOLARM

#		...	...
#		...	...
#		...	...		ASTRONAUT RETURN
#		TC	PHASCHNG	IMMEDIATE RETURN TO USER.  RESTART
#		OCT	X.1		PHASE CHANGE FOR PRIO DISPLAY

		BANK	10
		SETLOC	DISPLAYS
		BANK

		COUNT	10/DSPLA
PRIOLARM	INHINT			# * * * KEEP IN DISPLAY ROUTINES BANK
		TS	L		# SAVE ALARM CODE

		CA	BUF2		# 2 CADR OF PRIOLARM USER
		TS	ALMCADR
		CA	BUF2 +1
		TC	PRIOENT +1	# * LEAVE L ALONE
-2SEC		DEC	-200		# *** DONT MOVE
		CAF	V05N09
		TCF	PRIODSPR

## Page 1495

		BLOCK	02
		SETLOC	FFTAG13
		BANK

		COUNT	02/ALARM
		
BAILOUT		INHINT
		CA	Q
		TS	ALMCADR
		
		TC	BANKCALL
		CADR	VAC5STOR
		
		INDEX	ALMCADR
		CAF	0
		TC	BORTENT
OCT40400	OCT	40400

		INHINT
WHIMPER		CA	TWO
		AD	Z
		TS	BRUPT
		RESUME
		TC	POSTJUMP	# RESUME SENDS CONTROL HERE
		CADR	ENEMA
		
		SETLOC	FFTAG7
		BANK
		
POODOO		INHINT
		CA	Q
		TS	ALMCADR

		TC	BANKCALL
		CADR	VAC5STOR	# STORE ERASABLES FOR DEBUGGING PURPOSES.
		
		INDEX	ALMCADR
		CAF	0
ABORT2		TC	BORTENT
OCT77770	OCT	77770		# DONT MOVE
		CA	V37FLBIT	# IS AVERAGE G ON
		MASK	FLAGWRD7
		CCS	A
		TC	WHIMPER -1	# YES.  DONT DO POODOO.  DO BAILOUT.

## <b>Reconstruction:</b>  At this point in COMANCHE 51, there's a sequence of
## instructions which have been removed in COMANCHE 44, namely:<br>
## <pre>
##    TC DOWNFLAG
##    ADRES STATEFLG
##    TC DOWNFLAG
##    ADRES REINTFLG
##    TC DOWNFLAG
##    ADRES NODOFLAG
## </pre>
## This removal is justified by the document 
## <a href="http://www.ibiblio.org/apollo/Documents/Programmed%20Guidance%20Equations%20for%20Colossus%202.pdf#page=43">
## <i>Programmed Guidance Equations for COLOSSUS 2, p. GENP-23</i></a>, which indicates &mdash;
## via the change bars in the pseudocode<br>
## <pre>
##    Set bit 5(STATEFLG) of FLAGWRD3 = 0
##    Set bit 7(INTGRAB) of RASFLAG = 0  (i.e., FLGWRD10)
##    Set bit 1(NODOV37) of FLAGWRD2 = 0
## </pre>
## in POODOO &mdash; that these instructions were added some time between COMANCHE 45/2 and COMANCHE 51.
## As far as the differences in naming between the assembly language and the pseudocode are concerned
## &mdash; i.e., REINTFLG vs INTGRAB and NODOFLAG vs NODOV37 &mdash;
## the ERASABLE ASSIGNMENTS log section of COMANCHE 55 defines REINTFLG as bit 7 of flagword 10
## and NODOFLAG as bit 1 of flagword 2, so the differing names clearly refer to the identical
## flags.

## Page 1496
		TC	BANKCALL
		CADR	MR.KLEAN
		TC	WHIMPER
		
CCSHOLE		INHINT
		CA	Q
		TS	ALMCADR
		TC	BANKCALL
		CADR	VAC5STOR
		CA	OCT1103
		TC	ABORT2
OCT1103		OCT	1103
CURTAINS	INHINT
		CA	Q
		TC	ALARM2
OCT217		OCT	00217
		TC	ALMCADR		# RETURN TO USER

DOALARM		EQUALS	ENDOFJOB

# CALLING SEQUENCE FOR VARALARM
#
#		CAF	(ALARM)
#		TC	VARALARM

# VARALARM TURNS ON PROGRAM ALARM LIGHT BUT DOES NOT DISPLAY

VARALARM	INHINT

		TS	L		# SAVE USERS ALARM CODE

		CA	Q		# SAVE USERS Q
		TS	ALMCADR

		TC	PRIOENT
OCT14		OCT	14		# DONT MOVE

		TC	ALMCADR		# RETURN TO USER

ABORT		EQUALS	BAILOUT		# *** TEMPORARY UNTIL ABORT CALLS OUT
