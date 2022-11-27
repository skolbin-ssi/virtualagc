### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	T4RUPT_OUTPUT_CONTROL_PROGRAMS.agc
## Purpose:	Part of the source code for Solarium build 55. This
##		is for the Command Module's (CM) Apollo Guidance
##		Computer (AGC), for Apollo 6.
## Assembler:	yaYUL --block1
## Contact:	Jim Lawton <jim DOT lawton AT gmail DOT com>
## Website:	www.ibiblio.org/apollo/index.html
## Mod history:	2009-10-02 JL	Created.
##		2016-08-18 RSB	Typo.
##		2016-08-23 RSB	More of the same.
## 		2016-12-28 RSB	Proofed comment text using octopus/ProoferComments,
##				and fixed errors found.

		BANK	1
T4RUPT		CAF	ZERO		# ALONSO THINKS THIS SHOULD BE TURNED OFF
		TS	OUT0		# EVERY 60 MS AS A MATTER OF COURSE.
		CCS	DSRUPTSW	# SEE IF THIS IS A SPECIAL RUPT TO
		TC	REGRUPT +1	# ZERO OUT0 20MS AFTER IT WAS DRIVEN BY
		TC	REGRUPT		# DSPOUT. IF SO, DSRUPTSW IS NNZ.
		
		AD	ONE		# RESTORE DSRUPTSW TO ITS POSITIVE VALUE.
		TS	DSRUPTSW
		
		CAF	40MSRUPT	# SET TIME4 TO INTERRUPT 40 MS FROM NOW.
		TS	TIME4		# RE-ESTABLISHING THE REGULAR 60 MS
		TC	NBRESUME	# PATTERN. THEN DO NO-BANK-SWITCH RESUME.
		
REGRUPT		CAF	SEVEN		# REGULAR 60 MS RUPT - COUNT DOWN ON
 +1		TS	DSRUPTSW	# DSRUPTSW.
		
		CAF	LT4RUPTA	# CALL IN APPROPRIATE BANK.
		XCH	BANKREG		# SAVE BANKREG FOR RESUME.
		TS	BANKRUPT
		TC	T4RUPTA

LT4RUPTA	CADR	T4RUPTA

40MSRUPT	OCT	37774		# INTERRUPT IN 40 MS.


# RELTAB IS A PACKED TABLE. RELAYWORD CODE IN UPPER 4 BITS, RELAY CODE
# IN LOWER 5 BITS.

RELTAB		OCT	04025
		OCT	10003
		OCT	14031
		OCT	20033
		OCT	24017
		OCT	30036
		OCT	34034
		OCT	40023
		OCT	44035
		OCT	50037
		OCT	54000
RELTAB11	OCT	60000
		OCT	64000
		OCT	70000		# ALSO USEFUL AS A BANK-SWITCHING MASK.

#	SWITCHED-BANK PORTION OF T4RUPT.

		BANK	10
T4RUPTA		XCH	OVCTR		# SAVE OVCTR.
		TS	OVRUPT
		
		CAF	60MSRUPT	# T4 NORMALLY INTERRUPTS EVERY 60 MS.
		TS	TIME4
		
DSKYON		CCS	CDUIND		# DO AN IMU-CDU IF DESIRED.
		TC	DOIMUCDU +1	# WITH NEW CDUIND IN A.
		TC	DOIMUCDU	# SET COUNT TO 2.
		
		TC	DSRUPTBR	# NO CDU. NNZ MEANS CDUS ARE RESERVED.
		TC	DSRUPTBR	# -0 MEANS THEY ARE AVAILABLE.


#	T4RUPT IMU CDU DRIVE - SERVICED EVERY 60 MS.

DOIMUCDU	CAF	TWO		# SET CDUIND BACK TO 2.
 +1		TS	CDUIND
		
		XCH	LP		# SAVE LP FOR IMU CDU DRIVE ONLY.
		TS	LPRUPT
		
		INDEX	CDUIND		# 0 FOR X, 1 FOR Y, AND 2 FOR Z.
		CS	THETAD		# PICK UP DESIRED ANGLE.
		COM
		TS	ITEMP2
		
		INDEX	CDUIND
		CS	CDUX		# READ AND SAVE CDU COUNTER.
		TC	2SCOMDIF	# DIFFERENCE WITH -0 UNEQUAL TO +0.
		
		EXTEND			# RETURNS WITH DIFFERENCE IN A.
		MP	KG
		INDEX	CDUIND
		XCH	COMMAND
		EXTEND
		MP	KH
		INDEX	CDUIND
		AD	COMMAND
		INDEX	CDUIND
		TS	COMMAND
		TS	ITEMP1		# COMMAND TO TEMP STORAGE
		CCS	A		# CHECK SIGNUM OF COMMAND
		TC	POSCOM2
		TC	CDURSM
		TC	NEGCOM2
		TC	CDURSM

