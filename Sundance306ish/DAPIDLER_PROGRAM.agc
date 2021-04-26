### FILE="Main.annotation"
## Copyright:   Public domain.
## Filename:    DAPIDLER_PROGRAM.agc
## Purpose:     A section of an attempt to reconstruct Sundance revision 306
##              as closely as possible with available information. Sundance
##              306 is the source code for the Lunar Module's (LM) Apollo
##              Guidance Computer (AGC) for Apollo 9. This program was created
##              using the mixed-revision SundanceXXX as a starting point, and
##              pulling back features from Luminary 69 believed to have been
##              added based on memos, checklists, observed address changes,
##              or the Sundance GSOPs.
## Assembler:   yaYUL
## Contact:     Ron Burkey <info@sandroid.org>.
## Website:     www.ibiblio.org/apollo/index.html
## Mod history: 2020-07-24 MAS  Created from SundanceXXX.



# THE DAPIDLER PROGRAM IS STARTED BY FRESH START AND RESTART.  THE DAPIDLER PROGRAM IS DONE 10 TIMES
# PER SECOND UNTIL THE ASTRONAUT DESIRES THE DAP TO WAKE UP, AND THE IMU AND CDUS ARE READY FOR USE BY THE DAP.
# THE NECESSARY INITIALIZATION OF THE DAP IS DONE BY THE DAPIDLER PROGRAM.

                BANK    16
                SETLOC  DAPS1
                BANK

                EBANK=  AOSQ

                COUNT*  $$/DAPID

CHEKBITS        EXTEND
                READ    CHAN31          # IF BOTH BIT13 AND BIT14 ARE ONE, THEN
                COM                     # THE MODE SELECT SWITCH IS IN THE OFF
                MASK    BIT13-14        # POSITION, AND SO THE DAP SHOULD BE OFF,
                EXTEND                  # WITH NO ATTITUDE ERROR DISPLAY.
                BZF     MOREIDLE

                CS      IMODES33
                MASK    BIT6
                CCS     A
                TCF     ALTDSPLY
                CS      RCSFLAGS        # IMU NOT USABLE.  SET UP INITIALIZATION
                MASK    BIT3            # FLAG FOR ATT ERROR DISPLAY ROUTINE.
                ADS     RCSFLAGS
                TCF     SHUTDOWN

CHEKMORE        CAF     BIT10           # BIT 10 OF 30 IS PGNCS CONTROL OF S/C
                EXTEND
                RAND    CHAN30          # BITS IN 30 ARE INVERTED
                CCS     A
                TCF     MOREIDLE

                RETURN

# DAPIDLER ENTRY.

DAPIDLER        LXCH    BANKRUPT        # INTERRUPT LEAD INS (CONTINUED)
                EXTEND
                QXCH    QRUPT

                CCS     ACCSET          # CHECK IF 1/ACCJOB HAS BEEN SET UP SINCE
                TCF     CHECKUP         # THE LAST FRESH START OR RESTART.
                CAF     PRIO27
                TS      ACCSET          # ACCSET IS POSITIVE.
                TC      NOVAC           # SET UP JOB TO DO A LITTLE INITIALIZATION
                EBANK=  AOSQ            #       AND EXECUTE 1/ACCS.
1/ACCSAD        2CADR   1/ACCSET        # (WILL BRANCH TO MOREIDLE ON ACCSOKAY)

CHECKUP         TC      CHEKBITS        # CHECK TO SEE IF LM DAP IS TO GO ON AND
                                        #       DO ERROR DISPLAY.

                CAE     DAPBOOLS        # IF 1/ACCS HAS NOT BEEN COMPLETED, IDLE.
                MASK    ACCSOKAY        #       NOTE:   ONLY FRESH START AND RESTART
                EXTEND                  #               KNOCK THIS BIT DOWN.
                BZF     MOREIDLE

