/*
 * Copyright 2009,2010,2016-2021 Ronald S. Burkey <info@sandroid.org>
 *
 * This file is part of yaAGC.
 *
 * yaAGC is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * yaAGC is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with yaAGC; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * Filename:	VirtualAGC.cpp
 * Purpose:	This file contains the GUI event handlers for VirtualAGC.
 * 		The purpose of VirtualAGC is to provide a cross-platform
 *		GUI front-end that can be used to start up a Virtual AGC
 *		simulation (yaAGC, yaDSKY, yaAGS, etc.) in a convenient
 *		way.
 * Mods:	2009-03-02 RSB	Began.
 * 		2009-03-08 RSB	Getting close.
 *		2009-03-11 RSB	Added yaTelemetry, bypassing the workaround
 *				in which yaDSKY provided this service.
 *		2009-03-12 RSB	Now yaAGC and yaAGS load the symbol tables
 *				only if in --debug mode.  The tables are
 *				*big*, and on some platforms with limited
 *				memory the insistance on always loading them
 *				could cause yaAGC to run out of RAM and
 *				thus to abort at startup.
 *		2009-03-13 RSB	Added provision for different telemetry-screen
 *				types.
 *		2009-03-15 RSB	Added the Validation Suite simulation type.
 *				Added source-view buttons.
 *		2009-03-17 RSB	Can now show script contents from the
 *				run-simulation window.
 *		2009-03-23 RSB	Began adding digital-upload stuff.
 *		2009-03-24 RSB	That appears to work now.
 *		2009-03-25 RSB	Added custom AGC core-dump files.
 *		2009-03-26 RSB	Added shellouts for the Digital Uplink.
 *		2009-03-28 RSB	Replaced yaACA with yaACA3.
 *		2009-04-05 RSB	Tweaked the getting of the path to the
 *				executables to make it work properly in
 *				FreeBSD.
 *		2009-04-06 RSB	Now use yaACA3 *or* yaACA, depending on
 *				which one the configuration file is
 *				found for.
 *		2009-04-11 RSB	On the Mac OS X platform, replaced all
 *				uses of xterm by Terminator instead.
 *		2009-04-21 RSB	Accounted for reworking (shrinking) of
 *				VirtualAGC main window.
 *		2009-05-23 RSB	Activated Comanche055.  Also, allow
 *				Artemis72 source to be seen, though there's
 *				precious little of it!
 *		2009-06-07 RSB	Activated Luminary099.
 *		2009-07-04 RSB	Accounted for the new, jazzed-up html listings.
 *		2009-07-24 RSB	Replaced Colossus249 references with
 *				Apollo8Cm references, since I now think
 *				that 249 was for Apollo 9 and 237 was
 *				for Apollo 8.
 *		2010-02-16 RSB	Enabled the Artemis 072 button!
 *		2016-08-14 RSB  Enabled Colossus237.
 *		                And added Apollo 4 and 6 CM, and Apollo 5 LM,
 *		                buttons.
 *	        2016-08-28 RSB  Enabled the support for Apollo6, and added
 *	                        the buttons for AS-202 ("Apollo 3").
 *	        2016-11-07 RSB  Added Retread44, Aurora12, Sunburst39, and
 *	                        Zerlina buttons, and enabled Apollo 5
 *	                        (Sunburst 120) and Aurora12.
 *	        2016-11-08 RSB  Added ability to run Block 1 sims.
 *              2016-11-10 RSB  Refactored in terms of being a lot simpler to
 *                              add or edit mission types.  But also got rid of
 *                              a lot of the overly-complex event structure,
 *                              because almost all of the event handlers only
 *                              did one thing (namely, call EnforceConsistency()).
 *                              All lingering comments from wxGlade removed.
 *              2016-11-29 RSB  Fixed formation of 'simulate' script for Mac.
 *              2017-03-24 RSB  Added a SUPERJOB mission type, and activated the
 *                              Apollo 10 & 12 & 15-17 LM missions.  Also, now have
 *                              DSKY configurations that I *hope* are tailored to the
 *                              missions, as opposed to just being LM vs. CM.  This
 *                              affects only Apollo 15-17 LM, and missions prior to Apollo 7.
 *              2017-03-27 RSB  Added LUM99R2 and BOREALIS. Enabled Retread 44, which
 *                              was disabled for some reason.  Enabled Apollo 4, identifying
 *                              it with Apollo 6, since Solarium 54 and 55 programs are
 *                              believed to be identical.
 *              2017-04-17 RSB  Began adapting to use a drop-down list to choose the mission,
 *                              rather than a huge bunch of radio buttons.  This makes the
 *                              UI much smaller, and better for small displays.  It goes into
 *                              effect if the screen is smaller than 1280x1024.  Also, reading
 *                              the configuration file was not setting the AGC software version
 *                              correctly (it was always using Apollo 1), and somehow this
 *                              wasn't being noticed.  I don't see how that could be possible,
 *                              but that's what I was finding ....
 *              2017-04-18 RSB  In trying to build this with wxWidgets 3.0 (rather than the
 *                              recommended 2.8), the Run!, Default, and Exit buttons were too
 *                              small, height-wise.  Fixed that.
 *          	2017-05-30 RSB	Changed bogus references to Sunburst 39 to Sunburst 37.
 *          	2017-06-19 RSB	Enabled Sunburst 37.
 *          	2017-08-29 RSB	Enabled Zerlina 56.
 *          	2017-10-03 RSB	Changed definition of a "small" display to be anything less
 *          			than 1200 (as opposed to less than 1080), due to this issue:
 *          			https://github.com/virtualagc/virtualagc/issues/1051.
 *          	2018-03-04 RSB	Added the --radio-buttons, --normal, --squish and --maximize
 *          			command-line options for selecting the size of the UI window,
 *          			and removed the attempt to deduce an appropriate setting from
 *          			the number of pixels on the display ... which didn't seem to
 *          			work well anyway.
 *          	2019-07-23 RSB	Added SundialE.  I don't seem to have noted when I earlier
 *          			added Retread50, and perhaps other stuff.  What's the deal?
 *          	2019-07-28 RSB  Added Luminary 69 Rev 2 and Luminary 130.
 *          	2019-07-31 RSB	Added Comanche 51.  Also, I had added Luminary 97 and 98 a
 *          			couple of days ago, but neglected to mention it.
 *          	2019-08-16 RSB	Added Artemis 71.
 *          	2019-09-22 RSB  Added Luminary 163 and 173.
 *          	2020-07-23 RSB  Added Sundance XXX.
 *          	2020-08-13 RSB  Updated Apollo 9 LM support to use Sundance306ish (phase 2
 *          	                reconstruction of Sundance 306) in place of SundanceXXX
 *          	                (phase 1 reconstrunction).
 *          	2020-12-05 RSB  Added Comanche 44 and 45, though 45 isn't available yet, so
 *          	                it isn't enabled.
 *              2020-12-24 RSB  Enabled Comanche 45 and 45/2.  Also, filled in the details for
 *                              Comanche 45/2 (Manche45R2) that hadn't been available
 *                              before.  Also, I found that the message
 *                              displayed in the Simulation Status window was unnecessarily wide
 *                              and couldn't be used without the horizontal scroll bar.  I've
 *                              reformatted the message to fix that.
 *              2021-03-22 RSB  Changed constants (wxFONTFAMILY_xxx,
 *                              wxFONTSTYLE_xxx, wxFONTWEIGHT_xxx) used
 *                              in wxFont invocations, to avoid "deprecated"
 *                              warnings with wxWidgets 3.1.x. Removed
 *                              all wxALIGN_CENTRE's from wxStaticText
 *                              invocations; it seems never to have been
 *                              supported, and is now causing assertion
 *                              failures with wxWidgets 3.1.x. Eliminated combinations
 *                              of wxEXPAND with wxCENTER_xxx.  Eliminated
 *                              wxALIGN_CENTER_HORIZONTAL in horizontal sizers.
 *
 * This file was originally generated using the wxGlade RAD program.
 * However, it is now maintained entirely manually, and cannot be managed
 * in wxGlade.
 */

#include <stdio.h>
#include <errno.h>
#include <ctype.h>

#include "wx/file.h"
#include "wx/textfile.h"
#include "wx/stdpaths.h"
#include "wx/filefn.h"
#include "wx/utils.h"

#include "VirtualAGC.h"
#include "../yaAGC/yaAGC.h"
#include "../yaAGC/agc_engine.h"

int noSquish = 0;
int dropdownSquish = 1;
int maximumSquish = 0;
int maximizeAtStartup = 0;

/*
 * The following array specifies most properties of "missions" (i.e., specific
 * AGC program/versions). The array entries must be in the identical order of
 * the ID_xxxx constants in VirtualAGC.h that are in the range
 * ID_FIRSTMISSION <= ID_xxxx < ID_AGCCUSTOMBUTTON.  It contains all of the
 * constant data (tooltips, url, etc.) differentiating the various AGC software
 * versions, although a handful of special behaviors may be hardcoded separately.
 * Also, for newly-added missions, don't forget to add a consistency event for it
 * in the event table appearing later in this file.
 */
static const missionAlloc_t missionConstants[ID_AGCCUSTOMBUTTON
    - ID_FIRSTMISSION] =
      {
          //
            { "Apollo 1 Command Module", "",
                "Click this to select the unflown Apollo 1 mission.", DISABLED,
                CM, BLOCK1, NO_PERIPHERALS, "", "CM0.ini" },
            { "AS-202 (\"Apollo 3\") CM", "",
                "Click this to select the AS-202 (\"Apollo 3\") unmanned CM mission.",
                DISABLED, CM, BLOCK1, NO_PERIPHERALS, "", "CM0.ini" },
            { "Apollo 4 Command Module", "Solarium055/MAIN.agc.html",
                "Click this to select the unmanned Apollo 4 Block 1 CM mission, running software SOLARIUM 55, "
                    "which is believed to be identical to SOLARIUM 54.",
                ENABLED, CM, BLOCK1, NO_PERIPHERALS, "Solarium055", "CM0.ini" },
            { "Apollo 5 Lunar Module", "Sunburst120/MAIN.agc.html",
                "Click this to select the unmanned Apollo 5 LM mission, running software SUNBURST 120.",
                ENABLED, LM, BLOCK2, NO_PERIPHERALS, "Sunburst120", "LM0.ini" },
            { "Apollo 6 Command Module", "Solarium055/MAIN.agc.html",
                "Click this to select the unmanned Apollo 6 Block 1 CM mission, running software SOLARIUM 55.",
                ENABLED, CM, BLOCK1, NO_PERIPHERALS, "Solarium055", "CM0.ini" },
            { "2TV-1 Command Module", "SundialE/MAIN.agc.html",
                "Click this to select the 2TV-1 mission, running software Sundial E.",
                ENABLED, CM, BLOCK2, PERIPHERALS, "SundialE", "CM.ini" },
            { "Apollo 7 Command Module", "",
                "Click this to select the Apollo 7 mission.", DISABLED, CM,
                BLOCK2, PERIPHERALS, "", "CM.ini" },
            { "Apollo 8 Command Module", "Colossus237/MAIN.agc.html",
                "Click this to select the Apollo 8 mission, running software COLOSSUS 237.",
                ENABLED, CM, BLOCK2, PERIPHERALS, "Colossus237", "CM.ini" },
            { "Apollo 9 Command Module", "Colossus249/MAIN.agc.html",
                "Click this to select the CM for the Apollo 9 mission, running software COLOSSUS 249.",
                ENABLED, CM, BLOCK2, PERIPHERALS, "Colossus249", "CM.ini" },
            { "Apollo 9 Lunar Module", "Sundance306ish/MAIN.agc.html",
                "Click this to select the Sundance306ish (phase 2 reconstruction of Sundance 306) software for the Apollo 9 LM.",
                ENABLED, LM, BLOCK2, PERIPHERALS, "Sundance306ish", "CM.ini" /* Yes, the CM is intentional */},
            { "COMANCHE 44 (CM)", "Comanche044/MAIN.agc.html",
                "Click this to select software originally targeted (but not subsequently flown) in the CM for the Apollo 10 mission.",
                ENABLED, CM, BLOCK2, PERIPHERALS, "Comanche044", "CM.ini" },
            { "COMANCHE 45 (CM)", "Comanche045/MAIN.agc.html",
                "Click this to select software released (but not subsequently flown) in the CM for the Apollo 10 mission.",
                ENABLED, CM, BLOCK2, PERIPHERALS, "Comanche045", "CM.ini" },
            { "Apollo 10 Command Module", "Manche45R2/MAIN.agc.html",
                "Click this to select the CM for the Apollo 10 mission.",
                ENABLED, CM, BLOCK2, PERIPHERALS, "Manche45R2", "CM.ini" },
            { "LUMINARY 69 rev 0 (LM)", "Luminary069/MAIN.agc.html",
                "Click this to select Luminary 69 rev 0, a preliminary revision of the Apollo 10 LM software.",
                ENABLED, LM, BLOCK2, PERIPHERALS, "Luminary069", "CM.ini" /* Yes, the CM is intentional */},
            { "Apollo 10 Lunar Module", "LUM69R2/MAIN.agc.html",
                "Click this to select the LM for the Apollo 10 mission.",
                ENABLED, LM, BLOCK2, PERIPHERALS, "LUM69R2", "CM.ini" /* Yes, the CM is intentional */},
            { "COMANCHE 51 (CM)", "Comanche051/MAIN.agc.html",
                "Click this to select Comanche 51, the original software release targeting the Apollo 11 CM.",
                ENABLED, CM, BLOCK2, PERIPHERALS, "Comanche051", "CM.ini" },
            { "Apollo 11 Command Module", "Comanche055/MAIN.agc.html",
                "Click this to select the CM for the Apollo 11 mission, running software COMANCHE 55.",
                ENABLED, CM, BLOCK2, PERIPHERALS, "Comanche055", "CM.ini" },
            { "LUMINARY 97 (LM)", "Luminary097/MAIN.agc.html",
                "Click this to select Luminary 97, the original software release targeting the Apollo 11 LM.",
                ENABLED, LM, BLOCK2, PERIPHERALS, "Luminary097", "LM.ini" },
            { "LUMINARY 98 (LM)", "Luminary098/MAIN.agc.html",
                "Click this to select Luminary 98, an engineering revision of the Apollo 11 LM software.",
                ENABLED, LM, BLOCK2, PERIPHERALS, "Luminary098", "LM.ini" },
            { "LUMINARY 99 Rev 0 (LM)", "LMY99R0/MAIN.agc.html",
                "Click this to select Luminary 99 rev 0, the 2nd software release targeting the Apollo 11 LM.",
                ENABLED, LM, BLOCK2, PERIPHERALS, "LMY99R0", "LM.ini" },
            { "Apollo 11 Lunar Module", "Luminary099/MAIN.agc.html",
                "Click this to select the LM for the Apollo 11 mission, running software LUMINARY 99 Rev 1.",
                ENABLED, LM, BLOCK2, PERIPHERALS, "Luminary099", "LM.ini" },
            { "LUMINARY 99 rev 2 (LM)", "LUM99R2/MAIN.agc.html",
                "Click this to select Luminary 99 rev 2, a hypothetical but unflown revision of the Apollo 11 LM software.",
                ENABLED, LM, BLOCK2, PERIPHERALS, "LUM99R2", "LM.ini" },
            { "Apollo 12 Command Module", "",
                "Click this to select the CM for the Apollo 12 mission.",
                DISABLED, CM, BLOCK2, PERIPHERALS, "", "CM.ini" },
            { "Apollo 12 Lunar Module", "Luminary116/MAIN.agc.html",
                "Click this to select the LM for the Apollo 12 mission.",
                ENABLED, LM, BLOCK2, PERIPHERALS, "Luminary116", "LM.ini" },
            { "Apollo 13 Command Module", "",
                "Click this to select the CM for the Apollo 13 mission.",
                DISABLED, CM, BLOCK2, PERIPHERALS, "", "CM.ini" },
            { "LUMINARY 130 (LM)", "Luminary130/MAIN.agc.html",
                "Click this to select Luminary 130, a preliminary revision of the Apollo 13 LM software.",
                ENABLED, LM, BLOCK2, PERIPHERALS, "Luminary130", "LM.ini" },
            { "Apollo 13 Lunar Module", "Luminary131/MAIN.agc.html",
                "Click this to select the LM for the Apollo 13 mission, running software LUMINARY 131.",
                ENABLED, LM, BLOCK2, PERIPHERALS, "Luminary131", "LM.ini" },
            { "Apollo 14 Command Module", "",
                "Click this to select the CM for the Apollo 14 mission.",
                DISABLED, CM, BLOCK2, PERIPHERALS, "", "CM.ini" },
            { "LUMINARY 163 (LM)", "Luminary163/MAIN.agc.html",
                "Click this to select Luminary 163, the 1st software release targeting the Apollo 14 mission.",
                ENABLED, LM, BLOCK2, PERIPHERALS, "Luminary163", "LM.ini" },
            { "LUMINARY 173 (LM)", "Luminary173/MAIN.agc.html",
                "Click this to select Luminary 173, the 2nd software release targeting the Apollo 14 mission.",
                ENABLED, LM, BLOCK2, PERIPHERALS, "Luminary173", "LM.ini" },
            { "Apollo 14 Lunar Module", "Luminary178/MAIN.agc.html",
                "Click this to select the LM for the Apollo 14 mission.",
                ENABLED, LM, BLOCK2, PERIPHERALS, "Luminary178", "LM.ini" },
            { "ARTEMIS 71 (CM)", "Artemis071/MAIN.agc.html",
                "Click this to select Artemis 71, the initial software release targeting the CM for the Apollo 15 mission.",
                ENABLED, CM, BLOCK2, PERIPHERALS, "Artemis071", "CM.ini" },
            { "Apollo 15-17 Command Module", "Artemis072/MAIN.agc.html",
                "Click this to select the CM for the Apollo 15-17 mission, running software ARTEMIS 72.",
                ENABLED, CM, BLOCK2, PERIPHERALS, "Artemis072", "CM.ini" },
            { "Apollo 15-17 Lunar Module", "Luminary210/MAIN.agc.html",
                "Click this to select the LM for the Apollo 15-17 mission.",
                ENABLED, LM, BLOCK2, PERIPHERALS, "Luminary210", "LM1.ini" },
            { "Apollo Skylab Command Module", "",
                "Click this to select the Apollo-Soyuz mission.", DISABLED, CM,
                BLOCK2, PERIPHERALS, "", "CM.ini" },
            { "Apollo Soyuz Command Module", "",
                "Click this to select an Apollo-Skylab mission.", DISABLED, CM,
                BLOCK2, PERIPHERALS, "", "CM.ini" },
            { "Validation Suite", "Validation/Validation.agc.html",
                "Click this to select the AGC validation (non-mission) software.",
                ENABLED, LM, BLOCK2, NO_PERIPHERALS, "Validation", "LM.ini" },
            { "RETREAD 44 (LM)", "Retread44/MAIN.agc.html",
                "Click this to select the RETREAD 44 (earliest non-mission LM) software.",
                ENABLED, LM, BLOCK2, NO_PERIPHERALS, "Retread44", "LM0.ini" },
            { "RETREAD 50 (LM)", "Retread50/MAIN.agc.html",
                "Click this to select the RETREAD 50 software.",
                ENABLED, LM, BLOCK2, NO_PERIPHERALS, "Retread50", "LM0.ini" },
            { "AURORA 12 (LM)", "Aurora12/MAIN.agc.html",
                "Click this to select the AURORA 12 (early non-mission LM) software.  This is the last AGC version with full testing capabilities.",
                ENABLED, LM, BLOCK2, NO_PERIPHERALS, "Aurora12", "LM0.ini" },
            { "BOREALIS (LM)", "Borealis/MAIN.agc.html",
                "Click this to select the BOREALIS test-suite software.  BOREALIS is a modernized AGC self-test suite, based on AURORA.",
                ENABLED, LM, BLOCK2, NO_PERIPHERALS, "Aurora12", "LM0.ini" },
            { "SUNBURST 37 (LM)", "Sunburst37/MAIN.agc.html",
                "Click this to select the SUNBURST 37 (early non-mission LM) software.",
                ENABLED, LM, BLOCK2, NO_PERIPHERALS, "Sunburst37", "LM0.ini" },
            { "ZERLINA 56 (LM)", "Zerlina56/MAIN.agc.html",
                "Click this to select ZERLINA 56 (next-generation non-mission LM) software.",
                ENABLED, LM, BLOCK2, PERIPHERALS, "Zerlina56", "LM.ini" },
            { "SUPER JOB", "SuperJob/MAIN.agc.html",
                "Click this to select SUPER JOB (Raytheon Auxiliary Memory test) software.  Note that to run meaningfully, a simulated Auxiliary Memory unit (not yet available!) needs to be run also.",
                ENABLED, CM, BLOCK2, NO_PERIPHERALS, "SuperJob", "CM.ini" } };

// This is the array where shell commands for the Digital Uplink
// are stored.
#define MAX_SHELLOUTS 1024
static char *UplinkShellouts[MAX_SHELLOUTS];
static int NumShellouts = 0, OnShellout = 0;

#ifdef WIN32
#define EOL "\r\n"
#define PATH_DELIMITER '\\'
#define RESOURCE_PATH
#else
#define EOL "\n"
#define PATH_DELIMITER '/'
#endif

#define SET_FONT(Object,Relative) \
  Font = Object->GetFont (); \
  Font.SetPointSize (Points + Relative); \
  Object->SetFont (Font)

#define SCALE_BITMAP(Object) \
  Size = Object->GetSize (); \
  Height = (Size.GetHeight () * Points) / StartingPoints; \
  Width = (Size.GetWidth () * Points) / StartingPoints; \
  Image = Bitmap.ConvertToImage (); \
  Image.Rescale (Width, Height); \
  Bitmap = wxBitmap (Image); \
  Object->SetBitmap (Bitmap)

