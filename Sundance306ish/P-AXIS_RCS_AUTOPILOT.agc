### FILE="Main.annotation"
## Copyright:   Public domain.
## Filename:    P-AXIS_RCS_AUTOPILOT.agc
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



                BANK    16
                SETLOC  DAPS1
                BANK

                EBANK=  PERROR
                COUNT*  $$/DAPP

# THE FOLLOWING T5RUPT ENTRY BEGINS THE PROGRAM WHICH CONTROLS THE P-AXIS ACTION OF THE LEM USING THE RCS JETS.
# THE NOMINAL TIME BETWEEN THE P-AXIS RUPTS IS 100 MS IN ALL NON-IDLING MODES OF THE DAP.

PAXIS           CA      MS100
                TS      TIME5           # *** NECESSARY IN ORDER TO ALLOW SYN-
                                        # CHRONIZATION WITH OTHER INTERRUPTS ***

                LXCH    BANKRUPT        # INTERRUPT LEAD IN (CONTINUED)
                EXTEND
                QXCH    QRUPT

# CHECK IF DAP PASS IS PERMISSIBLE

                CCS     DAPZRUPT        # IF DAPZRUPT POSITIVE, DAP (JASK) IS
                TC      ABORT           #    STILL IN PROGRESS AND A RESTART IS
                OCT     02000           #   CALLED FOR.  IT IS NEVER ZERO.

                TC      CHEKBITS        # RETURN IS TO I+1 IF DAP SHOULD STAY ON.

# ***** KALCMANU-DAP AND "RATE-HOLD"-DAP INTERFACE *****
#
# THE FOLLOWING SECTION IS EXECUTED EVERY 100 MS (10 TIMES A SECOND) WITHIN THE P-AXIS REACTION CONTROL SYSTEM
# AUTOPILOT (WHENEVER THE DAP IS IN OPERATION).

                CA      CDUXD
                EXTEND
                MSU     DELCDUX
                TC      1STOTWOS
                TS      CDUXD
                CA      CDUYD
                EXTEND
                MSU     DELCDUY
                TC      1STOTWOS
                TS      CDUYD
                CA      CDUZD
                EXTEND
                MSU     DELCDUZ
                TC      1STOTWOS
                TS      CDUZD
# RATELOOP COMPUTES JETRATEQ, JETRATER, AND 1JACC*NO. PJETS IN ITEMP1.
#  RETURNS TO BACKP.
#
#  JETRATE = 1JACC*NO.PJETS*TJP   (NOTE TJ IS THE TIME FIRED DURING CSP)
#  JETRATEQ = 1JACCQ(TJU*NO.UJETS - TJV*NO.VJETS)
#  JETRATER = 1JACCR(TJU*NO.UJETS + TJV*NO.VJETS)

                TCF     RATELOOP
1STOTWOS        CCS     A
                AD      ONE
                TC      Q
                CS      A
                TC      Q
SUBDIVDE        EXTEND                  # OVERFLOW PROCTION ROUTINE TO GIVE
                MP      DAPTEMP3        # POSMAX OR NEGMAX IF THE DIVIDE WOULD
                DAS     OMEGAU          # OVERFLOW

 +3             CCS     OMEGAU
                TCF     +2
                TCF     DIVIDER
                AD      -OCT630
                EXTEND
                BZMF    DIVIDER

                CCS     OMEGAU
                CA      POSMAX          # 45 DEG/SEC
                TC      Q
                CS      POSMAX
                TC      Q

DIVIDER         DXCH    OMEGAU
                EXTEND
                DV      ITEMP1
                TC      Q

OVERSUB         TS      7               # RETURNS A UNCHANGED OR LIMITED TO
                TC      Q               #   POSMAX OR NEGMAX IF A HAS OVERFLOW
                INDEX   A
                CS      BIT15 -1
                TC      Q

-OCT630         OCT     77147

BACKP           CA      DAPTEMP1
                EXTEND
                MP      1JACC
                TS      JETRATE