STARTDAP        TC      IBNKCALL        # ZERO ATTITUDE ERROR AND DESIRED RATES.
                FCADR   ZATTEROR
                CAF     ZERO            # ********** INITIALIZE: **********
                TS      TJP
                TS      TJU
                TS      TJV
                TS      OMEGAP          # RATES IN BODY (PILOT) COORDINATES.
                TS      OMEGAQ
                TS      OMEGAR
                TS      TRAPEDP
                TS      TRAPEDQ
                TS      TRAPEDR
                TS      AOSQ            # OFFSET ACCELERATION ESTIMATES.
                TS      AOSQ +1
                TS      AOSR
                TS      AOSR +1
                TS      ALPHAQ          # COPIES OF OFFSET ESTIMATES FOR DOWNLIST.
                TS      ALPHAR
                TS      AOSQTERM        # QRAXIS RATE DERIVATION TERMS AND KALMAN
                TS      AOSRTERM        # FILTER INITIALIZATION TERMS.
                TS      QACCDOT         # DESCENT ACCELERATION DERIVATIVE EST.
                TS      RACCDOT
                TS      ALLOWGTS        # AOSTASK FLAG FOR QRAXIS RCS CONTROL USE.
                TS      COTROLER        # DO TRYGTS ON FIRST PASS (WILL GO TO RCS)
                TS      INGTS           # RECOGNIZE FIRST GTS PASS AS SUCH.
                TS      QGIMTIMR        # STOP GIMBAL DRIVES.  (PROBABLY WOULD BE
                TS      RGIMTIMR        #       GOOD ENOUGH JUST TO INACTIVATE TIMERS)
                TS      OLDPMIN         # MINIMUM IMPULSE MODE ERASABLES
                TS      OLDQRMIN

# SET UP "OLD" MEASURED CDU ANGLES:

                EXTEND
                DCA     CDUX            # OLDXFORP AND OLDYFORP
                DXCH    OLDXFORP
                CA      CDUZ
                TS      OLDZFORQ
                CAF     CHKVISAD
                TS      PJUMPADR
                CA      FOUR
                TS      SKIPU
                TS      SKIPV
                CA      POSMAX
                TS      TIME6
                TS      T6NEXT
                TS      T6FURTHA
                CA      ZERO
                TS      T6NEXT +1
                TS      T6FURTHA +1
                TS      NXT6ADR
                TS      NEXTP
                TS      NEXTU
                TS      NEXTV
                CS      TEN
                TS      DAPZRUPT        # JASK NOT IN PROGRESS, INITIALIZE NEG.
                CA      TWO
                TS      NPTRAPS
                TS      NQTRAPS
                TS      NRTRAPS
                EXTEND
                DCA     PAXADIDL
                DXCH    T5ADR
SETTIME5        CAF     MS100
                TS      TIME5
                TCF     RESUME
                EBANK=  AOSQ
IDLERADR        2CADR   DAPIDLER
MOREIDLE        TC      IBNKCALL        # CALCULATE Q,R-AXES ATTITUDE ERRORS.
                CADR    QERRCALC

                TC      IBNKCALL
                CADR    CALCPERR        # CALCULATE P AXIS ATTITUDE ERRORS.

SHUTDOWN        EXTEND
                DCA     IDLERADR
                DXCH    T5ADR

                CAF     ZERO            # KILL ANY POSSIBLE JET REQUESTS
                TS      NEXTP
                TS      NEXTU
                TS      NEXTV
                EXTEND                  # COMMAND JETS OFF.
                WRITE   CHAN5
                EXTEND
                WRITE   CHAN6
                CS      BGIM23          # TURN TRIM GIMBAL OFF
                EXTEND
                WAND    CHAN12
                TCF     SETTIME5        # RETURN IN 100 MSEC.

BGIM23          OCTAL   07400
                EBANK=  OMEGAP
PAXADIDL        2CADR   PAXIS

CHKVISAD        ADRES   CHKVISFZ
ACCSETAD        ADRES   1/ACCSAD

MS100           =       OCT37766
COSMG           =       ITEMP1