NEGCOM2		TS	ITEMP1		# SAVE CCS OF COMMAND.
		CS	CDUIND		# USE NEGATIVE TO SELECT OUT2 PATTERN.
		TC	CDUOUT
		
POSCOM2		TS	ITEMP1		# SAME AS ABOVE EXCEPT 1+CDUIND SELECTS.
		CAF	ONE
		AD	CDUIND
		
CDUOUT		TS	Q
		CAF	LOW8		# INTERRUPT OUT2 PULSES DURING OUT
		MASK	OUT2		#  OUT2 MODIFICATION.
		TS	OUT2
		
		CS	ITEMP1		# FORM 1.0 - ABS(COMMAND).
		AD	POSMAX
		TS	OUTCR1
		
		INDEX	Q
		CAF	CDUCODES +2
		AD	OUT2
		TS	OUT2

CDURSM		CAF	ONE		# RESTORE LP.
		EXTEND
		MP	LPRUPT


#	BRANCH ACCORDING TO DSRUPTSW  AND PERFORM THE APPROPRIATE DSRUPT FUNCTIONS.

DSRUPTBR	INDEX	DSRUPTSW	# JUMP ON DSRUPTSW.
		TC	+1
		TC	TMCHECK		# =0
		TC	CDRVE		# =1
		TC	TMCHECK		# =2
		TC	CDRVE		# =3
		TC	TMCHECK		# =4
		TC	OPTTEST		# =5	SERVICE OPTICS CDUS.
		TC	TMCHECK		# =6


#	SYSTEM FAILURE INPUT BITS MONITOR - ENTERED EVERY 480 MS BY T4RUPT.

ERRORMON	CCS	OLDERR		# IGNORE BITS IF C(OLDERR) = 40000
		TC	ERRMON		# ORDINARILY POSITIVE.
		TC	ERRMON
		TC	ENDT4ERR
		
ERRMON		XCH	IN2		# REFRESH LAST-SAMPLED-ERRORS REGISTER.
		XCH	IN2
		MASK	ERRMASK
		XCH	OLDERR
		COM
		AD	OLDERR
		CCS	A
		TC	ERRCHANG	# CHANGED.
ERRMASK		OCT	07000		# IMU, CDU, AND PIPA FAIL.
		TC	ERRCHANG
		TC	ENDT4ERR	# EXIT - NO CHANGE HAS TAKEN PLACE.
		
ERRCHANG	CAF	LITESOUT
		MASK	DSPTAB +11D
		AD	BIT15		# TO INDICATE CHANGE.
		TS	DSPTAB +11D
		
		CAF	TWO		# TURN ON LIGHTS ACCORDING TO C(OLDERR).
ERRSCAN		TS	ITEMP2
		INDEX	A
		CAF	BIT12		# SELECT BIT IN OLDERR.
		MASK	OLDERR
		CCS	A
		TC	BITON		# BIT IS PRESENT.
		
ERRSCAN3	CCS	ITEMP2		# LOOP THREE TIMES THROUGH.
		TC	ERRSCAN
		
		TC	ENDT4ERR	# FINISHED.
		
LITESOUT	OCT	37437


#	PROCESS ERROR SIGNALS PRESENT. NOTE THAT C(WASKSET) INDICATES THE STATE OF THE SYSTEM SINCE NO RELAYS
# HAVE BEEN SWITCHED IN THE LAST 120 MS, AND KSAMP WAS EXECUTED 60 MS AGO.

BITON		INDEX	ITEMP2		# 2, 1, OR 0.
		TC	+1
		TC	IMUFAIL
		TC	PIPAFAIL
		TC	CDUFAIL
		
IMUFAIL		CCS	WASKSET		# FAILURE NOT LEGITMATE IF IN COARSE ALIGN
		TC	IMUFAIL2	# PURSUE THIS ONE.
		TC	IMUFAIL3
		TC	IMUFAIL3
		
IMUFAIL3	CAF	BIT8		# TURN ON IMU FAIL LIGHT.
FAILITON	AD	DSPTAB +11D	# (WHICH HAD BEEN ZEROED IN ALL LIGHT
		TS	DSPTAB +11D	# POSITIONS).
		TC	ERRSCAN3	# PROCESS NEXT INPUT BIT.
		