# BEGINNING OF THE RATE DERIVATION
# OMEGAP,Q,R      BODY RATES SCALED AT PI/4
# TRAPER,Q,R      BODY ANGLE ERRORS FROM PREDICTED ANGLE (PI/40)
# NP(QR)TRAPS     NUMBER OF TIMES ANGLE ERROR HAS BEEN ACCUMULATED
# AOSQ(R)TERM     CHANGE IN RATE DUE TO OFFSET ACCELLERATION.  (PI/4)
# JETRATE,Q,R     CHANGE IN RATE DUE TO  JET   ACCELLERATION.  (PI/4)
# TRAPSIZE        NEGATIVE LIMIT OF MAGNITUDE OF TRAPEDP, ECT.
# OMEGAU          DP-TEMPORARY STORAGE
#     OMEGA = OMEGA + JETRATE + AOSTERM (+TRAPED/NTRAPS IF TRAPED BIG)

                CAE     CDUX
                TS      L
                EXTEND
                MSU     OLDXFORP        # SCALED AT PI
                LXCH    OLDXFORP
                TS      DAPTEMP1
                CA      1/40
                TS      ITEMP1
                CS      JETRATE
                EXTEND
                MP      BIT14
                ADS     TRAPEDP
                CA      JETRATEQ
                AD      AOSQTERM
                EXTEND
                MP      -BIT14
                ADS     TRAPEDQ
                CA      JETRATER
                AD      AOSRTERM
                EXTEND
                MP      -BIT14
                ADS     TRAPEDR

                CA      CDUY
                TS      L
                EXTEND
                MSU     OLDYFORP        # SCALED AT PI
                LXCH    OLDYFORP
                TS      DAPTEMP2
                EXTEND
                MP      M11             # M11 SCALED AT 1
                AD      DAPTEMP1
                DXCH    OMEGAU

                TC      SUBDIVDE +3     # RETURNS WITH CDU-RATE AT PI/4

                EXTEND
                SU      OMEGAP
                ADS     TRAPEDP
                TC      OVERSUB
                TS      TRAPEDP
                CA      CDUZ
                TS      L
                EXTEND
                MSU     OLDZFORQ
                TS      DAPTEMP3
                LXCH    OLDZFORQ
                CA      M21
                EXTEND
                MP      DAPTEMP2
                DXCH    OMEGAU
                CA      M22
                TC      SUBDIVDE

                EXTEND
                SU      OMEGAQ
                ADS     TRAPEDQ
                TC      OVERSUB
                TS      TRAPEDQ
                CA      M31
                EXTEND
                MP      DAPTEMP2
                DXCH    OMEGAU
                CA      M32

                TC      SUBDIVDE

                EXTEND
                SU      OMEGAR
                ADS     TRAPEDR
                TC      OVERSUB
                TS      TRAPEDR         # TRAPEDS HAVE ALL BEEN COMPUTED
                CA      DAPBOOLS        # PICK UP PAD LOADED STATE ESTIMATOR GAINS
                MASK    CSMDOCKD
                EXTEND
                BZF     LMONLY
                EXTEND                  # DOCKED
                DCA     DKOMEGAN
                DXCH    ITEMP1
                CA      DKTRAP
                TCF     +5
LMONLY          EXTEND                  # UNDOCKED
                DCA     LMOMEGAN
                DXCH    ITEMP1
                CA      LMTRAP
 +5             TS      ITEMP3
 
                CCS     TRAPEDP
                TCF     +2
                TCF     SMALPDIF
                AD      ITEMP3          # TRAPSIZE > ABOUT 77001 %-1.4DEG/SEC"
                EXTEND
                BZMF    SMALPDIF
                ZL
                LXCH    TRAPEDP
                CA      ZERO
                EXTEND
                DV      NPTRAPS
                ADS     OMEGAP
                TC      OVERSUB
                TS      OMEGAP
                CA      ITEMP1          # ABOUT 10 OR 0 FOR DOCKED OR UNDOCKED
                TS      NPTRAPS