# PROGRAM:      ALTDSPLY
# MOD 0.        6 DEC 1967
# AUTHOR:       CRAIG WORK, DON KEENE, MIT IL
# MOD 3 BY DON KEENE AUG 1, 1968 MOVED PROGRAM TO BANK 20
#
# PROGRAM DESCRIPTION:
#       ALTDSPLY REVERSES THE DSPLYALT BIT OF RCSFLAGS EACH TIME IT IS CALLED, WHICH IS PRESUMABLY EVERY 100 MS.
#       IF THE REVERSED BIT IS ONE, NEEDLER IS CALLED TO DISPLAY ATTITUDE ERRORS.  IF THE BIT IS ZERO, THE ATTITUDE ERR-
#       ORS ARE CALCULATED AS 1) DAP FOLLOWING ERRORS, IF NEEDLFLG = 0, AND 2) TOTAL ATTITUDE ERRORS FOR NEEDLFLG = 1.
#
#
# WARNING:      ALTDSPLY MAY ONLY BE CALLED WITH INTERRUPT INHIBITED.
#
# WARNING:      EBANK MUST BE SET TO 6 WHEN USING THIS ROUTINE.
#
# INPUT:        RCSFLAGS AND    1) IF NEEDLFLG = 0, INPUT PERROR, QERROR, RERROR.
#                               2) IF NEEDLFLG = 1, INPUT CPHI,CTHETA,CPSI,CDUX,CDUY,CDUZ,M11,M21,M31,M22,M32.  (GPMATRIX)
#
#
# OUTPUTS:      RCSFLAGS WITH DSPLYALT REVERSED, AK, AK1, AK2, + NEEDLER OUTPUTS.
#
# ENTRY:        TCF     ALTDSPLY
#
# EXIT:         TCF     CHEKMORE
#
# ALARM OR ABORT EXITS: NONE
#
# SUBPROGRAMS CALLED:  NEEDLER, OVERSUB2
#
# DEBRIS:       A, L, AND NEEDLER DEBRIS.

ALTDSPLY        CA      RCSFLAGS        # INVERT THE DISPLAY ALTERNATION BIT.
                TS      L
                CA      DSPLYALT
                EXTEND
                RXOR    LCHAN
                TS      RCSFLAGS

                MASK    DSPLYALT
                CCS     A               # IS ALTERNATION FLAG ZERO?
                TCF     NEEDLER

                CAE     FLAGWRD0        # NEEDLFLG WILL INDICATE TOTAL OR DAP AT-
                MASK    NEEDLBIT        # TITUDE ERROR DISPLAY REQUEST.
                CCS     A
                TCF     DSPLYTOT        # TOTAL ERROR IS NEEDED IN AK, AK +1, AK +2

                EXTEND
                DCS     QERROR          # YES.  DISPLAY ATT ERRORS ON THE ,-BALL.
                DXCH    AK +1           # ERROR COMPLEMENTS ARE INPUT TO NEEDLER.
                CS      PERROR
                XCH     AK

                TCF     CHEKMORE        # DISPLAY THESE THE NEXT TIME THROUGH

# CALCULATE GIMBAL ANGLE TOTAL ERRORS, RESOLVE INTO PILOT AXES, STORE TOTAL ERRORS FOR NEEDLER.  Q-AXIS FIRST.

DSPLYTOT        EXTEND
                QXCH    ITEMP1          # SAVE Q FOR CHEKBITS RETURN.

                CA      CTHETA          # DESIRED ATTITUDE, Y-AXIS, 2'S COMP.
                EXTEND                  # SUBTRACT CURRENT ATTITUDE.
                MSU     CDUY            # DIFFERENCE SCALED AT PI, 1'S COMP.
                TS      AK              # SAVE FOR R-ERROR CALCULATION.
                EXTEND
                MP      M21             # (CHTETA-CDUY)*M21 SCALED AT PI RADIANS.
                XCH     AK +1           # STORE FIRST TERM OF Q ERROR.
                CA      CPSI            # DESIRED ATTITUDE, Z-AXIS, 2'S COMP.
                EXTEND                  # SUBTRACT CURRENT ATTITUDE.
                MSU     CDUZ            # DIFFERENCE SCALED AT PI, 1'S COMP.
                TS      AK +2           # SAVE Z-AXIS TERM FOR R ERROR CALCULATION
                EXTEND
                MP      M22             # (CPSI-CDUZ)*M22, SCALED AT PI RADIANS.
                AD      AK +1           # Q ERROR COMPLETE         , AT PI RAD.
                TC      OVERSUB         # PIN NEEDLES IN CASE OF OVERFLOW.
                TS      AK +1

# R ERROR CALCULATION NEXT.

                CA      AK              # Y-AXIS DIFFERENCE STORED BY Q-AXIS CALC.
                EXTEND
                MP      M31             # (CTHETA-CDUY)*M31, SCALED AT PI RADIANS.
                XCH     AK +2           # FIRST TERM OF R ERROR.
                                        # Z-AXIS DIFFERENCE, STORED BY A CALC. IS
                EXTEND                  # RECOVERED BY THE EXCHANGE.
                MP      M32             # (CPSI-CDUZ)*M32, SCALED AT PI RADIANS.
                AD      AK +2           # R ERROR COMPLETE         , AT PI RAD.
                TC      OVERSUB         # PIN NEEDLES IN CASE OF OVERFLOW.
                TS      AK +2

