### FILE="Main.annotation"
## Copyright:   Public domain.
## Filename:    ORBITAL_INTEGRATION.agc
## Purpose:     A section of a reconstructed, mixed version of Sundance
##              It is part of the reconstructed source code for the Lunar
##              Module's (LM) Apollo Guidance Computer (AGC) for Apollo 9.
##              No original listings of this program are available;
##              instead, this file was created via disassembly of dumps
##              of various revisions of Sundance core rope modules.
## Assembler:   yaYUL
## Contact:     Ron Burkey <info@sandroid.org>.
## Website:     www.ibiblio.org/apollo/index.html
## Mod history: 2020-06-17 MAS  Created from Luminary 69.

## Sundance 302

# DELETE
                BANK    13
                SETLOC  ORBITAL
                BANK
                COUNT*  $$/ORBIT

# DELETE
KEPPREP         LXA,2   SETPD
                        PBODY
                        0
                DLOAD*  SQRT            # SQRT(MU) (+18 OR +15)         0D      PL 2D
                        MUEARTH,2
                PDVL    UNIT            #                                       PL 8D
                        RCV
                PDDL    NORM            # NORM R (+29 OR +27 - N1)      2D      PL 4D
                        36D
                        X1
                PDVL
                DOT     PDDL            # F*SQRT(MU)(+7 OR +5)          4D      PL 6D
                        VCV
                        TAU.            # (+28)
                DSU     NORM
                        TC
                        S1
                SR1
                DDV     PDDL
                        2D
                DMP     PUSH            # FS(+6 +N1-N2)                 6D      PL 8D
                        4D
                DSQ     PDDL            # (FS)SQ (+12 +2(N1-N2))        8D      PL 10D
                        4D
                DSQ     PDDL*           # SSQ/MU (-2 OR +2(N1-N2))      10D     PL 12D
                        MUEARTH,2
                SR3     SR4
                PDVL    VSQ             # PREALIGN MU (+43 OR +37)      12D     PL 14D
                        VCV
                DMP     BDSU            #                                       PL 12D
                        36D
                DDV     DMP             #                                       PL 10D
                        2D              # -(1/R-ALPHA) (+12 +3N1-2N2)
                DMP     SL*
                        DP2/3
                        0 -3,1          # 10L(1/R-ALPHA) (+13 +2(N1-N2))
                XSU,1   DAD             # 2(FS)SQ - ETCETRA                     PL 8D
                        S1              # X1 = N2-N1
                SL*     DSU             # -FS+2(FS)SQ ETC (+6 +N1-N2)           PL 6D
                        8D,1
                DMP     DMP
                        0D
                        4D
                SL*     SL*
                        8D,1
                        0,1             # S(-FS(1-2FS)-1/6...) (+17 OR +16)
                DAD     PDDL            #                                       PL 6D
                        XKEP
                DMP     SL*             # S(+17 OR +16)
                        0D
                        1,1
                BOVB    DAD
                        TCDANZIG
                STADR
                STORE   XKEPNEW
                STQ     AXC,1
                        KEPRTN
                DEC     10
                BON     AXC,1
                        MOONFLAG
                        KEPLERN
                DEC     2
                GOTO
                        KEPLERN

FBR3            LXA,1   SSP
                        DIFEQCNT
                        S1
                DEC     -13
                DLOAD   SR
                        DT/2
                        9D
                TIX,1   ROUND
                        +1
                PUSH    DAD
                        TC
                STODL   TAU.
                DAD
                        TET
                STCALL  TET
                        KEPPREP

# AGC ROUTINE TO COMPUTE ACCELERATION COMPONENTS.