SMALPDIF        INCR    NPTRAPS
P-RATE          CA      JETRATE
                ADS     OMEGAP
                TC      OVERSUB
                TS      OMEGAP

                CCS     TRAPEDQ
                TCF     +2
                TCF     Q-RATE
                AD      ITEMP3          # TRAPSIZE > ABOUT 77001 %-1.4DEG/SEC"
                EXTEND
                BZMF    Q-RATE
                ZL
                LXCH    TRAPEDQ
                CA      ZERO
                EXTEND
                DV      NQTRAPS
                TS      DAPTEMP1        # SAVE FOR OFFSET ESTIMATE
                ADS     SUMRATEQ
                CA      DAPTEMP1
                ADS     OMEGAQ
                TC      OVERSUB
                TS      OMEGAQ
                CA      ITEMP1          # ABOUT 10 OR 0 FOR DOCKED OR UNDOCKED
                XCH     NQTRAPS
                AD      ITEMP2          # KAOS > ABOUT 60D %N/N_60"
                XCH     DAPTEMP1
                EXTEND
                MP      FIVE
                EXTEND
                DV      DAPTEMP1
                ADS     AOSQ
Q-RATE          INCR    NQTRAPS
                CA      JETRATEQ
                AD      AOSQTERM
                ADS     OMEGAQ
                TC      OVERSUB
                TS      OMEGAQ

                CCS     TRAPEDR
                TCF     +2
                TCF     R-RATE
                AD      ITEMP3          # TRAPSIZE > ABOUT 77001 %-1.4DEG/SEC"
                EXTEND
                BZMF    R-RATE
                ZL
                LXCH    TRAPEDR
                CA      ZERO
                EXTEND
                DV      NRTRAPS
                TS      DAPTEMP2        # SAVE FOR OFFSET ESTIMATE
                ADS     SUMRATER
                CA      DAPTEMP2
                ADS     OMEGAR
                TC      OVERSUB
                TS      OMEGAR
                CA      ITEMP1          # ABOUT 10 OR 0 FOR DOCKED OR UNDOCKED
                XCH     NRTRAPS
                AD      ITEMP2          # KAOS > ABOUT 60D %N/N_60"
                XCH     DAPTEMP2
                EXTEND
                MP      FIVE
                EXTEND
                DV      DAPTEMP2
                ADS     AOSR
R-RATE          INCR    NRTRAPS
                CA      JETRATER
                AD      AOSRTERM
                ADS     OMEGAR
                TC      OVERSUB
                TS      OMEGAR

# END OF RATE DERIVATION
#  BEGIN OFFSET ESTIMATER
#   IN POWERED FLIGHT, AOSTASK WILL BE CALLED EVERY 2 SECONDS.
#   AOS = AOS + K*SUMRATE

                CS      DAPBOOLS
                MASK    DRIFTBIT
                CCS     A
                TCF     WORKTIME
                TS      ALPHAQ          # ZERO THE OFFSET ACCELERATION VALUES.
                TS      ALPHAR
                TS      AOSQTERM
                TS      AOSRTERM
                TS      AOSQ
                TS      AOSR
                TCF     PAXFILT
KAOS            DEC     60
WORKTIME        CA      QACCDOT
                EXTEND
                MP      CALLCODE        # OCTAL 00032 IS DECIMAL .1 AT 2(6).
                DAS     AOSQ
                CA      AOSQ
                TS      ALPHAQ
                EXTEND
                MP      200MS           # .2 AT 1
                TS      AOSQTERM
                CA      RACCDOT
                EXTEND
                MP      CALLCODE        # OCTAL 00032 IS DECIMAL .1 AT 2(6).
                DAS     AOSR
                CA      AOSR
                TS      ALPHAR
                EXTEND
                MP      200MS           # .2 AT 1
                TS      AOSRTERM

PAXFILT         DXCH    ARUPT
                DXCH    DAPARUPT
                CA      SUPERJOB        # SETTING UP THE SUPERJOB
                XCH     BRUPT
                LXCH    QRUPT
                DXCH    DAPBQRPT
                CA      SUPERADR
                DXCH    ZRUPT
                DXCH    DAPZRUPT
                TCF     NOQBRSM +1      # RELINT (JUST IN CASE) AND RESUME, IN THE
                                        #   FORM OF A JASK, AT SUPERJOB.

SUPERADR        GENADR  SUPERJOB +1

# COUNT DOWN GIMBAL DRIVE TIMERS AND TURN OFF DRIVES IF REQUIRED.