IMUFAIL2	AD	ONE		# SEE IF COASE ALIGN ACHIEVED.
		MASK	BIT2
		CCS	A
		TC	ERRSCAN3
		TC	IMUFAIL3	# FAILED.
		
CDUFAIL		CCS	WASKSET
		TC	CDUFAIL2	# FAILURE ONLY IF IN FINE ALIGN.
		TC	CDUFAIL3
		TC	CDUFAIL3
		
CDUFAIL3	CAF	BIT6		# CDU FAIL LIGHT ON.
		TC	FAILITON
		
		AD	ONE
		MASK	BIT1
		CCS	A
		TC	ERRSCAN3
		TC	CDUFAIL3

PIPAFAIL	CAF	BIT7		# TURN ON FAIL LIGHT UNCONDITIONALLY.
		TC	FAILITON

NOOPTCDU	EQUALS	CDRVE
ENDT4ERR	EQUALS	CDRVE


#	OPTICS CDU DRIVING PROGRAM, SERVICED EVERY 480 MS BY DSRUPT.

OPTTEST		CCS	OPTIND		# PNZ FOR ACTIVE, NEGATIVE FOR INACTIVE.
		TC	+5		# DRIVE CDU.
		TC	+3		# DRIVE CDU.
		TC	NOOPTCDU	# NNZ MEANS RESERVED.
		TC	NOOPTCDU	# -0 MEANS AVAILABLE. 
		
 +3		CAF	ONE		# GOES 1(-1)0.
 +5		TS	OPTIND

		TS	RUPTREG1	# SET UP OUT2SUB TO START OUT-COUNTER.
		CAF	ONE		# (TO ADDRESS OUTCR2).
		TS	RUPTREG2
		
		CCS	OPTIND		# DRIVE OPTICS Y DIFFERENT THAN OTHERS.
		TC	BLIVOT3		# OVF UNCORRECTION WONT WORK FOR OPTY.
		
		AD	DESOPTX		# DESIRED ANGLES.
		TS	ITEMP2
		
		INDEX	OPTIND
		CS	OPTX		# READ COUNTER.
		TC	2SCOMDIF	# TAKES DIFFERENCE WITH -0 UNEQUAL TO +0.
		
OPTOUT		TC	OUT2SUB

#	CDRVE  CHANGES A BANK OF C RELAYS IF ANY CHANGE IS INDICATED IN THE C-RELAY PORTION OF DSPTAB.

CDRVE		CCS	DSPTAB +11D	# IMU AND CAUTION LIGHTS.
		TC	CDRVE1
		TC	CDRVE1
		
		XCH	DSPTAB +11D
		MASK	LOW11
		TS	DSPTAB +11D
		AD	RELTAB11
		TC	DSPLAYC
		
CDRVE1		CCS	DSPTAB +12D	# OPTICS.
		TC	CDRVE2
		TC	CDRVE2
		
		XCH	DSPTAB +12D
		MASK	LOW11
		TS	DSPTAB +12D
		AD	RELTAB11 +1
		TC	DSPLAYC
		
CDRVE2		CCS	DSPTAB +13D	# SPACECRAFT RELAYS.
		TC	DSPOUT
		TC	DSPOUT
		
		XCH	DSPTAB +13D
		MASK	LOW11
		TS	DSPTAB +13D
		AD	RELTAB11 +2
		TC	DSPLAYC
		
DSPOUT		CCS	NOUT		# ENTERED IN INTERRUPTED STATE AT END OF
		TC	+2		# 			  DSRUPT
		TC	LVDSRUPT
		TS	NOUT
		CS	ZERO
		TS	DSRUPTEM	# SET TO -0 FOR 1ST PASS THRU DSPTAB
		XCH	DSPCNT
		AD	NEG0		# TO PREVENT +0
		TS	DSPCNT
DSPSCAN		INDEX	DSPCNT
		CCS	DSPTAB
		CCS	DSPCNT		# IF DSPTAB ENTRY +, SKIP
		TC	DSPSCAN -2	# IF DSPCNT +, AGAIN
		TC	DSPLAY		# IF DSPTAB ENTRY -, DISPLAY
TABLNTH		OCT	12		# DEC 10   LENGTH OF DSPTAB
		CCS	DSRUPTEM	# IF DSRUPTEM=+0,2ND PASS THRU DSPTAB
		LOC	+1		# (DSPCNT=0). +0 INTO NOUT, RESUME.
		TS	NOUT
		TC	LVDSRUPT
		TS	DSRUPTEM	# IF DSRUPTEM=-0,1ST PASS THRU DSPTAB
		CAF	TABLNTH		# (DSPCNT=0). +0 INTO DSRUPTEM. PASS AGAIN
		TC	DSPSCAN -1
		
