### FILE="Main.annotation"
## Copyright:   Public domain.
## Filename:    R13.agc
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



                EBANK=          E2DPS

# ****************************************************************************************************************
# GUILDENSTERN:  AUTO-MODES MONITOR (R13)
# ****************************************************************************************************************

                COUNT*          $$/R13

#    HERE IS THE PHILOSOPHY OF GUILDENSTERN:    ON EVERY APPEARANCE OR DISAPPEARANCE OF THE MANUAL THROTTLE
# DISCRETE TO SELECT P67 OR P66 RESPECTIVELY;   ON EVERY APPEARANCE OF THE ATTITUDE-HOLD DISCRETE TO SELECT P66
# UNLESS THE CURRENT PROGRAM IS P67 IN WHICH CASE THERE IS NO CHANGE.

GUILDEN         EXTEND                                  # IS UN-AUTO-THROTTLE DISCRETE PRESENT?
  STERN         READ            CHAN30
                MASK            BIT5
                CCS             A
                TCF             STARTP67                # YES
P67NOW?         TC              CHECKMM                 # NO:   ARE WE IN P67 NOW?
                DEC             67
                TCF             STABL?                  # NO
STARTP66        TC              FASTCHNG                # YES
                TC              NEWMODEX
DEC66           DEC             66
                EXTEND                                  # INITIALIZE VDGVERT USING
                DCA             VGU                     #   PRESENT DOWNWARD VELOCITY
                DXCH            VDGVERT
                CAF             ZERO
                TS              RODCOUNT
VRTSTART        TS              WCHVERT
                CAF             VERTADR                 # WCHPHASE = VERTICAL: P65,P66,P67
                TS              WCHPHASE
                TC              DOWNFLAG                # PERMIT X-AXIS OVERRIDE
                CADR            XOVINFLG
                TCF             GUILDRET

STARTP67        TC              NEWMODEX                # NO HARM IN "STARTING" P67 OVER AND OVER
                DEC             67                      #   SO NO NEED FOR A FASTCHNG AND NO NEED

                CAF             TEN                     #   TO SEE IF ALREADY IN P67
                TCF             VRTSTART

STABL?          CAF             BIT14                   # IS AUTO MODE DISCRETE PRESENT?
                EXTEND
                RAND            CHAN31
                EXTEND
                BZF             GUILDRET                # YES: ALL'S WELL
P66NOW?         TC              CHECKMM                 # NO:  ARE WE IN P66 NOW?
                DEC             66
                TCF             STARTP66                # NO
                TCF             GUILDRET                # YES

VERTADR         ADRES           VERTICAL