void
VirtualAGC::SetSize(void)
{
  wxFont Font;
  wxBitmap Bitmap;
  wxImage Image;
  wxSize Size;
  int Width, Height;
  if (!maximumSquish)
    {
      SET_FONT(SimTypeLabel, 2);
      SET_FONT(SimTypeLabel2, 2);
      SET_FONT(DeviceListLabel, 2);
      SET_FONT(OptionList, 2);
      SET_FONT(AeaCustomFilename, 0);
      SET_FONT(AeaCustomButton, 0);
    }
  //SET_FONT (AgcFilenameLabel, 0);
  SET_FONT(AgcCustomFilename, 0);
  //SET_FONT (AeaFilenameLabel, 0);
  int mission;
  for (mission = ID_FIRSTMISSION; mission < ID_AGCCUSTOMBUTTON; mission++)
    {
      SET_FONT(missionRadioButtons[mission - ID_FIRSTMISSION], 0);
    }
  SET_FONT(AgcCustomButton, 0);
  SET_FONT(DeviceAgcCheckbox, 0);
  SET_FONT(DeviceDskyCheckbox, 0);
  SET_FONT(DeviceAcaCheckbox, 0);
  SET_FONT(DeviceTelemetryCheckbox, 0);
  SET_FONT(DeviceAeaCheckbox, 0);
  SET_FONT(DeviceDedaCheckbox, 0);
  SET_FONT(DeviceCpumonCheckbox, 0);
  SET_FONT(DeviceImuCheckbox, 0);
  SET_FONT(DeviceDiscoutCheckbox, 0);
  SET_FONT(DeviceCrewinCheckbox, 0);
  SET_FONT(DeviceSysinCheckbox, 0);
  SET_FONT(DevicePropulsionCheckbox, 0);
  SET_FONT(NoviceButton, 0);
  SET_FONT(ExpertButton, 0);
  SET_FONT(FlightProgram4Button, 0);
  SET_FONT(FlightProgram5Button, 0);
  SET_FONT(FlightProgram6Button, 0);
  SET_FONT(FlightProgram7Button, 0);
  SET_FONT(FlightProgram8Button, 0);
  SET_FONT(StartupWipeButton, 0);
  SET_FONT(StartupPreserveButton, 0);
  SET_FONT(StartupResumeButton, 0);
  SET_FONT(CustomResumeButton, 0);
  SET_FONT(CoreFilename, 0);
  SET_FONT(CoreBrowse, 0);
  SET_FONT(CoreSaveButton, 0);
  SET_FONT(DskyLabel, 0);
  SET_FONT(DskyFullButton, 0);
  SET_FONT(DskyHalfButton, 0);
  SET_FONT(DskyLiteButton, 0);
  SET_FONT(DskyNavButton, 0);
  SET_FONT(DownlinkLabel, 0);
  SET_FONT(TelemetryResizable, 0);
  SET_FONT(TelemetryRetro, 0);
  SET_FONT(AgcDebugLabel, 0);
  SET_FONT(AgcDebugNormalButton, 0);
  SET_FONT(AgcDebugMonitorButton, 0);
  SET_FONT(DedaLabel, 0);
  SET_FONT(DedaFullButton, 0);
  SET_FONT(DedaHalfButton, 0);
  SET_FONT(AeaDebugLabel, 0);
  SET_FONT(AeaDebugNormalButton, 0);
  SET_FONT(AeaDebugMonitorButton, 0);
  SET_FONT(AgcSourceButton, 0);
  SET_FONT(AeaSourceButton, 0);
  SET_FONT(RunButton, 0);
  SET_FONT(DefaultsButton, 0);
  SET_FONT(ExitButton, 0);
}

VirtualAGC::VirtualAGC(wxWindow* parent, int id, const wxString& title,
    const wxPoint& pos, const wxSize& size, long style) :
    wxFrame(parent, id, title, pos, size,
        maximumSquish ?
            (maximizeAtStartup ? wxMAXIMIZE : 0) :
            (wxCAPTION | wxMINIMIZE_BOX | wxCLOSE_BOX | wxCLIP_CHILDREN
                | wxSYSTEM_MENU))
{

  // We auto-adjust fonts and image sizes if the screen size is too small.
  wxFont Font = GetFont();
  StartingPoints = Font.GetPointSize();
  Points = StartingPoints;
  //int x, y;
  //int height, width;
  //wxClientDisplayRect (&x, &y, &width, &height);
  DropDown = false;
  ReallySmall = false;
  if (maximumSquish)
    {
      Points = StartingPoints - 4;
      ReallySmall = true;
    }
  else if (dropdownSquish)
    {
      Points = StartingPoints - 2;
      ReallySmall = true;
    }
  if (ReallySmall)
    DropDown = true;
  if (Points < 8)
    Points = 8;
  Font.SetPointSize(Points);
  SetFont(Font);

  PathDelimiter = wxT("");
  PathDelimiter += PATH_DELIMITER;

  // Find the directory that the executable is in.  Then go up one
  // level and then down into Resources sub-directory.  I envision
  // the installation directory structure to be something like
  //	 .../VirtualAGC/bin
  // 	 .../VirtualAGC/Resources
  // in Win32 and Linux, and to be
  //   .../VirtualAGC.app/Contents/MacOS
  //   .../VirtualAGC.app/Contents/Resources
  // in Mac OS X.  The commonality here is the relative relationship
  // of the executables to the data files such as png images.
  ExecutableDirectory = wxStandardPaths::Get().GetExecutablePath().BeforeLast(
  PATH_DELIMITER);
#ifndef WIN32
  // In FreeBSD, for some reason, the operation above sometimes or always
  // returns a relative path rather than an absolute one.  So we need to convert
  // it to an absolute path.
  if (ExecutableDirectory.GetChar(0) != '/')
    {
      wxString old = ExecutableDirectory;
      wxString WorkingDir = wxGetCwd();
      ExecutableDirectory = WorkingDir;
      ExecutableDirectory += PATH_DELIMITER;
      ExecutableDirectory += old;
    }
#endif
  wxString TopDirectory = ExecutableDirectory.BeforeLast(PATH_DELIMITER);
  TopDirectory += PathDelimiter;
  RunDirectory = TopDirectory + wxT("Simulation");
  ResourceDirectory = TopDirectory + wxT("Resources");
  //wxMessageBox (ResourceDirectory, wxT ("Resource path"));
  wxSetWorkingDirectory(ResourceDirectory);
  //wxMessageBox (wxGetCwd (), wxT ("Working directory"));
  // The following contortions shouldn't be necessary, except that
  // I find wxGetHomeDir() doesn't always work.
  //wxString Dummy = wxT ("HOME");
  //if (!wxGetEnv (Dummy, &HomeDirectory))
  HomeDirectory = wxGetHomeDir();

  sizer_1_copy_staticbox = new wxStaticBox(this, -1, wxT("Browse Source Code"));
  sizer_18_staticbox = new wxStaticBox(this, -1, wxT("AGC Startup"));
  sizer_22_staticbox = new wxStaticBox(this, -1, wxT("Interface styles"));
  sizer_38_staticbox = new wxStaticBox(this, -1, wxT("Use AGC/AEA debugger?"));
  sizer_20_staticbox = new wxStaticBox(this, -1,
      wxT("LM Abort Computer (AEA) software"));
  sizer_19_staticbox = new wxStaticBox(this, -1,
      wxT("Guidance Computer (AGC) software"));
  if (!maximumSquish)
    {
      Patch1Bitmap = new wxStaticBitmap(this, wxID_ANY,
          wxBitmap(wxT("apo1.png"), wxBITMAP_TYPE_ANY));
      Patch7Bitmap = new wxStaticBitmap(this, wxID_ANY,
          wxBitmap(wxT("apo7.png"), wxBITMAP_TYPE_ANY));
      Patch8Bitmap = new wxStaticBitmap(this, wxID_ANY,
          wxBitmap(wxT("apo8.png"), wxBITMAP_TYPE_ANY));
      Patch9Bitmap = new wxStaticBitmap(this, wxID_ANY,
          wxBitmap(wxT("apo9.png"), wxBITMAP_TYPE_ANY));
      Patch10Bitmap = new wxStaticBitmap(this, wxID_ANY,
          wxBitmap(wxT("apo10.png"), wxBITMAP_TYPE_ANY));
      Patch11Bitmap = new wxStaticBitmap(this, wxID_ANY,
          wxBitmap(wxT("apo11.png"), wxBITMAP_TYPE_ANY));
      PatchBitmap = new wxStaticBitmap(this, wxID_ANY,
          wxBitmap(wxT("ApolloPatch2.png"), wxBITMAP_TYPE_ANY));
      Patch12Bitmap = new wxStaticBitmap(this, wxID_ANY,
          wxBitmap(wxT("apo12.png"), wxBITMAP_TYPE_ANY));
      Patch13Bitmap = new wxStaticBitmap(this, wxID_ANY,
          wxBitmap(wxT("apo13.png"), wxBITMAP_TYPE_ANY));
      Patch14Bitmap = new wxStaticBitmap(this, wxID_ANY,
          wxBitmap(wxT("apo14.png"), wxBITMAP_TYPE_ANY));
      Patch15Bitmap = new wxStaticBitmap(this, wxID_ANY,
          wxBitmap(wxT("apo15.png"), wxBITMAP_TYPE_ANY));
      Patch16Bitmap = new wxStaticBitmap(this, wxID_ANY,
          wxBitmap(wxT("apo16.png"), wxBITMAP_TYPE_ANY));
      Patch17Bitmap = new wxStaticBitmap(this, wxID_ANY,
          wxBitmap(wxT("apo17.png"), wxBITMAP_TYPE_ANY));
    }
  TopLine = new wxStaticLine(this, wxID_ANY);
  if (!maximumSquish)
    {
      SimTypeLabel = new wxStaticText(this, wxID_ANY,
          wxT("AGC Simulation Type"), wxDefaultPosition, wxDefaultSize);
      SimTypeLabel2 = new wxStaticText(this, wxID_ANY,
          wxT("AGC Simulation Type"), wxDefaultPosition, wxDefaultSize);
    }
  for (int i = ID_FIRSTMISSION; i < ID_AGCCUSTOMBUTTON; i++)
    {
      if (i == ID_FIRSTMISSION)
        missionRadioButtons[i - ID_FIRSTMISSION] = new wxRadioButton(this, i,
            wxString::FromUTF8(missionConstants[i - ID_FIRSTMISSION].name),
            wxDefaultPosition, wxDefaultSize, wxRB_GROUP);
      else
        missionRadioButtons[i - ID_FIRSTMISSION] = new wxRadioButton(this, i,
            wxString::FromUTF8(missionConstants[i - ID_FIRSTMISSION].name));
    }
  AgcCustomButton = new wxRadioButton(this, ID_AGCCUSTOMBUTTON, wxT("Custom:"));
  AgcCustomFilename = new wxTextCtrl(this, ID_AGCCUSTOMFILENAME, wxEmptyString);
  AgcFilenameBrowse = new wxButton(this, ID_AGCFILENAMEBROWSE, wxT("..."));
  static_line_2 = new wxStaticLine(this, wxID_ANY, wxDefaultPosition,
      wxDefaultSize, wxLI_VERTICAL);
  for (int i = ID_FIRSTMISSION; i < ID_AGCCUSTOMBUTTON; i++)
    if (missionConstants[i - ID_FIRSTMISSION].enabled)
      SoftwareVersionNames.Add(
          wxString::FromUTF8(missionConstants[i - ID_FIRSTMISSION].name));
  DeviceAGCversionDropDownList = new wxChoice(this, ID_AGCSOFTWAREDROPDOWNLIST,
      wxDefaultPosition, wxDefaultSize, SoftwareVersionNames);
  if (!maximumSquish)
    DeviceListLabel = new wxStaticText(this, wxID_ANY, wxT("Interfaces"),
        wxDefaultPosition, wxDefaultSize);
  DeviceAgcCheckbox = new wxCheckBox(this, ID_DEVICEAGCCHECKBOX,
      wxT("Guidance Computer"));
  DeviceDskyCheckbox = new wxCheckBox(this, ID_DEVICEDSKYCHECKBOX,
      wxT("DSKY (AGC display and keypad)"));
  DeviceAcaCheckbox = new wxCheckBox(this, ID_DEVICEACACHECKBOX,
      wxT("Attitude Controller Assembly"));
  JoystickConfigure = new wxButton(this, ID_JOYSTICKCONFIGURE, wxT("Handler"));
  DeviceTelemetryCheckbox = new wxCheckBox(this, ID_DEVICETELEMETRYCHECKBOX,
      wxT("Telemetry Downlink Monitor"));
  DeviceAeaCheckbox = new wxCheckBox(this, ID_DEVICEAEACHECKBOX,
      wxT("LM Abort Computer (AEA)"));
  DeviceDedaCheckbox = new wxCheckBox(this, ID_DEVICEDEDACHECKBOX,
      wxT("DEDA (AEA display and keypad)"));
  DeviceCpumonCheckbox = new wxCheckBox(this, ID_DEVICECPUMONCHECKBOX,
      wxT("AGC CPU Bus/Input/Output Monitor"));
  static_line_4 = new wxStaticLine(this, wxID_ANY, wxDefaultPosition,
      wxDefaultSize, wxLI_VERTICAL);
  DeviceImuCheckbox = new wxCheckBox(this, ID_DEVICEIMUCHECKBOX,
      wxT("Inertial Monitor Unit / FDAI (8-ball)"));
  DeviceDiscoutCheckbox = new wxCheckBox(this, ID_DEVICEDISCOUTCHECKBOX,
      wxT("Discrete Outputs"));
  DeviceCrewinCheckbox = new wxCheckBox(this, ID_DEVICECREWINCHECKBOX,
      wxT("Discrete Inputs (crew)"));
  DeviceSysinCheckbox = new wxCheckBox(this, ID_DEVICESYSINCHECKBOX,
      wxT("Discrete Inputs (LM system)"));
  DevicePropulsionCheckbox = new wxCheckBox(this, ID_DEVICEPROPULSIONCHECKBOX,
      wxT("Propulsion/Thrust/Fuel Monitor"));
  NoviceButton = new wxButton(this, ID_NOVICEBUTTON, wxT("Novice"));
  ExpertButton = new wxButton(this, ID_EXPERTBUTTON, wxT("Expert"));
  static_line_3 = new wxStaticLine(this, wxID_ANY, wxDefaultPosition,
      wxDefaultSize, wxLI_VERTICAL);
  static_line_5 = new wxStaticLine(this, wxID_ANY);
  AgcSourceButton = new wxButton(this, ID_AGCSOURCEBUTTON, wxT("AGC"));
  AeaSourceButton = new wxButton(this, ID_AEASOURCEBUTTON, wxT("AEA"));
  if (!maximumSquish)
    {
      OptionList = new wxStaticText(this, wxID_ANY, wxT("Options"),
          wxDefaultPosition, wxDefaultSize);
    }
  StartupWipeButton = new wxRadioButton(this, ID_STARTUPWIPEBUTTON,
      wxT("Restart program, wiping memory"), wxDefaultPosition, wxDefaultSize,
      wxRB_GROUP);
  StartupPreserveButton = new wxRadioButton(this, ID_STARTUPPRESERVEBUTTON,
      wxT("Restart program, preserving memory"));
  StartupResumeButton = new wxRadioButton(this, ID_STARTUPRESUMEBUTTON,
      wxT("Resume from ending point of prior run"));
  CustomResumeButton = new wxRadioButton(this, ID_CUSTOMRESUMEBUTTON,
      wxT("Custom:"));
  CoreFilename = new wxTextCtrl(this, wxID_ANY, wxEmptyString);
  CoreBrowse = new wxButton(this, ID_COREBROWSE, wxT("..."));
  CoreSaveButton = new wxButton(this, ID_CORESAVEBUTTON, wxT("Save"));
  DskyLabel = new wxStaticText(this, wxID_ANY, wxT("DSKY:"));
  DskyFullButton = new wxRadioButton(this, ID_DSKYFULLBUTTON, wxT("Full"),
      wxDefaultPosition, wxDefaultSize, wxRB_GROUP);
  DskyHalfButton = new wxRadioButton(this, ID_DSKYHALFBUTTON, wxT("Half"));
  DskyLiteButton = new wxRadioButton(this, ID_DSKYLITEBUTTON, wxT("\"Lite\""));
  DskyNavButton = new wxRadioButton(this, ID_DSKYNAVBUTTON, wxT("Nav"));
  DownlinkLabel = new wxStaticText(this, wxID_ANY, wxT("Downlink:"));
  TelemetryResizable = new wxRadioButton(this, wxID_ANY, wxT("Normal"),
      wxDefaultPosition, wxDefaultSize, wxRB_GROUP);
  TelemetryRetro = new wxRadioButton(this, wxID_ANY, wxT("\"Retro\""));
  DedaLabel = new wxStaticText(this, wxID_ANY, wxT("DEDA:"));
  DedaFullButton = new wxRadioButton(this, ID_DEDAFULLBUTTON, wxT("Full"),
      wxDefaultPosition, wxDefaultSize, wxRB_GROUP);
  DedaHalfButton = new wxRadioButton(this, ID_DEDAHALFBUTTON, wxT("Half"));
  AgcDebugLabel = new wxStaticText(this, wxID_ANY, wxT("AGC code:"));
  AgcDebugNormalButton = new wxRadioButton(this, ID_AGCDEBUGNORMALBUTTON,
      wxT("Normal"), wxDefaultPosition, wxDefaultSize, wxRB_GROUP);
  AgcDebugMonitorButton = new wxRadioButton(this, ID_AGCDEBUGMONITORBUTTON,
      wxT("Debugger"));
  AeaDebugLabel = new wxStaticText(this, wxID_ANY, wxT("AEA code:"));
  AeaDebugNormalButton = new wxRadioButton(this, ID_AEADEBUGNORMALBUTTON,
      wxT("Normal"), wxDefaultPosition, wxDefaultSize, wxRB_GROUP);
  AeaDebugMonitorButton = new wxRadioButton(this, ID_AEADEBUGMONITORBUTTON,
      wxT("Debugger"));
  FlightProgram4Button = new wxRadioButton(this, ID_FLIGHTPROGRAM4BUTTON,
      wxT("Apollo 9 (Flight Programs 3, 4)"), wxDefaultPosition, wxDefaultSize,
      wxRB_GROUP);
  FlightProgram5Button = new wxRadioButton(this, ID_FLIGHTPROGRAM5BUTTON,
      wxT("Apollo 10 (Flight Program 5)"));
  FlightProgram6Button = new wxRadioButton(this, ID_FLIGHTPROGRAM6BUTTON,
      wxT("Apollo 11 (Flight Program 6)"));
  FlightProgram7Button = new wxRadioButton(this, ID_FLIGHTPROGRAM7BUTTON,
      wxT("Apollo 12-14? (Flight Program 7)"));
  FlightProgram8Button = new wxRadioButton(this, ID_FLIGHTPROGRAM8BUTTON,
      wxT("Apollo 15-17 (Flight Program 8)"));
  if (!maximumSquish)
    {
      AeaCustomButton = new wxRadioButton(this, ID_AEACUSTOMBUTTON,
          wxT("Custom:"));
      AeaCustomFilename = new wxTextCtrl(this, ID_AEACUSTOMFILENAME,
          wxEmptyString);
      AeaFilenameBrowse = new wxButton(this, ID_AEAFILENAMEBROWSE, wxT("..."));
    }
  static_line_1 = new wxStaticLine(this, wxID_ANY);
  RunButton = new wxButton(this, ID_RUNBUTTON, wxT("Run!"));
  DefaultsButton = new wxButton(this, ID_DEFAULTSBUTTON, wxT("Defaults"));
  ExitButton = new wxButton(this, ID_EXITBUTTON, wxT("Exit"));

  set_properties();
  do_layout();

  SetDefaultConfiguration();
  ReadConfigurationFile();
  EnforceConsistency();

  SetSize();
  Layout();
  Fit();
}
BEGIN_EVENT_TABLE(VirtualAGC, wxFrame) //
EVT_BUTTON(ID_AGCFILENAMEBROWSE, VirtualAGC::AgcFilenameBrowseEvent)
EVT_BUTTON(ID_JOYSTICKCONFIGURE, VirtualAGC::JoystickConfigureClicked)
EVT_BUTTON(ID_NOVICEBUTTON, VirtualAGC::NoviceButtonEvent)
EVT_BUTTON(ID_EXPERTBUTTON, VirtualAGC::ExpertButtonEvent)
EVT_BUTTON(ID_AGCSOURCEBUTTON, VirtualAGC::AgcSourceEvent)
EVT_BUTTON(ID_AEASOURCEBUTTON, VirtualAGC::AeaSourceEvent)
EVT_BUTTON(ID_COREBROWSE, VirtualAGC::CoreBrowseEvent)
EVT_BUTTON(ID_CORESAVEBUTTON, VirtualAGC::CoreSaveEvent)
EVT_BUTTON(ID_AEAFILENAMEBROWSE, VirtualAGC::AeaFilenameBrowseEvent)
EVT_BUTTON(ID_RUNBUTTON, VirtualAGC::RunButtonEvent)
EVT_BUTTON(ID_DEFAULTSBUTTON, VirtualAGC::DefaultsButtonEvent)
EVT_BUTTON(ID_EXITBUTTON, VirtualAGC::ExitButtonEvent)
EVT_CHOICE(ID_AGCSOFTWAREDROPDOWNLIST, VirtualAGC::ConsistencyEvent)
EVT_CHECKBOX(ID_DEVICETELEMETRYCHECKBOX, VirtualAGC::ConsistencyEvent)
EVT_CHECKBOX(ID_DEVICEAEACHECKBOX, VirtualAGC::ConsistencyEvent)
EVT_CHECKBOX(ID_DEVICEDEDACHECKBOX, VirtualAGC::ConsistencyEvent)
EVT_CHECKBOX(ID_DEVICECPUMONCHECKBOX, VirtualAGC::ConsistencyEvent)
EVT_CHECKBOX(ID_DEVICEIMUCHECKBOX, VirtualAGC::ConsistencyEvent)
EVT_CHECKBOX(ID_DEVICEDISCOUTCHECKBOX, VirtualAGC::ConsistencyEvent)
EVT_CHECKBOX(ID_DEVICECREWINCHECKBOX, VirtualAGC::ConsistencyEvent)
EVT_CHECKBOX(ID_DEVICESYSINCHECKBOX, VirtualAGC::ConsistencyEvent)
EVT_CHECKBOX(ID_DEVICEPROPULSIONCHECKBOX, VirtualAGC::ConsistencyEvent)
EVT_CHECKBOX(ID_DEVICEAGCCHECKBOX, VirtualAGC::ConsistencyEvent)
EVT_CHECKBOX(ID_DEVICEDSKYCHECKBOX, VirtualAGC::ConsistencyEvent)
EVT_CHECKBOX(ID_DEVICEACACHECKBOX, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_DSKYFULLBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_DSKYHALFBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_DSKYLITEBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_DSKYNAVBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_DEDAFULLBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_DEDAHALFBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_AGCDEBUGNORMALBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_AGCDEBUGMONITORBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_AEADEBUGNORMALBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_AEADEBUGMONITORBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_FLIGHTPROGRAM4BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_FLIGHTPROGRAM5BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_FLIGHTPROGRAM6BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_FLIGHTPROGRAM7BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_FLIGHTPROGRAM8BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_AEACUSTOMBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_STARTUPWIPEBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_STARTUPPRESERVEBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_STARTUPRESUMEBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_CUSTOMRESUMEBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_APOLLO1CMBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_APOLLO3CMBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_APOLLO4CMBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_APOLLO5LMBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_APOLLO6CMBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_SUNDIALECMBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_APOLLO7CMBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_APOLLO8CMBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_APOLLO9CMBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_APOLLO9LMBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_COMANCHE44BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_COMANCHE45BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_APOLLO10CMBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_LUM69BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_APOLLO10LMBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_COMANCHE51BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_COMANCHE55BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_LUMINARY97BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_LUMINARY98BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_LMY99R0BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_LUMINARY99BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_LUM99R2BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_APOLLO12CMBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_APOLLO12LMBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_APOLLO13CMBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_LUMINARY130BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_LUMINARY131BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_APOLLO14CMBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_LUMINARY163BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_LUMINARY173BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_APOLLO14LMBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_ARTEMIS71BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_ARTEMIS72BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_APOLLO15LMBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_SKYLABCMBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_SOYUZCMBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_VALIDATIONBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_RETREAD44BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_RETREAD50BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_AURORA12BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_SUNBURST37BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_ZERLINA56BUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_SUPERJOBBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_AGCCUSTOMBUTTON, VirtualAGC::ConsistencyEvent)
EVT_RADIOBUTTON(ID_BOREALISBUTTON, VirtualAGC::ConsistencyEvent)
END_EVENT_TABLE();