SUPERJOB        CCS     QGIMTIMR        # Q-AXIS GIMBAL DRIVE TIMER
                TCF     DECQTIMR        #   POSITIVE- COUNTING DOWN
                TCF     TURNOFFQ        #   NEGATIVE- DRIVE SHOULD BE ENDED
CHKRTIMR        CCS     RGIMTIMR        #   NEGATIVE- INACTIVE
                TCF     DECRTIMR        #  (NEG ZERO - IMPOSSIBLE)
                TCF     TURNOFFR        # REPEATED (ABOVE) FOR R AXIS.

                TC      PJUMPADR

DECQTIMR        TS      QGIMTIMR        # COUNT TIMERS DOWN TO POS ZERO.
                TCF     CHKRTIMR
DECRTIMR        TS      RGIMTIMR
                TCF     CHKRTIMR +3

TURNOFFQ        TS      NEGUQ           # HALT DRIVES.
                TS      QACCDOT
                CS      QGIMBITS
                EXTEND
                WAND    CHAN12
                CAF     NEGMAX
                TS      QGIMTIMR
                TCF     CHKRTIMR
TURNOFFR        TS      NEGUR
                TS      RACCDOT
                CS      RGIMBITS
                EXTEND
                WAND    CHAN12
                CAF     NEGMAX
                TS      RGIMTIMR
                TCF     CHKRTIMR +3
QGIMBITS        EQUALS  OCT1400         # BITS 9 AND 10 (OF CHANNEL 12).
RGIMBITS        EQUALS  PRIO6           # BITS 11 AND 12 (OF CHANNEL 12).
SKIPPAXS        CA      CHKVISAD
                TS      PJUMPADR
                TCF     QRAXIS          # GO TO QRAXIS OR TO GTS.

# Y-Z TRANSLATION
#
# INPUT:   BITS 9-12 OF CH31 (FROM TRANSLATION CONTROLER)
#
# OUTPUT:  NEXTP
#
#   NEXTP IS THE CHANNEL 6 CODE OF JETS FOR THE DESIRED TRANSLATION.
#   IF THERE ARE FAILURES IN THE DESIRED POLICY, THEN
#      (1) FOR DIAGONAL TRANS:  UNFAILED PAIR
#                               ALARM (IF NO PAIR)
#      (2) FOR PRINCIPAL TRANS: TRY TO TACK WITH DIAGONAL PAIRS
#                               ALARM (IF DIAGONAL PAIRS ARE FAILED)

CHKVISFZ        EXTEND
                READ    CHAN31
                CS      A
                MASK    07400OCT
                EXTEND
                BZF     TSNEXTP
                EXTEND
                MP      BIT7
                INDEX   A
                CA      INDXYZ
                TS      ROTINDEX
TRYUORV         CA      SIX
                TC      SELECTYZ
                CS      SIX
                AD      NUMBERT
                EXTEND
                BZF     TSNEXTP -1
                CS      FIVE
                AD      ROTINDEX
                EXTEND
                BZMF    ALTERYZ
                CS      NUMBERT
                AD      FOUR
                EXTEND
                BZMF    TSNEXTP -1
ABORTYZ         TC      ALARM
                OCT     02001
                INCR    ZEROOR1
                CA      ZERO
                TCF     TSNEXTP
ALTERYZ         INCR    ZEROOR1
                CA      ZEROOR1
                MASK    BIT1
                AD      FOUR
                ADS     ROTINDEX
                TCF     TRYUORV
                CA      POLYTEMP
TSNEXTP         TS      NEXTP

# STATE LOGIC
#   CHECK IN ORDER:             IF ON
#   LPDPHASE                    GO TO PURGENCY
#   PULSES                      MINIMUM PULSE LOGIC
#   DETENT(BIT15 CH31)          RATE COMMAND
#   GO TO PURGENCY

                CA      BIT13           # CHECK STICK IF IN ATT. HOLD.
                EXTEND
                RAND    CHAN31
                EXTEND
                BZF     MANMODE

                CA      DAPBOOLS
                MASK    XOVINHIB
                CCS     A
                TCF     PURGENCY        # ATTITUDE STEER DURING VISIBILITY PHASE

                TCF     DETENTCK