ACCOMP          LXA,1   LXA,2
                        PBODY
                        PBODY
                VLOAD
                        ZEROVEC
                STOVL   FV
                        ALPHAV
                VSL*    VAD
                        0 -7,2
                        RCV
                STORE   BETAV
                BOF     XCHX,2
                        DIM0FLAG
                        +5
                        DIFEQCNT
                STORE   VECTAB,2
                XCHX,2
                        DIFEQCNT
                VLOAD   UNIT
                        ALPHAV
                STODL   ALPHAV
                        36D
                STORE   ALPHAM
                CALL
                        GAMCOMP
                VLOAD   SXA,1
                        BETAV
                        S2
                STODL   ALPHAV
                        BETAM
                STORE   ALPHAM
                BOF     DLOAD
                        MIDFLAG
                        OBLATE
                        TET
                CALL
                        LSPOS
                AXT,2   LXA,1
                        2
                        S2
                BOF
                        MOONFLAG
                        +3
                VCOMP   AXT,2
                        0
                STORE   BETAV
                STOVL   RPQV
                        2D
                STORE   RPSV
                SLOAD   DSU
                        MODREG
                        OCT27
                BHIZ    BOF
                        +3
                        DIM0FLAG
                        GETRPSV
                VLOAD   VXSC
                        ALPHAV
                        ALPHAM
                VSR*    VSU
                        1,2
                        BETAV
                XCHX,2
                        DIFEQCNT
                STORE   VECTAB +6,2
                STORE   RQVV
                XCHX,2
                        DIFEQCNT
GETRPSV         VLOAD   INCR,1
                        RPQV
                        4
                CLEAR   BOF
                        RPQFLAG
                        MOONFLAG
                        +5
                VSR     VAD
                        9D
                        RPSV
                STORE   RPSV
                CALL
                        GAMCOMP
                AXT,2   INCR,1
                        4
                        4
                VLOAD
                        RPSV
                STCALL  BETAV
                        GAMCOMP
                GOTO
                        OBLATE
GAMCOMP         VLOAD   VSR1
                        BETAV
                VSQ     SETPD
                        0
                NORM    ROUND
                        31D
                PDDL    NORM            # NORMED B SQUARED TO PD LIST
                        ALPHAM          # NORMALIZE (LESS ONE) LENGTH OF ALPHA
                        32D             # SAVING NORM SCALE FACTOR IN X1
                SR1     PDVL
                        BETAV           # C(PDL+2) = ALMOST NORMED ALPHA
                UNIT
                STODL   BETAV
                        36D
                STORE   BETAM
                NORM    BDDV            # FORM NORMALIZED QUOTIENT ALPHAM/BETAM
                        33D
                SR1R    PUSH            # C(PDL+2) = ALMOST NORMALIZED RHO.
                DLOAD*
                        ASCALE,1
                STORE   S1
                XCHX,2  XAD,2
                        S1
                        32D
                XSU,2   DLOAD
                        33D
                        2D
                SR*     XCHX,2
                        0 -1,2
                        S1
                PUSH    SR1R            # RHO/4 TO 4D
                PDVL    DOT
                        ALPHAV
                        BETAV
                SL1R    BDSU            # (RHO/4) - 2(ALPHAV/2.BETAV/2)
                PUSH    DMPR            # TO PDL+6
                        4
                SL1
                PUSH    DAD
                        DQUARTER
                PUSH    SQRT
                DMPR    PUSH
                        10D
                SL1     DAD
                        DQUARTER
                PDDL    DAD             # (1/4)+2((Q+1)/4)      TO PD+14D
                        10D
                        HALFDP
                DMPR    SL1
                        8D
                DAD     DDV
                        THREE/8
                        14D
                DMPR    VXSC
                        6
                        BETAV           #               -
                PDVL    VSR3            # (G/2)(C(PD+4))B/2 TO PD+16D
                        ALPHAV
                VAD     PUSH            # A12 + C(PD+16D) TO PD+16D
                DLOAD   DMP
                        0
                        12D
                NORM    ROUND
                        30D
                BDDV    DMP*
                        2
                        MUEARTH,2
                DCOMP   VXSC
                XCHX,2  XAD,2
                        S1
                        S2
                XSU,2   XSU,2
                        30D
                        31D
                BOV                     # CLEAR OVIND
                        +1
                VSR*    XCHX,2
                        0 -1,2
                        S1
                VAD
                        FV
                STORE   FV
                BOV     RVQ             # RETURN IF NO OVERFLOW
                        +1
GOBAQUE         DLOAD   SR
                        H
                        9D
                PUSH    BDSU
                        TC
                STODL   TAU.
                        TET
                DSU     STADR
                STCALL  TET
                        KEPPREP
                CALL
                        RECTIFY
                SETGO
                        RPQFLAG
                        TESTLOOP