# NOW CALCULATE P ERROR.  (NOTE THAT M13 = 1, SCALED AT 1, SO THE MULTIPLICATION IS BY-PASSED.)
                CA      AK              # Y-AXIS DIFFERENCE STORED BY Q AXIS CALC.
                EXTEND
                MP      M11             # (CTHETA-CDUY)*M11 SCALED AT PI RADIANS.
                XCH     AK              # FIRST TERM OF P ERROR IN AK, AT PI RAD.
                CAE     CPHI            # DESIRED ATTITUDE, X-AXIS, 2'S COMP.
                EXTEND                  # SUBTRACT CURRENT X ATTITUDE.
                MSU     CDUX            # X-AXIS DIFFERENCE, 1'S COMP, AT PI RAD.

# M13 = 1, SO BYPASS THE MULTIPLICATION.
#               EXTEND
#               MP      M13             (CPHI-CDUX)*M13 SCALED AT PI RADIANS.

                AD      AK              # P ERROR COMPLETE      , SCALED AT PI RAD
                TC      OVERSUB         # PIN NEEDLES IN CASE OF OVERFLOW.
                TS      AK

                EXTEND
                QXCH    ITEMP1          # RESTORE Q FOR CHEKBITS RETURN.

                TCF     CHEKMORE        # DISPLAY THESE THE NEXT TIME THROUGH

# FDAI ATTITUDE ERROR DISPLAY SUBROUTINE
#
# PROGRAM DESCRIPTION:          D. KEENE        5/24/67
# MOD 1 BY CRAIG WORK, 12 DEC 67
# MOD 2 BY CRAIG WORK, 6 APRIL 68 CONVERTS ATTITUDE ERROR DISPLAY SCALING FROM 16 7/8 DEG. TO 42 3/16 DEGREES.
#
# THIS SUBROUTINE IS USED TO DISPLAY ATTITUDE ERRORS ON THE FDAI VIA THE DIGITAL TO ANALOG CONVERTERS (DACS)
# IN THE CDUS.  CARE IS TAKEN TO METER OUT THE APPROPRIATE NUMBER OF PULSES TO THE IMU ERROR COUNTERS AND PREVENT
# OVERFLOW, TO CONTROL THE RELAY SEQUENCING, AND TO AVOID INTERFERENCE WITH THE COARSE ALIGN LOOP WHICH ALSO USES
# THE DACS.
#
# CALLING SEQUENCE:
#       DURING THE INITIALIZATION SECTION OF THE USER'S PROGRAM, BIT3 OF RCSFLAGS SHOULD BE SET TO INITIATE THE
#       TURN-ON SEQUENCE WITHIN THE NEEDLES PROGRAM:
#               CS      RCSFLAGS        IN EBANK6
#               MASK    BIT3
#               ADS     RCSFLAGS
#       THEREAFTER, THE ATTITUDE ERRORS GENERATED BY THE USER SHOULD BE TRANSFERED TO THE FOLLOWING LOCATIONS IN EBANK6:
#               AK      SCALED 180 DEGREES      NOTE:   THESE LOCATIONS ARE SUBJECT
#               AK1     SCALED 180 DEGREES              TO CHANGE
#               AK2     SCALED 180 DEGREES
#       FULL SCALED DEFLECTION OF THE NEEDLES CORRESPONDS TO 5 1/16 DEGREES, WHILE 384 BITS IN THE IMU ERROR COUNTER
#       CORRESPONDS TO 42 3/16 DEGREES.  (DAC MAXIMUM CAPACITY IS 384 BITS.)  46 BITS EFFECTIVELY PIN THE NEEDLES.
#
#       A CALL TO NEEDLER WILL THEN UPDATE THE DISPLAY:
#               INHINT
#               TC      IBNKCALL        NOTE:  EBANK SHOULD BE SET TO E6
#               CADR    NEEDLER
#               RELINT
#       THIS PROCESS SHOULD BE REPEATED EACH TIME THE ERRORS ARE UPDATED.  AT LEAST 3 PASSES THRU THE PROGRAM ARE
#       REQUIRED BEFORE ANYTHING IS ACTUALLY DISPLAYED ON THE ERROR METERS.
#       NOTE:  EACH CALL TO NEEDLER MUST BE SEPARATED BY AT LEAST 50 MS TO ASSURE PROPER RELAY SEQUENCING.
#
# ERASABLE USED:
#       AK              CDUXCMD
#       AK1             CDUYCMD
#       AK2             CDUZCMD
#       EDRIVEX         A,L,Q
#       EDRIVEY         T5TEMP
#       EDRIVEZ         DINDX
#
# SWITCHES:             RCSFLAGS  BITS 3,2
#
# I/O CHANNELS:         CHAN12  BIT 4 (COARSE ALIGN - READ ONLY)
#                       CHAN12  BIT 6 (IMU ERROR COUNTER ENABLE)
#                       CHAN14  BIT 13,14,15 (DAC ACTIVITY)
#
# SIGN CONVENTION<      AK = THETAC - THETA
#                       WHERE   THETAC = COMMAND ANGLE
#                               THETA = PRESENT ANGLE