#define TEMPTRACE(x) //wxMessageBox (wxT ("Trace"), wxT (x))
void
VirtualAGC::AgcFilenameBrowseEvent(wxCommandEvent &event)
{
  TEMPTRACE ("2");
  wxFileDialog *Dialog = new wxFileDialog(this,
      wxT("Choose AGC executable-binary file"), AgcDirectory, wxT(""),
      wxT("Source files (*.agc)|*.agc|Binary files (*.bin)|*.bin"),
      wxFD_DEFAULT_STYLE | wxFD_FILE_MUST_EXIST | wxFD_CHANGE_DIR);
  if (AgcCustomFilename->GetValue().IsEmpty())
    Dialog->SetDirectory(HomeDirectory);
  else
    Dialog->SetPath(AgcCustomFilename->GetValue());
  if (wxID_OK == Dialog->ShowModal())
    {
      wxString Pathname = Dialog->GetPath();
      wxString Basename = Pathname.BeforeLast('.');
      wxString Extension = Pathname.AfterLast('.');
      wxString Filename = Dialog->GetFilename();
      wxString Filebase = Filename.BeforeLast('.');
      wxString Directory = Dialog->GetDirectory();
      if (Extension.IsSameAs(wxT("agc")))  // Source code!
        {
          if (Pathname.StartsWith(ResourceDirectory))
            {
              if (wxYES
                  != wxMessageBox(
                      wxT(
                          "This source file is in the installation directory.\n"
                              L"Assembling it may overwrite some of Virtual AGC\'s\n"
                              L"distribution files.  Are you sure?"),
                      wxT("Warning"), wxYES_NO | wxICON_QUESTION))
                goto Done;
            }
          // Check whether final output files or intermediate files that might
          // have been created from a command-line assembly already exist.
          wxString Dummy, Dummy1, Dummy2, Dummy3, Dummy4, Dummy5;
          Dummy1 = Basename + wxT(".lst");
          Dummy2 = Pathname + wxT(".bin");
          Dummy3 = Basename + wxT(".bin");
          Dummy4 = Pathname + wxT(".symtab");
          Dummy5 = Basename + wxT(".bin.symtab");
          if (wxFileExists(Dummy1))
            Dummy += wxT("\n   ") + Dummy1;
          if (wxFileExists(Dummy2))
            Dummy += wxT("\n   ") + Dummy2;
          if (wxFileExists(Dummy3))
            Dummy += wxT("\n   ") + Dummy3;
          if (wxFileExists(Dummy4))
            Dummy += wxT("\n   ") + Dummy4;
          if (wxFileExists(Dummy5))
            Dummy += wxT("\n   ") + Dummy5;
          if (!Dummy.IsSameAs(wxT("")))
            {
              Dummy = wxT("The following output/intermediate files exist.")
                  + Dummy;
              Dummy += wxT("\nOverwrite them?");
              if (wxYES
                  != wxMessageBox(Dummy, wxT("Warning"),
                      wxYES_NO | wxICON_QUESTION))
                goto Done;
            }
          // Okay, the user has agreed to everything.  Let's create a batch file or
          // shell script to do the assembly, and then run it.
          wxFile BuildScript;
          wxString MvCommand, RmCommand, BuildFilename;
#ifdef WIN32
          MvCommand = wxT ("move");
          RmCommand = wxT ("del");
          BuildFilename = wxT ("build.bat");
#else
          MvCommand = wxT("mv");
          RmCommand = wxT("rm");
          BuildFilename = wxT("build.sh");
#endif
          if (!BuildScript.Open(BuildFilename, wxFile::write))
            {
              wxMessageBox(wxT("Could not create the build script."),
                  wxT("Error"), wxOK | wxICON_ERROR);
              goto Done;
            }
          Dummy = wxT("cd \"") + Directory + wxT("\"");
          Dummy += wxT(EOL);
          BuildScript.Write(Dummy);
          Dummy = RmCommand + wxT(" \"") + Dummy1 + wxT("\"");
          Dummy += wxT(EOL);
          BuildScript.Write(Dummy);
          Dummy = RmCommand + wxT(" \"") + Dummy2 + wxT("\"");
          Dummy += wxT(EOL);
          BuildScript.Write(Dummy);
          Dummy = RmCommand + wxT(" \"") + Dummy3 + wxT("\"");
          Dummy += wxT(EOL);
          BuildScript.Write(Dummy);
          Dummy = RmCommand + wxT(" \"") + Dummy4 + wxT("\"");
          Dummy += wxT(EOL);
          BuildScript.Write(Dummy);
          Dummy = RmCommand + wxT(" \"") + Dummy5 + wxT("\"");
          Dummy += wxT(EOL);
          BuildScript.Write(Dummy);
          Dummy = wxT("\"");
          Dummy += ExecutableDirectory;
          Dummy += PATH_DELIMITER;
          Dummy += wxT("yaYUL\" --html \"");
          Dummy += Filename;
          Dummy += wxT("\" >\"") + Filebase + wxT(".lst\"");
          Dummy += wxT(EOL);
          BuildScript.Write(Dummy);
          Dummy = MvCommand + wxT(" \"") + Filename + wxT(".bin\" \"")
              + Filebase + wxT(".bin\"");
          Dummy += wxT(EOL);
          BuildScript.Write(Dummy);
          Dummy = MvCommand + wxT(" \"") + Filename + wxT(".symtab\" \"")
              + Filebase + wxT(".bin.symtab\"");
          Dummy += wxT(EOL);
          BuildScript.Write(Dummy);
          BuildScript.Close();
          // Do it!
#ifndef WIN32
          BuildFilename = wxT("sh ") + BuildFilename;
#endif
          wxExecute(BuildFilename, wxEXEC_SYNC);
          Dummy = Basename + wxT(".bin");
          if (!wxFileExists(Dummy))
            {
              Dummy = wxT("There was an assembly error. Examine the report\n");
              Dummy += Basename + wxT(".lst");
              wxMessageBox(Dummy, wxT("Error"), wxOK | wxICON_ERROR);
              goto Done;
            }
          wxFile BinaryFile;
          BinaryFile.Open(Dummy);
          int Length = BinaryFile.Length();
          BinaryFile.Close();
          if (Length == 0)
            {
              Dummy = wxT("There was an assembly error. Examine the report\n");
              Dummy += Basename + wxT(".lst");
              wxMessageBox(Dummy, wxT("Error"), wxOK | wxICON_ERROR);
              goto Done;
            }
          Dummy = wxT("Created in ") + Directory + wxT(":");
          Dummy += wxT("\n   Binary: ") + Filebase + wxT(".bin");
          Dummy += wxT("\n   Symbol table: ") + Filebase + wxT(".bin.symtab");
          Dummy += wxT("\n   Listing: ") + Filebase + wxT(".lst");
          wxMessageBox(Dummy, wxT("Info"), wxICON_INFORMATION);
        }
      Pathname = Basename + wxT(".bin");
      AgcCustomFilename->SetValue(Pathname);
      AgcDirectory = Directory;
    }
  Done: delete Dialog;
  EnforceConsistency();
  wxSetWorkingDirectory(ResourceDirectory);
}

void
VirtualAGC::AeaFilenameBrowseEvent(wxCommandEvent &event)
{
  TEMPTRACE ("4");
  wxFileDialog *Dialog = new wxFileDialog(this,
      wxT("Choose AEA/AGS executable-binary file"), AeaDirectory, wxT(""),
      wxT("Source files (*.aea)|*.aea|Binary files (*.bin)|*.bin"),
      wxFD_DEFAULT_STYLE | wxFD_FILE_MUST_EXIST | wxFD_CHANGE_DIR);
  if (!maximumSquish)
    {
      if (AeaCustomFilename->GetValue().IsEmpty())
        Dialog->SetDirectory(HomeDirectory);
      else
        Dialog->SetPath(AeaCustomFilename->GetValue());
    }
  if (wxID_OK == Dialog->ShowModal())
    {
      wxString Pathname = Dialog->GetPath();
      wxString Basename = Pathname.BeforeLast('.');
      wxString Extension = Pathname.AfterLast('.');
      wxString Filename = Dialog->GetFilename();
      wxString Filebase = Filename.BeforeLast('.');
      wxString Directory = Dialog->GetDirectory();
      if (Extension.IsSameAs(wxT("aea")))  // Source code!
        {
          if (Pathname.StartsWith(ResourceDirectory))
            {
              if (wxYES
                  != wxMessageBox(
                      wxT(
                          "This source file is in the installation directory.\n"
                              L"Assembling it may overwrite some of Virtual AGC\'s\n"
                              L"distribution files.  Are you sure?"),
                      wxT("Warning"), wxYES_NO | wxICON_QUESTION))
                goto Done;
            }
          // Check whether final output files or intermediate files that might
          // have been created from a command-line assembly already exist.
          wxString Dummy, Dummy1, Dummy2, Dummy3, Dummy4, Dummy5, Dummy6;
          Dummy1 = Basename + wxT(".lst");
          Dummy2 = wxT("yaLEMAP.lst");
          Dummy3 = Basename + wxT(".bin");
          Dummy4 = wxT("yaLEMAP.bin");
          Dummy5 = Basename + wxT(".bin.symtab");
          Dummy4 = wxT("yaLEMAP.symtab");
          if (wxFileExists(Dummy2))
            Dummy += wxT("\n   ") + Dummy2;
          if (wxFileExists(Dummy4))
            Dummy += wxT("\n   ") + Dummy4;
          if (wxFileExists(Dummy6))
            Dummy += wxT("\n   ") + Dummy6;
          if (wxFileExists(Dummy1))
            Dummy += wxT("\n   ") + Dummy1;
          if (wxFileExists(Dummy3))
            Dummy += wxT("\n   ") + Dummy3;
          if (wxFileExists(Dummy5))
            Dummy += wxT("\n   ") + Dummy5;
          if (!Dummy.IsSameAs(wxT("")))
            {
              Dummy = wxT("The following intermediate/output files exist.")
                  + Dummy;
              Dummy += wxT("\nOverwrite them?");
              if (wxYES
                  != wxMessageBox(Dummy, wxT("Warning"),
                      wxYES_NO | wxICON_QUESTION))
                goto Done;
            }
          // Okay, the user has agreed to everything.  Let's create a batch file or
          // shell script to do the assembly, and then run it.
          wxFile BuildScript;
          wxString MvCommand, RmCommand, BuildFilename;
#ifdef WIN32
          MvCommand = wxT ("move");
          RmCommand = wxT ("del");
          BuildFilename = wxT ("build.bat");
#else
          MvCommand = wxT("mv");
          RmCommand = wxT("rm");
          BuildFilename = wxT("build.sh");
#endif
          if (!BuildScript.Open(BuildFilename, wxFile::write))
            {
              wxMessageBox(wxT("Could not create the build script."),
                  wxT("Error"), wxOK | wxICON_ERROR);
              goto Done;
            }
          Dummy = wxT("cd \"") + Directory + wxT("\"");
          Dummy += wxT(EOL);
          BuildScript.Write(Dummy);
          Dummy = RmCommand + wxT(" \"") + Filebase + wxT(".bin\"");
          Dummy += wxT(EOL);
          BuildScript.Write(Dummy);
          Dummy = RmCommand + wxT(" \"") + Filebase + wxT(".bin.symtab\"");
          Dummy += wxT(EOL);
          BuildScript.Write(Dummy);
          Dummy = RmCommand + wxT(" \"") + Filebase + wxT(".lst\"");
          Dummy += wxT(EOL);
          BuildScript.Write(Dummy);
          Dummy = RmCommand + wxT("yaLEMAP.bin");
          Dummy += wxT(EOL);
          BuildScript.Write(Dummy);
          Dummy = RmCommand + wxT("yaLEMAP.symtab");
          Dummy += wxT(EOL);
          BuildScript.Write(Dummy);
          Dummy = RmCommand + wxT("yaLEMAP.lst");
          Dummy += wxT(EOL);
          BuildScript.Write(Dummy);
          Dummy = wxT("\"");
          Dummy += ExecutableDirectory;
          Dummy += PATH_DELIMITER;
          Dummy += wxT("yaLEMAP\" --html ");
          Dummy += Filename;
          Dummy += wxT(EOL);
          BuildScript.Write(Dummy);
          Dummy = MvCommand + wxT(" yaLEMAP.bin \"") + Filebase + wxT(".bin\"");
          Dummy += wxT(EOL);
          BuildScript.Write(Dummy);
          Dummy = MvCommand + wxT(" yaLEMAP.symtab \"") + Filebase
              + wxT(".bin.symtab\"");
          Dummy += wxT(EOL);
          BuildScript.Write(Dummy);
          Dummy = MvCommand + wxT(" yaLEMAP.lst \"") + Filebase + wxT(".lst\"");
          Dummy += wxT(EOL);
          BuildScript.Write(Dummy);
          BuildScript.Close();
          // Do it!
#ifndef WIN32
          BuildFilename = wxT("sh ") + BuildFilename;
#endif
          wxExecute(BuildFilename, wxEXEC_SYNC);
          Dummy = Basename + wxT(".bin");
          if (!wxFileExists(Dummy))
            {
              Dummy = wxT("There was an assembly error. Examine the report\n");
              Dummy += Basename + wxT(".lst");
              wxMessageBox(Dummy, wxT("Error"), wxOK | wxICON_ERROR);
              goto Done;
            }
          wxFile BinaryFile;
          BinaryFile.Open(Dummy);
          int Length = BinaryFile.Length();
          BinaryFile.Close();
          if (Length == 0)
            {
              Dummy = wxT("There was an assembly error. Examine the report\n");
              Dummy += Basename + wxT(".lst");
              wxMessageBox(Dummy, wxT("Error"), wxOK | wxICON_ERROR);
              goto Done;
            }
          Dummy = wxT("Created in ") + Directory + wxT(":");
          Dummy += wxT("\n   Binary: ") + Filebase + wxT(".bin");
          Dummy += wxT("\n   Symbol table: ") + Filebase + wxT(".bin.symtab");
          Dummy += wxT("\n   Listing: ") + Filebase + wxT(".lst");
          wxMessageBox(Dummy, wxT("Info"), wxICON_INFORMATION);
        }
      Pathname = Basename + wxT(".bin");
      if (!maximumSquish)
        {
          AeaCustomFilename->SetValue(Pathname);
          AeaDirectory = Directory;
        }
    }
  Done: delete Dialog;
  EnforceConsistency();
  wxSetWorkingDirectory(ResourceDirectory);
}

void
VirtualAGC::CoreBrowseEvent(wxCommandEvent &event)
{
  wxString ScenarioDirectory;
  ScenarioDirectory = ResourceDirectory;
  ScenarioDirectory += PATH_DELIMITER;
  ScenarioDirectory += wxT("scenarios");
  wxFileDialog *Dialog = new wxFileDialog(this,
      wxT("Choose core-dump file for resumption"), ScenarioDirectory, wxT(""),
      wxT("Core-dump files (*.core)|*.core|All files (*)|*"),
      wxFD_DEFAULT_STYLE | wxFD_FILE_MUST_EXIST | wxFD_CHANGE_DIR);
  if (wxID_OK == Dialog->ShowModal())
    {
      wxString Pathname = Dialog->GetPath();
      CoreFilename->SetValue(Pathname);
    }
  delete Dialog;
  wxSetWorkingDirectory(ResourceDirectory);
}

void
VirtualAGC::CoreSaveEvent(wxCommandEvent &event)
{
  wxString ScenarioDirectory;
  ScenarioDirectory = ResourceDirectory;
  ScenarioDirectory += PATH_DELIMITER;
  ScenarioDirectory += wxT("scenarios");
  wxString CoreFile;
  int Response;
  if (IsLM)
    CoreFile = wxT("LM.core");
  else
    CoreFile = wxT("CM.core");
  Response = wxMessageBox(wxT("Do you wish to save ") + CoreFile,
      wxT("Core-dump file to save"), wxYES_NO | wxICON_QUESTION);
  if (Response == wxYES && !wxFileExists(CoreFile))
    {
      wxMessageBox(wxT("File does not exist"), wxT("Error"), wxICON_ERROR);
      goto Done;
    }
  if (Response == wxNO)
    {
      static wxString LastDirectory = wxT("");
      if (LastDirectory.IsEmpty())
        LastDirectory = HomeDirectory;
      wxFileDialog *DialogR = new wxFileDialog(this,
          wxT("Choose core-dump file to save"), LastDirectory, wxT(""),
          wxT("Core-dump files (*.core)|*.core|All files (*)|*"),
          wxFD_DEFAULT_STYLE | wxFD_FILE_MUST_EXIST | wxFD_CHANGE_DIR);
      if (wxID_OK == DialogR->ShowModal())
        {
          LastDirectory = DialogR->GetDirectory();
          wxString CoreFile = DialogR->GetPath();
          delete DialogR;
        }
      else
        {
          delete DialogR;
          goto Done;
        }
    }
    {
      wxFileDialog *DialogS = new wxFileDialog(this,
          wxT("Save core-dump file as"), ScenarioDirectory, wxT(""),
          wxT("Core-dump files (*.core)|*.core|All files (*)|*"),
          wxFD_DEFAULT_STYLE | wxFD_CHANGE_DIR | wxFD_SAVE
              | wxFD_OVERWRITE_PROMPT);
      if (wxID_OK == DialogS->ShowModal())
        {
          wxString Pathname = DialogS->GetPath();
          if (!Pathname.AfterLast('.').IsSameAs(wxT("core")))
            wxMessageBox(wxT("Note that you did not add the .core extension.\n"
                L"If you browse for core files later, you will\n"
                L"not see this file as a Core File and will have\n"
                L"to select All Files for it to show up."), wxT("Warning"),
                wxICON_WARNING);
          CoreFilename->SetValue(Pathname);
          wxSetWorkingDirectory(ResourceDirectory);
          wxCopyFile(CoreFile, Pathname, true);
          CustomResumeButton->SetValue(true);
          EnforceConsistency();
        }
      delete DialogS;
    }
  Done: wxSetWorkingDirectory(ResourceDirectory);
}

void
VirtualAGC::ConsistencyEvent(wxCommandEvent &event)
{
  EnforceConsistency();
}

void
VirtualAGC::NoviceButtonEvent(wxCommandEvent &event)
{
  TEMPTRACE ("17");
  DeviceAcaCheckbox->SetValue(false);
  DeviceTelemetryCheckbox->SetValue(false);
  DeviceAeaCheckbox->SetValue(false);
  DeviceCpumonCheckbox->SetValue(false);
  StartupWipeButton->SetValue(true);
  AgcDebugNormalButton->SetValue(true);
  EnforceConsistency();
}

void
VirtualAGC::ExpertButtonEvent(wxCommandEvent &event)
{
  TEMPTRACE ("18");
  DeviceAcaCheckbox->SetValue(true);
  DeviceTelemetryCheckbox->SetValue(true);
  DeviceAeaCheckbox->SetValue(true);
  DeviceCpumonCheckbox->SetValue(true);
  DeviceImuCheckbox->SetValue(true);
  DeviceDiscoutCheckbox->SetValue(true);
  DeviceCrewinCheckbox->SetValue(true);
  DeviceSysinCheckbox->SetValue(true);
  DevicePropulsionCheckbox->SetValue(true);
  EnforceConsistency();
}

void
VirtualAGC::RunButtonEvent(wxCommandEvent &event)
{
  TEMPTRACE ("24");
  wxSetWorkingDirectory(ResourceDirectory);
  if (DeviceCpumonCheckbox->GetValue())
    {
      if (!FormLmsIni())
        return;
    }
  if (!FormCommands())
    return;
  if (!FormScript())
    return;
  RunButton->Enable(false);
  Hide();
  SimulationWindow = new Simulation(this, wxID_ANY, wxEmptyString);
  SimulationWindow->Enable(true);
  int mission;
  for (mission = ID_FIRSTMISSION; mission < ID_AGCCUSTOMBUTTON; mission++)

    if (missionRadioButtons[mission - ID_FIRSTMISSION]->GetValue())
      {
        SimulationWindow->WriteSimulationLabel(
            wxString::FromUTF8(
                missionConstants[mission - ID_FIRSTMISSION].name));
        break;
      }
  if (mission >= ID_AGCCUSTOMBUTTON)
    {
      if (AgcCustomButton->GetValue())
        SimulationWindow->WriteSimulationLabel(wxT("Custom Lunar Module"));
      else
        SimulationWindow->WriteSimulationLabel(wxT("Unknown type of"));
    }
  // Write the run-script contents to the detail pane of the window.
  wxString OutDummy, InDummy;
  wxTextFile Script;
  int i, Lines;
  OutDummy = wxT("cd ") + ResourceDirectory;
#ifdef WIN32
  OutDummy += wxT ("\nsimulate2.bat");
  OutDummy += wxT ("\n\nThe contents of \"simulate2.bat\" are:");
  Script.Open (wxT ("simulate2.bat"));
  Lines = Script.GetLineCount ();
  for (i = 0; i < Lines; i++)
    {
      OutDummy += wxT ("\n");
      OutDummy += Script.GetLine (i);
    }
  Script.Close ();
  OutDummy += wxT ("\n\nThe contents of \"simulate.bat\" are:");
  Script.Open (wxT ("simulate.bat"));
#else
  OutDummy += wxT("\n./simulate");
  OutDummy += wxT("\n\nThe contents of \"simulate\" are:");
  Script.Open(wxT("simulate"));
#endif
  Lines = Script.GetLineCount();
  for (i = 0; i < Lines; i++)
    {
      OutDummy += wxT("\n");
      OutDummy += Script.GetLine(i);
    }
  Script.Close();
#ifdef WIN32
  OutDummy += wxT ("\n\nNote that WinAGC is used for the purpose of");
#else
  OutDummy += wxT("\n\nNote that SimStop is used for the purpose of");
#endif
  OutDummy += wxT("\ninsuring that all simulated components shut");
  OutDummy += wxT("\ndown after any one of them has shut down.  It");
  OutDummy += wxT("\ndoes not provide any other simulation capability");
  OutDummy += wxT("\nand might be unnecessary outside the context of");
  OutDummy += wxT("\nthe VirtualAGC GUI.");
  SimulationWindow->ScriptText->SetValue(OutDummy);
  SimulationWindow->LessButton->Disable();
  SimulationWindow->MoreButton->Enable();
  SimulationWindow->DetailPanel->Hide();
  SimulationWindow->Fit();
  SimulationWindow->Show();
#ifdef WIN32
  wxString Command = wxT ("simulate2.bat");
#else
  wxString Command = wxT("./simulate");
#endif
  wxExecute(Command, wxEXEC_SYNC | wxEXEC_NODISABLE);
  SimulationWindow->Close();
  delete SimulationWindow;
  Show();
  Raise();
  RunButton->Enable(true);
}