# THE OBLATE ROUTINE COMPUTES THE ACCELERATION DUE TO OBLATENESS. IT USES THE UNIT OF THE VEHICLE
# POSITION VECTOR FOUND IN ALPHAV AND THE DISTANCE TO THE CENTER IN ALPHAM. THIS IS ADDED TO THE SUM OF THE
# DISTURBING ACCELERATIONS IN FV AND THE PROPER DIFEQ STAGE IS CALLED VIA X1.

OBLATE          LXA,2   DLOAD
                        PBODY
                        ALPHAM
                SETPD   DSU*
                        0
                        RDE,2
                BPL     BOF             # GET URPV
                        NBRANCH
                        MOONFLAG
                        COSPHIE
                VLOAD   PDDL
                        ALPHAV
                        TET
                PDDL    CALL
                        3/5
                        R-TO-RP
                STORE   URPV
                VLOAD   VXV
                        504LM
                        ZUNIT
                VAD     VXM
                        ZUNIT
                        MMATRIX
                UNIT                    # POSSIBLY UNNECESSARY
COMTERM         STORE   UZ
                DLOAD   DMPR
                        COSPHI/2
                        3/32
                PDDL    DSQ             # P2/64 TO PD0
                        COSPHI/2
                DMPR    DSU
                        15/16
                        3/64
                PUSH    DMPR            # P3/32 TO PD2
                        COSPHI/2
                DMP     SL1R
                        7/12
                PDDL    DMPR
                        0
                        2/3
                BDSU    PUSH            # P4/128 TO PD4
                DMPR    DMPR
                        COSPHI/2        # BEGIN COMPUTING P5/1024
                        9/16
                PDDL    DMPR
                        2
                        5/128
                BDSU
                DMP*
                        J4REQ/J3,2
                DDV     DAD             #              -3
                        ALPHAM          # (((P5/256)B 2  /R+P4/32)  /R+P3/8)ALPHAV
                        4               #            4             3
                DMPR*   DDV
                        2J3RE/J2,2
                        ALPHAM
                DAD     VXSC
                        2
                        ALPHAV
                STODL   TVEC
                DMP*    SR1
                        J4REQ/J3,2
                DDV     DAD
                        ALPHAM          #               -3
                DMPR*   SR3
                        2J3RE/J2,2      #    3        4
                DDV     DAD
                        ALPHAM
                VXSC    VSL1
                        UZ
                BVSU
                        TVEC
                STODL   TVEC
                        ALPHAM
                NORM    DSQ
                        X1
                DSQ     NORM
                        S1              #         4
                PUSH    BDDV*           # NORMED R  TO 0D
                        J2REQSQ,2
                VXSC
                        TVEC
                STORE   TVEC
                XAD,1   XAD,1
                        X1
                        X1
                XAD,1   BOF
                        S1
                        MOONFLAG
                        NBRANCH1
                DLOAD   DSQ             #  2
                        URPV            # X  B-2 TO 2D
                PDDL    DSQ
                        URPV +2         #  2  2
                DAD     PDDL            # Y +X  B-2 TO 2D
                        2D
                SL1     DSU

                        2D
                PDDL    PUSH            # X -Y  B-2 TO 4D  COSPHI2 TO 6D
                        COSPHI/2
                VXSC    PDDL            # 2COSPHI(UZ) B-3 TO 6D
                        UZ
                DSQ     DSU
                        3/5             #   2   2      2
                DMP     SL3             # (X -Y)((5COS (PHI)-3)UR 2COS(PHI)UZ)
                        5/8
                VXSC    VSU             #      B-3 TO 4D
                        ALPHAV
                VXSC    VSL2
                PDDL
                        URPV
                DMP     PDVL            # XY B-2 TO 10D
                        URPV +2
                        ALPHAV
                VXV     VXSC
                        UZ
                VSL3    VAD             # 4XY(UR X UZ) +D( 4D) B-3
                PDDL    SL2
                DMP     BDDV
                        0D              # 3J22R2MU/(X +Y )R
                        3J22R2MU
                VXSC    VSR3
                VSR2    VAD
                        TVEC
NBRANCH1        BOV
                        +1
                VSL*    VAD
                        0 -22D,1
                        FV
                STORE   FV
                BOV
                        GOBAQUE

NBRANCH         SLOAD   LXA,1
                        DIFEQCNT
                        MPAC
                DMP     CGOTO
                        -1/12
                        MPAC
                        DIFEQTAB