MANMODE         CA      PULSES          # PULSES IS ONE FOR PULSE MODE
                MASK    DAPBOOLS
                EXTEND
                BZF     DETENTCK        # BRANCH FOR RATE COMMAND

                CA      ZERO
                TS      PERROR

# MINIMUM IMPULSE MODE

                CA      CDUX
                TS      CDUXD

                CCS     OLDPMIN
                TCF     CHECKP

FIREP           CA      BIT3
                EXTEND
                RAND    CHAN31
                EXTEND
                BZF     +XMIN

                CA      BIT4
                EXTEND
                RAND    CHAN31
                EXTEND
                BZF     -XMIN

                TCF     JETSOFF

CHECKP          EXTEND
                READ    CHAN31
                CS      A
                MASK    OCT14
                TS      OLDPMIN
                TCF     JETSOFF

-XMIN           CS      TEN             # ANYTHING LESS THAN 14MS.  CORRECTED
                TCF     +2              #   IN JET SELECTION ROUTINE
+XMIN           CA      TEN
                TS      TJP
                CA      ONE
                TS      OLDPMIN
                TCF     PJETSLEC -6

#                                       MANUAL RATE COMMAND MODE
#                                       ========================
#                                         BY ROBERT F. STENGEL
#
# THIS MODE PROVIDES RCAH MANUAL CONTROL THRU 2 CONTROL LAWS:                    1) DIRECT RATE AND 2) PSEUDO-AUTO.
# THE DIRECT RATE MODE AFFORDS IMMEDIATE CONTROL WITHOUT OVERSHOOT. THE PSEUDO-AUTO MODE PROVIDES PRECISE
# RATE CONTROL AND ATTITUDE HOLD.
#
# IN DIRECT RATE, JETS ARE FIRED WHEN STICK POSITION CHANGES BY A FIXED NUMBER OF INCREMENTS IN ONE DAP CYCLE.
# THE 'BREAKOUT LEVEL' IS .6 D/S FOR LM-ONLY AND .3 D/S FOR CSM-DOCKED. THIS LAW NULLS THE RATE ERROR TO WITHIN
# THE 'TARGET DEADBAND', WHICH EQUALS THE BREAKOUT LEVEL.
# IN PSEUDO-AUTO, BODY-FIXED RATE AND ATTITUDE ERRORS ARE SUPPLIED TO TJETLAW, WHICH EXERCISES CONTROL.
# CONTROL SWITCHES FROM DIRECT RATE TO PSEUDO-AUTO IF THE TARGET DB IS ACHIEVED OR IF TIME IN (1) EXCEEDS 4 SEC.
# IF THE INITIAL COMMAND DOES NOT EXCEED THE BREAKOUT LEVEL, CONTROL GOES TO PSEUDO-AUTO IMMEDIATELY.
#
# SINCE P-AXIS CONTROL IS SEPARATE FROM Q,R AXES CONTROL, IT IS POSSIBLE TO USE (1) IN P-AXIS AND (2) IN Q,R AXES,
# OR VICE VERSA.  THIS ALLOWS A DEGREE OF ATTITUDE HOLD IN UNCONTROLLED AXES.  DUE TO U,V CONTROL, HOWEVER, Q AND
# R AXES ARE COUPLED AND MUST USE THE SAME CONTROL LAW.
#
# HAND CONTROLLER COMMANDS ARE SCALED BY A LINEAR/QUADRATIC LAW. FOR THE LM-ALONE, MAXIMUM COMMANDED RATES ARE 20
# AND 4 D/S IN NORMAL AND FINE SCALING; HOWEVER, STICK SENSITIVITY AT ZERO COUNTS (OBTAINED AT A STICK DEFLECTION
# OF 2 DEGREES FROM THE CENTERED POSITION) IS .5 OR .1 D/S PER DEGREE. NORMAL AND FINE SCALINGS FOR THE CSM-DOCKED
# CASE IS AUTOMATICALLY SET TO 1/10 THE ABOVE VALUES. SCALING IS DETERMINED IN ROUTINE 3.
# ZEROENBL      ENABLES COUNTERS SO THEY CAN BE READ NEXT TIME
# JUSTOUT       FIRST DETECTION OF OUT OF DETENT (BY OURRCBIT)