void
VirtualAGC::JoystickConfigureClicked(wxCommandEvent &event)
{
  wxSetWorkingDirectory(ResourceDirectory);
  Hide();
#if defined (WIN32)
  wxString Command = wxT ("..\\bin\\jWiz");
#elif defined (__APPLE__)
  wxString Command = wxT ("../MacOS/jWiz.app/Contents/MacOS/jWiz");
#else
  wxString Command = wxT("../bin/jWiz");
#endif
  wxExecute(Command, wxEXEC_SYNC);
  Show();
}

void
VirtualAGC::DefaultsButtonEvent(wxCommandEvent &event)
{
  TEMPTRACE ("25");
  SetDefaultConfiguration();
  EnforceConsistency();
}

void
VirtualAGC::ExitButtonEvent(wxCommandEvent &event)
{
  TEMPTRACE ("26");
  EnforceConsistency();
  WriteConfigurationFile();
  Close();
}

void
VirtualAGC::AgcSourceEvent(wxCommandEvent &event)
{
  wxString Dummy;
  Dummy = wxT("file://");
#ifdef MACOSX
  Dummy = wxT("");
#endif
  Dummy += ResourceDirectory;
  Dummy += wxT("/source/");
  int mission;
  for (mission = ID_FIRSTMISSION; mission < ID_AGCCUSTOMBUTTON; mission++)
    if (missionRadioButtons[mission - ID_FIRSTMISSION]->GetValue())
      {
        Dummy += wxString::FromUTF8(
            missionConstants[mission - ID_FIRSTMISSION].html);
        break;
      }
  if (mission >= ID_AGCCUSTOMBUTTON && AgcCustomButton->GetValue())
    Dummy = wxT("file://") + AgcCustomFilename->GetValue().BeforeLast('.')
        + wxT(".agc.html");
  wxLaunchDefaultBrowser(Dummy);
}

void
VirtualAGC::AeaSourceEvent(wxCommandEvent &event)
{
  wxString Dummy;
  Dummy = wxT("file://");
#ifdef MACOSX
  Dummy = wxT("");
#endif
  Dummy += ResourceDirectory;
  Dummy += wxT("/source/");
  if (FlightProgram4Button->GetValue())
    Dummy += wxT("FP4/FP4.aea.html");
  else if (FlightProgram5Button->GetValue())
    Dummy += wxT("FP5/FP5.aea.html");
  else if (FlightProgram6Button->GetValue())
    Dummy += wxT("FP6/FP6.aea.html");
  else if (FlightProgram7Button->GetValue())
    Dummy += wxT("FP7/FP7.aea.html");
  else if (FlightProgram8Button->GetValue())
    Dummy += wxT("FP8/FP8.aea.html");
  else if (!maximumSquish && AeaCustomButton->GetValue())
    Dummy = wxT("file://") + AeaCustomFilename->GetValue().BeforeLast('.')
        + wxT(".aea.html");
  wxLaunchDefaultBrowser(Dummy);
}

void
VirtualAGC::set_properties()
{
  SetTitle(wxT("VirtualAGC Simulation Manager"));
  wxIcon _icon;
  _icon.CopyFromBitmap(wxBitmap(wxT("ApolloPatch2.png"), wxBITMAP_TYPE_ANY));
  SetIcon(_icon);
  SetBackgroundColour(wxColour(255, 255, 255));
  if (!maximumSquish)
    {
      Patch1Bitmap->SetToolTip(
          wxT(
              "This is the mission patch for the ill-fated Apollo 1 mission, which resulted in the deaths during a launch-pad test of astronauts Gus Grissom, Ed White, and Roger Chaffee."));
      Patch7Bitmap->SetToolTip(
          wxT(
              "This is the mission patch for Apollo 7, the first mission which actually launched.  It was an Earth-orbital CM-only mission without an LM.  The astronauts were Wally Schirra, Donn Eisele, and Walt Cunningham."));
      Patch8Bitmap->SetToolTip(
          wxT(
              "This is the mission patch for Apollo 8, which performed the famous lunar fly-by at Christmas in 1968.  It was a CM-only mission without an LM. The astronauts were Frank Borman, Jim Lovell, and Bill Anders."));
      Patch9Bitmap->SetToolTip(
          wxT(
              "This is the mission patch for Apollo 9, the first mission with an LM.  This was an Earth-orbital test.  The astronauts were Jim McDivitt, Dave Scott, and Rusty Schweikart."));
      Patch10Bitmap->SetToolTip(
          wxT(
              "This is the mission patch for Apollo 10, which was the first test of the LM in the lunar neighborhood (8.4 miles).  There must have been a great temptation to try to land, but the LM was slightly too heavy for this.  There was a mishap during the landing rehearsal in which control of the LM was temporarily compromised, but fortunately disaster was averted.  The astronauts were Tom Stafford, John Young, and Gene Cernan."));
      Patch11Bitmap->SetToolTip(
          wxT(
              "This is the mission patch for Apollo 11, the famous first landing.  A faulty checklist procedure caused the rendezvous radar to remain activated during the landing.  The unwanted and unexpected extra data overloaded the AGC and caused spurious warning messages that could have resulted in an abort.  Fortunately the design of the AGC software allowed the computer to work around this problem, though at reduced capacity, and thus the landing was not aborted.  However, there were only seconds of fuel left after touchdown. The mission patch is unique in that the astronauts' names do not appear on it.  The astronauts were, of course, Neil Armstrong, Buzz Aldrin, and Michael Collins."));
      Patch12Bitmap->SetToolTip(
          wxT(
              "This is the mission patch for Apollo 12.  The rocket was famously struck by lightning while still in Earth's atmosphere.  The astronauts were Pete Conrad, DickGordon, and Alan Bean."));
      Patch13Bitmap->SetToolTip(
          wxT(
              "This is the mission patch for Apollo 13.  As is well-known, outgassing of oxygen from a ruptured tank en route to the moon averted any possibility of a landing.  The crew instead had to spend the entire journey in the LM to conserve the precious resources of the CM for eventual re-entry, but fortunately survived the experience.  The astronauts were Jim Lovell, Jack Swigert, and Fred Haise.  Swigert was a last-minute replacement for Ken Mattingly, who later flew on Apollo 16."));
      Patch14Bitmap->SetToolTip(
          wxT(
              "This is the mission patch for Apollo 14.  The mission almost had an aborted landing due to a short-circuit sending faulty data to the AGC.  The astronauts were Alan Shepard, Stu Roosa, and Edgar Mitchell.  Shepard was the first American in space, but had flown no missions since then due to medical problems."));
      Patch15Bitmap->SetToolTip(
          wxT(
              "This is the mission patch for Apollo 15.  This was the first mission involving the lunar rover vehicle.  The astronauts were Dave Scott, Al Worden, and Jim Irwin."));
      Patch16Bitmap->SetToolTip(
          wxT(
              "This is the mission patch for Apollo 16.  The landing was nearly scrubbed because of a fault in the CM, but fortunately the landing took place.  The astronauts were Jim Young, Ken Mattingly, and Charles Duke."));
      Patch17Bitmap->SetToolTip(
          wxT(
              "This is the mission patch for Apollo 17, the last moon landing in the Apollo program.  This was the only night launch in the Apollo program, and thus the only one which could be seen easily by large numbers of Americans.  It was also the first and only mission with a geologist aboard.  The astronauts were Gene Cernan, Ronald Evans, and Jack Schmitt.  Schmitt was the geologist and later a U.S. Senator."));
      SimTypeLabel->SetBackgroundColour(wxColour(255, 255, 255));
      SimTypeLabel->SetFont(
          wxFont(12, wxFONTFAMILY_DEFAULT, wxFONTSTYLE_NORMAL, wxFONTWEIGHT_BOLD, 1, wxT("")));
      SimTypeLabel->SetToolTip(
          wxT(
              "In this area, you can select the Apollo mission and the spacecraft software version."));
      SimTypeLabel2->SetBackgroundColour(wxColour(255, 255, 255));
      SimTypeLabel2->SetFont(
          wxFont(12, wxFONTFAMILY_DEFAULT, wxFONTSTYLE_NORMAL, wxFONTWEIGHT_BOLD, 1, wxT("")));
      SimTypeLabel2->SetToolTip(
          wxT(
              "In this area, you can select the Apollo mission and the spacecraft software version."));

    }
  int mission;
  for (mission = ID_FIRSTMISSION; mission < ID_AGCCUSTOMBUTTON; mission++)
    {
      missionRadioButtons[mission - ID_FIRSTMISSION]->Enable(
          missionConstants[mission - ID_FIRSTMISSION].enabled == ENABLED);
      missionRadioButtons[mission - ID_FIRSTMISSION]->SetToolTip(
          wxString::FromUTF8(
              missionConstants[mission - ID_FIRSTMISSION].tooltip));
    }
  AgcCustomButton->SetBackgroundColour(wxColour(255, 255, 255));
  AgcCustomButton->SetToolTip(
      wxT(
          "Click here to run your own personal software creation on the AGC system.  You should first have compiled your assembly-language source code using the yaYUL program to create an executable binary."));
  AgcCustomFilename->SetBackgroundColour(wxColour(255, 255, 255));
  AgcCustomFilename->SetForegroundColour(wxColour(16, 16, 16));
  AgcCustomFilename->SetFont(
      wxFont(10, wxFONTFAMILY_DEFAULT, wxFONTSTYLE_NORMAL, wxFONTWEIGHT_NORMAL, 0, wxT("")));
  AgcCustomFilename->SetToolTip(
      wxT(
          "If you wish to run guidance-computer software you have written yourself rather than actual mission software, you can put the filename here.  It must already have been compiled into binary executable format.  If you want to actually compile the software in addition, use the \"...\" button to the right."));
  AgcCustomFilename->Enable(false);
  AgcFilenameBrowse->SetMinSize(wxSize(50, 24));
  AgcFilenameBrowse->SetBackgroundColour(wxColour(240, 240, 240));
  AgcFilenameBrowse->SetToolTip(
      wxT(
          "Click this button to select the name of the AGC runtime software using a file-selection dialog.  This can be either a pre-compiled binary, or it can be AGC assembly-language source code.  If the latter, then VirtualAGC will actually compile it for you using the yaYUL utility."));
  AgcFilenameBrowse->Enable(false);
  if (!maximumSquish)
    {
      DeviceListLabel->SetBackgroundColour(wxColour(255, 255, 255));
      DeviceListLabel->SetFont(
          wxFont(12, wxFONTFAMILY_DEFAULT, wxFONTSTYLE_NORMAL, wxFONTWEIGHT_BOLD, 1, wxT("")));
      DeviceListLabel->SetToolTip(
          wxT(
              "In this area, you can select the particular computers and peripherals devices which will be simulated, along with the controls that will be displayed."));
    }
  DeviceAgcCheckbox->SetBackgroundColour(wxColour(255, 255, 255));
  DeviceAgcCheckbox->SetToolTip(
      wxT(
          "We assume that you will ALWAYS need to run the simulated guidance computer (AGC), so we don't allow you the option of deselecting it."));
  DeviceAgcCheckbox->Enable(false);
  DeviceAgcCheckbox->SetValue(1);
  DeviceDskyCheckbox->SetBackgroundColour(wxColour(255, 255, 255));
  DeviceDskyCheckbox->SetToolTip(
      wxT(
          "We assume that you will ALWAYS need to run the simulated display/keypad (DSKY), so we don't allow you the option of deselecting it."));
  DeviceDskyCheckbox->Enable(false);
  DeviceDskyCheckbox->SetValue(1);
  DeviceAcaCheckbox->SetBackgroundColour(wxColour(255, 255, 255));
  DeviceAcaCheckbox->SetToolTip(
      wxT(
          "The ACA is the rotational hand-controller (stick) used by the astronauts to control thrusters.  To use it, you must have a supported 3D joystick."));
  JoystickConfigure->SetMinSize(wxSize(70, 24));
  JoystickConfigure->SetBackgroundColour(wxColour(240, 240, 240));
  JoystickConfigure->SetToolTip(
      wxT("Click this to run the joystick-configurator program."));
  DeviceTelemetryCheckbox->SetBackgroundColour(wxColour(255, 255, 255));
  DeviceTelemetryCheckbox->SetToolTip(
      wxT(
          "The telemetry downlink monitor displays information which the guidance computer continually transmits to mission control.  Unfortunately, it does not mimic the actual APPEARANCE of the display screens used in mission control, because nobody seems to know exactly how they looked."));
  DeviceAeaCheckbox->SetBackgroundColour(wxColour(255, 255, 255));
  DeviceAeaCheckbox->SetToolTip(
      wxT(
          "The AEA (or sometimes AGS) is a completely separate computer system in the LM which could be used (but never was used in a real mission) in case of failure of the guidance computer, in order to abort."));
  DeviceDedaCheckbox->SetBackgroundColour(wxColour(255, 255, 255));
  DeviceDedaCheckbox->SetToolTip(
      wxT(
          "The DEDA was the display/keyboard interface used for the LM abort computer (AEA)."));
  DeviceDedaCheckbox->Enable(false);
  DeviceCpumonCheckbox->SetBackgroundColour(wxColour(255, 255, 255));
  DeviceCpumonCheckbox->SetToolTip(
      wxT(
          "This is the main window for the \"LM_simulator\" subsystem.  While designed for the LM and not yet adapted for the CM, it is of some use in CM simulations as well.  This particular window provides a continuous display of the state of the guidance computer's input/output channels.  It does not correspond to anything that actually existed in the spacecraft.  This needs to be selected in order to select any of the peripheral devices appearing below."));
  DeviceImuCheckbox->SetBackgroundColour(wxColour(255, 255, 255));
  DeviceImuCheckbox->SetToolTip(
      wxT(
          "This is part of the \"LM_Simulator\" subsystem.  It is basically an interface to the Inertial Monitoring Unit (IMU).  It gives continuous feedback on the velocity and attitude of the spacecraft.  The FDAI (8-ball) provides a visual status of the pitch/yaw/roll.  "));
  DeviceImuCheckbox->Enable(false);
  DeviceDiscoutCheckbox->SetBackgroundColour(wxColour(255, 255, 255));
  DeviceDiscoutCheckbox->SetToolTip(
      wxT(
          "This is part of the \"LM_Simulator\" subsystem.  It provides a visual indicator of the states of various discrete signals controlled by the guidance computer.  In the actual spacecraft, these signals were not all collected together into a single window like this."));
  DeviceDiscoutCheckbox->Enable(false);
  DeviceCrewinCheckbox->SetBackgroundColour(wxColour(255, 255, 255));
  DeviceCrewinCheckbox->SetToolTip(
      wxT(
          "This is part of the \"LM_Simulator\" subsystem.  It provides a way to turn various signals on or off (as the crew would have done with switches or buttons) and to feed those signals to the guidance computer."));
  DeviceCrewinCheckbox->Enable(false);
  DeviceSysinCheckbox->SetBackgroundColour(wxColour(255, 255, 255));
  DeviceSysinCheckbox->SetToolTip(
      wxT(
          "This is part of the \"LM_Simulator\" subsystem.  It provides a way to set the states of various signals used as inputs to the guidance computer that would normally have been set by systems within the spacecraft that are not present in this simulation."));
  DeviceSysinCheckbox->Enable(false);
  DevicePropulsionCheckbox->SetBackgroundColour(wxColour(255, 255, 255));
  DevicePropulsionCheckbox->SetToolTip(
      wxT(
          "This is part of the \"LM_Simulator\" subsystem.  It provides a continuous monitor of the spacecraft's fuel level, thrust, and so on.  The data is closely tied to the LM at this point, and is limited value in the CM."));
  DevicePropulsionCheckbox->Enable(false);
  NoviceButton->SetBackgroundColour(wxColour(240, 240, 240));
  NoviceButton->SetToolTip(
      wxT(
          "Click this button to set the minimum reasonable combination of devices above without having to go through the list and select them or deselect them one-by-one."));
  ExpertButton->SetBackgroundColour(wxColour(240, 240, 240));
  ExpertButton->SetToolTip(
      wxT(
          "Click this button to set the maximum reasonable combination of devices above, given the simulation type being run, without having to go through the list and select them or deselect them one-by-one."));
  AgcSourceButton->SetBackgroundColour(wxColour(240, 240, 240));
  AgcSourceButton->SetToolTip(
      wxT(
          "Click this to view the assembly listing (source code) for the selected AGC simulation type(s)."));
  AeaSourceButton->SetBackgroundColour(wxColour(240, 240, 240));
  AeaSourceButton->SetToolTip(
      wxT(
          "Click this to view the selected AEA Flight Program assembly listing."));
  if (!maximumSquish)
    {
      OptionList->SetBackgroundColour(wxColour(255, 255, 255));
      OptionList->SetFont(wxFont(12, wxFONTFAMILY_DEFAULT, wxFONTSTYLE_NORMAL, wxFONTWEIGHT_BOLD, 1, wxT("")));
      OptionList->SetToolTip(
          wxT(
              "In this area, you can select various infrequently-used options that can assist in special purposes."));
    }
  StartupWipeButton->SetToolTip(
      wxT(
          "The magnetic-core memory of the AGC is \"persistent\", meaning that it retains its memory when power is off, and hence can resume the computer program after power-up that it was running before shutdown.  If you would prefer NOT to resume and instead to start with completely erased memory, then choose this option."));
  StartupWipeButton->SetValue(1);
  StartupPreserveButton->SetToolTip(
      wxT(
          "Choose this to restart the program on startup, but otherwise preserving the contents of volatile memory."));
  StartupResumeButton->SetToolTip(
      wxT(
          "The magnetic-core memory of the AGC is \"persistent\", meaning that it retains its memory when power is off, and hence can resume the computer program after power-up that it was running before shutdown.  If you would like to do that, then choose this option."));
  CustomResumeButton->SetToolTip(
      wxT("Select a custom memory-core file from which to resume operation."));
  CoreFilename->SetBackgroundColour(wxColour(255, 255, 255));
  CoreFilename->Enable(false);
  CoreBrowse->SetMinSize(wxSize(50, 24));
  CoreBrowse->SetBackgroundColour(wxColour(240, 240, 240));
  CoreBrowse->SetToolTip(
      wxT(
          "Click this button to select the name of an AGC core dump from which to resume execution."));
  CoreBrowse->Enable(false);
  CoreSaveButton->SetMinSize(wxSize(50, 24));
  CoreSaveButton->SetBackgroundColour(wxColour(240, 240, 240));
  CoreSaveButton->SetToolTip(
      wxT(
          "Click this button to preserve the most-recent core-dump so that you can resume operation from it later, by name."));
  DskyLabel->SetBackgroundColour(wxColour(255, 255, 255));
  DskyFullButton->SetToolTip(
      wxT("This is the default display/keypad simulation."));
  DskyFullButton->SetValue(1);
  DskyHalfButton->SetToolTip(
      wxT(
          "Using a half-size display/keypad simulation can be useful if you don't have much space on your display-screen."));
  DskyLiteButton->SetToolTip(
      wxT(
          "The DSKY Lite is an alternate simulation of the display/keypad unit, using software contributed by Stephan Hotto.  There may be some circumstances under which you would find it useful.  However, it can only be used if in the \"Devices\" menu you select \"AGC CPU Bus/Input/Output Monitor\" and DO NOT select \"Telemetry Downlink Monitor\"."));
  DskyNavButton->SetToolTip(
      wxT("Nav-bay DSKY (vs main control-panel DSKY), for Block I only."));
  DownlinkLabel->SetBackgroundColour(wxColour(255, 255, 255));
  TelemetryResizable->SetToolTip(
      wxT(
          "Uses a format for the telemetry display in which the text size and display size is adjustable."));
  TelemetryResizable->SetValue(1);
  TelemetryRetro->SetToolTip(
      wxT(
          "The telemetry-display has a \"retro\" appearance, in which it looks somewhat like it's a CRT such as those from mission control.  However, it is not resizable and consumes quite a lot of space on your computer's actual display."));
  DedaLabel->SetBackgroundColour(wxColour(255, 255, 255));
  DedaFullButton->SetToolTip(
      wxT("This is the default AEA display/keypad simulation."));
  DedaFullButton->SetValue(1);
  DedaHalfButton->SetToolTip(
      wxT(
          "The half-size DEDA simulation can be useful if you have limited free space on your display screen."));
  AgcDebugLabel->SetBackgroundColour(wxColour(255, 255, 255));
  AgcDebugNormalButton->SetToolTip(
      wxT("Click this to run the simulated AGC CPU in the normal manner."));
  AgcDebugNormalButton->SetValue(1);
  AgcDebugMonitorButton->SetToolTip(
      wxT(
          "Click this to run the simulated AGC CPU with a debug monitor that allows single-stepping, breakpoints, disassembly, dumping/editing of memory, etc."));
  AeaDebugLabel->SetBackgroundColour(wxColour(255, 255, 255));
  AeaDebugNormalButton->SetToolTip(
      wxT("This is the normal manner of simulating the AEA/AGS."));
  AeaDebugNormalButton->SetValue(1);
  AeaDebugMonitorButton->SetToolTip(
      wxT(
          "Click this to run the simulated AEA/AGS CPU with a debug monitor that allows single-stepping, breakpoints, disassembly, dumping/editing of memory, etc."));
  FlightProgram4Button->SetBackgroundColour(wxColour(255, 255, 255));
  FlightProgram4Button->SetToolTip(
      wxT(
          "Click this to simulate the Apollo 9 LM for the first orbital test of the LM.  This will run the AEA/AGS software designated as Flight Program 3 or 4."));
  FlightProgram4Button->Enable(false);
  FlightProgram5Button->SetBackgroundColour(wxColour(255, 255, 255));
  FlightProgram5Button->SetToolTip(
      wxT(
          "Click this to simulate the Apollo 10 LM, which was the first LM test in the lunar neighborhood.  The Apollo 10 mission experienced a mishap associated with the AGC and AEA both trying to control the LM simultaneously.  This will run the AEA/AGS software designated as Flight Program 5."));
  FlightProgram5Button->Enable(false);
  FlightProgram6Button->SetBackgroundColour(wxColour(255, 255, 255));
  FlightProgram6Button->SetToolTip(
      wxT(
          "Click this to simulate the Apollo 11 LM for the FIRST moon landing.  This will run the AEA/AGS software designated as Flight Program 6 (June 1969)."));
  FlightProgram6Button->SetValue(1);
  FlightProgram7Button->SetBackgroundColour(wxColour(255, 255, 255));
  FlightProgram7Button->SetToolTip(
      wxT(
          "Click this to simulate the Apollo 12-14 LM ... maybe.  We're not actually sure which missions were associated with this software version.  This will run the AEA/AGS software designated as Flight Program 7."));
  FlightProgram7Button->Enable(false);
  FlightProgram8Button->SetBackgroundColour(wxColour(255, 255, 255));
  FlightProgram8Button->SetToolTip(
      wxT(
          "Click this to simulate the Apollo 15-17 LM.  This will run the AEA/AGS software designated as Flight Program 8 (December 1970)."));
  if (!maximumSquish)
    {
      AeaCustomButton->SetBackgroundColour(wxColour(255, 255, 255));
      AeaCustomButton->SetToolTip(
          wxT(
              "Click here to run your own personal software creation on the AEA/AGS system.  You should first have compiled your assembly-language source code using the yaLEMAP program to create an executable binary."));
      AeaCustomFilename->SetBackgroundColour(wxColour(255, 255, 255));
      AeaCustomFilename->SetForegroundColour(wxColour(16, 16, 16));
      AeaCustomFilename->SetToolTip(
          wxT(
              "If you wish to run abort-computer software you have written yourself rather than actual mission software, you can put the filename here.  It must already have been compiled into binary executable format.  If you want to actually compile the software in addition, use the \"...\" button to the right."));
      AeaCustomFilename->Enable(false);
      AeaFilenameBrowse->SetMinSize(wxSize(50, 24));
      AeaFilenameBrowse->SetBackgroundColour(wxColour(240, 240, 240));
      AeaFilenameBrowse->SetToolTip(
          wxT(
              "Click this button to select the name of the AEA runtime software using a file-selection dialog.  This can be either a pre-compiled binary, or it can be AEA assembly-language source code.  If the latter, then VirtualAGC will actually compile it for you using the yaLEMAP utility."));
      AeaFilenameBrowse->Enable(false);
    }
  RunButton->SetBackgroundColour(wxColour(240, 240, 240));
  RunButton->SetToolTip(
      wxT(
          "Click this button to begin running the simulation using all of the various options and settings selected above!"));
  DefaultsButton->SetBackgroundColour(wxColour(240, 240, 240));
  DefaultsButton->SetToolTip(
      wxT(
          "When you change the various settings above, they are persistent.  In other words, if you run this program again, the settings will be whatever you set them at in the prior run.  If you click this button, it will return the settings to the defaults that existed when this program was first installed."));
  ExitButton->SetBackgroundColour(wxColour(240, 240, 240));
  ExitButton->SetToolTip(
      wxT(
          "Click this button to exit this program.  Your settings will be saved."));
}