COSPHIE         DLOAD
                        ALPHAV  +4
                STOVL   COSPHI/2
                        ZUNIT
                GOTO
                        COMTERM
DIFEQTAB        CADR    DIFEQ+0
                CADR    DIFEQ+1
                CADR    DIFEQ+2
TIMESTEP        BOF     VLOAD
                        MIDFLAG
                        RECTEST
                        RCV
                DOT     BMN
                        VCV
                        RECTEST
                BON     BOF
                        MOONFLAG
                        LUNSPH
                        RPQFLAG
                        EARSPH
                DLOAD   CALL
                        TET
                        LSPOS           # RPQV IN MPAC
                STORE   RPQV            # RPQV
                LXA,2
                        PBODY
INLUNCHK        BVSU    ABVAL
                        RCV
                DSU     BMN
                        RSPHERE
                        DOSWITCH
RECTEST         VLOAD   ABVAL           # RECTIFY IF
                        TDELTAV
                BOV
                        CALLRECT
                DSU     BPL             #       1) EITHER TDELTAV OR TNUV EQUALS OR
                        3/4             #          EXCEEDS 3/4 IN MAGNITUDE
                        CALLRECT        #
                DAD     SL*             #                       OR
                        3/4             #
                        0 -7,2          #       2) ABVAL(TDELTAV) EQUALS OR EXCEEDS
                DDV     DSU             #          .01(ABVAL(RCV))
                        10D
                        RECRATIO
                BPL     VLOAD
                        CALLRECT
                        TNUV
                ABVAL   DSU
                        3/4
                BOV
                        CALLRECT
                BMN
                        INTGRATE
CALLRECT        CALL
                        RECTIFY
INTGRATE        VLOAD
                        TNUV
                STOVL   ZV
                        TDELTAV
                STORE   YV
                CLEAR
                        JSWITCH
DIFEQ0          VLOAD   SSP
                        YV
                        DIFEQCNT
                        0
                STODL   ALPHAV
                        DPZERO
                STORE   H               # START H AT ZERO.  GOES 0(DELT/2)DELT.
                BON     GOTO
                        JSWITCH
                        DOW..
                        ACCOMP
EARSPH          VLOAD   GOTO
                        RPQV
                        INLUNCHK
LUNSPH          DLOAD   SR2
                        10D
                DSU     BMN
                        RSPHERE
                        RECTEST
                BOF     DLOAD
                        RPQFLAG
                        DOSWITCH
                        TET
                CALL
                        LUNPOS
                VCOMP
                STORE   RPQV
DOSWITCH        CALL
                        ORIGCHNG
                GOTO
                        INTGRATE
ORIGCHNG        STQ     CALL
                        ORIGEX
                        RECTIFY
                VLOAD   VSL*
                        RCV
                        0,2
                VSU     VSL*
                        RPQV
                        2,2
                STORE   RRECT
                STODL   RCV
                        TET
                CALL
                        LUNVEL
                BOF     VCOMP
                        MOONFLAG
                        +1
                PDVL    VSL*
                        VCV
                        0,2
                VSU
                VSL*
                        0 +2,2
                STORE   VRECT
                STORE   VCV
                LXA,2   SXA,2
                        ORIGEX
                        QPRET
                BON     GOTO
                        MOONFLAG
                        CLRMOON
                        SETMOON
# THE RECTIFY SUBROUTINE IS CALLED BY THE INTEGRATION PROGRAM AND OCCASIONALLY BY THE MEASUREMENT INCORPORATION
# ROUTINES TO ESTABLISH A NEW CONIC.

RECTIFY         LXA,2   VLOAD
                        PBODY
                        TDELTAV
                VSL*    VAD
                        0 -7,2
                        RCV
                STORE   RRECT
                STOVL   RCV
                        TNUV
                VSL*    VAD
                        0 -4,2
                        VCV
MINIRECT        STORE   VRECT
                STOVL   VCV
                        ZEROVEC
                STORE   TDELTAV
                STODL   TNUV
                        ZEROVEC
                STORE   TC
                STORE   XKEP
                RVQ