DETENTCK        CAF     BIT15           # CHECK OUT-OF-DETENT BIT.
                EXTEND
                RAND    CHAN31
                EXTEND
                BZF     RHCMOVED        # BRANCH IF OUT OF DETENT.
                CAF     OURRCBIT        # IN DETENT. CHECK THE RATE COMMAND BIT.
                MASK    DAPBOOLS
                EXTEND
                BZF     PURGENCY        # BRANCH IF NOT IN RATE COMMAND LAST PASS.

# ........................................................................

                CAF     BIT13           # CHECK FOR ATTITUDE HOLD.
                EXTEND
                RAND    CHAN31
                EXTEND
                BZF     JOEY            # BRANCH IF IN ATTITUDE HOLD.

                CCS     OMEGAP
                TCF     +4
                TCF     RATEDONE
                TCF     +2
                TCF     RATEDONE
                AD      -RATEDB
                EXTEND                  # BRANCH IF P-AXIS RATE > RATEDB.
                BZMF    RATEDONE

                CAF     ZERO
                TCF     JOEY

RATEDONE        CS      OURRCBIT        # MANUAL COMMAND AND DAMPING COMPLETED IN
                INHINT                  # ALL AXES.
                MASK    DAPBOOLS
                TS      DAPBOOLS

# READ CDUS INTO CDU DESIRED REGISTERS

                CA      CDUX            # (X-AXIS OVERRIDE)
                TS      CDUXD
                TCF     PURGENCY

                TS      PERROR
JUSTOUT         CA      OURRCBIT        # INITIALIZATION - FIRST MANUAL PASS.
                INHINT
                ADS     DAPBOOLS
                RELINT
                CA      ZERO
                TS      Q-RHCCTR
                TS      R-RHCCTR
                TC      ZEROENBL
                TCF     JETSOFF
ZEROENBL        LXCH    R-RHCCTR
                CA      Q-RHCCTR
                DXCH    SAVEHAND
                CA      ZERO
                TS      P-RHCCTR
                TS      Q-RHCCTR
                TS      R-RHCCTR
                CA      BITS8,9
                EXTEND
                WOR     CHAN13          # COUNTERS ZEROED AND ENABLED
                TC      Q

RHCMOVED        CA      RHCSCALE
                MASK    DAPBOOLS
                CCS     A
                CA      -1.0D/S
                AD      -0.4D/S
                TS      -RATEDB

                CA      OURRCBIT        # P CONTROL
                MASK    DAPBOOLS
                EXTEND
                BZF     JUSTOUT -1

                CA      RHCSCALE        # LINEAR CONTROLLER SCALING
                MASK    DAPBOOLS
                CCS     A
                CA      143DEC          # SCALE P-RHCCTR FOR 20D/S MAX (177D)
                AD      34DEC           # SCALE P-RHCCTR FOR 4D/S MAX (34D)
                EXTEND
                MP      P-RHCCTR
                CA      L

JOEY            EXTEND                  # FORM THE RATE ERROR.
                SU      OMEGAP
                TS      EDOTP
                CCS     EDOTP
                TCF     +3
                TCF     +2
                TCF     +1
                TS      ABSEDOTP
                AD      TARGETDB
                EXTEND
                BZMF    ZEROENBL -2
                TC      ZEROENBL

PEGI            CA      CDUX            # DIRECT RATE CONTROL.
                TS      CDUXD
                CA      EDOTP
                EXTEND
                MP      1/2JTSP         # 1/2JTSP SCALED AT 2EXP(7)/PI
                DAS     A
                DAS     A
                TC      OVERSUB
                EXTEND
                MP      25/32           # A CONTAINS TJET SCALED AT 2EXP(4)(16/25)
                TS      TJP             # 4.JET TIME
                CA      ABSEDOTP
                AD      -2JETLIM        # COMPARING DELTA RATE WITH 2 JET LIMIT
                EXTEND
                BZMF    +3

                CA      SIX
                TCF     +8D
                CA      TJP
                ADS     TJP