DSPLAY		AD	ONE
		INDEX	DSPCNT
		TS	DSPTAB		# REPLACE POSITIVELY
		MASK	LOW11		# REMOVE BITS 12 TO 15
		TS	DSRUPTEM
		CAF	HI5
		INDEX	DSPCNT
		MASK	RELTAB		# PICK UP BITS 12 TO 15 OF RELTAB ENTRY
		AD	DSRUPTEM
DSPLAYC		TS	OUT0
		TS	DISPBUF
		CAF	20MSRUPT	# SET T4 TO INTERRUPT IN 20 MS SO OUT0 MAY
		TS	TIME4		# BE TURNED OFF AS SOON AS POSSIBLE. WHEN
		CS	DSRUPTSW	# THIS RUPT OCCURS, T4 IS RESET TO FIRE
		TS	DSRUPTSW	# IN 40MS, RE-ESTABLISHING THE REGULAR 60.
		
		TC	LVDSRUPT

LVDSRUPT	EQUALS	OVRESUME


#	OUT2SUB IS USED BY THE GYRO DRIVE AND THE OPTICS CDU DRIVE TO SET THE PROPER SECTION OF OUT2 AND THE
# PROPER OUT-COUNTER TO DELIVER THE COMMAND ARRIVING IN A.

OUT2SUB		TS	ITEMP1		# SIGNED COMMAND.
		XCH	Q
		TS	ITEMP2
		CCS	ITEMP1
		TC	POSCOM
		TC	ITEMP2		# RETURN TO CALLER ON EITHER ZERO.
		TC	NEGCOM
		TC	ITEMP2
		
NEGCOM		TS	ITEMP1		# CCS OF COMMAND LEFT IN ITEMP1
		CS	RUPTREG1	# 0 AND 1 FOR OPTICS - 2, 3, AND 4 FOR GYR
		TC	SETOUT2
		
POSCOM		TS	ITEMP1		# CCS OF COMMAND.
		CAF	ONE
		AD	RUPTREG1
		

SETOUT2		TS	Q
		INDEX	RUPTREG2
		CAF	LOW8
		MASK	OUT2
		TS	OUT2

		CS	ITEMP1		# ABS(COMMAND) - 1.
		AD	POSMAX		# FORMS 1.0 - ABS(COMMAND).
		INDEX	RUPTREG2
		TS	OUTCR1
		
		INDEX	Q		# ENABLE THE APPROPRIATE OUTCR BY SETTING
		CAF	OPTCODES +1	# THE PROPER CODE IN OUT2
		AD	OUT2
		TS	OUT2
		
		TC	ITEMP2
		
# ALTERNATE 120 MS LEG OF T4RUPT.

TMCHECK		CAF	SEVEN		# ALLOW UP TO SEVEN TM WORDS UNTIL NEXT
		XCH	TELCOUNT	# DSRUPT0 EXECUTION. CHECK LAST TM PERIOD
		AD	NEG7		# TO SEE IF AT LEAST ONE WORD WENT OUT.
		CCS	A		# THIS SATISFIES BOTH HIGH- AND LOW-POWER.
		
NEG7		DEC	-7
		LOC	+1
		TC	+2		# OK - PROCEED.
		TC	TMFAIL		# TURN ON TM FAIL LIGHT BEFORE KSAMP.
		
MODESAMP	XCH	IN3		# SAMPLE MODE BITS AND TUCK THEM AWAY
		XCH	IN3		# FOR KSAMP AND OPTSAMP.
		TS	KSAMPTEM
		MASK	LOW7
		XCH	KSAMPTEM
		MASK	OPTBITS
		TS	OSAMPTEM
		XCH	IN0		# THIS CLEARS THE KEY CODE WITHIN 120MS
					#  OF THE TIME THE KEY WAS RELEASED.
		
		MASK	BIT7
		TS	OVCTR		# SEE IF INHIBIT UP-SYNC BIT IS ON.
		CCS	A
		TC	TMFAIL		# IF SO, TURN ON TELEMETRY FAIL LIGHT.
		
		CCS	OVCTR		# SEE IF MARK BUTTON DOWN.
		TC	OPTSAMP
		TC	OPTSAMP
		TC	+1
		CAF	NOMKACPT	# DONT INCLUDE MARK ACCEPT INFORMATION.
		MASK	OSAMPTEM
		TS	OSAMPTEM
		

#	OPTICS MODE SAMPLING.