# THE THREE DIFEQ ROUTINES - DIFEQ+0, DIFEQ+12, AND DIFEQ+24 - ARE ENTEREDTO PROCESS THE CONTRIBUTIONS AT THE
# BEGINNING, MIDDLE, AND END OF THE TIMESTEP, RESPECTIVELY.  THE UPDATING IS DONE BY THE NYSTROM METHOD.

DIFEQ+0         VLOAD   VSR3
                        FV
                STCALL  PHIV
                        DIFEQCOM
DIFEQ+1         VLOAD   VSR1
                        FV
                PUSH    VAD
                        PHIV
                STOVL   PSIV
                VSR1    VAD
                        PHIV
                STCALL  PHIV
                        DIFEQCOM
DIFEQ+2         DLOAD   DMPR
                        H
                        DP2/3
                PUSH    VXSC
                        PHIV
                VSL1    VAD
                        ZV
                VXSC    VAD
                        H
                        YV
                STOVL   YV
                        FV
                VSR3    VAD
                        PSIV
                VXSC    VSL1
                VAD     BOV
                        ZV
                        +1
                STORE   ZV
                BOFF    CALL
                        JSWITCH
                        ENDSTATE
                        GRP2PC
                LXA,2   VLOAD
                        COLREG
                        ZV
                VSL3                    # ADJUST W-POSITION FOR STORAGE
                STORE   W +54D,2
                VLOAD
                        YV
                VSL3    BOV
                        WMATEND
                STORE   W,2

                CALL
                        GRP2PC
                LXA,2   SSP
                        COLREG
                        S2
                        0
                INCR,2  SXA,2
                        6
                        YV
                TIX,2   CALL
                        RELOADSV
                        GRP2PC
                LXA,2   SXA,2
                        YV
                        COLREG

NEXTCOL         CALL
                        GRP2PC
                LXA,2   VLOAD*
                        COLREG
                        W,2
                VSR3                    # ADJUST W-POSITION FOR INTEGRATION
                STORE   YV
                VLOAD*  AXT,1
                        W +54D,2
                        0
                VSR3                    # ADJUST W-VELOCITY FOR INTEGRATION
                STCALL  ZV
                        DIFEQ0

ENDSTATE        VLOAD
                        ZV
                STOVL   TNUV
                        YV
                STORE   TDELTAV
                BON     BOFF
                        MIDAVFLG
                        CKMID2          # CHECK FOR MID2 BEFORE GOING TO TIMEINC
                        DIM0FLAG
                        TESTLOOP
                EXIT
                TC      PHASCHNG
                OCT     04022           # PHASE 1
                CS      RASFLAG         # PHASE CHANGE HAS OCCURRED BETWEEN
                MASK    REINTBIT        # INTSTALL AND INTWAKE
                ADS     RASFLAG
                TC      INTPRET
                SSP
                        QPRET
                        AMOVED
                BON     GOTO
                        VINTFLAG
                        ATOPCSM
                        ATOPLEM
AMOVED          SET     SSP
                        JSWITCH
                        COLREG
                DEC     -30
                BOFF    SSP
                        D6OR9FLG
                        NEXTCOL
                        COLREG
                DEC     -48
                GOTO
                        NEXTCOL

RELOADSV        DLOAD                   # RELOAD TEMPORARY STATE VECTOR
                        TDEC            # FROM PERMANENT IN CASE OF
                STCALL  TDEC1
                        INTEGRV2        # BY STARTING AT INTEGRV2.
DIFEQCOM        DLOAD   DAD             # INCREMENT H AND DIFEQCNT.
                        DT/2
                        H
                INCR,1  SXA,1
                DEC     -12
                        DIFEQCNT        # DIFEQCNT SET FOR NEXT ENTRY.
                STORE   H
                VXSC    VSR1
                        FV
                VAD     VXSC
                        ZV
                        H
                VAD
                        YV
                STORE   ALPHAV
                BON     GOTO
                        JSWITCH
                        DOW..
                        FBR3

WMATEND         CLEAR   CLEAR
                        DIM0FLAG        # DONT INTEGRATE W THIS TIME
                        ORBWFLAG        # INVALIDATE W
                CLEAR
                        RENDWFLG
                SET     EXIT
                        STATEFLG        # PICK UP STATE VECTOR UPDATE
                TC      ALARM
                OCT     421
                TC      INTPRET
                GOTO
                        TESTLOOP        # FINISH INTEGRATING STATE VECTOR

