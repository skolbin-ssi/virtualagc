### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	P30,P38.agc
## Purpose:	A section of Skylark revision 048.
##		It is part of the source code for the Apollo Guidance Computer (AGC)
##		for Skylab-2, Skylab-3, Skylab-4, and ASTP. No original listings of
##		this software are available; instead, this file was created via
##		disassembly of dumps of the core rope modules actually flown on
##		Skylab-2. Access to these modules was provided by the New Mexico
##		Museum of Space History.
## Assembler:	yaYUL
## Contact:	Ron Burkey <info@sandroid.org>.
## Website:	www.ibiblio.org/apollo/index.html
## Mod history:	2023-09-04 MAS  Created from Artemis 072.
##		2024-03-05 MAS  Updated for Skylark 48.

# PROGRAM DESCRIPTION	P30	DATE 5-1-69
#
# MOD.I BY S. ZELDIN-  TO ADD P31 AND ADAPT P30 FOR P31 USE.	22DEC67
# MOD.II BY P.WOLFF TO REDUCE CODING AND DELETE RESTART PROTECTION	4-30-69
# MOD.III BY C.BEALS TO DELETE P31	1NOV69
#
# FUNCTIONAL DESCRIPTION
#	P30 (EXTERNAL DELTA-V TARGETTING PROGRAM)
#		ACCEPTS ASTRONAUT INPUTS OF TIG,DELV(LV) AND COMPUTES, FOR DISPLAY,
#		APOGEE, PERIGEE, DELV(MAG), MGA ASSOCIATED WITH DESIRED MANEUVER
#
# THE FOLLOWING SUBROUTINES ARE USED IN P30
#	S30/31.1  COMPUTES APOGEE AND PERIGEE ALTITUDE
#	P30/P31 - DISPLAYS TIG
#	CNTUP30 - DISPLAYS DELV(LV)
#	COMPTGO	  CLOCKTASK COMPUTE TTOGO
#	LOMAT	  COMPUTE X,Y,Z IN LV COORDS
#	PARAM30 - DISPLAYS APOGEE, PERIGEE, DELV(MAG), MGA, TIME FROM TIG,
#	   	  MARKS SINCE LAST THRUSTING MANEUVER
#
# CALLING SEQUENCE VIA JOB FROM V37
#
# EXIT VIA V37 CALL OR GOTOPOOH
#
# OUTPUT FOR POWERED FLIGHT
#	VTIG	X
#	RTIG
#	DELVSIN	X
#
# P30 CALCULATIONS
#
# P30 CALC BASED ON STORED TARGET PARAMETERS (R OF IGNITION (RTIG), V OF
# IGNITION (VTIG), TIME OF IGNITION (TIG), DELV(LV), COMPUTE PERIGEE ALTITUDE
# APOGEE ALTITUDE AND DELTA-V REQUIRED IN REF. COORDS. (DELVSIN)
# 
# ERASABLE INITIALIZATION REQUIRED
#	TIG		TIME OF IGNITION			DP	B28CS
#	DELVSLV		SPECIFIED DELTA-V IN LOCAL VERT.
#			COORDS. OF ACTIVE VEHICLE AT
#			TIME OF IGNITION			VCT.	B+7M/CS
#
# SUBROUTINES CALLED
#	THISPREC
#
# OUTPUT
#	RTIG		POSITION AT TIG				VCT.	B+29M
#	VTIG		VELOCITY AT TIG				VCT.	B+7M
#	DELVSIN		DELVSLV IN REF COORDS			VCT.	B+7M/CS
#
# DEBRIS QTEMP    TEMP. ERASABLE
#	 QPRET, MPAC
#	 PUSHLIST

		SETLOC	P30S1
		BANK

		EBANK=	+MGA

		COUNT*	$$/P30
P30		TC	UPFLAG
		ADRES	UPDATFLG	# SET UPDATFLG
		TC	UPFLAG
		ADRES	TRACKFLG	# SET TRACKFLG
DSP0633		CAF	V06N33		# DISPLAY TIME OF IGNITION
		TC	VNFLASH
		CAF	V06N81
		TC	VNFLASH
		TC	UPFLAG
		ADRES	XDELVFLG	# BIT 8 FLAG 2
		TC	INTPRET
		CLEAR	DLOAD
			UPDATFLG	# RESET UPDATFLG
			TIG		# TIME IGNITION SCALED AT 2(+28)CS
		STCALL	TDEC1
			THISPREC	# ENCKE ROUTINE FOR

		VLOAD
			VATT
		STOVL	VTIG
			RATT
		STORE	RTIG
		STORE	RACT3
		VXV	UNIT
			VTIG
		STCALL	UNRM
			LOMAT
		VLOAD	VXM
			DELVSLV
			0
		VSL1
		STORE	DELVSIN
		ABVAL
		STOVL	VGDISP		# MAG DELV
			RTIG
		PDVL	VAD
			DELVSIN
			VTIG
		CALL	
			S30/31.1
		EXIT
PARAM30		CAF	V06N42		# DISPLAY HAPO, HPER, DELTAV
		TC	VNFLASH
REFTEST		TC	INTPRET
		BOFF	VLOAD
			REFSMFLG	# TEST FOR REFSMFLAG ON
			NOTSET
			DELVSIN
		PUSH	CALL
			GET+MGA
		EXIT