OPTSAMP		CCS	DESOPSET	# IS COMPUTER COMMANDING
		TC	OPTCOMM		# YES
		TC	NOOPCOM		# NO
		
		CAF	BIT12		# MAKE SURE WE ARE STILL ZEROING
		MASK	OSAMPTEM	# (THIS PORTION ENTERED FOR 30 SEC. DURING
		AD	WASOPSET	#    MANUAL OPTICS ZERO).
		MASK	BIT12		# SEE IF CDU-ZERO BIT HAS CHANGED.
		CCS	A		# ALARM IF SO.
		TC	+2
		TC	LVOPTSMP
		
		TC	ALARM		# IF NOT, ALARM ON
		OCT	00101		# OPTICS ALARM NO. 1.
		TC	LVOPTSMP
		
OPTCOMM		CAF	BIT14		# SEE IF COMPUTER-ON SWITCH JUST CHANGED.
		MASK	WASOPSET	# FORM WAS BIT14 - IS BIT14.
		TS	Q
		CAF	BIT14
		MASK	OSAMPTEM	# PRESENT INPUT BITS.
		COM
		AD	Q
		CCS	A
		TC	COMP.OFF	# SWITCH JUST TURNED OFF.
OFFMASK		OCT	34760		# USED FOR SETTING IMU C-RELAYS.
		TC	COMP.ON		# SWITCH JUST TURNED ON.

OPTCOMM2	CS	DESOPSET	# SEE IF DESIRED MODE ACHIEVED.
		AD	OSAMPTEM
		CCS	A
		TC	OPTCTEST	# COMMAND NOT EQUAL TO ACTUAL
OPTBITS		OCT	35000
		TC	OPTCOMM3	# NO MATCH - SEE IF COMP ON ONLY MISMATCH.
		
OPTCTEST	CCS	DSPTAB +12D	# IS CHANGE COMING.
		TC	OPTCFAIL	# NO - C-RELAY FAILURE OR UNWANTED MANUAL
		TC	OPTCFAIL	# INTERVENTION.
		
		CAF	ZERO		# LEAVE WAITING FLAG IN WASOPSET.
		TC	LVOPTSMP +1
		
OPTCOMM3	AD	-BIT14+1	# NO ERROR IF COMPUTER-ON ONLY ONE DIFF.
		CCS	A
		TC	OPTCTEST
NOMKACPT	OCT	31000
		TC	OPTCTEST
		CAF	BIT14		# IN THIS CASE, SET COMP.ON BIT TO 1 IN
		AD	OSAMPTEM	# WASOPSET TO PREVENT +0 FOR CORRECT MODES
		TC	LVOPTSMP +1
		
COMP.OFF	CCS	OPTIND		# TAKE AGC OUT OF CDU LOOP IF APPROPRIATE.
		TC	+2
		TC	+1		# POSITIVE MEANS COMPUTER WAS IN LOOP.
		CAF	ONE		# LEAVE CDUS RESERVED (RARE).
		COM			# -0 REVERTS TO -0.
		TS	OPTIND
		
		TC	OPTCOMM2	# DO MODE CHECK.
		
COMP.ON		CCS	OPTIND		# PUT AGC BACK INTO CDU LOOP IF DESIRED.
		TC	ONALARM		# (THIS SHOULD NEVER HAPPEN).
		TC	ONALARM
		TC	ONOK		# CDUS HAD BEEN RESERVED.
		
ONALARM		TC	OFAILTST	# SEE IF FAIL FLAG ALREADY SET.
		TC	ALARM		# ALARM AND SET FAILURE FLAG.
		OCT	00104
		TC	OFAILSET
		
OPTCFAIL	TC	OFAILTST	# SEE IF ALARM ALREADY SOUNDED.
		TC	ALARM		# ALARM AND SET FAIL FLAG IF NOT.
		OCT	00102
		
OFAILSET	CS	ZERO
		TC	LVOPTSMP +1	# SET FAIL FLAG AND EXIT.
		
OFAILTST	CCS	WASOPSET	# RETURNS TO CALLER IF NO FAILURE ALARM
		TC	Q		# GIVEN. EXITS WITHOUT CHANGING WASOPSET
		TC	Q		# IF SO.
		TC	NOOPRSET
		TC	NOOPRSET

NOZALARM	TC	ALARM
		OCT	00103
		TC	RECONTRK
		
ONOK		TS	OPTIND		# SET OPTIND TO +0 TO ACTIVE CDU DRIVE.
		TC	OPTCOMM2	# DO MODE AGREEMENT CHECK.
		