void
VirtualAGC::do_layout()
{
  wxBoxSizer* TopSizer = new wxBoxSizer(wxVERTICAL);
  wxBoxSizer* sizer_3 = new wxBoxSizer(wxHORIZONTAL);
  wxBoxSizer* sizer_2 = new wxBoxSizer(wxHORIZONTAL);
  wxBoxSizer* sizer_8 = new wxBoxSizer(wxVERTICAL);
  wxBoxSizer* sizer_9 = new wxBoxSizer(wxHORIZONTAL);
  wxBoxSizer* sizer_10 = new wxBoxSizer(wxVERTICAL);
  wxBoxSizer* sizer_29 = new wxBoxSizer(wxHORIZONTAL);
  wxBoxSizer* sizer_30 = new wxBoxSizer(wxVERTICAL);
  wxStaticBoxSizer* sizer_20 = new wxStaticBoxSizer(sizer_20_staticbox,
      wxVERTICAL);
  wxBoxSizer* sizer_15_copy = new wxBoxSizer(wxHORIZONTAL);
  wxStaticBoxSizer* sizer_38 = new wxStaticBoxSizer(sizer_38_staticbox,
      wxHORIZONTAL);
  wxGridSizer* grid_sizer_1 = new wxGridSizer(2, 3, 0, 0);
  wxStaticBoxSizer* sizer_22 = new wxStaticBoxSizer(sizer_22_staticbox,
      wxHORIZONTAL);
  wxGridSizer* grid_sizer_2 = new wxGridSizer(3, 5, 0, 0);
  wxStaticBoxSizer* sizer_18 = new wxStaticBoxSizer(sizer_18_staticbox,
      wxVERTICAL);
  wxBoxSizer* sizer_34 = new wxBoxSizer(wxHORIZONTAL);
  wxBoxSizer* sizer_5 = new wxBoxSizer(wxVERTICAL);
  wxBoxSizer* sizer_1 = new wxBoxSizer(wxHORIZONTAL);
  wxStaticBoxSizer* sizer_1_copy = new wxStaticBoxSizer(sizer_1_copy_staticbox,
      wxHORIZONTAL);
  wxBoxSizer* sizer_6 = new wxBoxSizer(wxHORIZONTAL);
  wxBoxSizer* sizer_7 = new wxBoxSizer(wxVERTICAL);
  wxBoxSizer* sizer_12 = new wxBoxSizer(wxHORIZONTAL);
  wxBoxSizer* sizer_35 = new wxBoxSizer(wxHORIZONTAL);
  wxBoxSizer* sizer_36 = new wxBoxSizer(wxVERTICAL);
  wxBoxSizer* sizer_37 = new wxBoxSizer(wxHORIZONTAL);
  wxBoxSizer* sizer_4 = new wxBoxSizer(wxVERTICAL);
  wxBoxSizer* sizer_11 = new wxBoxSizer(wxHORIZONTAL);
  wxBoxSizer* sizer_13 = new wxBoxSizer(wxHORIZONTAL);
  wxBoxSizer* sizer_14 = new wxBoxSizer(wxVERTICAL);
  wxStaticBoxSizer* sizer_19 = new wxStaticBoxSizer(sizer_19_staticbox,
      wxVERTICAL);
  wxBoxSizer* sizer_15 = new wxBoxSizer(wxHORIZONTAL);
  wxBoxSizer* HeaderSizer = new wxBoxSizer(wxHORIZONTAL);
  wxGridSizer* RightSizer = new wxGridSizer(1, 6, 0, 0);
  wxBoxSizer* MiddleSizer = new wxBoxSizer(wxHORIZONTAL);
  wxGridSizer* LeftSizer = new wxGridSizer(1, 6, 0, 0);
  if (!maximumSquish)
    {
      TopSizer->Add(20, 5, 0, wxALIGN_CENTER_HORIZONTAL, 0);
      LeftSizer->Add(Patch1Bitmap, 0,
          wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
      LeftSizer->Add(Patch7Bitmap, 0,
          wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
      LeftSizer->Add(Patch8Bitmap, 0,
          wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
      LeftSizer->Add(Patch9Bitmap, 0,
          wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
      LeftSizer->Add(Patch10Bitmap, 0,
          wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
      LeftSizer->Add(Patch11Bitmap, 0,
          wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
      HeaderSizer->Add(LeftSizer, 1, wxEXPAND, 0);
      MiddleSizer->Add(20, 20, 1,
          wxALIGN_CENTER_VERTICAL, 0);
      MiddleSizer->Add(PatchBitmap, 0,
          wxALIGN_CENTER_VERTICAL, 0);
      MiddleSizer->Add(20, 20, 1,
          wxALIGN_CENTER_VERTICAL, 0);
      HeaderSizer->Add(MiddleSizer, 1, wxEXPAND, 0);
      RightSizer->Add(Patch12Bitmap, 0,
          wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
      RightSizer->Add(Patch13Bitmap, 0,
          wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
      RightSizer->Add(Patch14Bitmap, 0,
          wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
      RightSizer->Add(Patch15Bitmap, 0,
          wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
      RightSizer->Add(Patch16Bitmap, 0,
          wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
      RightSizer->Add(Patch17Bitmap, 0,
          wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
      HeaderSizer->Add(RightSizer, 1, wxEXPAND, 0);
      TopSizer->Add(HeaderSizer, 0, wxEXPAND, 0);
      TopSizer->Add(20, 5, 0, wxALIGN_CENTER_HORIZONTAL, 0);
      TopSizer->Add(TopLine, 0, wxEXPAND, 0);
      sizer_4->Add(20, 10, 0,
          wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
      sizer_4->Add(SimTypeLabel, 0, wxALIGN_CENTER_HORIZONTAL, 0);
      sizer_11->Add(20, 20, 0,
          wxALIGN_CENTER_VERTICAL, 0);
      sizer_14->Add(20, 10, 0, wxEXPAND, 0);
    }
  int mission;
  for (mission = ID_FIRSTMISSION; mission < ID_AGCCUSTOMBUTTON; mission++)
    sizer_19->Add(missionRadioButtons[mission - ID_FIRSTMISSION], 0, 0, 0);
  sizer_15->Add(AgcCustomButton, 0, 0, 0);
  sizer_15->Add(AgcCustomFilename, 1, wxEXPAND, 0);
  sizer_15->Add(AgcFilenameBrowse, 0, 0, 0);
  sizer_19->Add(sizer_15, 0, wxEXPAND, 0);
  sizer_14->Add(sizer_19, 1, wxEXPAND, 0);
  if (!maximumSquish)
    sizer_14->Add(20, 10, 0, wxEXPAND, 0);
  sizer_13->Add(sizer_14, 1, wxEXPAND, 0);
  sizer_11->Add(sizer_13, 1, wxEXPAND, 0);
  if (!maximumSquish)
    sizer_11->Add(20, 20, 0,
       wxALIGN_CENTER_VERTICAL, 0);
  sizer_4->Add(sizer_11, 1, wxEXPAND, 0);
  sizer_2->Add(sizer_4, 1, wxEXPAND, 0);

  sizer_6->Add(static_line_2, 0, wxEXPAND, 0);
  if (!maximumSquish)
    sizer_6->Add(20, 20, 0, wxALIGN_CENTER_VERTICAL,
        0);
  if (!maximumSquish)
    sizer_7->Add(20, 10, 0, wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL,
        0);
  if (DropDown)
    {
      sizer_2->Show(false);
      if (!maximumSquish)
        {
          sizer_7->Add(SimTypeLabel2, 0, wxALIGN_CENTER_HORIZONTAL, 0);
          sizer_7->Add(20, 10, 0,
              wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
        }
      sizer_7->Add(DeviceAGCversionDropDownList, 0, 0, 0);
      if (!maximumSquish)
        sizer_7->Add(20, 10, 0,
            wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
    }
  else
    {
      DeviceAGCversionDropDownList->Show(false);
      if (!maximumSquish)
        SimTypeLabel2->Show(false);
    }
  if (!maximumSquish)
    {
      sizer_7->Add(DeviceListLabel, 0, wxALIGN_CENTER_HORIZONTAL, 0);
      sizer_7->Add(20, 10, 0,
          wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
    }
  sizer_7->Add(DeviceAgcCheckbox, 0, 0, 0);
  sizer_7->Add(DeviceDskyCheckbox, 0, 0, 0);
  sizer_37->Add(DeviceAcaCheckbox, 0, wxALIGN_CENTER_VERTICAL, 0);
  sizer_37->Add(2, 20, 1, 0, 0);
  sizer_37->Add(JoystickConfigure, 0, 0, 0);
  sizer_7->Add(sizer_37, 0, wxEXPAND, 0);
  sizer_7->Add(DeviceTelemetryCheckbox, 0, 0, 0);
  sizer_7->Add(DeviceAeaCheckbox, 0, 0, 0);
  sizer_7->Add(DeviceDedaCheckbox, 0, 0, 0);
  sizer_7->Add(DeviceCpumonCheckbox, 0, 0, 0);
  sizer_35->Add(static_line_4, 1, wxEXPAND, 0);
  sizer_36->Add(DeviceImuCheckbox, 0, 0, 0);
  sizer_36->Add(DeviceDiscoutCheckbox, 0, 0, 0);
  sizer_36->Add(DeviceCrewinCheckbox, 0, 0, 0);
  sizer_36->Add(DeviceSysinCheckbox, 0, 0, 0);
  sizer_36->Add(DevicePropulsionCheckbox, 0, 0, 0);
  sizer_35->Add(sizer_36, 15, wxEXPAND, 0);
  sizer_7->Add(sizer_35, 1, wxEXPAND, 0);
  if (!maximumSquish)
    sizer_7->Add(20, 10, 0, wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL,
        0);
  sizer_12->Add(NoviceButton, 0, 0, 2);
  if (!maximumSquish)
    sizer_12->Add(20, 20, 0,
        wxALIGN_CENTER_VERTICAL, 0);
  sizer_12->Add(ExpertButton, 0, 0, 0);
  sizer_7->Add(sizer_12, 0, wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL,
      0);
  if (!maximumSquish)
    sizer_7->Add(20, 10, 0, 0, 0);
  sizer_6->Add(sizer_7, 1, 0, 0);
  if (!maximumSquish)
    sizer_6->Add(20, 20, 0, wxALIGN_CENTER_VERTICAL,
        0);
  sizer_6->Add(static_line_3, 0, wxEXPAND, 0);
  sizer_5->Add(sizer_6, 0, wxEXPAND, 0);
  sizer_5->Add(static_line_5, 0, wxEXPAND, 0);
  if (!maximumSquish)
    sizer_5->Add(20, 10, 10, wxEXPAND, 0);
  if (!maximumSquish)
    sizer_1_copy->Add(20, 20, 1, 0, 0);
  sizer_1_copy->Add(AgcSourceButton, 0, 0, 0);
  if (!maximumSquish)
    sizer_1_copy->Add(20, 20, 0, 0, 0);
  sizer_1_copy->Add(AeaSourceButton, 0, 0, 0);
  if (!maximumSquish)
    sizer_1_copy->Add(20, 20, 1, 0, 0);
  if (DropDown)
    sizer_1->Add(20, 20, 0, 0, 0);
  sizer_1->Add(sizer_1_copy, 1, wxEXPAND, 0);
  sizer_5->Add(sizer_1, 0, wxEXPAND, 0);
  if (!maximumSquish)
    sizer_5->Add(20, 10, 0, wxEXPAND, 0);
  sizer_2->Add(sizer_5, 1, wxEXPAND, 0);
  optionsBox = sizer_8;
  if (!maximumSquish)
    {
      sizer_8->Add(20, 10, 0,
          wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
      sizer_8->Add(OptionList, 0, wxALIGN_CENTER_HORIZONTAL, 0);
      sizer_8->Add(20, 10, 0,
          wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
      sizer_9->Add(20, 20, 0,
          wxALIGN_CENTER_VERTICAL, 0);
    }
  agcStartupBox = sizer_18;
  sizer_18->Add(StartupWipeButton, 0, 0, 0);
  sizer_18->Add(StartupPreserveButton, 0, 0, 0);
  sizer_18->Add(StartupResumeButton, 0, 0, 0);
  sizer_34->Add(CustomResumeButton, 0, 0, 0);
  sizer_34->Add(CoreFilename, 1, wxEXPAND, 0);
  sizer_34->Add(CoreBrowse, 0, 0, 0);
  sizer_34->Add(CoreSaveButton, 0, 0, 0);
  sizer_18->Add(sizer_34, 1, wxEXPAND, 0);
  sizer_10->Add(sizer_18, 0, wxEXPAND, 0);
  if (!maximumSquish)
    sizer_10->Add(20, 10, 0, wxALIGN_CENTER_HORIZONTAL, 0);
  interfaceStylesBox = grid_sizer_2;
  grid_sizer_2->Add(DskyLabel, 0, wxALIGN_CENTER_VERTICAL, 0);
  grid_sizer_2->Add(DskyFullButton, 0, 0, 0);
  grid_sizer_2->Add(DskyHalfButton, 0, 0, 0);
  grid_sizer_2->Add(DskyLiteButton, 0, 0, 0);
  grid_sizer_2->Add(DskyNavButton, 0, 0, 0);
  grid_sizer_2->Add(DownlinkLabel, 0, wxALIGN_CENTER_VERTICAL, 0);
  grid_sizer_2->Add(TelemetryResizable, 0, 0, 0);
  grid_sizer_2->Add(TelemetryRetro, 0, 0, 0);
  grid_sizer_2->Add(20, 20, 0, 0, 0);
  grid_sizer_2->Add(20, 20, 0, 0, 0);
  grid_sizer_2->Add(DedaLabel, 0, wxALIGN_CENTER_VERTICAL, 0);
  grid_sizer_2->Add(DedaFullButton, 0, 0, 0);
  grid_sizer_2->Add(DedaHalfButton, 0, 0, 0);
  grid_sizer_2->Add(20, 20, 0, 0, 0);
  grid_sizer_2->Add(20, 20, 0, 0, 0);
  sizer_22->Add(grid_sizer_2, 1, wxEXPAND, 0);
  sizer_10->Add(sizer_22, 0, wxEXPAND, 0);
  if (!maximumSquish)
    sizer_10->Add(20, 10, 0, wxALIGN_CENTER_HORIZONTAL, 0);
  debuggerBox = grid_sizer_1;
  grid_sizer_1->Add(AgcDebugLabel, 0, wxALIGN_CENTER_VERTICAL, 0);
  grid_sizer_1->Add(AgcDebugNormalButton, 0, wxALIGN_CENTER_VERTICAL, 0);
  grid_sizer_1->Add(AgcDebugMonitorButton, 0, wxALIGN_CENTER_VERTICAL, 0);
  grid_sizer_1->Add(AeaDebugLabel, 0, wxALIGN_CENTER_VERTICAL, 0);
  grid_sizer_1->Add(AeaDebugNormalButton, 0, wxEXPAND, 0);
  grid_sizer_1->Add(AeaDebugMonitorButton, 0, wxEXPAND, 0);
  sizer_38->Add(grid_sizer_1, 1, wxEXPAND, 0);
  sizer_10->Add(sizer_38, 0, wxEXPAND, 0);
  if (!maximumSquish)
    sizer_10->Add(20, 1, 1, wxEXPAND, 0);
  sizer_20->Add(FlightProgram4Button, 0, 0, 0);
  sizer_20->Add(FlightProgram5Button, 0, 0, 0);
  sizer_20->Add(FlightProgram6Button, 0, 0, 0);
  sizer_20->Add(FlightProgram7Button, 0, 0, 0);
  sizer_20->Add(FlightProgram8Button, 0, 0, 0);
  if (!maximumSquish)
    {
      sizer_15_copy->Add(AeaCustomButton, 0, 0, 0);
      sizer_15_copy->Add(AeaCustomFilename, 1, wxEXPAND, 0);
      sizer_15_copy->Add(AeaFilenameBrowse, 0, 0, 0);
      sizer_20->Add(sizer_15_copy, 0, wxEXPAND, 0);
    }
  sizer_30->Add(sizer_20, 0, wxEXPAND, 0);
  sizer_29->Add(sizer_30, 1, wxEXPAND, 0);
  sizer_10->Add(sizer_29, 0, wxEXPAND, 0);
  if (!maximumSquish)
    sizer_10->Add(20, 10, 0, wxALIGN_CENTER_HORIZONTAL, 0);
  sizer_9->Add(sizer_10, 0, wxEXPAND, 0);
  if (!maximumSquish)
    sizer_9->Add(20, 20, 0, wxALIGN_CENTER_VERTICAL,
        0);
  sizer_8->Add(sizer_9, 1, wxEXPAND, 0);
  sizer_2->Add(sizer_8, 1, wxEXPAND, 0);
  TopSizer->Add(sizer_2, 0, wxEXPAND, 0);
  TopSizer->Add(static_line_1, 0, wxEXPAND, 0);
  if (!maximumSquish)
    TopSizer->Add(20, 15, 0,
        wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
  sizer_3->Add(RunButton, 0,
      wxALIGN_CENTER_VERTICAL, 0);
  sizer_3->Add(40, 40, 0, wxALIGN_CENTER_VERTICAL,
      0);
  sizer_3->Add(DefaultsButton, 0,
      wxALIGN_CENTER_VERTICAL, 0);
  sizer_3->Add(40, 40, 0, wxALIGN_CENTER_VERTICAL,
      0);
  sizer_3->Add(ExitButton, 0,
      wxALIGN_CENTER_VERTICAL, 0);
  TopSizer->Add(sizer_3, 0, wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL,
      0);
  if (!maximumSquish)
    TopSizer->Add(20, 15, 0,
        wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
  SetSizer(TopSizer);
  TopSizer->Fit(this);
  Layout();
}

class VirtualAgcApp : public wxApp
{
public:
  bool
  OnInit();
};

IMPLEMENT_APP (VirtualAgcApp)

static VirtualAGC *MainFrame;
bool
VirtualAgcApp::OnInit()
{
  wxInitAllImageHandlers();

  for (int i = 1; i < argc; i++)
    {
      wxString Arg = argv[i];
      wxString ArgStart = Arg.BeforeFirst('=');
      wxString ArgEnd = Arg.AfterFirst('=');

      if (Arg.IsSameAs(wxT("--squish")))
        {
          noSquish = 0;
          dropdownSquish = 0;
          maximumSquish = 1;
        }
      else if (Arg.IsSameAs(wxT("--dropdown")))
        {
          noSquish = 0;
          dropdownSquish = 1;
          maximumSquish = 0;
        }
      else if (Arg.IsSameAs(wxT("--radio-buttons")))
        {
          noSquish = 1;
          dropdownSquish = 0;
          maximumSquish = 0;
        }
      else if (Arg.IsSameAs(wxT("--maximize")))
        {
          maximizeAtStartup = 1;
        }
      else
        {
          Help: printf("USAGE:\n");
          printf("\tVirtualAGC [OPTIONS]\n");
          printf("The available options are:\n");
          printf("--radio-buttons\n");
          printf("\tSets main-window size appropriate to the largest\n");
          printf("\tdisplay screens ... varies by target platform, but\n");
          printf("\tprobably okay as long as there are at least 1024\n");
          printf("\tof usable pixel rows on the desktop. The name\n");
          printf("\t(radio buttons) refers to the fact that mission\n");
          printf("\tselection is performed using a bit list of so-called\n");
          printf("\t\"radio buttons\".\n");
          printf("--dropdown\n");
          printf("\tSets the main-window size suitable for a smaller\n");
          printf("\tdisplay-screen size.  This is the default, in regard\n");
          printf("\tto --radio-buttons vs --dropdown vs --squish.\n");
          printf("\tactual sizes vary by target platform, but probably\n");
          printf("\tworks at least as small as 700 usable pixel rows.\n");
          printf("--squish\n");
          printf("\tReduces the user interface to the smallest possible\n");
          printf("\tsize ... removing all decoration, extra spacing,\n");
          printf("\ttitles, and even some options.  This is known to\n");
          printf("\tfit in 480 pixel rows (Raspberry Pi 7-inch touchscreen)\n");
          printf("\tbut the actual size will vary by target platform.\n");
          printf("\tNote that when run in this mode there is no title\n");
          printf("\tbar on the main window, and hence no exit (X) button\n");
          printf("\tin the (non-existent) title bar, so the program can\n");
          printf("\tonly be exited by hitting the EXIT button at the\n");
          printf("\tbottom of the main window or from the desktop taskbar,\n");
          printf("\tif any.  Similarly, there is no minimization (-)\n");
          printf("\tbutton, so the program can only be minimized or\n");
          printf("\tunminimized from the desktop taskbar, if any.\n");
          printf("\tThe main window can, however, still be dragged on the\n");
          printf("\tdesktop, by grabbing and dragging the window border.\n");
          printf("--maximize\n");
          printf("\tUsed only with --squish, to run VirtualAGC maximized.\n");
          printf("\tThis may be useful in a kiosk.  Note, though, that\n");
          printf("\twith --squish there is no title bar and hence no way\n");
          printf("\tto unmaximize the program after it is started up.\n");
          printf("\tNote that the program does not generally have a\n");
          printf("\tmaximization button, nor is it generally resizable.\n");
          printf("\tso --maximize is actually the only method provided of\n");
          printf("\tmaximizing the program anyway.\n");
          exit(1);
        }
    }

  MainFrame = new VirtualAGC(NULL, wxID_ANY, wxEmptyString);
  SetTopWindow(MainFrame);
  MainFrame->Show();
  return true;
}

///////////////////////////////////////////////////////////////////////////////////////
// Various Auxiliary functions needed by the stuff above.

void
VirtualAGC::EnableRunButton(void)
{
  RunButton->Enable(true);
  Show(true);
}

// Converts a drop-list representation of the selected mission to a radio-button representation.
void
VirtualAGC::ConvertDropDown(void)
{
  wxString selectedMission;
  int mission;
  selectedMission = DeviceAGCversionDropDownList->GetString(
      DeviceAGCversionDropDownList->GetSelection());
  for (mission = ID_FIRSTMISSION; mission < ID_AGCCUSTOMBUTTON; mission++)
    {
      if (selectedMission
          == wxString::FromUTF8(
              missionConstants[mission - ID_FIRSTMISSION].name))
        {
          missionRadioButtons[mission - ID_FIRSTMISSION]->SetValue(true);
          break;
        }
    }
}

// Converts a radio-button representation of the selected mission to a drop-list representation.
void
VirtualAGC::ConvertRadio(void)
{
  for (int mission = ID_FIRSTMISSION; mission < ID_AGCCUSTOMBUTTON; mission++)
    if (missionRadioButtons[mission - ID_FIRSTMISSION]->GetValue())
      {
        wxString missionName = wxString::FromUTF8(
            missionConstants[mission - ID_FIRSTMISSION].name);
        for (int drop = 0; drop < DeviceAGCversionDropDownList->GetCount();
            drop++)
          {
            if (DeviceAGCversionDropDownList->GetString(drop) == missionName)
              {
                DeviceAGCversionDropDownList->SetSelection(drop);
                break;
              }
          }
        break;
      }
}

// This function checks the enabling/disabling of all controls, and makes sure that
// they are consistent among themselves.
void
VirtualAGC::EnforceConsistency(void)
{
  bool IsCustom = false;
  bool abnormalCase = false;
  bool hasSource = false;

  block1 = false;
  IsLM = false;
  int mission;
  if (DropDown)
    ConvertDropDown();
  for (mission = ID_FIRSTMISSION; mission < ID_AGCCUSTOMBUTTON; mission++)
    if (missionRadioButtons[mission - ID_FIRSTMISSION]->GetValue())
      {
        block1 = (missionConstants[mission - ID_FIRSTMISSION].Block1 == BLOCK1);
        abnormalCase = block1
            || (missionConstants[mission - ID_FIRSTMISSION].noPeripherals
                == NO_PERIPHERALS);
        IsLM = (missionConstants[mission - ID_FIRSTMISSION].lm == LM);
        hasSource = (missionConstants[mission - ID_FIRSTMISSION].html[0] != 0);
        break;
      }
  IsLM = IsLM || AgcCustomButton->GetValue();

  //optionsBox->Enable(!block1);
  StartupWipeButton->Enable(!block1);
  StartupPreserveButton->Enable(!block1);
  StartupResumeButton->Enable(!block1);
  CustomResumeButton->Enable(!block1);
  CoreFilename->Enable(!block1);
  CoreBrowse->Enable(!block1);
  CoreSaveButton->Enable(!block1);
  DskyLabel->Enable(true);
  DskyFullButton->Enable(true);
  DskyHalfButton->Enable(!block1);
  DskyLiteButton->Enable(!block1);
  DskyNavButton->Enable(block1);
  if (block1 && (DskyHalfButton->GetValue() || DskyLiteButton->GetValue()))
    DskyFullButton->SetValue(true);
  else if (!block1 && DskyNavButton->GetValue())
    DskyFullButton->SetValue(true);
  DownlinkLabel->Enable(!block1);
  TelemetryResizable->Enable(!block1);
  TelemetryRetro->Enable(!block1);
  DedaLabel->Enable(!block1);
  DedaFullButton->Enable(!block1);
  DedaHalfButton->Enable(!block1);
  AgcDebugLabel->Enable(!block1);
  AgcDebugNormalButton->Enable(!block1);
  AgcDebugMonitorButton->Enable(!block1);
  AeaDebugLabel->Enable(!block1);
  AeaDebugNormalButton->Enable(!block1);
  AeaDebugMonitorButton->Enable(!block1);

  DeviceAgcCheckbox->SetValue(true);
  DeviceDskyCheckbox->SetValue(true);
  NoviceButton->Enable(!block1);
  ExpertButton->Enable(!block1);
  RunButton->Enable(true);

  IsCustom = AgcCustomButton->GetValue();
  EnableLM(IsLM && !abnormalCase);
  EnableCustomAGC(IsCustom);
  DeviceTelemetryCheckbox->Enable(!abnormalCase);
  if (!DeviceTelemetryCheckbox->IsEnabled())
    DeviceTelemetryCheckbox->SetValue(false);
  //if (DeviceTelemetryCheckbox->GetValue () && DskyLiteButton->GetValue ())
  //  DskyFullButton->SetValue (true);
  DeviceCpumonCheckbox->Enable(!abnormalCase);
  if (!DeviceCpumonCheckbox->IsEnabled())
    DeviceCpumonCheckbox->SetValue(false);
  if (!DeviceCpumonCheckbox->GetValue())
    {
      if (DskyLiteButton->GetValue())
        DskyFullButton->SetValue(true);
      DeviceImuCheckbox->Enable(false);
      DeviceDiscoutCheckbox->Enable(false);
      DeviceCrewinCheckbox->Enable(false);
      DeviceSysinCheckbox->Enable(false);
      DevicePropulsionCheckbox->Enable(false);
    }
  if (!DeviceAcaCheckbox->IsEnabled())
    DeviceAcaCheckbox->SetValue(false);
  JoystickConfigure->Enable(DeviceAcaCheckbox->GetValue());
  if (!DeviceAeaCheckbox->IsEnabled())
    {
      DeviceAeaCheckbox->SetValue(false);
      DeviceDedaCheckbox->SetValue(false);
    }
  DedaLabel->Enable(DeviceAeaCheckbox->GetValue());
  AeaDebugLabel->Enable(DeviceAeaCheckbox->GetValue());
  if (!DeviceImuCheckbox->IsEnabled())
    DeviceImuCheckbox->SetValue(false);
  if (!DeviceDiscoutCheckbox->IsEnabled())
    DeviceDiscoutCheckbox->SetValue(false);
  if (!DeviceCrewinCheckbox->IsEnabled())
    DeviceCrewinCheckbox->SetValue(false);
  if (!DeviceSysinCheckbox->IsEnabled())
    DeviceSysinCheckbox->SetValue(false);
  if (!DevicePropulsionCheckbox->IsEnabled())
    DevicePropulsionCheckbox->SetValue(false);
  DskyLiteButton->Enable(
      DeviceCpumonCheckbox->GetValue() /* && !DeviceTelemetryCheckbox->GetValue () */);
  DskyNavButton->Enable(block1);
  TelemetryResizable->Enable(DeviceTelemetryCheckbox->GetValue());
  TelemetryRetro->Enable(DeviceTelemetryCheckbox->GetValue());
  DownlinkLabel->Enable(DeviceTelemetryCheckbox->GetValue());
  AgcSourceButton->Enable(
      hasSource
          || (AgcCustomButton->GetValue()
              && !AgcCustomFilename->GetValue().IsEmpty()));
  AeaSourceButton->Enable(
      (FlightProgram6Button->IsEnabled() && FlightProgram6Button->GetValue())
          || (FlightProgram8Button->IsEnabled()
              && FlightProgram8Button->GetValue())
          || (!maximumSquish && AeaCustomButton->IsEnabled()
              && AeaCustomButton->GetValue()
              && !AeaCustomFilename->GetValue().IsEmpty()));
  CoreFilename->Enable(CustomResumeButton->GetValue());
  CoreBrowse->Enable(CustomResumeButton->GetValue());
}

// This function goes through and either enables or disables all of the LM controls.
void
VirtualAGC::EnableLM(bool YesNo)
{
  DeviceAcaCheckbox->Enable(YesNo);
  DeviceAeaCheckbox->Enable(YesNo);
  DeviceDedaCheckbox->SetValue(DeviceAeaCheckbox->GetValue());
  EnableAEA(YesNo && DeviceAeaCheckbox->GetValue());
  EnableCpumon(YesNo && DeviceCpumonCheckbox->GetValue());
}

// This function goes through and either enables or disables all of the AEA controls.
void
VirtualAGC::EnableAEA(bool YesNo)
{
  FlightProgram6Button->Enable(YesNo);
  FlightProgram8Button->Enable(YesNo);
  if (!maximumSquish)
    {
      AeaCustomButton->Enable(YesNo);
      EnableCustomAEA(YesNo && AeaCustomButton->GetValue());
    }
  DeviceDedaCheckbox->Enable(false);
  EnableDEDA(YesNo && DeviceDedaCheckbox->GetValue());
  AeaDebugNormalButton->Enable(YesNo);
  AeaDebugMonitorButton->Enable(YesNo);
}

// This function either enables or disables the DEDA controls
void
VirtualAGC::EnableDEDA(bool YesNo)
{
  DedaFullButton->Enable(YesNo);
  DedaHalfButton->Enable(YesNo);
}

// This function either enables or disables the AGC custom-program controls
void
VirtualAGC::EnableCustomAGC(bool YesNo)
{
  //AgcFilenameLabel->Enable (YesNo);
  AgcCustomFilename->Enable(YesNo);
  AgcFilenameBrowse->Enable(YesNo);
}

// This function either enables or disables the AEA custom-program controls
void
VirtualAGC::EnableCustomAEA(bool YesNo)
{
  if (!maximumSquish)
    {
      //AeaFilenameLabel->Enable (YesNo);
      AeaCustomFilename->Enable(YesNo);
      AeaFilenameBrowse->Enable(YesNo);
    }
}

// This function either enables or disables the LM-Simulator controls
void
VirtualAGC::EnableCpumon(bool YesNo)
{
  DeviceImuCheckbox->Enable(YesNo);
  DeviceDiscoutCheckbox->Enable(YesNo);
  DeviceCrewinCheckbox->Enable(YesNo);
  DeviceSysinCheckbox->Enable(YesNo);
  DevicePropulsionCheckbox->Enable(YesNo);
}

// Sets all of the settings to a reasonable default configuration.
void
VirtualAGC::SetDefaultConfiguration(void)
{
  missionRadioButtons[ID_LUMINARY131BUTTON - ID_FIRSTMISSION]->SetValue(true);
  AgcCustomFilename->SetValue(wxT(""));
  FlightProgram6Button->SetValue(true);
  if (!maximumSquish)
    {
      AeaCustomFilename->SetValue(wxT(""));
    }
  DeviceAgcCheckbox->SetValue(true);
  DeviceDskyCheckbox->SetValue(true);
  DeviceAcaCheckbox->SetValue(false);
  DeviceTelemetryCheckbox->SetValue(true);
  DeviceAeaCheckbox->SetValue(false);
  DeviceDedaCheckbox->SetValue(false);
  DeviceCpumonCheckbox->SetValue(false);
  DeviceImuCheckbox->SetValue(false);
  DeviceDiscoutCheckbox->SetValue(false);
  DeviceCrewinCheckbox->SetValue(false);
  DeviceSysinCheckbox->SetValue(false);
  DevicePropulsionCheckbox->SetValue(false);
  StartupWipeButton->SetValue(true);
  AgcDebugNormalButton->SetValue(true);
  if (Points >= StartingPoints && !maximumSquish)
    {
      DedaFullButton->SetValue(true);
      DskyFullButton->SetValue(true);
    }
  else
    {
      DedaHalfButton->SetValue(true);
      DskyHalfButton->SetValue(true);
    }
  AeaDebugNormalButton->SetValue(true);
  TelemetryResizable->SetValue(true);
}

// Reads a configuration file to get all of the settings.

#define CHECK_TEXT_SETTING(name) \
  if (!Skip && Name.IsSameAs (wxT (#name))) \
    { \
      Skip = true; \
      name->SetValue (Value); \
    }

#define CHECK_TRUE_FALSE_SETTING(name) \
  if (!Skip && Name.IsSameAs (wxT (#name))) \
    { \
      Skip = true; \
      if (Value.IsSameAs (wxT ("true"))) \
        name->SetValue (true); \
      else \
        name->SetValue (false); \
    }

void
VirtualAGC::ReadConfigurationFile(void)
{
  int mission = ID_FIRSTMISSION - 1;
  wxTextFile Fin;
  if (wxFileExists(wxT("VirtualAGC.cfg")))
    {
      if (Fin.Open(wxT("VirtualAGC.cfg")))
        {
          int i, NumLines = Fin.GetLineCount();
          for (i = 0; i < NumLines; i++)
            {
              wxString Line, Name, Value;
              bool Skip = false;
              Line = Fin.GetLine(i);
              Name = Line.BeforeFirst('=');
              Value = Line.AfterFirst('=');
              if (Name.IsSameAs(
                  wxT("missionRadioButtons[mission - ID_FIRSTMISSION]")))
                mission++;
              CHECK_TEXT_SETTING(AgcCustomFilename);
              if (!maximumSquish)
                {
                  CHECK_TEXT_SETTING(AeaCustomFilename);
                }
              CHECK_TEXT_SETTING(CoreFilename);
              CHECK_TRUE_FALSE_SETTING(
                  missionRadioButtons[mission - ID_FIRSTMISSION]);
              CHECK_TRUE_FALSE_SETTING(AgcCustomButton);
              CHECK_TRUE_FALSE_SETTING(FlightProgram4Button);
              CHECK_TRUE_FALSE_SETTING(FlightProgram5Button);
              CHECK_TRUE_FALSE_SETTING(FlightProgram6Button);
              CHECK_TRUE_FALSE_SETTING(FlightProgram7Button);
              CHECK_TRUE_FALSE_SETTING(FlightProgram8Button);
              if (!maximumSquish)
                {
                  CHECK_TRUE_FALSE_SETTING(AeaCustomButton);
                }
              CHECK_TRUE_FALSE_SETTING(DeviceAgcCheckbox);
              CHECK_TRUE_FALSE_SETTING(DeviceDskyCheckbox);
              CHECK_TRUE_FALSE_SETTING(DeviceAcaCheckbox);
              CHECK_TRUE_FALSE_SETTING(DeviceTelemetryCheckbox);
              CHECK_TRUE_FALSE_SETTING(DeviceAeaCheckbox);
              CHECK_TRUE_FALSE_SETTING(DeviceDedaCheckbox);
              CHECK_TRUE_FALSE_SETTING(DeviceCpumonCheckbox);
              CHECK_TRUE_FALSE_SETTING(DeviceImuCheckbox);
              CHECK_TRUE_FALSE_SETTING(DeviceDiscoutCheckbox);
              CHECK_TRUE_FALSE_SETTING(DeviceCrewinCheckbox);
              CHECK_TRUE_FALSE_SETTING(DeviceSysinCheckbox);
              CHECK_TRUE_FALSE_SETTING(DevicePropulsionCheckbox);
              CHECK_TRUE_FALSE_SETTING(StartupWipeButton);
              CHECK_TRUE_FALSE_SETTING(StartupPreserveButton);
              CHECK_TRUE_FALSE_SETTING(StartupResumeButton);
              CHECK_TRUE_FALSE_SETTING(CustomResumeButton);
              CHECK_TRUE_FALSE_SETTING(DskyFullButton);
              CHECK_TRUE_FALSE_SETTING(DskyHalfButton);
              CHECK_TRUE_FALSE_SETTING(DskyLiteButton);
              CHECK_TRUE_FALSE_SETTING(DskyNavButton);
              CHECK_TRUE_FALSE_SETTING(AgcDebugNormalButton);
              CHECK_TRUE_FALSE_SETTING(AgcDebugMonitorButton);
              CHECK_TRUE_FALSE_SETTING(DedaFullButton);
              CHECK_TRUE_FALSE_SETTING(DedaHalfButton);
              CHECK_TRUE_FALSE_SETTING(AeaDebugNormalButton);
              CHECK_TRUE_FALSE_SETTING(AeaDebugMonitorButton);
              CHECK_TRUE_FALSE_SETTING(TelemetryResizable);
              CHECK_TRUE_FALSE_SETTING(TelemetryRetro);
            }
          Fin.Close();
          if (DropDown)
            ConvertRadio();
          EnforceConsistency();
        }
      else
        {
          wxMessageBox(
              wxT("Cannot open VirtualAGC.cfg.\nDefault configuration used!"),
              wxT("Warning"), wxOK | wxICON_HAND);
        }
    }
}

// Writes a configuration file of all the settings.

#define WRITE_TRUE_FALSE_SETTING(name) \
  Fout.Write (wxT (#name)); \
  Fout.Write (wxT ("=")); \
  if (name->GetValue ()) \
    Fout.Write (wxT ("true")); \
  else \
    Fout.Write (wxT ("false")); \
  Fout.Write (wxT ("\n"))

#define WRITE_TEXT_SETTING(name) \
  Fout.Write (wxT (#name)); \
  Fout.Write (wxT ("=")); \
  Fout.Write (name->GetValue ()); \
  Fout.Write (wxT ("\n"))

void
VirtualAGC::WriteConfigurationFile(void)
{
  wxFile Fout;
  if (Fout.Create(wxT("VirtualAGC.cfg"), true))
    {
      WRITE_TEXT_SETTING(AgcCustomFilename);
      if (!maximumSquish)
        {
          WRITE_TEXT_SETTING(AeaCustomFilename);
        }
      WRITE_TEXT_SETTING(CoreFilename);
      int mission;
      if (DropDown)
        ConvertDropDown();
      for (mission = ID_FIRSTMISSION; mission < ID_AGCCUSTOMBUTTON; mission++)
        {
          WRITE_TRUE_FALSE_SETTING(
              missionRadioButtons[mission - ID_FIRSTMISSION]);
        }
      WRITE_TRUE_FALSE_SETTING(AgcCustomButton);
      WRITE_TRUE_FALSE_SETTING(FlightProgram4Button);
      WRITE_TRUE_FALSE_SETTING(FlightProgram5Button);
      WRITE_TRUE_FALSE_SETTING(FlightProgram6Button);
      WRITE_TRUE_FALSE_SETTING(FlightProgram7Button);
      WRITE_TRUE_FALSE_SETTING(FlightProgram8Button);
      if (!maximumSquish)
        {
          WRITE_TRUE_FALSE_SETTING(AeaCustomButton);
        }
      WRITE_TRUE_FALSE_SETTING(DeviceAgcCheckbox);
      WRITE_TRUE_FALSE_SETTING(DeviceDskyCheckbox);
      WRITE_TRUE_FALSE_SETTING(DeviceAcaCheckbox);
      WRITE_TRUE_FALSE_SETTING(DeviceTelemetryCheckbox);
      WRITE_TRUE_FALSE_SETTING(DeviceAeaCheckbox);
      WRITE_TRUE_FALSE_SETTING(DeviceDedaCheckbox);
      WRITE_TRUE_FALSE_SETTING(DeviceCpumonCheckbox);
      WRITE_TRUE_FALSE_SETTING(DeviceImuCheckbox);
      WRITE_TRUE_FALSE_SETTING(DeviceDiscoutCheckbox);
      WRITE_TRUE_FALSE_SETTING(DeviceCrewinCheckbox);
      WRITE_TRUE_FALSE_SETTING(DeviceSysinCheckbox);
      WRITE_TRUE_FALSE_SETTING(DevicePropulsionCheckbox);
      WRITE_TRUE_FALSE_SETTING(StartupWipeButton);
      WRITE_TRUE_FALSE_SETTING(StartupPreserveButton);
      WRITE_TRUE_FALSE_SETTING(StartupResumeButton);
      WRITE_TRUE_FALSE_SETTING(CustomResumeButton);
      WRITE_TRUE_FALSE_SETTING(DskyFullButton);
      WRITE_TRUE_FALSE_SETTING(DskyHalfButton);
      WRITE_TRUE_FALSE_SETTING(DskyLiteButton);
      WRITE_TRUE_FALSE_SETTING(DskyNavButton);
      WRITE_TRUE_FALSE_SETTING(AgcDebugNormalButton);
      WRITE_TRUE_FALSE_SETTING(AgcDebugMonitorButton);
      WRITE_TRUE_FALSE_SETTING(DedaFullButton);
      WRITE_TRUE_FALSE_SETTING(DedaHalfButton);
      WRITE_TRUE_FALSE_SETTING(AeaDebugNormalButton);
      WRITE_TRUE_FALSE_SETTING(AeaDebugMonitorButton);
      WRITE_TRUE_FALSE_SETTING(TelemetryResizable);
      WRITE_TRUE_FALSE_SETTING(TelemetryRetro);
      Fout.Close();
    }
  else
    {
      wxMessageBox(
          wxT("Cannot create VirtualAGC.cfg.\nConfiguration not be saved!"),
          wxT("Warning"), wxOK | wxICON_HAND);
    }
}

// This function forms and outputs the file lm_simulator.ini.  Returns true
// on success, false on failure.
bool
VirtualAGC::FormLmsIni(void)
{
  //bool IsLM = true;
  wxFile Fout;
  if (Fout.Create(wxT("LM_Simulator/lm_simulator.ini"), true))
    {
      if (missionRadioButtons[ID_LUMINARY99BUTTON - ID_FIRSTMISSION]->GetValue())
        {
          // These are the numbers for LM 7 --- must correct or fix.
          Fout.Write(wxT("LM_Weight_Ascent_KG           4670.0\n"
              L"LM_Weight_Descent_KG          10694.0\n"
              L"Ascent_Propellant_Mass_KG     2353.0\n"
              L"Ascent_Thrust_N               15600.0\n"
              L"Ascent_Specific_Impulse_MS    3050.0\n"
              L"Descent_Propellant_Mass_KG    8355.0\n"
              L"Descent_Propulsion_Min_N      4560.0\n"
              L"Descent_Propulsion_Max_N      45040.0\n"
              L"Descent_Specific_Impulse_MS   3050.0\n"
              L"RCS_Propellant_Mass_KG        287.0\n"
              L"RCS_Thrust_N                  445.0\n"
              L"RCS_Specific_Impulse_MS       2840.0\n"));
        }
      else if (missionRadioButtons[ID_LUMINARY131BUTTON - ID_FIRSTMISSION]->GetValue())
        {
          // These are the numbers for LM 7 --- must correct or fix.
          Fout.Write(wxT("LM_Weight_Ascent_KG           4670.0\n"
              L"LM_Weight_Descent_KG          10694.0\n"
              L"Ascent_Propellant_Mass_KG     2353.0\n"
              L"Ascent_Thrust_N               15600.0\n"
              L"Ascent_Specific_Impulse_MS    3050.0\n"
              L"Descent_Propellant_Mass_KG    8355.0\n"
              L"Descent_Propulsion_Min_N      4560.0\n"
              L"Descent_Propulsion_Max_N      45040.0\n"
              L"Descent_Specific_Impulse_MS   3050.0\n"
              L"RCS_Propellant_Mass_KG        287.0\n"
              L"RCS_Thrust_N                  445.0\n"
              L"RCS_Specific_Impulse_MS       2840.0\n"));
        }
      else if (AgcCustomButton->GetValue()) // Pretend generalized LM
        {
          // These are the numbers for LM 7 --- must correct or fix.
          Fout.Write(wxT("LM_Weight_Ascent_KG           4670.0\n"
              L"LM_Weight_Descent_KG          10694.0\n"
              L"Ascent_Propellant_Mass_KG     2353.0\n"
              L"Ascent_Thrust_N               15600.0\n"
              L"Ascent_Specific_Impulse_MS    3050.0\n"
              L"Descent_Propellant_Mass_KG    8355.0\n"
              L"Descent_Propulsion_Min_N      4560.0\n"
              L"Descent_Propulsion_Max_N      45040.0\n"
              L"Descent_Specific_Impulse_MS   3050.0\n"
              L"RCS_Propellant_Mass_KG        287.0\n"
              L"RCS_Thrust_N                  445.0\n"
              L"RCS_Specific_Impulse_MS       2840.0\n"));
        }
      else // CM
        {
          //IsLM = false;
          // These numbers are meaningless for the CM, but LM_Simulator
          // isn't designed for the CM (though nevertheless useful) and
          // will abort if some values aren't present.
          Fout.Write(wxT("LM_Weight_Ascent_KG           4670.0\n"
              L"LM_Weight_Descent_KG          10694.0\n"
              L"Ascent_Propellant_Mass_KG     2353.0\n"
              L"Ascent_Thrust_N               15600.0\n"
              L"Ascent_Specific_Impulse_MS    3050.0\n"
              L"Descent_Propellant_Mass_KG    8355.0\n"
              L"Descent_Propulsion_Min_N      4560.0\n"
              L"Descent_Propulsion_Max_N      45040.0\n"
              L"Descent_Specific_Impulse_MS   3050.0\n"
              L"RCS_Propellant_Mass_KG        287.0\n"
              L"RCS_Thrust_N                  445.0\n"
              L"RCS_Specific_Impulse_MS       2840.0\n"));
        }
#ifdef WIN32
      Fout.Write (wxT ("Operating_System Windows\n"));
#else
      Fout.Write(wxT("Operating_System Linux\n"));
#endif
      Fout.Write(wxT("ServerIP         localhost\n"));
      if (IsLM)
        Fout.Write(wxT("ServerSocket     19801\n"));
      else
        Fout.Write(wxT("ServerSocket     19701\n"));
      if (DeviceDskyCheckbox->GetValue() && DskyLiteButton->GetValue())
        Fout.Write(wxT("dsky             on\n"));
      else
        Fout.Write(wxT("dsky             off\n"));
      if (DeviceDiscoutCheckbox->GetValue())
        Fout.Write(wxT("output           on\n"));
      else
        Fout.Write(wxT("output           off\n"));
      if (DeviceSysinCheckbox->GetValue())
        Fout.Write(wxT("system           on\n"));
      else
        Fout.Write(wxT("system           off\n"));
      if (DeviceCrewinCheckbox->GetValue())
        Fout.Write(wxT("crew             on\n"));
      else
        Fout.Write(wxT("crew             off\n"));
      if (DeviceImuCheckbox->GetValue())
        Fout.Write(wxT("imu              on\n"));
      else
        Fout.Write(wxT("imu              off\n"));
      if (DevicePropulsionCheckbox->GetValue())
        Fout.Write(wxT("attitude         on\n"));
      else
        Fout.Write(wxT("attitude         off\n"));
      Fout.Write(wxT("FDAI_Update_Rate 10\n"));
      Fout.Close();
    }
  else
    {
      wxMessageBox(
          wxT(
              "Cannot create lm_simulator.ini.\nLM-Simulator won\'t run properly."),
          wxT("Warning"), wxOK | wxICON_HAND);
      return (false);
    }
  return (true);
}

// Forms command lines for other programs we want to execute for the
// simulation.  Returns true on success, false on failure.
bool
VirtualAGC::FormCommands(void)
{
  int DebugMode = 0;
  wxString CoreCmd;
  if (block1)
    CoreCmd = wxT("--rope=");
  else
    CoreCmd = wxT("--core=");
  CmSim = LmSim = AeaSim = false;

#ifdef __APPLE__
  wxString localExecutableDirectory = wxT ("../MacOS");
#else
  wxString localExecutableDirectory = wxT("..") + PathDelimiter + wxT("bin");
#endif
  wxString CoreBin, CMorLM, Port, TelemetrySwitches, DirCmd;

  FunkyYaACA = false;

  if (DeviceAgcCheckbox->GetValue())
    {
      if (block1)
        {
          yaAGC = localExecutableDirectory + PathDelimiter + wxT("yaAGCb1");
        }
      else
        {
          yaAGC = localExecutableDirectory + PathDelimiter + wxT("yaAGC");
          if (AgcDebugMonitorButton->GetValue())
            {
#ifdef ONNO_STYLE
              CoreCmd = wxT("--exec=");
#endif
              yaAGC += wxT(" --debug");
              DirCmd = wxT(" --directory=");
              DebugMode = 1;
            }
        }
    }
  else
    yaAGC = wxT("");
  if (DeviceDskyCheckbox->GetValue())
    {
      yaDSKY = localExecutableDirectory + PathDelimiter;
#ifdef __APPLE__
      if (block1)
      yaDSKY += wxT ("yaDSKYb1.app/Contents/MacOS/");
      else
      yaDSKY += wxT ("yaDSKY2.app/Contents/MacOS/");
#endif
      if (block1)
        {
          yaDSKY += wxT("yaDSKYb1 --images=images-yaDSKYb1" + PathDelimiter);
          if (DskyNavButton->GetValue())
            yaDSKY += wxT(" --nav-bay");
        }
      else
        {
#ifdef YADSKY2
          yaDSKY += wxT("yaDSKY2");
#else
          yaDSKY += wxT("yaDSKY --relative-pixmaps");
#endif
          //if (DeviceTelemetryCheckbox->GetValue ())
          //  yaDSKY += wxT (" --test-downlink");
          if (DskyHalfButton->GetValue())
            yaDSKY += wxT(" --half-size");
        }
    }
  else
    yaDSKY = wxT("");
  if (DeviceAcaCheckbox->GetValue())
    {
      // By default we want to use yaACA3 here.  However, if someone
      // has gone to the trouble to configure yaACA2 or yaACA --- in
      // which case yaACA-0.cfg or yaACA2-0.cfg will exist --- we use
      // it instead.
      if (wxFileExists(wxT("yaACA2-0.cfg")))
        yaACA = localExecutableDirectory + PathDelimiter + wxT("yaACA2");
      else if (wxFileExists(wxT("yaACA-0.cfg")))
        {
#ifdef WIN32
          FunkyYaACA = true;
#endif
          yaACA = localExecutableDirectory + PathDelimiter + wxT("yaACA");
        }
      else
        yaACA = localExecutableDirectory + PathDelimiter + wxT("yaACA3");
    }
  else
    yaACA = wxT("");
  if (DeviceTelemetryCheckbox->GetValue())
    {
      yaTelemetry = localExecutableDirectory + PathDelimiter;
#ifdef __APPLE__
      yaTelemetry += wxT ("yaTelemetry.app/Contents/MacOS/");
#endif
      yaTelemetry += wxT("yaTelemetry");
      if (TelemetryResizable->GetValue())
        yaTelemetry += wxT(" --simple");
    }
  else
    yaTelemetry = wxT("");
  if (DeviceAeaCheckbox->GetValue())
    {
      AeaSim = true;
      yaAGS = localExecutableDirectory + PathDelimiter + wxT("yaAGS");
      if (AeaDebugMonitorButton->GetValue())
        yaAGS += wxT(" --debug");
      if (FlightProgram4Button->GetValue())
        CoreBin = wxT("source/FP4/FP4.bin");
      else if (FlightProgram5Button->GetValue())
        CoreBin = wxT("source/FP5/FP5.bin");
      else if (FlightProgram6Button->GetValue())
        CoreBin = wxT("source/FP6/FP6.bin");
      else if (FlightProgram7Button->GetValue())
        CoreBin = wxT("source/FP7/FP7.bin");
      else if (FlightProgram8Button->GetValue())
        CoreBin = wxT("source/FP8/FP8.bin");
      else if (!maximumSquish && AeaCustomButton->GetValue())
        CoreBin = AeaCustomFilename->GetValue();
      else
        // This can't happen.
        return (false);
      yaAGS += wxT(" --core=\"") + CoreBin + wxT("\"");
    }
  else
    yaAGS = wxT("");
  if (!yaAGS.IsSameAs(wxT("")) && AeaDebugMonitorButton->GetValue())
    {
      wxString Symtab = CoreBin + wxT(".symtab");
      if (wxFileExists(Symtab))
        yaAGS += wxT(" --symtab=\"") + Symtab + wxT("\"");
    }
  if (DeviceDedaCheckbox->GetValue())
    {
      yaDEDA = localExecutableDirectory + PathDelimiter;
#ifdef YADEDA2
#ifdef __APPLE__
      yaDEDA += wxT ("yaDEDA2.app/Contents/MacOS/");
#endif
      yaDEDA += wxT("yaDEDA2");
#else
#ifdef __APPLE__
      yaDEDA += wxT ("yaDEDA.app/Contents/MacOS/");
#endif
      yaDEDA += wxT("yaDEDA --relative-pixmaps");
#endif
      if (DedaHalfButton->GetValue())
        yaDEDA += wxT(" --half-size");
    }
  else
    yaDEDA = wxT("");
  if (DeviceCpumonCheckbox->GetValue())
    LM_Simulator = wxT("wish VirtualAGC.tcl --cfg=lm_simulator.ini");
  else
    LM_Simulator = wxT("");
  wxString basename;
  int mission;
  const char *dskyIni;
  for (mission = ID_FIRSTMISSION; mission < ID_AGCCUSTOMBUTTON; mission++)
    if (missionRadioButtons[mission - ID_FIRSTMISSION]->GetValue())
      {
        basename = wxString::FromUTF8(
            missionConstants[mission - ID_FIRSTMISSION].basename);
        if (missionConstants[mission - ID_FIRSTMISSION].Block1 == BLOCK1)
          Port = wxT("19671");
        else if (missionConstants[mission - ID_FIRSTMISSION].lm == LM)
          Port = wxT("19797");
        else
          Port = wxT("19697");
        CMorLM = wxString::FromUTF8(
            (missionConstants[mission - ID_FIRSTMISSION].lm == LM) ?
                "LM" : "CM");
        dskyIni = missionConstants[mission - ID_FIRSTMISSION].dsky;
        break;
      }
  if (mission >= ID_AGCCUSTOMBUTTON)
    {
      if (AgcCustomButton->GetValue())
        {
          CoreBin = AgcCustomFilename->GetValue();
          if (DebugMode)
            DirCmd += wxT("\"") + CoreBin.BeforeLast(PATH_DELIMITER)
                + wxT("\"");
          CMorLM = wxT("LM");
          Port = wxT("19797");
        }
      else
        {
          /* This can't happen */
          return (false);
        }
    }
  wxString CorePad, CoreLst;
  if (!AgcCustomButton->GetValue())
    {
      CoreBin = wxT("source/") + basename + wxT("/") + basename + wxT(".bin");
      CorePad = wxT("source/") + basename + wxT("/") + basename + wxT(".pad");
      CoreLst = wxT("source/") + basename + wxT("/") + basename + wxT(".lst");
      if (DebugMode)
        DirCmd += wxT("source/" + basename);
    }
  if (mission == ID_SUNBURST37BUTTON)
    {
      yaAGC += wxT(" --initialize-sunburst-37");
    }
  if (CMorLM.IsSameAs(wxT("CM")))
    {
      CmSim = true;
      TelemetrySwitches = wxT(" --port=19700 --spacecraft=CM");
    }
  else
    {
      LmSim = true;
      TelemetrySwitches = wxT(" --port=19800 --spacecraft=LM");
    }
  if (!yaTelemetry.IsSameAs(wxT("")))
    yaTelemetry += TelemetrySwitches;
  if (!yaAGC.IsSameAs(wxT("")))
    {
      yaAGC += wxT(" ") + CoreCmd + wxT("\"") + CoreBin + wxT("\" --port=")
          + Port + DirCmd;
      if (block1)
        {
          yaAGC += wxT(" --run --pads=\"") + CorePad + wxT("\" --listing=\"")
              + CoreLst + wxT("\"");
        }
      else
        {
          yaAGC += wxT(" --cfg=")
              + wxString::FromUTF8(dskyIni) /*CMorLM + wxT(".ini")*/;
        }
      if (StartupResumeButton->GetValue()
          && wxFileExists(CMorLM + wxT(".core")))
        yaAGC += wxT(" --resume=") + CMorLM + wxT(".core");
      if (CustomResumeButton->GetValue()
          && wxFileExists(CoreFilename->GetValue()))
        yaAGC += wxT(" --resume=\"") + CoreFilename->GetValue() + wxT("\"");
      if (AgcDebugMonitorButton->GetValue())
        {
          wxString Symtab = CoreBin + wxT(".symtab");
          if (wxFileExists(Symtab))
            yaAGC += wxT(" --symtab=\"") + Symtab + wxT("\"");
        }
    }
  if (!yaDSKY.IsSameAs(wxT("")))
    {
      if (block1)
        yaDSKY += wxT(" --port=") + Port;
      else
        yaDSKY += wxT(" --cfg=") + wxString::FromUTF8(dskyIni) /* CMorLM + wxT(".ini") */
        + wxT(" --port=") + Port;
    }
  return (true);
}

// This function takes the various command-lines which have already
// been created as wxStrings and creates shell scripts or batch files
// based on them

#if defined (WIN32)

bool
VirtualAGC::FormScript (void)
  {
    wxFile Fout;
    if (Fout.Create (wxT ("simulate.bat"), true))
      {
        if (!yaAGC.IsSameAs (wxT ("")))
          {
            if (AgcDebugMonitorButton->GetValue ())
            Fout.Write (wxT ("cmd /C start /WAIT "));
            Fout.Write (yaAGC + wxT (EOL));
          }
        if (!yaAGS.IsSameAs (wxT ("")))
          {
            if (AeaDebugMonitorButton->GetValue ())
            Fout.Write (wxT ("cmd /C start /WAIT "));
            Fout.Write (yaAGS + wxT (EOL));
          }
        if (!yaDEDA.IsSameAs (wxT ("")))
        Fout.Write (yaDEDA + wxT (EOL));
        if (!yaDSKY.IsSameAs (wxT ("")))
        Fout.Write (yaDSKY + wxT (EOL));
        if (/*!FunkyYaACA &&*/!yaACA.IsSameAs (wxT ("")))
        Fout.Write (yaACA + wxT (EOL));
        if (!yaTelemetry.IsSameAs (wxT ("")))
        Fout.Write (yaTelemetry + wxT (EOL));
        if (!LM_Simulator.IsSameAs (wxT ("")))
        Fout.Write (LM_Simulator + wxT (EOL));
        Fout.Close ();
      }
    else
      {
        wxMessageBox (wxT ("Cannot create simulation script, simulate.bat."), wxT ("Warning"), wxOK | wxICON_HAND);
        return (false);
      }
    if (Fout.Create (wxT ("simulate2.bat"), true))
      {
        if (StartupWipeButton->GetValue ())
          {
            Fout.Write (wxT ("del LM.core" EOL));
            Fout.Write (wxT ("del CM.core" EOL));
          }
        //if (FunkyYaACA)
        //  Fout.Write (wxT ("start cmd /C ") + yaACA + wxT (EOL));
        Fout.Write (wxT ("..\\bin\\WinAGC.exe <simulate.bat" EOL));
        Fout.Close ();
      }
    else
      {
        wxMessageBox (wxT ("Cannot create shutdown manager, simulate.bat."), wxT ("Warning"), wxOK | wxICON_HAND);
        return (false);
      }
    return (true);
  }

#else // Presumably Linux or Mac OS X
bool
VirtualAGC::FormScript(void)
{
#ifdef __APPLE__
  wxString localExecutableDirectory = wxT ("../MacOS");
#else
  wxString localExecutableDirectory = wxT("..") + PathDelimiter + wxT("bin");
#endif
  wxFile Fout;
  if (Fout.Create(wxT("simulate"), true, wxS_DEFAULT | wxS_IXUSR | wxS_IXGRP))
    {
      Fout.Write(wxT("#!/bin/sh\n"));
#ifdef __APPLE__
      Fout.Write (wxT ("PATH=$PATH:/usr/X11/bin\n"));
#endif
      Fout.Write(wxT("PIDS=\n"));
      if (StartupWipeButton->GetValue())
        {
          Fout.Write(wxT("rm LM.core\n"));
          Fout.Write(wxT("rm CM.core\n"));
        }

      // Run DSKY
      if (DeviceDskyCheckbox->GetValue())
        {
          if (!DskyLiteButton->GetValue())
            {
              //if (DeviceTelemetryCheckbox->GetValue ())
              // Fout.Write (wxT ("xterm -geometry 80x43 -e "));
              Fout.Write(yaDSKY + wxT(" &\n"));
              Fout.Write(wxT("PIDS=\"$! ${PIDS}\"\n"));
            }
        }

      // Run DEDA
      if (DeviceDedaCheckbox->GetValue())
        {
          Fout.Write(yaDEDA + wxT(" &\n"));
          Fout.Write(wxT("PIDS=\"$! ${PIDS}\"\n"));
        }

      // Run AEA
      if (DeviceAeaCheckbox->GetValue())
        {
          if (AeaDebugMonitorButton->GetValue())
            {
#ifdef __APPLE__
              Fout.Write (wxT ("../MacOS/Terminator.app/Contents/MacOS/Terminator --working-directory \""));
              Fout.Write (ResourceDirectory);
              Fout.Write (wxT ("\" \'"));
              Fout.Write (yaAGS + wxT ("\' &\n"));
#else
              Fout.Write(wxT("xterm -sb -geometry 112x40 -e "));
              Fout.Write(yaAGS + wxT(" &\n"));
#endif
            }
          else
            Fout.Write(yaAGS + wxT(" &\n"));
          Fout.Write(wxT("PIDS=\"$! ${PIDS}\"\n"));
        }

      // Run ACA
      if (DeviceAcaCheckbox->GetValue())
        {
          Fout.Write(yaACA + wxT(" &\n"));
          Fout.Write(wxT("PIDS=\"$! ${PIDS}\"\n"));
        }

      // Run AGC
      if (DeviceAgcCheckbox->GetValue())
        {
          if (AgcDebugMonitorButton->GetValue())
            {
#ifdef __APPLE__
              Fout.Write (wxT ("../MacOS/Terminator.app/Contents/MacOS/Terminator --working-directory \""));
              Fout.Write (ResourceDirectory);
              Fout.Write (wxT ("\" \'"));
              Fout.Write (yaAGC + wxT ("\' &\n"));
#else
              Fout.Write(wxT("xterm -sb -geometry 112x40 -e "));
              Fout.Write(yaAGC + wxT(" &\n"));
#endif
            }
          else
            Fout.Write(yaAGC + wxT(" &\n"));
          Fout.Write(wxT("PIDS=\"$! ${PIDS}\"\n"));
        }

      // Run LM-Simulator
      if (DeviceCpumonCheckbox->GetValue())
        {
          // The one-second delay here is because I've noted intermittent
          // instances in which LM_Simulator fails to connect.  I believe
          // this may be because it tries to connect before yaAGC is
          // running (perhaps because of the time it takes to load symbol
          // tables or something).
          Fout.Write(LM_Simulator + wxT(" &\n"));
          Fout.Write(wxT("PIDS=\"$! ${PIDS}\"\n"));
        }

      // Run yaTelemetry
      if (DeviceTelemetryCheckbox->GetValue())
        {
          Fout.Write(yaTelemetry + wxT(" &\n"));
          Fout.Write(wxT("PIDS=\"$! ${PIDS}\"\n"));
        }

      Fout.Write(wxT("export PIDS\n"));
      Fout.Write(localExecutableDirectory + wxT("/SimStop\n"));
#ifdef __APPLE__
      // In Mac OS X, starting LM_Simulator starts a child process which
      // actually runs the program, and when SimStop eventually kills the
      // parent it won't kill the child process.  So here's a little bit
      // of stuff that accomplishes that.  It actually kills all child
      // processes of the current shell, which includes a lot of
      // processes that SimStop killed off already.
      Fout.Write (wxT ("kill `ps -o pid -g $$ | tail -n +2`\n"));
#endif
      Fout.Close();
    }
  else
    {
      wxMessageBox(wxT("Cannot create simulation script."), wxT("Warning"),
          wxOK | wxICON_HAND);
      return (false);
    }
  return (true);
}

#endif

Simulation::Simulation(wxWindow* parent, int id, const wxString& title,
    const wxPoint& pos, const wxSize& size, long style) :
    wxFrame(parent, id, title, pos, size,
        wxCAPTION | wxMINIMIZE_BOX | wxSTAY_ON_TOP | wxSYSTEM_MENU)
{
  DetailPanel = new wxPanel(this, wxID_ANY, wxDefaultPosition, wxDefaultSize,
      wxNO_BORDER | wxTAB_TRAVERSAL);
  ScriptPanel = new wxPanel(DetailPanel, wxID_ANY, wxDefaultPosition,
      wxDefaultSize, wxSUNKEN_BORDER | wxTAB_TRAVERSAL);
  UplinkPanel = new wxPanel(this, wxID_ANY, wxDefaultPosition, wxDefaultSize,
      wxNO_BORDER | wxTAB_TRAVERSAL);
  sizer_32_staticbox = new wxStaticBox(ScriptPanel, -1,
      wxT("To do the same thing from a command line ..."));
  sizer_33_staticbox = new wxStaticBox(UplinkPanel, -1,
      wxT("Digital uplink status"));
  if (!maximumSquish)
    PatchBitmap = new wxStaticBitmap(this, wxID_ANY,
        wxBitmap(wxT("ApolloPatch2.png"), wxBITMAP_TYPE_ANY));
  SimulationLabel = new wxStaticText(this, ID_SIMULATIONLABEL,
      wxT("Apollo 13 Lunar Module\nsimulation in progress!"), wxDefaultPosition,
      wxDefaultSize);
  MoreButton = new wxButton(this, ID_MORE, wxT("More"));
  LessButton = new wxButton(this, ID_LESS, wxT("Less"));
  UploadButton = new wxButton(this, ID_UPLOAD, wxT("Uplink"));
  UplinkText = new wxTextCtrl(UplinkPanel, wxID_ANY, wxEmptyString,
      wxDefaultPosition, wxDefaultSize,
      wxTE_MULTILINE | wxTE_READONLY | wxHSCROLL | wxTE_RICH);
  ScriptText = new wxTextCtrl(ScriptPanel, wxID_ANY, wxEmptyString,
      wxDefaultPosition, wxDefaultSize,
      wxTE_MULTILINE | wxTE_READONLY | wxHSCROLL | wxTE_RICH);

  set_properties();
  do_layout();

  Timer = new TimerClass;
}
BEGIN_EVENT_TABLE(Simulation, wxFrame) //
EVT_BUTTON(ID_MORE, Simulation::MoreEvent)
EVT_BUTTON(ID_LESS, Simulation::LessEvent)
EVT_BUTTON(ID_UPLOAD, Simulation::UploadEvent)
END_EVENT_TABLE();

// Various callbacks for events.

void
Simulation::MoreEvent(wxCommandEvent &event)
{
  Show(false);
  LessButton->Enable();
  MoreButton->Disable();
  DetailPanel->Show();
  InvalidateBestSize();
  Layout();
  Fit();
  Show(true);
}

void
Simulation::LessEvent(wxCommandEvent &event)
{
  Show(false);
  LessButton->Disable();
  MoreButton->Enable();
  DetailPanel->Hide();
  InvalidateBestSize();
  Layout();
  Fit();
  Show(true);
}

void
Simulation::UploadEvent(wxCommandEvent &event)
{
  static wxString LastDirectory = wxT("");
  if (Timer->IsRunning())
    {
      Timer->Stop();
      for (; OnShellout < NumShellouts; OnShellout++)
        free(UplinkShellouts[OnShellout]);
      OnShellout = NumShellouts = 0;
      UploadButton->SetLabel(wxT("Uplink"));
      UploadButton->SetToolTip(
          wxT(
              "Click this button to use the digital-uplink to send data to the AGC or AEA from a pre-created script of commands.  This allows setting the AGC or AEA to a known configuration suitable for your purposes, much in the same way mission control could have done this in real missions."));
      MoreButton->Enable(MoreEnabled);
      LessButton->Enable(LessEnabled);
      UplinkPanel->Hide();
      DetailPanel->Show(DetailShown);
      Hide();
      InvalidateBestSize();
      Layout();
      Fit();
      Refresh();
      Update();
      Show();
      return;
    }
  wxString Dummy;
  if (LastDirectory.IsEmpty())
    {
      LastDirectory = MainFrame->ResourceDirectory;
      LastDirectory += PATH_DELIMITER;
      LastDirectory += wxT("scenarios");
    }
  wxFileDialog *Dialog = new wxFileDialog(this,
      wxT("Choose script for digital upload to AGC or AEA"), LastDirectory,
      wxT(""), wxT("Script files (*.txt)|*.txt"),
      wxFD_DEFAULT_STYLE | wxFD_FILE_MUST_EXIST | wxFD_CHANGE_DIR);
  if (wxID_OK == Dialog->ShowModal())
    {
      LastDirectory = Dialog->GetDirectory();
      wxString Pathname = Dialog->GetPath();
      Upload(Pathname);
    }
  Done: delete Dialog;
  wxSetWorkingDirectory(MainFrame->ResourceDirectory);
}

void
Simulation::set_properties()
{
  SetTitle(wxT("Simulation status"));
  wxIcon _icon;
  _icon.CopyFromBitmap(wxBitmap(wxT("ApolloPatch2.png"), wxBITMAP_TYPE_ANY));
  SetIcon(_icon);
  SetBackgroundColour(wxColour(255, 255, 255));
  SimulationLabel->SetFont(wxFont(14, wxFONTFAMILY_DEFAULT, wxFONTSTYLE_NORMAL, wxFONTWEIGHT_BOLD, 0, wxT("")));
  MoreButton->SetToolTip(
      wxT(
          "Click this button to display the script which is being run.  This could be helpful to know if you'd like to run a custom simulation that VirtualAGC can't handle, such as having 2 DSKYs, ganging multiple PCs interconnected via ethernet, etc."));
  LessButton->SetToolTip(wxT("Click this button to hide the script data."));
  LessButton->Enable(false);
  UploadButton->SetToolTip(
      wxT(
          "Click this button to use the digital-uplink to send data to the AGC or AEA from a pre-created script of commands.  This allows setting the AGC or AEA to a known configuration suitable for your purposes, much in the same way mission control could have done this in real missions."));
  UplinkText->SetMinSize(wxSize(480, 480));
  UplinkText->SetBackgroundColour(wxColour(230, 230, 230));
  UplinkText->SetFont(wxFont(10, wxFONTFAMILY_MODERN, wxFONTSTYLE_NORMAL, wxFONTWEIGHT_NORMAL, 0, wxT("")));
  UplinkPanel->SetBackgroundColour(wxColour(255, 255, 255));
  UplinkPanel->Hide();
  ScriptText->SetMinSize(wxSize(480, 480));
  ScriptText->SetBackgroundColour(wxColour(230, 230, 230));
  ScriptText->SetFont(wxFont(8, wxFONTFAMILY_MODERN, wxFONTSTYLE_NORMAL, wxFONTWEIGHT_NORMAL, 0, wxT("")));
  DetailPanel->SetBackgroundColour(wxColour(255, 255, 255));
}

void
Simulation::do_layout()
{
  wxBoxSizer* sizer_25 = new wxBoxSizer(wxVERTICAL);
  wxBoxSizer* sizer_17 = new wxBoxSizer(wxHORIZONTAL);
  wxBoxSizer* sizer_31 = new wxBoxSizer(wxVERTICAL);
  wxStaticBoxSizer* sizer_32 = new wxStaticBoxSizer(sizer_32_staticbox,
      wxHORIZONTAL);
  wxStaticBoxSizer* sizer_33 = new wxStaticBoxSizer(sizer_33_staticbox,
      wxHORIZONTAL);
  wxBoxSizer* sizer_16 = new wxBoxSizer(wxHORIZONTAL);
  wxBoxSizer* sizer_27 = new wxBoxSizer(wxHORIZONTAL);
  wxBoxSizer* sizer_26 = new wxBoxSizer(wxHORIZONTAL);
  if (!maximumSquish)
    sizer_25->Add(20, 10, 0,
        wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
  if (!maximumSquish)
    {
      sizer_26->Add(20, 20, 1,
          wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
      sizer_26->Add(PatchBitmap, 0,
          wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
      sizer_26->Add(20, 20, 1,
          wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
    }
  sizer_25->Add(sizer_26, 0, wxEXPAND, 0);
  if (!maximumSquish)
    sizer_25->Add(20, 20, 0,
        wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
  if (!maximumSquish)
    sizer_27->Add(20, 20, 0,
        wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
  sizer_27->Add(SimulationLabel, 1, wxEXPAND, 0);
  if (!maximumSquish)
    sizer_27->Add(20, 20, 0,
        wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
  sizer_25->Add(sizer_27, 0, wxEXPAND, 0);
  if (!maximumSquish)
    sizer_25->Add(20, 20, 0,
        wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
  if (!maximumSquish)
    sizer_16->Add(20, 20, 1, 0, 0);
  sizer_16->Add(MoreButton, 0,
      wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
  sizer_16->Add(50, 20, 0, 0, 0);
  sizer_16->Add(LessButton, 0,
      wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL, 0);
  if (!maximumSquish)
    sizer_16->Add(50, 20, 0, 0, 0);
  sizer_16->Add(UploadButton, 0, 0, 0);
  if (!maximumSquish)
    sizer_16->Add(20, 20, 1, 0, 0);
  sizer_25->Add(sizer_16, 0, wxEXPAND, 0);
  if (!maximumSquish)
    sizer_25->Add(20, 10, 0, 0, 0);
  sizer_33->Add(UplinkText, 1, wxEXPAND, 0);
  UplinkPanel->SetSizer(sizer_33);
  sizer_25->Add(UplinkPanel, 1, wxEXPAND, 0);
  if (!maximumSquish)
    sizer_17->Add(10, 20, 0, 0, 0);
  sizer_32->Add(ScriptText, 1, wxEXPAND, 0);
  ScriptPanel->SetSizer(sizer_32);
  sizer_31->Add(ScriptPanel, 0, wxEXPAND, 0);
  if (!maximumSquish)
    sizer_31->Add(20, 10, 0, 0, 0);
  sizer_17->Add(sizer_31, 1, wxEXPAND, 0);
  if (!maximumSquish)
    sizer_17->Add(10, 20, 0, 0, 0);
  DetailPanel->SetSizer(sizer_17);
  sizer_25->Add(DetailPanel, 1, wxEXPAND, 0);
  SetSizer(sizer_25);
  sizer_25->Fit(this);
  Layout();
}

void
Simulation::WriteSimulationLabel(wxString Label)
{
  SimulationLabel->SetLabel(Label + wxT("\nAGC simulation running!"));
  SimulationLabel->Fit();
  Layout();
}

void
Simulation::Upload(wxString &Filename)
{
  wxTextFile File;
  UnitType = UT_UNKNOWN;
  if (File.Open(Filename))
    {
      // Format of the file:  The type of the file (CM, LM, or AEA) is determined by the first
      // character of the file, which is C, L, or A.  In the remainder of the file:
      //	1. All characters between a '#' and an end-of-line are ignored.
      //	2. All characters between an '!' and the end-of-line are treated as a shell
      //	   command.  An example of how to use something like this would be if you
      //	   were making a tutorial on using the AGC, or a museum display, and wished
      //           to display something or play an audio clip at various points in the uplink.
      //	   What you can do is limited only by the software available on the computer
      //	   running the simulation.
      //	3. The following characters are translated in an obvious way to keystrokes:
      //	   a. For LM or CM AGC:
      //		VNECPKR+-0123456789
      //	        Z (which doesn't correspond to anything on the DSKY keypad) is the
      //		uplink-error-clear code.
      //	   b. For AEA:
      //		CREH+-0123456789
      //	4. A space (' ') is interpreted as an extra 0.5-second delay.
      //	5. All other characters are ignored.
      // Note that on transmission to the simulated CPU, a delay of 0.2 seconds is automatically
      // inserted after each keycode.  Z,Y,X can be used to insert extra delay.
      int i, j, Len, LineCount = File.GetLineCount(), Keycode;
      wxString Line;
      wxChar c;
      OnShellout = NumShellouts = 0;
      NumKeycodes = 0;
      for (i = 0; i < LineCount; i++)
        {
          Line = File.GetLine(i);
          //Line = Line.MakeUpper ();
          Len = Line.Len();
          if (i == 0 && Len == 0)
            {
              wxMessageBox(wxT("Ill-formed script"), wxT("Error"),
                  wxICON_ERROR);
              goto Done;
            }
          for (j = 0; j < Len; j++)
            {
              c = Line.GetChar(j);
              if (i == 0 && j == 0)
                {
                  if (toupper(c) == 'C')
                    {
                      UnitType = UT_CM;
                      if (!MainFrame->CmSim)
                        {
                          wxMessageBox(wxT("There is no CM simulation running"),
                              wxT("Error"), wxICON_ERROR);
                          goto Done;
                        }
                    }
                  else if (toupper(c) == 'L')
                    {
                      UnitType = UT_LM;
                      if (!MainFrame->LmSim)
                        {
                          wxMessageBox(wxT("There is no LM simulation running"),
                              wxT("Error"), wxICON_ERROR);
                          goto Done;
                        }
                    }
                  else if (toupper(c) == 'A')
                    {
                      UnitType = UT_AEA;
                      if (!MainFrame->AeaSim)
                        {
                          wxMessageBox(
                              wxT("There is no AEA simulation running"),
                              wxT("Error"), wxICON_ERROR);
                          goto Done;
                        }
                    }
                  else
                    {
                      wxMessageBox(wxT("Ill-formed script"), wxT("Error"),
                          wxICON_ERROR);
                      goto Done;
                    }
                }
              else if (c == '#') // Comment.
                break;
              else if (UnitType == UT_AEA)
                {
                  // Not sure what to do with this stuff yet.  Ignore for now.
                  File.Close();
                  wxMessageBox(wxT("AEA uploads not implemented yet"),
                      wxT("Error"), wxICON_ERROR);
                  goto Done;
                }
              else // UnitType == UT_CM || UnitType == UT_LM
                {
                  switch (toupper(c))
                    {
                  case 'Z':
                    Keycode = 254;
                    break;
                  case '!':
                    if (NumShellouts < MAX_SHELLOUTS)
                      {
                        char *s;
                        UplinkShellouts[NumShellouts] = (char *) malloc(
                            Len - j);
                        for (j++, s = UplinkShellouts[NumShellouts]; j < Len;
                            j++)
                          *s++ = Line.GetChar(j);
                        *s = 0;
                        NumShellouts++;
                        Keycode = 253;
                      }
                    else
                      Keycode = -1;
                    break;
                  case 'V':
                    Keycode = 17;
                    break;
                  case 'N':
                    Keycode = 31;
                    break;
                  case '+':
                    Keycode = 26;
                    break;
                  case '-':
                    Keycode = 27;
                    break;
                  case '0':
                    Keycode = 16;
                    break;
                  case '7':
                    Keycode = 7;
                    break;
                  case '4':
                    Keycode = 4;
                    break;
                  case '1':
                    Keycode = 1;
                    break;
                  case '8':
                    Keycode = 8;
                    break;
                  case '5':
                    Keycode = 5;
                    break;
                  case '3':
                    Keycode = 3;
                    break;
                  case '2':
                    Keycode = 2;
                    break;
                  case '9':
                    Keycode = 9;
                    break;
                  case '6':
                    Keycode = 6;
                    break;
                  case 'C':
                    Keycode = 30;
                    break;
                  case 'K':
                    Keycode = 25;
                    break;
                  case 'E':
                    Keycode = 28;
                    break;
                  case 'R':
                    Keycode = 18;
                    break;
                  case ' ':
                    Keycode = 255;
                    break;
                  case 'P': // The "PRO" key has no keycode, and falls through.
                  default:
                    Keycode = -1;
                    break;
                    }
                  if (Keycode >= 0)
                    {
                      if (NumKeycodes < sizeof(Keycodes))
                        Keycodes[NumKeycodes++] = Keycode;
                    }
                }
            }
        }
      File.Close();
      if (NumKeycodes == sizeof(Keycodes))
        {
          wxMessageBox(wxT("Too much data in script"), wxT("Error"),
              wxICON_ERROR);
          goto Done;
        }
      // The Keycodes[] array, consisting of NumKeycodes bytes, can now be transmitted to
      // the simulated CPU.  All we really need to worry about, though, is getting the
      // background timer started that's going to handle it.
      if (UnitType == UT_AEA)
        Timer->Portnum = 19906;
      else if (UnitType == UT_LM)
        Timer->Portnum = 19806;
      else
        // UnitType == UT_CM
        Timer->Portnum = 19706;
      MoreEnabled = MoreButton->IsEnabled();
      MoreButton->Disable();
      LessEnabled = LessButton->IsEnabled();
      LessButton->Disable();
      DetailShown = DetailPanel->IsShown();
      DetailPanel->Hide();
      UplinkPanel->Show(true);
      UplinkText->Clear();
      if (UnitType == UT_AEA)
        UplinkText->AppendText(wxT("Digital uplink to AEA starting ..."));
      else if (UnitType == UT_CM)
        UplinkText->AppendText(wxT("Digital uplink to CM starting ..."));
      else if (UnitType == UT_LM)
        UplinkText->AppendText(wxT("Digital uplink to LM starting ..."));
      UploadButton->SetLabel(wxT("Cancel"));
      UploadButton->SetToolTip(
          wxT(
              "Click this button to halt the digital-uplink in progress.  Only the uplink and not the simulation itself will terminate."));
      Hide();
      InvalidateBestSize();
      Layout();
      Fit();
      Refresh();
      Update();
      Show();
      Timer->KeycodeIndex = 0;
      Timer->Start(100);
    }
  else
    wxMessageBox(wxT("Could not open file"), wxT("Error"), wxICON_ERROR);
  Done: ;
}

// This is the event handler for the background timer.  The background timer
// executes about every 100 ms. and services the socket interface.  Upon
// receiving downlink data, it updates the output screen.

void
TimerClass::Notify()
{
  static int ServerSocket = -1;
  static unsigned char Packet[4];
  static int PacketSize = 0;
  static int Delaying = 0;
  static char hostname[] = "localhost";
  int i;
  unsigned char c;
  // Try to connect to the server (yaAGC) if not already connected.
  if (ServerSocket == -1)
    {
      ServerSocket = CallSocket(hostname, Portnum);
      if (ServerSocket != -1)
        {
          printf("Digital uplink is connected.\n");
          MainFrame->SimulationWindow->UplinkText->AppendText(
              wxT("\nConnected to simulated CPU."));
        }
    }
  if (ServerSocket != -1)
    {
      // Service incoming data.
      for (;;)
        {
          i = recv(ServerSocket, (char *) &c, 1, MSG_NOSIGNAL);
          if (i == -1)
            {
              // The conditions i==-1,errno==0 or 9 occur only on Win32,
              // and I'm not sure exactly what they corresponds to---but
              // empirically I find that ignoring them makes no difference
              // to the operation of the program.
              if (errno == EAGAIN || errno == 0 || errno == 9)
                i = 0;
              else
                {
                  //wxString Dummy;
                  //Dummy << wxT ("yaTelemetry reports server error ") << errno;
                  //wxMessageBox (Dummy);
                  printf("Digital uplink reports server error %d\n", errno);
                  MainFrame->SimulationWindow->UplinkText->AppendText(
                      wxT("\nConnection failure."));
                  close(ServerSocket);
                  ServerSocket = -1;
                  break;
                }
            }
          if (i == 0)
            break;
          if (0 == (0xc0 & c))
            PacketSize = 0;
          if (PacketSize != 0 || (0xc0 & c) == 0)
            {
              Packet[PacketSize++] = c;
              if (PacketSize >= 4)
                {
                  PacketSize = 0;
                  // If I wanted to do something with incoming data, I'd do it here!

                }
            }
        }
      // Handle outgoing data. This function is called every 100 ms.  Delaying holds
      // a count for the delay between outputting packets.
      if (Delaying > 0)
        Delaying--;
      else if (KeycodeIndex < MainFrame->SimulationWindow->NumKeycodes)
        {
          static int LastKeycode = -2;
          int Keycode = MainFrame->SimulationWindow->Keycodes[KeycodeIndex++];
          if (Keycode == 255)
            {
              Delaying = 5;
              if (LastKeycode != Keycode)
                MainFrame->SimulationWindow->UplinkText->AppendText(wxT("\n."));
              else
                MainFrame->SimulationWindow->UplinkText->AppendText(wxT(" ."));
            }
          else
            {
              switch (Keycode)
                {
              case 253: // Shellout.
                if (OnShellout < NumShellouts)
                  {
                    //printf ("Shellout: %s\n", UplinkShellouts[OnShellout]);
                    wxExecute(wxString::FromAscii(UplinkShellouts[OnShellout]));
                    free(UplinkShellouts[OnShellout]);
                    OnShellout++;
                  }
                Keycode = -1;
                break;
              case 254:
                MainFrame->SimulationWindow->UplinkText->AppendText(
                    wxT("\nATTN"));
                break;
              case 16:
                MainFrame->SimulationWindow->UplinkText->AppendText(wxT(" 0"));
                break;
              case 1:
                MainFrame->SimulationWindow->UplinkText->AppendText(wxT(" 1"));
                break;
              case 2:
                MainFrame->SimulationWindow->UplinkText->AppendText(wxT(" 2"));
                break;
              case 3:
                MainFrame->SimulationWindow->UplinkText->AppendText(wxT(" 3"));
                break;
              case 4:
                MainFrame->SimulationWindow->UplinkText->AppendText(wxT(" 4"));
                break;
              case 5:
                MainFrame->SimulationWindow->UplinkText->AppendText(wxT(" 5"));
                break;
              case 6:
                MainFrame->SimulationWindow->UplinkText->AppendText(wxT(" 6"));
                break;
              case 7:
                MainFrame->SimulationWindow->UplinkText->AppendText(wxT(" 7"));
                break;
              case 8:
                MainFrame->SimulationWindow->UplinkText->AppendText(wxT(" 8"));
                break;
              case 9:
                MainFrame->SimulationWindow->UplinkText->AppendText(wxT(" 9"));
                break;
              case 17:
                MainFrame->SimulationWindow->UplinkText->AppendText(
                    wxT("\nVERB"));
                break;
              case 31:
                MainFrame->SimulationWindow->UplinkText->AppendText(
                    wxT(" NOUN"));
                break;
              case 26:
                MainFrame->SimulationWindow->UplinkText->AppendText(wxT(" +"));
                break;
              case 27:
                MainFrame->SimulationWindow->UplinkText->AppendText(wxT(" -"));
                break;
              case 30:
                MainFrame->SimulationWindow->UplinkText->AppendText(
                    wxT("\nCLR"));
                break;
              case 25:
                MainFrame->SimulationWindow->UplinkText->AppendText(
                    wxT("\nKEY-REL"));
                break;
              case 28:
                MainFrame->SimulationWindow->UplinkText->AppendText(
                    wxT(" ENTR"));
                break;
              case 18:
                MainFrame->SimulationWindow->UplinkText->AppendText(
                    wxT("\nRST"));
                break;
              default:
                Keycode = -1;
                break;
                }
              if (Keycode != -1)
                {
                  if (Keycode == 254)
                    Keycode = 0;
                  else
                    {
                      Keycode &= 037;
                      Keycode |= ((Keycode << 10) | ((Keycode ^ 037) << 5));
                    }
                  FormIoPacket(0173, Keycode, Packet);
                  i = send(ServerSocket, (const char *) Packet, 4,
                  MSG_NOSIGNAL);
                  if (i == SOCKET_ERROR && SOCKET_BROKEN)
                    {
                      close(ServerSocket);
                      ServerSocket = -1;
                      MainFrame->SimulationWindow->UplinkText->AppendText(
                          wxT("\nUplink failure."));
                      wxMessageBox(wxT("Server error on digital uplink"),
                          wxT("Error"), wxICON_ERROR);
                      goto Error;
                    }
                  Delaying = 2;
                }
            }
          LastKeycode = Keycode;
        }
      else // All done!
        {
          Error: MainFrame->SimulationWindow->UploadButton->SetLabel(
              wxT("Uplink"));
          MainFrame->SimulationWindow->UploadButton->SetToolTip(
              wxT(
                  "Click this button to use the digital-uplink to send data to the AGC or AEA from a pre-created script of commands.  This allows setting the AGC or AEA to a known configuration suitable for your purposes, much in the same way mission control could have done this in real missions."));
          MainFrame->SimulationWindow->MoreButton->Enable(
              MainFrame->SimulationWindow->MoreEnabled);
          MainFrame->SimulationWindow->LessButton->Enable(
              MainFrame->SimulationWindow->LessEnabled);
          MainFrame->SimulationWindow->UplinkPanel->Hide();
          MainFrame->SimulationWindow->DetailPanel->Show(
              MainFrame->SimulationWindow->DetailShown);
          MainFrame->SimulationWindow->Hide();
          MainFrame->SimulationWindow->InvalidateBestSize();
          MainFrame->SimulationWindow->Layout();
          MainFrame->SimulationWindow->Fit();
          MainFrame->SimulationWindow->Refresh();
          MainFrame->SimulationWindow->Update();
          MainFrame->SimulationWindow->Show();
          Stop();
        }
    }
}