NEEDLER         CA      RCSFLAGS
                MASK    SIX
                EXTEND
                BZF     NEEDLES3
                MASK    BIT3
                EXTEND
                BZF     NEEDLER2        # BIT3 = 0, BIT2 = 1

                CS      BIT6            # FIRST PASS BIT3 = 1
                EXTEND                  # DISABLE IMU ERROR COUNTER TO ZERO DACS
                WAND    CHAN12          # MUST WAIT AT LEAST 60 MS BEFORE
NEEDLE11        CS      ZERO            # ENABLING COUNTERS.
                TS      AK              # ZERO THE INPUTS ON FIRST PASS
                TS      AK1
                TS      AK2
                TS      EDRIVEX         # ZERO THE DISPLAY REGISTERS
                TS      EDRIVEY
                TS      EDRIVEZ
                TS      CDUXCMD         # ZERO THE OUT COUNTERS
                TS      CDUYCMD
                TS      CDUZCMD
                CS      SIX             # RESET RCSFLAGS FOR PASS2
                MASK    RCSFLAGS
                AD      BIT2
                TS      RCSFLAGS
                TCF     CHEKMORE

NEEDLER2        CAF     BIT6            # ENABLE IMU ERROR COUNTERS
                EXTEND
                WOR     CHAN12
                CS      SIX             # RESET RCSFLAGS TO DISPLAY ATTITUDE
                MASK    RCSFLAGS        # ERRORS    WAIT AT LEAST 4 MS FOR
                TS      RCSFLAGS        # RELAY CLOSURE
                TCF     CHEKMORE

NEEDLES3        CAF     BIT6            # CHECK TO SEE IF IMU ERROR COUNTER
                EXTEND                  # IS ENABLED
                RAND    CHAN12
                CCS     A               # IF NOT, RE-INITIALIZE NEEDLER.
                TCF     NEEDLES

                CS      RCSFLAGS        # SET UP INITIALIZATION FLAG IN RCSFLAGS.
                MASK    BIT3
                ADS     RCSFLAGS
                TCF     CHEKMORE

NEEDLES         CAF     TWO
DACLOOP         TS      DINDX
                CS      ONETENTH        # RESCALE INPUTS TO + OR - 1800 DEGREES.
                EXTEND
                INDEX   DINDX
                MP      AK
                TS      L
                CCS     A
                CA      DACLIMIT
                TCF     +2
                CS      DACLIMIT
                AD      L
                TS      T5TEMP          # OVFLO CHK
                TCF     +4
                INDEX   A               # ON OVERFLOW LIMIT OUTPUT TO +-384
                CAF     DACLIMIT
                TS      L
                INDEX   DINDX
                CS      EDRIVEX         # CURRENT VALUE OF DAC
                AD      L
                INDEX   DINDX
                ADS     CDUXCMD
                INDEX   DINDX
                LXCH    EDRIVEX
                CCS     DINDX
                TCF     DACLOOP
                CAF     13,14,15
                EXTEND
                WOR     CHAN14          # SET DAC ACTIVITY BITS
                TCF     CHEKMORE

                DEC     -384
DACLIMIT        DEC     16000
                DEC     384

ONETENTH        OCT     03146           # DECIMAL +0.1, SCALED AT 1.
DSPLYALT        EQUALS  BIT4            # 100 MS ALTERNATION BIT IN RCSFLAGS