DISPMGA		TC	COMPTGO

DISP45		CAF	V16N45		# DISPLAY MARK CNT, TFI, +MGA
		TC	VNFLASH
		TC	DOWNFLAG
		ADRES	TIMRFLAG	# RESET TIMRFLAG
		TCF	GOTOPOOH

COMPTGO		EXTEND
		QXCH	PHSPRDT6

		TC	UPFLAG		# SET TIMRFLAG
		ADRES	TIMRFLAG
		CAF	ZERO
		TS	NVWORD1

		CAF	ONE
		TC	WAITLIST
		EBANK=	TIG
		2CADR	CLOKTASK

		TC	2PHSCHNG
		OCT	40036		# 6.3SPOT FOR CLOKTASK
		OCT	05024		# GROUP 4 CONTINUES HERE
		OCT	13000

6P3SPT1		=	6.3SPOT
		TC	PHSPRDT6

NOTSET		DLOAD	DCOMP
			MARSDP
		STORE	+MGA
		RTB
			DISPMGA
MARSDP		OCT	00000		# (00000) (16440) = (+00001)
		OCT	35100
					# ( .01 ) DEGREES IN THE LOW ORDER REGISTE
			
V06N42		VN	0642


# S30/31.1	SUBROUTINE USED BY P30/P31 CALCULATIONS
# MOD NO 1		LOG SECTION P30,P37
#
# FUNCTIONAL DESCRIPTION
#	THROUGH A SERIES OF CALLS COMPUTES APOGEE AND PERIGEE ALTITUDE
#
# SUBROUTINES CALLED
#	PERIAPO1
#	MAXCHK
#
# CALLING SEQUENCE
#	L	CALL
#	L+1		S30/31.1
#
# NORMAL EXIT MODE
#	AT L+2 OR CALLING SEQUENCE
#
# OUTPUT
#	HAPO		APOGEE ALT.		DP 	B+29 M
#	HPER		PERIGEE ALT.		DP 	B+29 M

		SETLOC	P30S1A
		BANK
		
		COUNT*	$$/P30
S30/31.1	STQ	CALL
			QTEMP
			PERIAPO1
		CALL
			MAXCHK
		STODL	HPER		# PERIGEE ALT B+29
			4D
		CALL
			MAXCHK
		STCALL	HAPO		# APOGEE ALT B+29
			QTEMP



		SETLOC	P30SUBS
		BANK
		COUNT*	$$/P30
		EBANK=	SUBEXIT
P20FLGON	EXTEND
		QXCH	SUBEXIT
		TC	UPFLAG
		ADRES	TRACKFLG
		TC	UPFLAG
		ADRES	UPDATFLG
		TC	DOWNFLAG
		ADRES	PCFLAG
		TC	SUBEXIT

		SETLOC	P38TAG
		BANK
# PLANE CHANGE TARGETING PROGRAM	P38
# 
# PURPOSE
#	TO COMPUTE PARAMETERS FOR PLANE CHANGE MANEUVER
#
# INPUT
#	LASTTIG
# 
# OUTPUT
# 	TIG		TIME OF PLANE CHANGE MANEUVER  COMPUTED TO BE
#			LASTTIG + 90 DEG TRANSFER TIME
#	DELVLVC		DELTA VELOCITY AT PC - LOCAL VERTICAL
#	DELVSIN		DELTA VELOCITY AT PC - REFERENCE

		COUNT*	$$/P38
P38		TC	P20FLGON	# SET TRACK,UPDATE - CLEAR PC FLAGS
		TC	UPFLAG
		ADRES	PCFLAG

		TC	INTPRET
		CLEAR	DLOAD
			FINALFLG
			TIG
		STORE	LASTTIG
		EXIT
		CAF	V06N39
		TC	VNFLASH
		TC	INTPRET
P38A		SET	DLOAD
			XDELVFLG
			LASTTIG
		STCALL	TDEC1
			CSMPREC		# INTEGRATE STATES TO LASTTIG
		DLOAD	SET
			ZEROVECS
			RVSW
		STODL	CSTH		# COS 90 DEGREES
			CS359+
		STOVL	SNTH		# SINE 90 DEGREES
			RATT
		STOVL	RVEC
			VATT
		STCALL	VVEC		# COMPUTE TRANSFER TIME OF 90 DEG
			TIMETHET
		DAD
			LASTTIG
		STORE	TIG
		EXIT
		CAF	V06N33
		TC	VNFLASH
		TC	INTPRET
		CALL
			VN1645
P38RECYC	VLOAD
			ZEROVECS
		STODL	DELVLVC
			TIG
		STCALL	TDEC1
			PRECSET
		BON	SET
			FINALFLG
			+2
			UPDATFLG
 +2		VLOAD
			VACT3
		STOVL	VTIG
			RACT3
		STCALL	RTIG
			DISPN90
		CALL
			LOMAT
		VLOAD	VXM
			DELVLVC		# ROTATE DV (LV TO REF)
			0D
		VSL1
		STCALL	DELVSIN
			VN1645
		GOTO
			P38RECYC

CS359+		2DEC	+.499999992
V06N39		VN	0639