NOOPCOM		CS	WASOPSET	# ENTERS HERE IF COMPUTER NOT COMMANDING.
		AD	OSAMPTEM	# SEE IF ANY CHANGES SINCE LAST LOCK.
		CCS	A
		TC	NOOPCOM1	# CHANGED.
60MSRUPT	OCT	37772		# UNUSED CCS BRANCH.
		TC	NOOPCOM1	# CHANGED.
		TC	LVOPTSMP	# NO CHANGE - NORMAL EXIT IN MANUAL.
		
NOOPCOM1	CS	WASOPSET	# SEE IF MANUAL CDU-ZERO JUST REQUESTED.
		MASK	BIT12
		MASK	OSAMPTEM
		CCS	A
		TC	MANOPTZ		# CALL MANUAL OPTICS ZERO SUBROUTINE.
					# (THIS RECONCILES OPTICS-ZERO C-RELAY).

		CAF	BIT12
		MASK	OSAMPTEM
		CCS	A
		TC	RECONTRK
		CAF	BIT13
		MASK	OSAMPTEM
		AD	WASOPSET
		MASK	BIT13
		CCS	A
		TC	NOZALARM
		
# WE USED TO TEST HERE TO SEE IF THE SXT-ON SWITCH HAS CHANGED.
# SINCE IN BLOCK 50 - 100 IT IS ALWAYS ON, WE DON;T NOW.
RECONTRK	CAF	BIT10		# RECONCILE TRKR-ON C-RELAY.
		MASK	OSAMPTEM
		CCS	A
		CAF	BIT2		# TURN ON TRKR-ON C-RELAY.
		AD	BIT15
		XCH	DSPTAB +12D
		MASK	OCT37775	# CHANGE BITS 2 AND 15.
		AD	DSPTAB +12D
		TS	DSPTAB +12D
		
		XCH	OSAMPTEM	# SET WASOPSET AND CALL SETZLIT TO 
		TS	WASOPSET	# SET ZERO-ENCODER LIGHT. 
		TC	SETZLIT
		TC	NOOPRSET
		
LVOPTSMP	XCH	OSAMPTEM
		TS	WASOPSET
		
NOOPRSET	EQUALS			# DONT RESET WASOPSET.


# KSAMP		ENTERED EVERY 120 MS DURING T4RUPT. SAMPLES STATUS OF
# -----		IMU MODE SWITCHES.
#		SETS C(WASKSET)=C(DESKSET) FOR SUCCESSFUL COMP. COMM.
#			       =+0 FOR WAITING(START-UP,CONTACT BOUNCE)
#			       =-X FOR ASTRONAUT COMM. IGNORE
#			       =-0 FOR SYSTEM FAILURE



KSAMP		CCS	DESKSET		# C(DESKSET)=DESIRED K RELAY SETTING
		TC	KSAMP1		# 	    =+0 FOR COMPUTER NOT COMM.
		TC	KSAMP4		# 	    -DESIRED K SETTING FOR MAN 0.
		
		CAF	BIT1		# ENTERS HERE TO BE SURE MANUAL CDU ZERO
		MASK	KSAMPTEM	# LASTS AT LEAST 30 SEC.
		AD	WASKSET		# ALARM IF CDU-ZERO SWITCH CHANGED STATE.
		MASK	BIT1
		CCS	A
		TC	+2
		TC	LVKSAMP
		
		TC	ALARM
		OCT	00201		# CDU NOT ZEROED PROPERLY.
		TC	LVKSAMP
		
KSAMP4		XCH	KSAMPTEM	# NO COMPUTER COMMAND.
		XCH	WASKSET		# CURRENT STATUS TO WASKSET
		TS	KSAMPTEM	# (FOR EVENTUAL USE BY MANUAL ZERO TEST).
		CS	A
		AD	WASKSET
		CCS	A
		TC	KSAMP2B		# SEE IF TRNSW JUST ON AND IS ONLY CHANGE.
20MSRUPT	OCT	37776		# UNUSED CCS BRANCH - USED TO CAUSE 0 OUT0
		TC	KSAMP2
		TC	ENDKSAMP	# EXIT ON NO CHANGE IN MODE.
		
KSAMP2		CAF	BIT6		# CHANGE IN MODE
		MASK	WASKSET
		CCS	A		# IS TRNSW ON MANUAL
		TC	MODALARM
		
MANZTEST	CS	KSAMPTEM	# SEE IF MANUAL ZERO SWITCH JUST ON.
		MASK	BIT1
		MASK	WASKSET
		CCS	A
		TC	MANCDU		# MANUAL IMU CDU ZERO JUST REQUESTED.
		
