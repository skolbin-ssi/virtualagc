# Copyright:	Public domain.
# Filename:	Makefile
# Purpose:	Makefile for Manche45 Revision 2.
#		The final, flown release of the software for the Command
#		Module's (CM) Apollo Guidance Computer (AGC) for Apollo 10. It
#		has been reconstructed from a listing of Comanche 055 and NASA
#		drawing 2021153D.
# Contact:	Ron Burkey <info@sandroid.org>.
# Website:	http://www.ibiblio.org/apollo
# Mod history:	2019-08-04 MAS	Created from Comanche 055.

BASENAME=Manche45R2

NO_BINSOURCE=yes
EXTRA_TARGETS=diffManche45R2sums

include ../Makefile.inc

.PHONY: diffManche45R2sums
diffManche45R2sums:
	../Tools/check_buggers.py Manche45R2.bin Manche45R2.buggers