# ORBITAL ROUTINE FOR EXTRAPOLATION OF THE W MATRIX. IT COMPUTES THE SECOND DERIVATIVE OF EACH COLUMN POSITION
# VECTOR OF THE MATRIX AND CALLS THE NYSTROM INTEGRATION ROUTINES TO SOLVE THE DIFFERENTIAL EQUATIONS. THE PROGRAM
# USES A TABLE OF VEHICLE POSITION VECTORS COMPUTED DURING THE INTEGRATION OF THE VEHICLES POSITION AND VELOCITY.

DOW..           LXA,2   DLOAD*
                        PBODY
                        MUEARTH,2
                STCALL  BETAM
                        DOW..1
                STORE   FV
                BOF     INCR,1
                        MIDFLAG
                        NBRANCH
                DEC     -6
## The following line was LXC,2 in Luminary. Was this fixed for Sundance 306?
                LXA,2   DLOAD*
                        PBODY
                        MUEARTH -2,2
                STCALL  BETAM
                        DOW..1
                BON     VSR6
                        MOONFLAG
                        +1
                VAD
                        FV
                STCALL  FV
                        NBRANCH
DOW..1          VLOAD   VSR4
                        ALPHAV
                PDVL*   UNIT
                        VECTAB,1
                PDVL    VPROJ
                        ALPHAV
                VXSC    VSU
                        3/4
                PDDL    NORM
                        36D
                        S2
                PUSH    DSQ
                DMP
                NORM    PDDL
                        34D
                        BETAM
                SR1     DDV
                VXSC
                LXA,2   XAD,2
                        S2
                        S2
                XAD,2   XAD,2
                        S2
                        34D
                VSL*    RVQ
                        0 -8D,2

                SETLOC  ORBITAL1
                BANK

3/5             2DEC    .6 B-2

THREE/8         2DEC    .375

.3D             2DEC    .3 B-2

3/64            2DEC    3 B-6

DP1/4           2DEC    .25

DQUARTER        EQUALS  DP1/4
POS1/4          EQUALS  DP1/4
3/32            2DEC    3 B-5

15/16           2DEC    15. B-4

3/4             2DEC    3.0 B-2

7/12            2DEC    .5833333333

9/16            2DEC    9 B-4

5/128           2DEC    5 B-7

DPZERO          EQUALS  ZEROVEC
DP2/3           2DEC    .6666666667

2/3             EQUALS  DP2/3
OCT27           OCT     27

# LM504 IS TEMPORARY

# IT IS VITAL THAT THE FOLLOWING CONSTANTS NOT BE SHUFFLED
                DEC     -11
                DEC     -2
                DEC     -9
                DEC     -6
                DEC     -2
                DEC     -2
                DEC     0
                DEC     -12
                DEC     -9
                DEC     -4
ASCALE          DEC     -7
                DEC     -6

# *** THE ORDER OF THE FOLLOWING CONSTANTS MUST NOT BE CHANGED ***********

                2DEC*   1.32715445 E16 B-54* # S
MUM             2DEC*   4.9027780 E8 B-30*   # M

MUEARTH         2DEC*   3.986032 E10 B-36*
                2DEC    0

J4REQ/J3        2DEC*   .4991607391 E7 B-26*
                2DEC    0
2J3RE/J2        2DEC*   -.1355426363 E5 B-27*
                2DEC*   .3067493316 E18 B-60*
J2REQSQ         2DEC*   1.75501139 E21 B-72*
3J22R2MU        2DEC*   9.20479048 E16 B-58*

5/8             2DEC    5 B-3

-1/12           2DEC    -.1

RECRATIO        2DEC    .01

RSPHERE         2DEC    64373.76 E3 B-29

RDM             2DEC    16093.44 E3 B-27

RDE             2DEC    80467.20 E3 B-29

INTFLBIT        =       BIT14
REINTBIT        =       BIT7

RATT            EQUALS  00
VATT            EQUALS  6D
TAT             EQUALS  12D
RATT1           EQUALS  14D
VATT1           EQUALS  20D
MU(P)           EQUALS  26D
TDEC1           EQUALS  32D
URPV            EQUALS  14D
COSPHI/2        EQUALS  URPV    +4
UZ              EQUALS  20D
TVEC            EQUALS  26D