PRERECON	CAF	OFFMASK		# MANUAL MODE CHANGE
		MASK	DSPTAB +11D	# SO THE C-RELAYS MUST BE UPDATED.
		AD	BIT15		# ALL ARE TURNED OFF AND THE RIGHT ONES
		TS	DSPTAB +11D	# ARE TURNED ON BY SCANNING IN3.
		
		CS	WASKSET		# UPDATE C-RELAYS SO THEY AGREE WITH THE
		DOUBLE			# CURRENT MODE. THE SCAN IS FROM LEFT TO
		XCH	SR		# RIGHT SO THE PILOTS BUTTON WORKS OK.
		TS	SRRUPT
		CAF	SIX	
		
RECONCIL	TS	KSAMPTEM
		CS	SR		# NEXT BIT INTO POSITION.
		MASK	BIT1
		CCS	A
		TC	SETC

		CCS	KSAMPTEM
		TC	RECONCIL

		TC	ALARM
		OCT	00203

		TC	LVRECON

KSAMP2B		AD	LOW5BAR		# NO ERROR IF TRNSW JUST ON IS ONLY CHANGE
		CCS	A
		TC	KSAMP2
LOW5BAR		OCT	-37
		TC	KSAMP2
		TC	ENDKSAMP	# ORIGINAL DIFFERENCE WAS JUST BIT 6.

MODALARM	TC	ALARM		# UN-CALLED-FOR MODE CHANGE WITH COMPUTER
		OCT	00204		# DOING MODE SWITCHING.
		TC	ENDKSAMP
		
SETC		INDEX	KSAMPTEM
		CAF	MODECHNG	# NEW IMU C-RELAY SETTINGS.
		AD	DSPTAB +11D
 +3		TS	DSPTAB +11D
		TC	SETZLIT		# UPDATE THE ZERO ENCODER LAMP.
LVRECON		XCH	SRRUPT
-BIT14+1	DOUBLE
		TS	SR
		TC	ENDKSAMP

KSAMP1		CS	DESKSET		# IS PRESENT MODE = COMMANDED
		AD	KSAMPTEM
		CCS	A
		TC	KSAMP1A
OCT37775	OCT	37775		# UNUSED CCS BRANCH - USED TO SET TRKR-ON.
		TC	KSAMP1A
		
LVKSAMP		XCH	KSAMPTEM	# YES
		TS	WASKSET
		TC	ENDKSAMP
		
KSAMP1A		CAF	BIT1		# IS COMPUTER TRYING TO ZERO CDU AND
		MASK	DESKSET		# GETTING COARSE ALIGN.
		DOUBLE
		MASK	KSAMPTEM
		CCS	A
		TC	IMUSTART	# YES.
		
KSAMP2A		CCS	WASKSET		# CHECK ON PREVIOUS ACTIVITIES
		TC	KSAMP3A		#  NORMAL OPERATION
		TC	KSAMP3A		# WAITING
		TC	ENDKSAMP	# SYSTEM FAILURE
		TC	ENDKSAMP	# SYSTEM FAILURE
		
KSAMP3A		CCS	DSPTAB +11D	# SEE IF BANK IS TO BE CHANGED.
		TC	SYSFAIL		# NO - SYSTEM FAILURE.
		TC	SYSFAIL
		
IMUSTART	CAF	WAITFLAG	# SET WAITING FLAG AND EXIT.
		TC	LVKSAMP +1
		
SYSFAIL		CS	ZERO		# IMU SYSTEM FAILURE.
		TS	WASKSET
		TC	ALARM		# CALL ALARM SUBROUTINE FOR DISPLAY.
		OCT	00202
		TC	ENDKSAMP
		
WAITFLAG	EQUALS	ZERO

ENDKSAMP	EQUALS	LVDSRUPT


#	MANUAL CDU-ZERO PROGRAMS FOR IMU AND OPTICS CDUS.

MANCDU		CS	TWO		# INITIATE MANUAL CDU ZERO MONITOR.
		TS	DESKSET		# (C-RELAYS WILL BE SET BY RECONCIL).
		CAF	40SECS		# FIXME
		TC	WAITLIST
		CADR	MANIZD
		
		TC	PRERECON
		
#	WAITLIST TASK TO COMPLETE MANUAL ZERO. TURNS OFF LIGHT TO INDICCATE COMPLETION.

MANIZD		TC	ZEROICTR	# ZERO COUNTERS.
		TS	DESKSET
		TC	SETZLIT		# TURN OFF LIGHT IF APPROPRIATE.
		TC	TASKOVER