# GOES TO PJETSLEC FOR TWO JETS
#
# P-JET-SELECTION-ROUTINE (ROTATION)
#
# INPUT:        NUMBERT         4,5,6 FOR WHICH PAIR OR 4 JETS
#               TJP             + FOR +P ROTATION
#
# OUTPUT:       CHANNEL 6
#               PJUMPADR        FOR P-AXIS SKIP
#               (JTLST CALL)    (SMALL TJP)
#
# ORDER OF POLICIES TRIED IN CASE OF FAILURE.
#       +P      -P
#       7,15    8,16
#       4,12    3,11
#       4,7     8,11
#       7,12    11,16
#       12,15   3,16
#       4,15    3,8
#       ALARM   ALARM

                CA      AORBSYST
                MASK    DAPBOOLS
                CCS     A
                CA      ONE
                AD      FOUR
                TS      NUMBERT
PJETSLEC        CA      ONE
                TS      L
                CCS     TJP
                TCF     +5
                TCF     JETSOFF
                TCF     +2
                TCF     JETSOFF
                ZL
                AD      ONE
                TS      ABSTJ
                LXCH    ROTINDEX
                TC      SELECTP
                CS      SIX
                AD      NUMBERT
                EXTEND
                BZF     +2

                CS      TWO
                AD      FOUR
                TS      NO.PJETS
                CA      POLYTEMP
                TC      WRITEP
                CS      ABSTJ
                AD      +150MST6
                EXTEND
                BZMF    QRAXIS          # GO TO QRAXIS OR TO GTS.

                AD      -136MST6
                EXTEND
                BZMF    +5

                ADS     ABSTJ
                INDEX   ROTINDEX
                CA      MINTIMES
                TS      TJP

                CA      ABSTJ
                ZL
                INHINT
                DXCH    T6FURTHA
                TC      IBNKCALL
                CADR    JTLST
                CA      PSKIPADR
                TS      PJUMPADR

                TC      ALTSYST
                TCF     QRAXIS

ALTSYST         CA      DAPBOOLS        # ALTERNATE P-AXIS JETS
                TS      L
                CA      AORBSYST
                EXTEND
                RXOR    LCHAN
                TS      DAPBOOLS
                RELINT
                TC      Q

DKALT           TC      ALTSYST

JETSOFF         TC      WRITEP  -1
                CA      ZERO
                TS      TJP
                TCF     QRAXIS

# (NOTE -- M13 = 1 IDENTICALLY IMPLIES NULL MULTIPLICATION.)

CALCPERR        CA      CDUY            # P-ERROR CALCULATION.
                EXTEND
                MSU     CDUYD           # CDU VALUE - ANGLE DESIRED (Y-AXIS)            
                EXTEND
                MP      M11             # (CDUY-CDUYD)M11 SCALED AT PI RADIANS
                XCH     E               # SAVE FIRST TERM (OF TWO)
                CA      CDUX            # THIRD COMPONENT
                EXTEND
                MSU     CDUXD           # CDU VALUE - ANGLE DESIRED (X-AXIS)
#               EXTEND
#               MP      M13
                AD      DELPEROR        # KALCMANU INERFACE ERROR
                ADS     E               # SAVE SUM OF TERMS.  COULD BE OVERFLOW.
                XCH     PERROR          # SAVE P-ERROR FOR EIGHT-BALL DISPLAY.
                TC      Q               # RETURN TO CALLER

# P-AXIS URGENCY FUNCTION CALCULATION.
PURGENCY        TC      CALCPERR        # CALCULATE P-AXIS ERRORS.
                CS      OMEGAPD         # THIS CODING IS COMMON TO BOTH LM DAP AND
                AD      OMEGAP          # SPS-BACKUP MODE.
                TS      EDOTP           # EDOTP = OMEGAP - OMEGAPD AT PI/4 RAD/SEC

                CS      ONE
                TS      AXISCTR
                CA      DAPBOOLS
                MASK    CSMDOCKD
                EXTEND
                BZF     HEADTJET
                INHINT                  # IF CSMDOCKD = 1, GO TO DOCKED RCS LOGIC
                TC      IBNKCALL
                CADR    SPSRCS

                CA      TJP
                EXTEND
                BZF     DKALT           # IF TJP = ZERO, CHANGE AORBSYST.
                RELINT
                CS      NUMBERT
                AD      SIX
                EXTEND                  # IF NUMBERT = 6 BYPASS AORBSYST CHECK
                BZF     PJETSLEC        #    AND USE FOUR JETS,  OTHERWISE,
                TCF     PJETSLEC -6     #    SELECT AORBSYST AND USE TWO JETS