#	MANUAL OPTICS ZEROING PROCEDURES.
MANOPTZ		CAF	60SECS		# MANUAL OPTICS ZEROING ROUTINE.
		TC	WAITLIST	# CALL WAITLIST FOR 60 SEC. WAIT
		CADR	MANOZD
		CS	TWO		# SET ZEROING FLAG IN DESOPSET.
		TS	DESOPSET
		CS	CSQ		# RECONCILE ZERO OPTICS C RELAY
		MASK	DSPTAB +12D
		AD	CSQ
		TS	DSPTAB +12D
		TC	RECONTRK
		
#	WAITLIST TASK TO COMPLETE MANUAL OPTICS ZERO.

MANOZD		CAF	ZERO
		TS	DESOPSET	# LEAVE MANUAL ZERO MONITOR
		TC	ZEROOCTR +1	# SET OPTICS COUNTERS.
		TC	SETZLIT		# TURN OFF LIGHT (POSSIBLY) AS SIGNAL.
		TC	TASKOVER

ZEROOCTR	CAF	ZERO
		TS	OPTX
		CAF	BIT13
		MASK	WASOPSET
		CCS	A
		CS	20DEGS
		TS	OPTY
		TC	Q
	
20DEGS		DEC	7199

#	THE FOLLOWING PROGRAM TAKES A 2S COMPLEMENT DIFFERENCE BETWEEN THE ACTUAL CDU COUNTER AND THE DESIRED
# SETTING. THE AGC AD INSTRUCTION BY ITSELF CANNOT BE USED SINCE +0 = -0 THERE. TO COMPENSATE, IF THE SIGNS OF
# THE OPERANDS ARE DIFFERENT AND THE ROTATION NECESSARY TO NULL OUT THE ERROR PASSES THROUGH ZERO (NO OVERFLOW
# OCCURS IN DIFFERENCING THE DESIRED AND ACTUAL), A ONE WITH THE SIGN OF THE DESIRED ANGLE IS ADDEDTO THE DIFFER-
# ENCE.

2SCOMDIF	TS	ITEMP1		# NEGATIVE OF CDU COUNTER ARRIVES IN A.
		XCH	Q
		TS	ITEMP3
		
2SCOM2		CCS	ITEMP1		# NO OVERFLOW - SEE IF SIGNS OF INPUTS ARE 
		TC	EXAM2		# DIFFERENT.
		TC	EXAM2
		TC	+1
		CCS	ITEMP2
		CAF	ZERO
		TC	INCEX-
		TC	+1
		CS	ONE
		TC	INCEX-		# ADD -1 AND EXIT HERE.
		
EXAM2		CCS	ITEMP2
		TC	+4
		TC	+3
		CAF	ZERO
		TC	INCEX-
		
		CAF	ONE
INCEX-		AD	ITEMP1
		AD	ITEMP2
		TS	ITEMP1
		TC	ITEMP3		# NORMAL TRAIN OF EVENTS.
		INDEX	A		# IF OVERFLOW, SIMPLY DO OVERFLOW UNCOR-
		CAF	LIMITS		# RECTION AND EXIT.
		AD	ITEMP1
		TC	ITEMP3


#	OUTCTR SETTINGS FOR OUT2, AND C-RELAY SETTING CONSTANTS FOR IMU MODES.

CDUCODES	OCT	50400		# -Z CDU
		OCT	51000		# -Y CDU
		OCT	52000		# -X CDU
		OCT	32000		# +X CDU
		OCT	31000		# +Y CDU
		OCT	30400		# +Z CDU
		
MODECHNG	OCT	02000
		OCT	00000		# (TRANSFER SWITCH - NOT USED).
		OCT	01000
		OCT	00010
		OCT	00004
		OCT	00002
		OCT	00011

#	ZERO-ENCODER LIGHT NOT COVERED HERE.

LOW8		OCT	377
OUT2MASK	EQUALS	LOW8
OPTMASK		OCT	77407		# COMPLEMENT OF OUTCR2 ACTIVITY BITS.

		OCT	44400		# -Z GYRO
		OCT	45000		# -Y GYRO
		OCT	46000		# -X GYRO.
		
OPTCODES	OCT	00220		# -Y OPTICS CDU.
		OCT	00240		# -X OPTICS CDU.
		OCT	00140		# +X OPTICS CDU.
		OCT	00120		# +Y OPTICS CDU.
		
		OCT	26000		# +X GYRO
		OCT	25000		# +Y GYRO
		OCT	24400		# +Z GYRO.
		
HI5		EQUALS	BANKMASK