HEADTJET        CA      ZERO
                TS      SENSETYP
                INHINT
                TC      IBNKCALL
                CADR    TJETLAW
                RELINT
                
                CS      FIREFCT
                AD      -FOURDEG
                EXTEND
                BZMF    PJETSLEC -6
                CCS     TJP
                TCF     +2
                TCF     JETSOFF 
                AD      -160MST6
                EXTEND
                BZMF    PJETSLEC -6
                CA      SIX
                TCF     PJETSLEC -1
-160MST6        DEC     -256
-FOURDEG        DEC     -.08888

LOWSCALE        CA      -0.4D/S
                TS      -RATEDB
                CS      E
                EXTEND
                SU      EDOTP
                TCF     JOEY +3

# JET POLICY CONSTRUCTION SUBROUTINE
#
# INPUT:        ROTINDEX, NUMBERT
#
# OUTPUT:       POLYTEMP (JET POLICY)
#
# THIS SUBROUTINE SELECT A SUBSET OF THE DESIRED JETS WHICH HAS NO FAILURE

SELECTP         CA      SIX
                TS      TEMPNUM
                INDEX   NUMBERT
                CA      TYPEP
                INDEX   ROTINDEX
                MASK    JETSALL
                TS      POLYTEMP
                MASK    CH6MASK
                CCS     A
                TCF     +2
                TC      Q
                CCS     TEMPNUM
                TCF     +4
                TC      ALARM
                OCT     02003
                TCF     JETSOFF         # *****TCF ALARMJET *********************
SELECTYZ        TS      NUMBERT
                TCF     SELECTP +1
-1              TCF     ABORTYZ +2
JETSALL         OCT     00252
                OCT     00125           # +P
                OCT     00140           # -Y
                OCT     00006           # -Z
                OCT     00220           # +Y
                OCT     00011           # +Z
                OCT     00151           # +V
TYPEP           OCT     00146           # -U
                OCT     00226           # -V
                OCT     00231           # +U
                OCT     00151           # +V
                OCT     00132           # 1-3
                OCT     00245           # 2-4
                OCT     00377           # ALL
INDXYZ          =       -136MST6
-136MST6        DEC     -218
                DEC     4
                DEC     2
                OCT     07776
                DEC     5
                DEC     9
                DEC     10
                OCT     07776
                DEC     3
                DEC     8
                DEC     7
                OCT     07776           # THESE INDEXES OF MASK JETSALL WILL
                OCT     07776           # CHANGE THE INSTRUCTION AT SELECTP +4
                OCT     07776           # TO BE    TC  JETSALL -1
                OCT     07776           # ONLY USED FOR TRANSLATION FAILURE
                OCT     07776
+150MST6        DEC     240
07400OCT        OCT     07400

# T-JET LAW FIXED CONSTANTS

NORMSCL         OCT     266
-1.0D/S         DEC     -364
-0.4D/S         DEC     -145
-100MS          DEC     -.1
200MS           DEC     .2
143DEC          =       OCT217
25/32           =       PRIO31          # (DEC .78125)
BITS8,9         OCTAL   00600
1/40            DEC     .02500
MINTIMES        DEC     -22
                DEC     22
PSKIPADR        GENADR  SKIPPAXS

# GOES TO Q,R-AXES RCS AUTOPILOT
QRAXIS          CS      OMEGARD
                AD      OMEGAR
                TC      OVERSUB
                TS      EDOTR
                CS      OMEGAQD
                AD      OMEGAQ
                TC      OVERSUB
                TS      EDOTQ
                EXTEND
                DCA     QERRCALL
                DTCB

                EBANK=  AOSQ
QERRCALL        2CADR   CALLQERR
