#!/usr/bin/env python3
'''
License:    The author, Ron Burkey, declares this program to be in the Public
            Domain, and may be used or modified in any way desired.
Filename:   g.py
Purpose:    This is part of the port of the original XPL source code for 
            HAL/S-FC into Python.  It contains what might be thought of as the
            global variables accessible by all other source files.
Contact:    The Virtual AGC Project (www.ibiblio.org/apollo).
History:    2023-08-24 RSB  Began importing global variables from ##DRIVER.xpl.
            2023-08-25 RSB  Finished initial port.
            2023-09-07 RSB  Split off xplBuiltins.py to contain just the 
                            functions.
'''

import sys
from xplBuiltins import OUTPUT, BYTE
import HALINCL.COMMON as h

#------------------------------------------------------------------------------
# Command-line parameters.

# The Shuttle flight code was originally encoded in EBCDIC.  We are assuming it
# has been translated into 7-bit ASCII, since EBCDIC has gone the way of the 
# dodo long since.  All characters in the HAL/S character set exist both in 
# EBCDIC and in ASCII, except the logical-NOT symbol and the U.S. cent symbol,
# so translating those into ASCII is not straightforward.  Our assumption is
# that logical-NOT has been translated as '~' and cent has been translated 
# as '`'. 

SANITY_CHECK = False
pfs = True
debug3 = False
scan1 = False
intersection = False

# Apparently comes from MONITOR.bal, normally, but we don't have that and so
# must hard-code something that's big enough but not too big.
FREELIMIT = 8 * 1024 * 1024  # That's the maximum IBM 360 memory size.
FREEPOINT = 0  # Must be somewhat smaller than FREELIMIT

# The following are the default values of the compiler options for the original
# compiler, some of which I may allow to be altered by command-line parameters.
# The names correspond to the documentation, as prefixed by 'p'.
pOPTIONS_CODE = 0
pCON = ["NOADDRS", "NODECK", "NODUMP", "NOHALMAT", "NOHIGHOPT", "LFXI",
        "NOLIST", "NOLISTING2", "NOLSTALL", "MICROCODE", "NOPARSE",
        "NOREGOPT", "SCAL", "NOSDL", "NOSREF", "NOSRN", "NOTABDMP",
        "TABLES", "NOTABLST", "NOTEMPLATE", "NOVARSYM", "ZCON"]
pPRO = [""] * len(pCON)
# (See the comments for TYPE2_TYPE in INITIALI.py.)  Since we have no 
# operating system to communicate the names and values of type 2 options to
# us from the JCL, pDESC and pVALS provide those for us.
pDESC = ["TITLE", "LINECT", "PAGES", "SYMBOLS", "MACROSIZE", "LITSTRING",
         "COMPUNIT", "XREFSIZE", "CARDTYPE", "LABELSIZE", "DSR", "BLOCKSUM",
         "MFID"]
bfsDESC = pDESC.index("MFID")
pVALS = ["", "59", "2500", "200", "500", "2500", "0", "2000", "", "1200",
         "1", "400", "0"]

for parm in sys.argv[1:]:
    if parm.startswith("--hal="):
        pass  # This case is handled in xplBuiltins.py.
    elif parm == "--no-syn":
        pass  # This case is handled by SYNTHESI.py.
    elif parm.startswith("--dummy="):
        pass
    elif parm == '--bfs':
        pfs = False
        index = pDESC.index("MFID")
        pDESC[bfsDESC] = "OLDTPL"
        pVALS[bfsDESC] = 0
    elif parm == '--sanity':
        SANITY_CHECK = True
    elif parm == '--debug3':
        debug3 = True  # Makes changes to CONTROL[] below.
    elif parm == "--scan1":
        scan1 = True
    elif parm == "--intersection":
        intersection = True
    elif parm in pCON or ("NO" + parm) in pCON or \
            (parm.startswith("NO") and parm[2:] in pCON):
        # Type 1 option:
        if parm in pCON:
            index = pCON.index(parm)
        elif parm.startswith("NO") and parm[2:] in pCON:
            index = pCON.index(parm[2:])
        else:
            index = pCON.index("NO" + parm)
        pCON[index] = parm
    elif "=" in parm and parm.split("=")[0] in (pDESC + ["MFID", "OLDTPL"]):
        # Type 2 option:
        fields = parm.split("=")
        if fields[0] in ["MFID", "OLDTPL"]:
            index = bfsDESC
        else:
            index = pDESC.index(fields[0])
        value = fields[1]
        if index not in [0, 8]:  # I.e., not TITLE or CARDTYPE
            pVALS[index] = int(value)
        else:
            pVALS[index] = value
    elif parm == '--help':
        print('This is PASS 1 of HAL/S-FC as ported to Python 3.')
        print('Usage:')
        print('\tHAL-S-FC.py [OPTIONS] [<SOURCE.hal]')
        print('The allowed "modern" OPTIONS are:')
        print('--hal=SOURCE.hal Choose HAL/S source-code file (default stdin).')
        print('--pfs            Compile for PFS (PASS).')
        print('--bfs            Compile for BFS. (Default is --pfs.)')
        print('--debug3         Activate HAL/S-FC parser messages.')
        print('--no-syn         Do not synthesize HALMAT.')
        print('--sanity         Perform a sanity check on the Python port.')
        print('--help           Show this explanation.')
        print('--dummy=X        This option is ignored.')
        print('--scan1          Use SCAN1 rather than SCAN')
        print('--intersection   Helps test overlap between globals/locals.')
        print('Additionally, many of the options from the original JCL')
        print('PARMLISTs can be used.  For "type 1" options (i.e., those')
        print('without values), you can use either the form XXXX or NOXXXX,')
        print('where XXXX is among these: ADDRS, DECK, DUMP, HALMAT, HIGHOPT,')
        print('LFXI, LIST, LISTING2, LSTALL, MICROCODE, PARSE, REGOPT, SCAL,')
        print('SDL, SREF, SRN, TABDMP, TABLES, TABLST, TEMPLATE, VARSYM, ZCON.')
        print('If neither XXXX nor NOXXXX is specified, the following defaults')
        print('are used:')
        chunks = 5
        chunk = (len(pCON) + chunks - 1) // chunks
        for i in range(0, len(pCON), chunk):
            for j in range(i, min(i + chunk, len(pCON))):
                print("    %-10s" % pCON[j], end="")
            print()
        print('As for "type 2" options, i.e. those with values, they can be')
        print('specified in the form XXXX=value, where the defaults for PFS')
        print('are the following:')
        chunks = 4
        chunk = (len(pDESC) + chunks - 1) // chunks
        for i in range(0, len(pDESC), chunk):
            for j in range(i, min(i + chunk, len(pDESC))):
                s = "%s=%s" % (pDESC[j], str(pVALS[j]))
                print("    %-14s" % s, end="")
            print()
        print("For --bfs, OLDTPL=None is the default and MFID is unavailable.")
        print("TITLE and CARDTYPE are strings; all others are integers.")
        print('While these original options are syntactically allowed on the')
        print('command line, this does not necessarily imply that they are all')
        print('applicable to PHASE 1, nor that they are fully ported, nor that')
        print('this comprises the complete list of all original options.')
        sys.exit(0)
    else:
        print("Unrecognized command-line options:", parm)
        print("Use --help for more information.")
        sys.exit(1)

'''
The following code relates to determining and printing out the compiler
options which have been supplied originally by JCL, but for us by 
command-line options.  The available options are described by the "HAL/S-FC
User's Manual" (chapter 5), while the organization of these in IBM 
System/360 system memory (as we would need it to work with the following
code) is described in the "HAL/S-FC and HAL/S-360 Compiler System Program 
Description" (IR-182-1) around p. 696. In neither source is there an 
explanation of how the options specifically relate to the bit-flags in
the 32-bit variable OPTIONS_WORD, so whatever I know about that has been
gleaned from looking at how the source code processes that word.
    Flag          Pass         Keyword (abbreviation)
    ----          ----         ----------------------
    0x40000000    1            REGOPT (R) for BFS
    0x10000000    3            DEBUG
    0x08000000    3            DLIST
    0x04000000    1            MICROCODE (MC)
    0x02000000    1            REGOPT (R) for PFS
    0x01000000    ?            STATISTICS
    0x00800000    1            SDL (NONE)
    0x00400000    4            DECK (D)
    0x00200000    1            LFXI (NONE)
    0x00100000    1            ADDRS (A)
    0x00080000    1            SRN (NONE)
    0x00040000    1            HALMAT (HM)
    0x00020000    1            CODE_LISTING_REQUESTED
    0x00010000    1            PARTIAL_PARSE
    0x00008000    3,4          SDF_SUMMARY, TABLST (TL)
    0x00004000    1            EXTRA_LISTING
    0x00002000    1            SREF (SR)
    0x00001000    3,4          TABDMP (TBD)
    0x00000800    1            SIMULATING
    0x00000400    1            Z_LINKAGE ... perhaps ZCON (Z)
    0x00000200    ?            TRACE
    0x00000080    3            HIGHOPT (HO)
    0x00000040    1,2,4        NO_VM_OPT, ?, BRIEF
    0x00000020    4            ALL
    0x00000010    1            TEMPLATE (TP)
    0x00000008    2,3          TRACE
    0x00000004    1            LIST (L)
    0x00000002    1            LISTING2 (L2)
    ?                          DUMP (DP)
    ?                          LSTALL (LA)
    ?                          SCAL (SC) for BFS only
    ?                          TABLES (TBL)
    ?                          VARSYM (VS)
'''

if pfs:
    regoptFlag = 0x02000000
    scalFlag = None
else:
    regoptFlag = 0x40000000
    scalFlag = None
parmFlags = {
    "REGOPT": regoptFlag,
    "DEBUG": 0x10000000,
    "DLIST": 0x08000000,
    "MICROCODE": 0x04000000,
    "STATISTICS": 0x01000000,
    "SDL": 0x00800000,
    "DECK": 0x00400000,
    "LXFI": 0x00200000,
    "ADDRS": 0x00100000,
    "SRN": 0x00080000,
    "HALMAT": 0x00040000,
    "CODE_LISTING_REQUESTED": 0x00020000,
    "PARSE": 0x00010000,
    "TABLST": 0x00008000,
    "SDF_SUMMARY": 0x00008000,
    "EXTRA_LISTING": 0x00004000,
    "SREF": 0x00004000,
    "TABDMP": 0x00001000,
    "SIMULATING": 0x00000800,
    "ZCON": 0x00000400,
    "TRACE": 0x00000200,
    "HIGHOPT": 0x00000080,
    "NO_VM_OPT": 0x00000040,
    "BRIEF": 0x00000040,
    "LSTALL": 0x00000020,
    "TEMPLATE": 0x00000010,
    "TRACE": 0x00000008,
    "LIST": 0x00000004,
    "LISTING2": 0x00000002,
    "DUMP": None,  # TBD
    "LSTALL": None,  # TBD
    "SCAL": None,  # TBD for BFS, none for PFS
    "TABLES": None,  # TBD
    "VARSYM": None  # TBD
    }

PARM_FIELD = ""


def fixParm(option):
    global pOPTIONS_CODE, pCON, PARM_FIELD
    if option not in parmFlags:
        return
    if option in sys.argv[1:]:
        NO = False
        parm = option[:]
    elif ("NO" + option) in sys.argv[1:]:
        NO = True
        parm = "NO" + option
    else:
        return
    mask = parmFlags[option]
    if mask == None:
        return
    if option in pCON:
        index = pCON.index(option)
        pOPTIONS_CODE |= mask
    elif ("NO" + option) in pCON:
        index = pCON.index("NO" + option)
        pOPTIONS_CODE &= ~mask
    else:
        return
    pCON[index] = parm
    if len(PARM_FIELD) == 0:
        PARM_FIELD = parm
    else:
        PARM_FIELD = PARM_FIELD + "," + parm
    if NO:
        pOPTIONS_CODE &= ~mask
    else:
        pOPTIONS_CODE |= mask


for parm in parmFlags:
    fixParm(parm)

#------------------------------------------------------------------------------
# Here's some stuff intended to functionally replace some of XPL's 'implicitly
# declared' functions and variables while retaining roughly the same syntax.

# Creation data/time of this port of the compiler.  They'll have to be manually 
# maintained.  They correspond to the supposed implicit variables DATE and 
# TIME when the compiler itself was compiled, and of course it never was 
# compiled!  I suppose I could fetch the file timestamp, but then there's more
# than one file comprising the compiler, so which one would I choose?
DATE_OF_GENERATION = 123239
TIME_OF_GENERATION = 0

#------------------------------------------------------------------------------
# Definitions originally found in ##DRIVER, or at least related to them.

# THESE ARE LALR PARSING TABLES
MAXRp = 441  # MAX READ #
MAXLp = 666  # MAX LOOK #
MAXPp = 810  # MAX PUSH #
MAXSp = 1263  # MAX STATE #
NT = 142
NSY = 311
VOCAB = (
    '.<(+|&$*);^-/,>:#@=||**ATBYDOGOIFINONORTO END_OF_FILEANDBINBITCA' + \
    'TDECENDFORHEXNOTOCTOFFSETTABCALLCASECHARELSEEXITFILELINELOCKNAME' + \
    'NULLPAGEREADSENDSKIPTASKTHENTRUEWAITAFTERARRAYCLOSEDENSEERROREVE' + \
    'NTEVERYFALSERESETRIGIDUNTILWHILEWRITE<TEXT>ACCESSASSIGNCANCEL',
    'COLUMNDOUBLEEQUATEIGNOREMATRIXNONHALREMOTEREPEATRETURNSCALARSIGN' + \
    'ALSINGLESTATICSUBBITSYSTEMUPDATEVECTOR<EMPTY><LABEL><LEVEL>ALIGN' + \
    'EDBOOLEANCOMPOOLDECLAREINITIALINTEGERLATCHEDPROGRAMREADALLREPLAC' + \
    'E<BIT ID>CONSTANTEXTERNALFUNCTIONPRIORITYSCHEDULE<CHAR ID>',
    'AUTOMATICCHARACTERDEPENDENTEXCLUSIVEPROCEDUREREENTRANTSTRUCTURET' + \
    'EMPORARYTERMINATE<ARITH ID><BIT FUNC><EVENT ID><CHAR FUNC><ARITH' + \
    ' FUNC><IDENTIFIER><CHAR STRING><STRUCT FUNC><% MACRO NAME><STRUC' + \
    'TURE ID><SIMPLE NUMBER><COMPOUND NUMBER><NO ARG BIT FUNC>',
    '<STRUCT TEMPLATE><NO ARG CHAR FUNC><NO ARG ARITH FUNC><NO ARG ST' + \
    'RUCT FUNC><$><**><=1><IF><OR><AND><CAT><NOT><SUB><TERM><RADIX><A' + \
    'SSIGN><ENDING><FACTOR><NUMBER><PREFIX><REPEAT><TIMING><BIT CAT><' + \
    'BIT EXP><BIT VAR><CLOSING><FOR KEY><NAME ID><PRIMARY><PRODUCT>',
    '<SUB EXP><ARG LIST><BIT PRIM><BIT SPEC><CALL KEY><CHAR EXP><CHAR' + \
    ' VAR><CONSTANT><FILE EXP><FOR LIST><LIST EXP><NAME EXP><NAME KEY' + \
    '><NAME VAR><READ ARG><READ KEY><REL PRIM><STOPPING><SUB HEAD><VA' + \
    'RIABLE><WAIT KEY><ARITH EXP><ARITH VAR><BIT CONST><CALL LIST>',
    '<CASE ELSE><CHAR PRIM><CHAR SPEC><EVENT VAR><FILE HEAD><IF CLAUS' + \
    'E><LABEL VAR><ON CLAUSE><ON PHRASE><PREC SPEC><QUALIFIER><STATEM' + \
    'ENT><SUB START><SUBSCRIPT><TRUE PART><TYPE SPEC><WHILE KEY><WRIT' + \
    'E ARG><WRITE KEY><ARITH CONV><ARITH SPEC><ARRAY HEAD>',
    '<ARRAY SPEC><ASSIGNMENT><ATTRIBUTES><BIT FACTOR><BLOCK BODY><BLO' + \
    'CK STMT><CHAR CONST><COMPARISON><DCL LIST ,><EXPRESSION><IO CONT' + \
    'ROL><SCALE HEAD><SQ DQ NAME><SUBBIT KEY><TERMINATOR><% MACRO ARG' + \
    '><ASSIGN LIST><COMPILATION><DECLARATION><PRE PRIMARY>',
    '<QUAL STRUCT><READ PHRASE><REPEAT HEAD><STRUCT SPEC><SUBBIT HEAD' + \
    '><% MACRO HEAD><# EXPRESSION><COMPILE LIST><DECLARE BODY><IF STA' + \
    'TEMENT><REPLACE HEAD><REPLACE STMT><SUB RUN HEAD><WHILE CLAUSE><' + \
    'WRITE PHRASE><ANY STATEMENT><BIT FUNC HEAD><BIT QUALIFIER>',
    '<DECLARE GROUP><DO GROUP HEAD><FUNCTION NAME><RELATIONAL OP><SCH' + \
    'EDULE HEAD><SIGNAL CLAUSE><STRUCTURE EXP><STRUCTURE VAR><BIT CON' + \
    'ST HEAD><BIT INLINE DEF><BLOCK STMT TOP><CHAR FUNC HEAD><FUNC ST' + \
    'MT BODY><ITERATION BODY><LABEL EXTERNAL><PARAMETER HEAD>',
    '<PARAMETER LIST><PROC STMT BODY><PROCEDURE NAME><RELATIONAL EXP>' + \
    '<STRUCTURE STMT><TEMPORARY STMT><TERMINATE LIST><ARITH FUNC HEAD' + \
    '><BASIC STATEMENT><BLOCK STMT HEAD><CHAR INLINE DEF><DECLARE ELE' + \
    'MENT><INIT/CONST HEAD><MINOR ATTR LIST><MINOR ATTRIBUTE>',
    '<OTHER STATEMENT><SCHEDULE PHRASE><ARITH INLINE DEF><BLOCK DEFIN' + \
    'ITION><CALL ASSIGN LIST><DECLARATION LIST><LABEL DEFINITION><LIT' + \
    'ERAL EXP OR *><SCHEDULE CONTROL><STRUC INLINE DEF><STRUCT FUNC H' + \
    'EAD><STRUCT SPEC BODY><STRUCT SPEC HEAD><STRUCT STMT HEAD>',
    '<STRUCT STMT TAIL><SUB OR QUALIFIER><DECLARE STATEMENT><ITERATIO' + \
    'N CONTROL><MODIFIED BIT FUNC><RELATIONAL FACTOR><REPEATED CONSTA' + \
    'NT><TYPE & MINOR ATTR><MODIFIED CHAR FUNC><NESTED REPEAT HEAD><M' + \
    'ODIFIED ARITH FUNC><MODIFIED STRUCT FUNC><DOUBLY QUAL NAME HEAD>'
    )
if SANITY_CHECK and len(VOCAB) != 11 + 1:
    print('Bad VOCAB', file=sys.stderr)
    sys.exit(1)
    
VOCAB_INDEX = [ 0, 16777216, 16777472, 16777728,
    16777984, 16778240, 16778496, 16778752, 16779008, 16779264, 16779520,
    16779776, 16780032, 16780288, 16780544, 16780800, 16781056, 16781312,
    16781568, 16781824, 33559296, 33559808, 33560320, 33560832, 33561344,
    33561856, 33562368, 33562880, 33563392, 33563904, 33564416, 201337088,
    50345216, 50345984, 50346752, 50347520, 50348288, 50349056, 50349824,
    50350592, 50351360, 50352128, 50352896, 50353664, 50354432, 67132416,
    67133440, 67134464, 67135488, 67136512, 67137536, 67138560, 67139584,
    67140608, 67141632, 67142656, 67143680, 67144704, 67145728, 67146752,
    67147776, 67148800, 67149824, 83928064, 83929344, 83930624, 83931904,
    83933184, 83934464, 83935744, 83937024, 83938304, 83939584, 83940864,
    83942144, 83943424, 100721920, 100723456, 100724992, 100726528, 100663297,
    100664833, 100666369, 100667905, 100669441, 100670977, 100672513,
    100674049, 100675585, 100677121, 100678657, 100680193, 100681729,
    100683265, 100684801, 100686337, 100687873, 117466625, 117468417,
    117470209, 117472001, 117473793, 117475585, 117477377, 117479169,
    117480961, 117482753, 117484545, 117486337, 117488129, 134267137,
    134269185, 134271233, 134273281, 134275329, 134277377, 151056641,
    150994946, 150997250, 150999554, 151001858, 151004162, 151006466,
    151008770, 151011074, 151013378, 167792898, 167795458, 167798018,
    184577794, 201357826, 201360898, 218141186, 218144514, 234925058,
    234928642, 251709442, 285267714, 285272066, 285212675, 301994243,
    318776067, 335558147, 50350595, 67128579, 67129603, 67130627, 67131651,
    83909891, 83911171, 83912451, 83913731, 100692227, 117470979, 134249987,
    134252035, 134254083, 134256131, 134258179, 134260227, 134262275,
    151041539, 151043843, 151046147, 151048451, 151050755, 151053059,
    151055363, 151057667, 150994948, 167774468, 167777028, 167779588,
    167782148, 167784708, 167787268, 167789828, 167792388, 167794948,
    167797508, 167800068, 167802628, 167805188, 167807748, 167810308,
    167812868, 167815428, 167817988, 167820548, 167823108, 184602884,
    184605700, 184608516, 184611332, 184549381, 184552197, 184555013,
    184557829, 184560645, 184563461, 184566277, 184569093, 184571909,
    184574725, 184577541, 184580357, 184583173, 184585989, 184588805,
    184591621, 184594437, 184597253, 184600069, 201380101, 201383173,
    201386245, 201326598, 201329670, 201332742, 201335814, 201338886,
    201341958, 201345030, 201348102, 201351174, 201354246, 201357318,
    201360390, 201363462, 201366534, 201369606, 218149894, 218153222,
    218156550, 218159878, 218163206, 218103815, 218107143, 218110471,
    218113799, 218117127, 234897671, 234901255, 234904839, 234908423,
    234912007, 234915591, 234919175, 234922759, 234926343, 234929927,
    251710727, 251714567, 251718407, 251658248, 251662088, 251665928,
    251669768, 251673608, 251677448, 251681288, 251685128, 268466184,
    268470280, 268474376, 268478472, 268482568, 268486664, 268490760,
    268494856, 268435465, 268439561, 268443657, 268447753, 268451849,
    268455945, 268460041, 285241353, 285245705, 285250057, 285254409,
    285258761, 285263113, 285267465, 285271817, 285212682, 285217034,
    301998602, 302003210, 302007818, 302012426, 302017034, 302021642,
    302026250, 302030858, 302035466, 302040074, 302044682, 302049290,
    301989899, 301994507, 318776331, 318781195, 318786059, 318790923,
    318795787, 318800651, 335582731, 335587851, 352370187, 369152779,
    385935627]
if SANITY_CHECK and len(VOCAB_INDEX) != NSY + 1:
    print('Bad VOCAB_INDEX', file=sys.stderr)
    sys.exit(1)

V_INDEX = (1, 20, 31, 45, 63, 76, 97, 110,
    116, 126, 129, 130, 132, 134, 136, 137, 137, 140, 141, 142, 143)
if SANITY_CHECK and len(V_INDEX) != 20 + 1:
    print('Bad V_INDEX', file=sys.stderr)
    sys.exit(1)

Pp = 453  # # OF PRODUCTIONS

STATE_NAME = (0, 0, 1, 1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3
    , 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 8, 8, 9, 9
    , 9, 9, 9, 10, 12, 12, 12, 12, 13, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 15
    , 16, 16, 17, 18, 18, 18, 18, 19, 19, 22, 22, 23, 23, 24, 25, 27, 28, 28, 30, 30, 30, 30, 30
    , 32, 34, 34, 37, 38, 38, 42, 43, 44, 45, 46, 47, 49, 50, 51, 52, 54, 55, 56, 57, 58, 63, 64
    , 65, 67, 67, 67, 69, 71, 73, 75, 80, 82, 84, 85, 87, 88, 90, 95, 95, 95, 96, 98, 98, 98, 98
    , 98, 99, 103, 104, 108, 109, 110, 111, 112, 113, 113, 113, 113, 113, 113, 113, 114, 114
    , 115, 116, 118, 118, 119, 123, 123, 124, 124, 126, 128, 131, 131, 131, 131, 131, 131
    , 134, 138, 139, 140, 141, 142, 143, 143, 143, 144, 145, 146, 147, 147, 148, 148, 149
    , 149, 149, 150, 150, 150, 150, 153, 153, 154, 154, 154, 155, 156, 157, 157, 157, 157
    , 157, 158, 158, 158, 158, 158, 158, 158, 158, 158, 158, 158, 159, 160, 161, 161, 161
    , 161, 161, 162, 162, 162, 162, 162, 162, 162, 164, 164, 164, 164, 164, 165, 166, 167
    , 168, 169, 170, 172, 173, 174, 174, 174, 174, 174, 177, 177, 178, 180, 181, 181, 182
    , 182, 184, 187, 188, 188, 188, 188, 189, 190, 190, 190, 190, 190, 190, 190, 190, 190
    , 190, 190, 190, 190, 190, 190, 190, 190, 190, 190, 190, 190, 190, 190, 190, 190, 190
    , 190, 190, 190, 190, 190, 190, 190, 190, 190, 190, 190, 191, 193, 193, 193, 193, 193
    , 194, 196, 198, 199, 200, 201, 202, 203, 203, 206, 207, 207, 207, 207, 208, 209, 210
    , 210, 212, 213, 214, 215, 216, 217, 218, 219, 219, 220, 220, 220, 220, 220, 221, 224
    , 225, 225, 225, 227, 227, 228, 229, 230, 231, 234, 235, 236, 236, 237, 238, 239, 240
    , 240, 241, 242, 243, 244, 244, 246, 247, 248, 249, 249, 250, 252, 254, 255, 256, 257
    , 257, 257, 257, 257, 258, 259, 259, 260, 262, 263, 264, 265, 267, 268, 269, 270, 270
    , 272, 273, 273, 273, 273, 276, 277, 278, 279, 280, 282, 283, 283, 283, 286, 287, 289
    , 289, 290, 290, 291, 291, 291, 291, 291, 291, 292, 292, 292, 292, 292, 292, 292, 293
    , 294, 295, 297, 298, 304, 304, 305, 305, 308, 311)
if SANITY_CHECK and len(STATE_NAME) != MAXRp + 1:
    print('Bad STATE_NAME', file=sys.stderr)
    sys.exit(1)

pPRODUCE_NAME = (0, 233, 243, 243, 190, 190, 190
    , 190, 190, 152, 152, 168, 168, 168, 168, 156, 156, 144, 235, 235, 235, 277, 277, 213
    , 213, 213, 213, 167, 235, 167, 167, 167, 167, 285, 285, 285, 205, 205, 251, 251, 278
    , 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278
    , 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278, 278
    , 278, 278, 278, 241, 241, 231, 231, 171, 171, 171, 171, 171, 171, 171, 171, 171, 252
    , 252, 161, 161, 161, 161, 219, 219, 162, 162, 257, 257, 257, 257, 257, 257, 257, 257
    , 223, 223, 223, 223, 223, 304, 304, 273, 273, 185, 185, 185, 195, 195, 195, 195, 195
    , 195, 265, 265, 300, 300, 174, 174, 174, 174, 174, 217, 217, 245, 245, 208, 199, 199
    , 146, 255, 255, 255, 255, 255, 255, 255, 255, 194, 210, 210, 249, 249, 178, 178, 267
    , 267, 302, 302, 165, 165, 155, 155, 155, 202, 201, 201, 259, 259, 259, 177, 198, 173
    , 193, 193, 289, 289, 225, 225, 225, 225, 225, 260, 260, 260, 260, 295, 179, 179, 188
    , 188, 188, 188, 188, 188, 188, 182, 182, 182, 182, 182, 182, 180, 180, 180, 181, 200
    , 309, 303, 307, 310, 261, 191, 175, 163, 197, 236, 236, 158, 158, 240, 229, 207, 207
    , 207, 207, 207, 206, 206, 206, 206, 206, 187, 187, 151, 151, 151, 151, 248, 169, 169
    , 242, 242, 242, 145, 143, 148, 148, 147, 147, 150, 150, 149, 149, 204, 204, 204, 227
    , 227, 253, 153, 153, 153, 153, 262, 262, 192, 192, 192, 192, 192, 222, 222, 226, 226
    , 226, 226, 226, 237, 237, 250, 250, 183, 183, 211, 211, 184, 184, 212, 288, 220, 220
    , 220, 287, 287, 263, 280, 294, 221, 264, 264, 264, 264, 264, 291, 268, 268, 279, 279
    , 279, 279, 279, 279, 279, 279, 279, 256, 272, 266, 266, 266, 271, 271, 271, 270, 269
    , 269, 232, 154, 281, 281, 281, 281, 247, 246, 246, 170, 170, 275, 301, 244, 244, 290
    , 290, 224, 254, 254, 274, 298, 298, 298, 299, 239, 296, 296, 297, 234, 234, 166, 166
    , 218, 218, 218, 216, 216, 216, 216, 216, 215, 215, 306, 306, 306, 209, 209, 209, 209
    , 209, 172, 172, 196, 214, 214, 214, 228, 228, 228, 228, 228, 311, 311, 292, 292, 203
    , 203, 283, 283, 284, 284, 284, 284, 284, 284, 284, 284, 284, 284, 284, 284, 282, 282
    , 282, 305, 305, 305, 305, 305, 238, 308, 308, 176, 176, 176, 176, 157, 157, 164, 164
    , 164, 230, 230, 276, 276, 189, 258, 258, 258, 258, 286, 286, 286, 293, 293, 293, 160
    , 160, 160, 159, 186, 186)
if SANITY_CHECK and len(pPRODUCE_NAME) != Pp + 1:
    print('Bad #PRODUCE_NAME', file=sys.stderr)
    sys.exit(1)

RSIZE = 1319  # READ STATES INFO
LSIZE = 919  # LOOK AHEAD STATES INFO
ASIZE = 819  # APPLY PRODUCTION STATES INFO

READ1 = (0, 95, 98, 135, 19, 3, 4, 12, 84, 89, 96, 99       
      , 105, 113, 130, 135, 136, 137, 99, 3, 4, 11, 12, 28, 33, 34, 36, 39, 40, 41, 42, 47, 61, 70    
      , 84, 89, 93, 96, 99, 105, 113, 118, 127, 129, 130, 132, 135, 136, 137, 131, 99, 136, 53     
      , 54, 93, 135, 18, 18, 18, 3, 84, 89, 96, 99, 105, 113, 130, 135, 136, 137, 9, 10, 10, 78      
      , 132, 10, 10, 48, 123, 44, 51, 53, 55, 58, 80, 93, 135, 3, 4, 11, 12, 28, 33, 34, 36, 39, 40    
      , 41, 42, 44, 47, 51, 53, 54, 55, 58, 61, 70, 80, 84, 89, 93, 96, 99, 105, 113, 118, 127, 129   
      , 130, 132, 133, 135, 136, 137, 87, 99, 131, 18, 19, 99, 99, 18, 81, 91, 18, 33, 36, 39, 41    
      , 81, 91, 50, 76, 10, 38, 46, 73, 74, 30, 67, 3, 11, 28, 33, 34, 36, 39, 40, 41, 42, 61, 70, 93   
      , 113, 127, 135, 98, 43, 71, 90, 3, 98, 124, 135, 3, 11, 28, 33, 34, 36, 39, 40, 41, 42, 61     
      , 70, 93, 113, 119, 127, 135, 67, 135, 3, 3, 10, 98, 3, 3, 3, 9, 3, 3, 67, 3, 3, 98, 3, 3, 112, 3   
      , 3, 10, 98, 3, 4, 10, 11, 12, 28, 33, 34, 36, 39, 40, 41, 42, 47, 53, 54, 61, 70, 84, 89, 93     
      , 96, 99, 105, 113, 118, 127, 129, 130, 132, 133, 135, 136, 137, 114, 3, 16, 10, 10, 10, 9    
      , 34, 52, 59, 64, 66, 68, 72, 77, 81, 84, 85, 86, 89, 91, 92, 96, 100, 101, 104, 105, 106      
      , 107, 111, 113, 117, 118, 121, 131, 139, 3, 3, 131, 3, 131, 10, 34, 81, 84, 89, 91, 96, 101   
      , 105, 118, 139, 34, 101, 10, 81, 84, 89, 91, 96, 105, 118, 139, 30, 135, 3, 3, 10, 131, 3     
      , 131, 53, 3, 16, 52, 66, 72, 77, 85, 86, 92, 100, 104, 106, 111, 117, 9, 14, 30, 19, 3, 10     
      , 12, 3, 99, 135, 136, 3, 3, 99, 135, 136, 3, 4, 11, 12, 28, 33, 34, 36, 39, 40, 41, 42, 47, 53   
      , 54, 61, 70, 84, 89, 93, 96, 99, 105, 113, 118, 127, 129, 130, 132, 133, 135, 136, 137, 3    
      , 4, 12, 47, 84, 89, 96, 99, 105, 113, 118, 129, 130, 132, 135, 136, 137, 3, 28, 33, 34, 36    
      , 39, 41, 42, 61, 70, 93, 113, 127, 135, 3, 28, 33, 34, 36, 39, 41, 42, 61, 70, 93, 113, 127    
      , 135, 2, 15, 19, 3, 9, 3, 3, 10, 1, 3, 8, 84, 89, 96, 99, 105, 113, 130, 135, 136, 137, 9, 9, 9   
      , 9, 9, 110, 116, 126, 128, 126, 141, 98, 110, 116, 126, 128, 138, 140, 141, 142, 128, 98    
      , 110, 128, 138, 98, 110, 126, 128, 138, 141, 116, 126, 140, 141, 142, 63, 69, 73, 74, 20    
      , 35, 2, 11, 15, 19, 20, 35, 40, 5, 29, 60, 5, 9, 29, 5, 10, 29, 10, 10, 10, 10, 10, 34, 52, 59    
      , 64, 66, 68, 72, 77, 81, 84, 85, 86, 89, 91, 92, 96, 100, 101, 104, 105, 106, 107, 111, 113   
      , 117, 118, 121, 139, 21, 13, 30, 9, 14, 10, 3, 10, 78, 9, 20, 35, 2, 9, 11, 15, 19, 20, 35, 40   
      , 19, 10, 10, 73, 74, 2, 11, 15, 19, 40, 3, 3, 9, 9, 10, 44, 51, 53, 55, 58, 80, 93, 135, 9, 10    
      , 14, 16, 14, 19, 9, 14, 19, 10, 3, 4, 12, 38, 73, 84, 89, 96, 99, 105, 113, 130, 135, 136      
      , 137, 4, 12, 17, 20, 35, 4, 12, 20, 35, 2, 4, 11, 12, 15, 19, 20, 35, 40, 4, 10, 12, 4, 9, 12     
      , 20, 35, 4, 10, 12, 4, 12, 30, 2, 4, 9, 11, 12, 15, 19, 20, 35, 40, 4, 12, 17, 20, 35, 4, 10, 12   
      , 4, 9, 12, 4, 12, 22, 4, 10, 12, 4, 9, 12, 4, 9, 12, 4, 9, 12, 4, 9, 12, 4, 9, 12, 4, 9, 12, 4, 12    
      , 23, 4, 10, 12, 4, 9, 12, 4, 9, 12, 19, 9, 14, 9, 14, 9, 14, 9, 14, 9, 14, 10, 24, 25, 26, 28, 42   
      , 43, 45, 49, 50, 53, 56, 57, 62, 71, 75, 79, 87, 88, 90, 93, 95, 98, 108, 115, 125, 134, 135   
      , 10, 14, 30, 10, 32, 9, 14, 9, 14, 3, 4, 8, 12, 17, 84, 89, 96, 99, 105, 113, 130, 135, 136     
      , 137, 3, 83, 94, 10, 10, 52, 66, 72, 77, 85, 86, 92, 100, 104, 106, 111, 117, 3, 4, 11, 12     
      , 28, 33, 34, 36, 39, 40, 41, 42, 61, 70, 84, 89, 93, 96, 99, 105, 113, 127, 130, 135, 136     
      , 137, 3, 4, 10, 11, 12, 28, 33, 34, 36, 39, 40, 41, 42, 44, 47, 51, 53, 54, 55, 58, 61, 70, 80   
      , 84, 89, 93, 96, 99, 105, 113, 118, 127, 129, 130, 132, 133, 135, 136, 137, 10, 34, 52, 66   
      , 68, 72, 77, 81, 84, 85, 86, 89, 91, 92, 96, 100, 101, 104, 105, 106, 111, 117, 118, 139     
      , 10, 14, 6, 32, 10, 24, 25, 26, 28, 42, 43, 45, 49, 50, 53, 56, 57, 62, 65, 71, 75, 79, 87, 88   
      , 90, 93, 95, 98, 108, 115, 125, 134, 135, 82, 103, 109, 123, 131, 10, 9, 10, 81, 91, 7, 10    
      , 135, 9, 14, 10, 14, 1, 7, 10, 14, 3, 28, 33, 36, 39, 41, 42, 47, 53, 61, 70, 93, 99, 132, 135   
      , 136, 137, 10, 53, 93, 135, 3, 4, 11, 12, 28, 33, 34, 36, 39, 40, 41, 42, 47, 53, 54, 61, 70    
      , 84, 89, 93, 96, 99, 105, 113, 118, 127, 129, 130, 132, 133, 135, 136, 137, 28, 33, 36, 39   
      , 41, 42, 47, 53, 61, 70, 93, 99, 132, 135, 136, 137, 4, 12, 31, 95, 98, 10, 10, 23, 10, 3, 4    
      , 12, 17, 84, 89, 96, 99, 105, 113, 130, 135, 136, 137, 10, 10, 10, 14, 3, 10, 24, 25, 26, 28   
      , 37, 42, 43, 45, 49, 50, 53, 56, 57, 62, 71, 75, 79, 87, 88, 90, 93, 95, 98, 108, 115, 124     
      , 125, 134, 135, 3, 34, 68, 81, 84, 89, 91, 96, 101, 105, 118, 139, 53, 54, 113, 133, 135     
      , 22, 27, 28, 114, 10, 10, 132, 10, 72, 77, 3, 14, 102, 107, 113, 121, 131, 34, 68, 81, 84     
      , 89, 91, 96, 101, 105, 118, 139, 78, 3, 78, 5, 29, 60, 5, 9, 29, 5, 9, 29, 10, 14, 3, 48, 120    
      , 122, 3, 4, 8, 11, 12, 28, 33, 34, 36, 39, 40, 41, 42, 47, 53, 54, 61, 70, 84, 89, 93, 96, 99    
      , 105, 113, 118, 127, 129, 130, 132, 133, 135, 136, 137, 16, 52, 66, 72, 77, 85, 86, 92      
      , 100, 104, 106, 111, 117, 10, 14, 73, 74, 119, 9, 14, 9, 14, 14, 59, 95, 112, 10, 24, 25, 26   
      , 28, 42, 43, 45, 49, 50, 53, 56, 57, 59, 62, 65, 71, 75, 79, 87, 88, 90, 93, 95, 98, 108, 112   
      , 115, 125, 134, 135, 10, 24, 25, 26, 28, 37, 42, 43, 45, 49, 50, 53, 56, 57, 59, 62, 71, 75    
      , 79, 87, 88, 90, 93, 95, 98, 108, 112, 115, 125, 134, 135, 10, 24, 25, 26, 28, 42, 43, 45     
      , 49, 50, 53, 56, 57, 62, 65, 71, 75, 79, 87, 88, 90, 93, 95, 98, 108, 115, 125, 134, 135, 10   
      , 24, 25, 26, 28, 37, 42, 43, 45, 49, 50, 53, 56, 57, 62, 71, 75, 79, 87, 88, 90, 93, 95, 98     
      , 108, 115, 125, 134, 135, 9, 9, 14, 9, 14, 9, 9, 9, 10, 3, 9, 14, 9, 14, 3, 4, 8, 12, 84, 89, 96   
      , 99, 105, 113, 130, 135, 136, 137)
if SANITY_CHECK and len(READ1) != RSIZE + 1:
    print('Bad READ1', file=sys.stderr)
    sys.exit(1)

LOOK1 = (0, 135, 0, 126, 141, 0, 19, 0, 126, 141, 0        
      , 126, 141, 0, 126, 141, 0, 126, 141, 0, 126, 141, 0, 98, 110, 116, 126, 128, 138, 140, 141   
      , 0, 98, 110, 116, 126, 128, 138, 140, 141, 142, 0, 98, 110, 116, 126, 128, 138, 140, 141    
      , 142, 0, 53, 93, 135, 0, 98, 110, 116, 126, 128, 138, 140, 141, 142, 0, 98, 110, 128, 138    
      , 0, 53, 54, 93, 135, 0, 98, 110, 116, 126, 128, 138, 140, 141, 142, 0, 98, 110, 116, 126     
      , 128, 138, 140, 141, 142, 0, 98, 110, 116, 126, 128, 138, 140, 141, 142, 0, 98, 110, 116    
      , 126, 128, 138, 140, 141, 142, 0, 53, 93, 135, 0, 126, 141, 0, 126, 141, 0, 126, 141, 0      
      , 126, 141, 0, 126, 141, 0, 18, 0, 126, 141, 0, 98, 110, 126, 128, 138, 141, 0, 18, 0, 116     
      , 126, 140, 141, 0, 53, 93, 135, 0, 126, 141, 0, 126, 141, 0, 126, 141, 0, 126, 141, 0, 48, 0   
      , 126, 141, 0, 126, 141, 0, 126, 141, 0, 126, 141, 0, 53, 93, 135, 0, 126, 141, 0, 110, 116    
      , 126, 128, 0, 98, 110, 116, 126, 128, 138, 140, 141, 142, 0, 135, 0, 126, 141, 0, 98, 110    
      , 116, 126, 128, 138, 140, 141, 142, 0, 53, 93, 135, 0, 18, 0, 19, 0, 98, 110, 116, 126, 128   
      , 138, 140, 141, 142, 0, 18, 81, 91, 0, 18, 81, 91, 0, 18, 33, 36, 39, 41, 81, 91, 0, 18, 0, 98   
      , 110, 116, 126, 128, 138, 140, 141, 142, 0, 50, 0, 126, 141, 0, 126, 141, 0, 126, 141, 0     
      , 126, 141, 0, 98, 110, 128, 138, 0, 53, 93, 135, 0, 126, 141, 0, 126, 141, 0, 126, 141, 0, 7   
      , 0, 98, 0, 126, 0, 98, 110, 128, 138, 0, 135, 0, 135, 0, 126, 141, 0, 126, 141, 0, 98, 0, 7, 0   
      , 7, 0, 7, 0, 126, 141, 0, 135, 0, 126, 141, 0, 3, 0, 98, 110, 116, 126, 128, 138, 140, 141     
      , 142, 0, 135, 0, 114, 0, 114, 0, 3, 0, 7, 0, 7, 0, 98, 0, 135, 0, 7, 0, 7, 0, 3, 0, 7, 0, 7, 0, 53    
      , 0, 3, 0, 7, 0, 7, 0, 7, 0, 7, 0, 126, 0, 126, 0, 126, 141, 0, 98, 110, 116, 126, 128, 138, 140   
      , 141, 142, 0, 98, 110, 116, 126, 128, 138, 140, 141, 142, 0, 98, 110, 128, 138, 0, 98, 110   
      , 116, 126, 128, 138, 140, 141, 142, 0, 98, 110, 128, 138, 0, 98, 110, 116, 126, 128, 138    
      , 140, 141, 142, 0, 98, 110, 128, 138, 0, 116, 126, 140, 141, 0, 116, 126, 140, 141, 0, 98    
      , 110, 128, 138, 0, 98, 110, 128, 138, 0, 98, 110, 128, 138, 0, 3, 0, 1, 3, 8, 84, 89, 96, 99    
      , 105, 113, 126, 130, 135, 136, 137, 141, 0, 63, 69, 0, 10, 0, 20, 35, 0, 2, 11, 15, 19, 20     
      , 35, 40, 0, 20, 35, 0, 20, 35, 0, 5, 29, 0, 10, 0, 5, 29, 0, 10, 0, 126, 141, 0, 10, 14, 0, 21, 0   
      , 13, 0, 30, 0, 20, 35, 0, 20, 35, 0, 110, 116, 126, 128, 0, 126, 141, 0, 4, 12, 0, 9, 14, 0, 9    
      , 10, 14, 0, 4, 12, 30, 0, 9, 14, 0, 4, 12, 22, 0, 4, 12, 0, 4, 12, 0, 10, 0, 4, 12, 0, 4, 12, 0, 4    
      , 12, 0, 4, 12, 0, 4, 12, 0, 4, 12, 0, 4, 12, 23, 0, 4, 12, 0, 4, 12, 0, 110, 116, 126, 128, 0      
      , 110, 116, 126, 128, 0, 110, 116, 126, 128, 0, 9, 10, 14, 16, 126, 141, 0, 83, 94, 0, 110     
      , 116, 126, 128, 0, 10, 14, 0, 98, 110, 116, 126, 128, 138, 140, 141, 142, 0, 98, 110, 126    
      , 128, 138, 141, 0, 98, 110, 116, 126, 128, 138, 140, 141, 142, 0, 7, 0, 126, 141, 0, 10, 14   
      , 0, 6, 32, 0, 6, 32, 0, 110, 116, 126, 128, 0, 110, 116, 126, 128, 0, 110, 116, 126, 128, 0    
      , 110, 116, 126, 128, 0, 110, 116, 126, 128, 0, 82, 103, 109, 123, 0, 126, 141, 0, 126, 141   
      , 0, 81, 91, 0, 7, 0, 98, 0, 7, 0, 1, 7, 0, 9, 14, 110, 116, 126, 128, 0, 53, 93, 135, 0, 98, 110   
      , 116, 126, 128, 138, 140, 141, 142, 0, 98, 110, 116, 126, 128, 138, 140, 141, 142, 0, 4     
      , 12, 0, 126, 141, 0, 82, 103, 109, 123, 0, 110, 116, 126, 128, 0, 10, 72, 77, 120, 122, 0     
      , 98, 110, 128, 138, 0, 116, 126, 140, 141, 0, 126, 141, 0, 142, 0, 22, 27, 28, 114, 0, 82     
      , 103, 109, 123, 0, 14, 0, 10, 72, 77, 120, 122, 0, 78, 0, 3, 78, 0, 10, 0, 48, 0, 120, 122, 0    
      , 82, 103, 109, 123, 0, 98, 110, 116, 126, 128, 138, 140, 141, 142, 0, 10, 14, 0, 10, 14, 0    
      , 82, 103, 109, 123, 0, 14, 0, 14, 0, 59, 95, 112, 0, 102, 107, 110, 113, 116, 121, 126, 128   
      , 0, 110, 116, 126, 128, 0, 102, 107, 110, 113, 116, 121, 126, 128, 0, 110, 116, 126, 128    
      , 0, 110, 116, 126, 128, 0, 82, 103, 109, 123, 0, 126, 141, 0, 6, 32, 0, 6, 32, 0, 98, 110      
      , 116, 126, 128, 138, 140, 141, 142, 0, 126, 141, 0)
if SANITY_CHECK and len(LOOK1) != LSIZE + 1:
    print('Bad LOOK1', file=sys.stderr)
    sys.exit(1)

# PUSH STATES ARE BUILT-IN TO THE INDEX TABLES

APPLY1 = (0, 0, 0, 8, 11, 17, 18, 20, 25, 26, 27, 28
      , 30, 31, 32, 33, 34, 36, 37, 40, 60, 62, 67, 68, 75, 80, 82, 83, 85, 88, 93, 94, 95, 106, 117
      , 123, 125, 132, 187, 188, 190, 192, 194, 195, 242, 269, 322, 329, 330, 331, 350, 351
      , 364, 372, 381, 383, 408, 440, 0, 42, 43, 44, 54, 55, 56, 57, 0, 3, 46, 206, 0, 186, 0, 0, 0
      , 0, 0, 0, 419, 420, 421, 422, 423, 0, 313, 316, 319, 327, 0, 378, 0, 316, 419, 420, 421
      , 422, 423, 0, 0, 0, 193, 196, 197, 199, 0, 0, 17, 28, 188, 190, 191, 192, 329, 380, 0, 189
      , 0, 11, 17, 22, 28, 37, 90, 101, 188, 329, 330, 0, 226, 229, 258, 273, 279, 388, 0, 0, 190
      , 0, 17, 28, 329, 0, 192, 0, 194, 195, 0, 0, 163, 0, 11, 17, 28, 40, 188, 190, 192, 329, 381
      , 0, 59, 0, 0, 0, 0, 0, 0, 0, 224, 412, 0, 257, 0, 0, 0, 0, 0, 378, 0, 0, 0, 96, 0, 81, 0, 0, 0, 20
      , 25, 26, 27, 0, 41, 0, 62, 75, 80, 132, 187, 331, 364, 408, 440, 0, 17, 28, 188, 190, 192
      , 39, 384, 0, 0, 68, 0, 19, 24, 29, 41, 59, 61, 69, 92, 263, 361, 363, 365, 0, 19, 24, 0, 17
      , 28, 188, 190, 192, 329, 382, 0, 17, 18, 20, 25, 26, 27, 28, 62, 68, 75, 80, 132, 187, 188
      , 190, 192, 329, 331, 364, 382, 408, 440, 0, 19, 24, 65, 105, 158, 160, 354, 365, 0, 19, 24
      , 365, 0, 19, 24, 365, 0, 19, 24, 365, 0, 19, 24, 365, 0, 17, 18, 20, 25, 26, 27, 28, 62, 68
      , 75, 80, 132, 187, 188, 190, 192, 329, 331, 364, 384, 408, 440, 0, 19, 24, 29, 41, 59, 61
      , 69, 92, 100, 183, 185, 263, 313, 316, 319, 327, 340, 341, 342, 343, 344, 361, 363, 365
      , 378, 419, 420, 421, 422, 423, 0, 11, 17, 18, 20, 25, 26, 27, 28, 40, 62, 68, 75, 80, 132
      , 187, 188, 190, 192, 194, 195, 329, 331, 364, 381, 408, 440, 0, 19, 24, 29, 41, 59, 61, 69
      , 92, 263, 313, 316, 319, 327, 340, 341, 342, 343, 344, 361, 363, 365, 378, 419, 420, 421
      , 422, 423, 0, 19, 24, 29, 41, 59, 61, 69, 92, 103, 124, 133, 263, 313, 316, 319, 327, 340
      , 341, 342, 343, 344, 361, 363, 365, 378, 419, 420, 421, 422, 423, 0, 17, 18, 19, 20, 24
      , 25, 26, 27, 28, 29, 41, 59, 61, 62, 68, 69, 75, 80, 92, 132, 187, 188, 190, 192, 263, 313
      , 316, 319, 327, 329, 331, 340, 341, 342, 343, 344, 361, 363, 364, 365, 378, 384, 408
      , 419, 420, 421, 422, 423, 440, 0, 11, 17, 18, 19, 20, 22, 24, 25, 26, 27, 28, 29, 37, 40, 41
      , 59, 61, 62, 65, 68, 69, 75, 80, 90, 92, 100, 101, 103, 105, 124, 132, 133, 158, 160, 183
      , 185, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 199, 263, 313, 316, 319
      , 327, 329, 330, 331, 340, 341, 342, 343, 344, 354, 361, 363, 364, 365, 378, 380, 381
      , 384, 408, 419, 420, 421, 422, 423, 440, 0, 19, 24, 29, 41, 59, 61, 69, 92, 263, 313, 316
      , 319, 327, 340, 341, 342, 343, 344, 361, 363, 365, 378, 419, 420, 421, 422, 423, 0, 0
      , 120, 121, 122, 141, 148, 161, 169, 170, 178, 180, 181, 182, 332, 353, 358, 0, 0, 0, 0, 0
      , 83, 372, 0, 0, 0, 98, 163, 357, 0, 436, 437, 0, 399, 400, 401, 402, 0, 17, 28, 188, 190
      , 192, 193, 226, 229, 251, 253, 258, 273, 279, 329, 388, 0, 225, 226, 227, 228, 229, 250
      , 251, 252, 253, 254, 0, 357, 0, 70, 71, 0, 0, 78, 0, 0, 361, 365, 0, 361, 365, 0, 62, 331, 0
      , 0, 0, 61, 0, 62, 0, 0, 0, 1, 367, 0, 390, 407, 413, 432, 0, 0, 0, 0, 0, 0, 0, 1, 340, 341, 342
      , 343, 344, 367, 378, 419, 421, 422, 423, 0, 0, 0, 0, 0, 0, 0, 202, 398, 0, 0, 397, 0, 48, 249
      , 0, 377, 0, 0, 0, 0, 0, 0, 167, 0, 58, 0, 0, 0, 0, 0, 0, 152, 157, 0, 0, 0, 346, 435, 0, 0, 243, 0
      , 0, 0, 335, 0, 379, 396, 0, 152, 153, 154, 155, 0, 152, 153, 156, 0, 151, 152, 153, 155
      , 156, 0, 0, 0, 5, 6, 7, 9, 334, 434, 0, 76, 77, 78, 352, 0, 173, 328, 0, 409, 410, 411, 0, 0
      , 440, 0, 0, 0, 361, 0, 13, 14, 15, 16, 21, 23, 183, 185, 361, 365, 0, 340, 341, 342, 343
      , 344, 0, 0, 0, 0, 0, 0, 0, 0, 0, 224, 0)
if SANITY_CHECK and len(APPLY1) != ASIZE + 1:
    print('Bad APPLY1', file=sys.stderr)
    sys.exit(1)

READ2 = (0, 1125, 138, 1031, 915, 448, 473, 478        
      , 836, 834, 835, 1239, 833, 151, 831, 1030, 1238, 830, 143, 450, 473, 1064, 478, 1083     
      , 1076, 508, 1077, 1074, 1065, 1075, 1084, 107, 1081, 1082, 836, 834, 1035, 835, 1239    
      , 833, 153, 534, 901, 937, 831, 1085, 1030, 1238, 830, 1150, 1239, 1238, 1019, 112       
      , 1035, 1030, 493, 494, 495, 448, 836, 834, 835, 1239, 833, 151, 831, 1030, 1238, 830     
      , 1220, 887, 859, 1142, 1086, 860, 861, 962, 535, 104, 110, 1019, 113, 116, 127, 1035     
      , 1030, 450, 473, 1064, 478, 1083, 1076, 508, 1077, 1074, 1065, 1075, 1084, 104, 107     
      , 110, 1019, 1017, 113, 116, 1081, 1082, 127, 836, 834, 1035, 835, 1239, 833, 152, 534    
      , 901, 937, 831, 1085, 1000, 1030, 1238, 830, 1261, 1164, 1151, 496, 916, 1162, 1163     
      , 1072, 1208, 1207, 1072, 1076, 1077, 1074, 1075, 1208, 1207, 109, 1147, 954, 510, 514   
      , 964, 963, 91, 517, 455, 1064, 1083, 1076, 508, 1077, 1074, 1065, 1075, 1084, 1081      
      , 1082, 1035, 154, 901, 1030, 142, 512, 521, 525, 445, 976, 168, 1030, 455, 1064, 1083    
      , 1076, 508, 1077, 1074, 1065, 1075, 1084, 1081, 1082, 1035, 154, 164, 901, 1030, 518    
      , 1030, 462, 21, 852, 139, 13, 463, 449, 1018, 464, 14, 519, 465, 1182, 1241, 15, 466      
      , 150, 446, 10, 854, 140, 450, 473, 862, 1064, 478, 1083, 1076, 508, 1077, 1074, 1065     
      , 1075, 1084, 107, 1019, 1017, 1081, 1082, 836, 834, 1035, 835, 1239, 833, 152, 534      
      , 901, 937, 831, 1085, 1000, 1030, 1238, 830, 531, 1203, 1118, 853, 855, 856, 1222, 97    
      , 111, 1181, 118, 1213, 1191, 1218, 1215, 1208, 523, 130, 1217, 1200, 1207, 1211, 528    
      , 1214, 1192, 145, 1199, 1221, 1180, 149, 1178, 1212, 162, 1179, 538, 179, 1223, 16      
      , 539, 1224, 175, 1108, 97, 1208, 523, 1200, 1207, 528, 1192, 1199, 162, 179, 97, 1192    
      , 1108, 1208, 523, 1200, 1207, 528, 1199, 162, 179, 505, 1030, 468, 447, 871, 173, 1169   
      , 176, 1173, 12, 73, 111, 1213, 1218, 1215, 130, 1217, 1211, 1214, 145, 1221, 149, 1212   
      , 1138, 1140, 504, 974, 888, 886, 53, 467, 1239, 1030, 1238, 38, 470, 1239, 1030, 1238    
      , 451, 473, 1064, 478, 1083, 1076, 508, 1077, 1074, 1065, 1075, 1084, 107, 1019, 1017    
      , 1081, 1082, 836, 834, 1035, 835, 1239, 833, 152, 534, 901, 937, 831, 1085, 1000, 1030   
      , 1238, 830, 471, 473, 478, 107, 836, 834, 835, 1239, 833, 156, 534, 937, 831, 1085       
      , 1030, 1238, 830, 455, 1083, 1076, 508, 1077, 1074, 1075, 1084, 1081, 1082, 1035, 154   
      , 901, 1030, 460, 1083, 1076, 508, 1077, 1074, 1075, 1084, 1081, 1082, 1035, 154, 901    
      , 1030, 917, 918, 912, 23, 1073, 461, 472, 864, 443, 448, 476, 836, 834, 835, 1239, 833    
      , 151, 831, 1030, 1238, 830, 1100, 1102, 1101, 49, 1079, 530, 533, 536, 537, 536, 542     
      , 529, 530, 533, 536, 537, 540, 541, 542, 543, 537, 529, 530, 537, 540, 529, 530, 536      
      , 537, 540, 542, 533, 536, 541, 542, 543, 515, 520, 964, 963, 1066, 1067, 444, 1064, 491   
      , 911, 1066, 1067, 1065, 1062, 1063, 952, 1062, 896, 1063, 1062, 874, 1063, 1103, 840    
      , 898, 934, 998, 97, 111, 1181, 118, 1213, 1191, 1218, 1215, 1208, 523, 130, 1217, 1200   
      , 1207, 1211, 528, 1214, 1192, 145, 1199, 1221, 1180, 149, 1178, 1212, 162, 1179, 179    
      , 827, 481, 1052, 1149, 66, 1109, 452, 858, 1142, 936, 1066, 1067, 444, 936, 1064, 491    
      , 911, 1066, 1067, 1065, 497, 870, 955, 964, 963, 444, 1064, 491, 911, 1065, 453, 456     
      , 1009, 1016, 865, 104, 110, 1019, 113, 116, 127, 1035, 1030, 1036, 1043, 1045, 1044     
      , 482, 498, 1007, 482, 1058, 1146, 448, 473, 478, 511, 522, 836, 834, 835, 1239, 833      
      , 151, 831, 1030, 1238, 830, 474, 479, 1231, 1066, 1067, 474, 479, 1066, 1067, 444, 474   
      , 1064, 479, 491, 911, 1066, 1067, 1065, 474, 872, 479, 474, 828, 479, 1066, 1067, 474    
      , 477, 479, 474, 479, 506, 444, 474, 828, 1064, 479, 491, 911, 1066, 1067, 1065, 474      
      , 479, 492, 1066, 1067, 474, 873, 479, 474, 984, 479, 474, 479, 500, 474, 877, 479, 474    
      , 1088, 479, 474, 1090, 479, 474, 1091, 479, 474, 1087, 479, 474, 1089, 479, 474, 1253    
      , 479, 474, 479, 501, 474, 878, 479, 474, 1069, 479, 474, 1070, 479, 973, 48, 488, 838     
      , 488, 900, 488, 935, 488, 999, 488, 857, 86, 87, 953, 89, 102, 512, 513, 108, 109, 1019    
      , 114, 115, 1247, 521, 126, 1244, 131, 524, 525, 1035, 135, 138, 146, 532, 1243, 177      
      , 1030, 1110, 483, 507, 883, 96, 1068, 490, 1068, 71, 448, 473, 1049, 478, 1055, 836      
      , 834, 835, 1239, 833, 151, 831, 1030, 1238, 830, 1034, 980, 979, 885, 882, 111, 1213     
      , 1218, 1215, 130, 1217, 1211, 1214, 145, 1221, 149, 1212, 469, 473, 1064, 478, 1083     
      , 1076, 508, 1077, 1074, 1065, 1075, 1084, 1081, 1082, 836, 834, 1035, 835, 1239, 833    
      , 155, 901, 831, 1030, 1238, 830, 450, 473, 867, 1064, 478, 1083, 1076, 508, 1077, 1074   
      , 1065, 1075, 1084, 104, 107, 110, 1019, 1017, 113, 116, 1081, 1082, 127, 836, 834       
      , 1035, 835, 1239, 833, 152, 534, 901, 937, 831, 1085, 1000, 1030, 1238, 830, 1107, 97    
      , 111, 1213, 1191, 1218, 1215, 1208, 523, 130, 1217, 1200, 1207, 1211, 528, 1214, 1192   
      , 145, 1199, 1221, 149, 1212, 162, 179, 851, 58, 1060, 1061, 857, 86, 87, 953, 89, 102     
      , 512, 513, 108, 109, 1019, 114, 115, 1247, 516, 521, 126, 1244, 131, 524, 525, 1035      
      , 526, 138, 146, 532, 1243, 177, 1030, 128, 144, 147, 165, 538, 863, 899, 869, 1208       
      , 1207, 1059, 875, 1030, 47, 889, 1165, 64, 442, 1059, 866, 484, 1232, 1083, 1076, 1077   
      , 1074, 1075, 1084, 107, 1019, 1081, 1082, 1035, 1239, 1085, 1030, 1238, 1235, 1111     
      , 1019, 1035, 1030, 450, 473, 1064, 478, 1083, 1076, 508, 1077, 1074, 1065, 1075, 1084   
      , 107, 1019, 1017, 1081, 1082, 836, 834, 1035, 835, 1239, 833, 152, 534, 901, 937, 831    
      , 1085, 1000, 1030, 1238, 830, 1083, 1076, 1077, 1074, 1075, 1084, 107, 1019, 1081      
      , 1082, 1035, 1239, 1085, 1030, 1238, 1235, 475, 480, 811, 1125, 138, 1153, 1152, 84     
      , 1144, 448, 473, 478, 1055, 836, 834, 835, 1239, 833, 151, 831, 1030, 1238, 830, 957     
      , 956, 868, 485, 457, 857, 86, 87, 953, 89, 509, 102, 512, 513, 108, 109, 1019, 114, 115    
      , 1247, 521, 126, 1244, 131, 524, 525, 1035, 526, 138, 146, 532, 167, 1243, 177, 1030     
      , 1139, 97, 1191, 1208, 523, 1200, 1207, 528, 1192, 1199, 162, 179, 1019, 1017, 157      
      , 1000, 1030, 499, 502, 503, 159, 881, 884, 1080, 1112, 1114, 1113, 458, 487, 1122       
      , 1121, 1130, 1131, 174, 97, 1191, 1208, 523, 1200, 1207, 528, 1192, 1199, 162, 179      
      , 1142, 1139, 1142, 1062, 1063, 951, 1062, 928, 1063, 1062, 929, 1063, 876, 486, 454     
      , 950, 1116, 1117, 450, 473, 45, 1064, 478, 1083, 1076, 508, 1077, 1074, 1065, 1075      
      , 1084, 107, 1019, 1017, 1081, 1082, 836, 834, 1035, 835, 1239, 833, 152, 534, 901, 937   
      , 831, 1085, 1000, 1030, 1238, 830, 74, 111, 1213, 1218, 1215, 130, 1217, 1211, 1214     
      , 145, 1221, 149, 1212, 879, 63, 964, 963, 1254, 50, 489, 51, 489, 1158, 1123, 1124       
      , 1120, 857, 86, 87, 953, 89, 102, 512, 513, 108, 109, 1019, 114, 115, 1123, 1247, 516     
      , 521, 126, 1244, 131, 524, 525, 1035, 527, 138, 146, 1120, 532, 1243, 177, 1030, 857     
      , 86, 87, 953, 89, 509, 102, 512, 513, 108, 109, 1019, 114, 115, 1123, 1247, 521, 126      
      , 1244, 131, 524, 525, 1035, 527, 138, 146, 1120, 532, 1243, 177, 1030, 857, 86, 87, 953   
      , 89, 102, 512, 513, 108, 109, 1019, 114, 115, 1247, 516, 521, 126, 1244, 131, 524, 525    
      , 1035, 135, 138, 146, 532, 1243, 177, 1030, 857, 86, 87, 953, 89, 509, 102, 512, 513      
      , 108, 109, 1019, 114, 115, 1247, 521, 126, 1244, 131, 524, 525, 1035, 135, 138, 146      
      , 532, 1243, 177, 1030, 1198, 1177, 1183, 1193, 1204, 1194, 1168, 1216, 880, 459, 1219   
      , 1225, 1229, 1233, 448, 473, 1206, 478, 836, 834, 835, 1239, 833, 151, 831, 1030, 1238   
      , 830)
if SANITY_CHECK and len(READ2) != RSIZE + 1:
    print('Bad READ2', file=sys.stderr)
    sys.exit(1)

LOOK2 = (0, 2, 1033, 667, 667, 3, 4, 913, 668, 668       
      , 5, 669, 669, 6, 670, 670, 7, 671, 671, 8, 672, 672, 9, 673, 673, 673, 673, 673, 673, 673    
      , 673, 11, 674, 674, 674, 674, 674, 674, 674, 674, 674, 17, 675, 675, 675, 675, 675, 675    
      , 675, 675, 675, 18, 19, 19, 19, 676, 677, 677, 677, 677, 677, 677, 677, 677, 677, 20, 678   
      , 678, 678, 678, 22, 24, 24, 24, 24, 679, 680, 680, 680, 680, 680, 680, 680, 680, 680, 25    
      , 681, 681, 681, 681, 681, 681, 681, 681, 681, 26, 682, 682, 682, 682, 682, 682, 682, 682   
      , 682, 27, 683, 683, 683, 683, 683, 683, 683, 683, 683, 28, 29, 29, 29, 684, 685, 685, 30    
      , 686, 686, 31, 687, 687, 32, 688, 688, 33, 689, 689, 34, 35, 1041, 690, 690, 36, 691, 691   
      , 691, 691, 691, 691, 37, 39, 1041, 692, 692, 692, 692, 40, 41, 41, 41, 693, 694, 694, 42    
      , 695, 695, 43, 696, 696, 44, 697, 697, 46, 52, 958, 698, 698, 54, 699, 699, 55, 700, 700    
      , 56, 701, 701, 57, 59, 59, 59, 702, 703, 703, 60, 704, 704, 704, 704, 61, 705, 705, 705     
      , 705, 705, 705, 705, 705, 705, 62, 65, 706, 707, 707, 67, 708, 708, 708, 708, 708, 708     
      , 708, 708, 708, 68, 69, 69, 69, 709, 70, 1042, 72, 914, 710, 710, 710, 710, 710, 710, 710   
      , 710, 710, 75, 76, 76, 76, 1071, 77, 77, 77, 1071, 78, 78, 78, 78, 78, 78, 78, 1071, 79      
      , 1071, 711, 711, 711, 711, 711, 711, 711, 711, 711, 80, 81, 1058, 712, 712, 82, 713, 713   
      , 83, 714, 714, 85, 715, 715, 88, 716, 716, 716, 716, 90, 92, 92, 92, 717, 718, 718, 93      
      , 719, 719, 94, 720, 720, 95, 98, 721, 99, 975, 722, 100, 723, 723, 723, 723, 101, 103      
      , 724, 105, 725, 726, 726, 106, 727, 727, 117, 119, 1240, 120, 728, 121, 729, 122, 730     
      , 731, 731, 123, 124, 732, 733, 733, 125, 129, 1202, 734, 734, 734, 734, 734, 734, 734     
      , 734, 734, 132, 133, 735, 134, 1125, 136, 1124, 137, 1201, 141, 736, 148, 737, 738, 158   
      , 160, 739, 161, 740, 163, 741, 166, 1167, 169, 742, 170, 743, 171, 1172, 172, 1148, 178   
      , 744, 180, 745, 181, 746, 182, 747, 748, 183, 749, 185, 750, 750, 186, 751, 751, 751      
      , 751, 751, 751, 751, 751, 751, 187, 752, 752, 752, 752, 752, 752, 752, 752, 752, 188      
      , 753, 753, 753, 753, 189, 754, 754, 754, 754, 754, 754, 754, 754, 754, 190, 755, 755      
      , 755, 755, 191, 756, 756, 756, 756, 756, 756, 756, 756, 756, 192, 757, 757, 757, 757      
      , 193, 758, 758, 758, 758, 194, 759, 759, 759, 759, 195, 760, 760, 760, 760, 196, 761      
      , 761, 761, 761, 197, 762, 762, 762, 762, 199, 200, 1078, 206, 206, 206, 206, 206, 206     
      , 206, 206, 206, 763, 206, 206, 206, 206, 763, 821, 223, 223, 1260, 1256, 224, 225, 225    
      , 907, 226, 226, 226, 226, 226, 226, 226, 907, 227, 227, 908, 228, 228, 921, 230, 230      
      , 992, 965, 233, 235, 235, 1251, 1263, 236, 764, 764, 242, 1170, 1170, 243, 244, 825      
      , 245, 819, 246, 1048, 250, 250, 993, 254, 254, 920, 765, 765, 765, 765, 263, 766, 766     
      , 269, 270, 270, 1205, 991, 991, 271, 991, 991, 991, 272, 278, 278, 278, 969, 991, 991     
      , 280, 283, 283, 283, 1053, 284, 284, 1249, 285, 285, 1250, 1262, 286, 287, 287, 943      
      , 288, 288, 944, 291, 291, 919, 297, 297, 1053, 299, 299, 1259, 300, 300, 1258, 301, 301   
      , 301, 971, 302, 302, 970, 305, 305, 972, 767, 767, 767, 767, 313, 768, 768, 768, 768      
      , 316, 769, 769, 769, 769, 319, 1046, 1046, 1046, 1046, 770, 770, 322, 324, 324, 978      
      , 771, 771, 771, 771, 327, 1184, 1184, 328, 772, 772, 772, 772, 772, 772, 772, 772, 772    
      , 329, 773, 773, 773, 773, 773, 773, 330, 774, 774, 774, 774, 774, 774, 774, 774, 774      
      , 331, 332, 775, 776, 776, 334, 1175, 1175, 335, 338, 338, 909, 339, 339, 910, 777, 777    
      , 777, 777, 340, 778, 778, 778, 778, 341, 779, 779, 779, 779, 342, 780, 780, 780, 780      
      , 343, 781, 781, 781, 781, 344, 345, 345, 345, 345, 782, 783, 783, 350, 784, 784, 351      
      , 352, 352, 1196, 353, 785, 786, 354, 357, 841, 358, 358, 787, 1230, 1230, 788, 788, 788   
      , 788, 361, 363, 363, 363, 789, 790, 790, 790, 790, 790, 790, 790, 790, 790, 364, 791      
      , 791, 791, 791, 791, 791, 791, 791, 791, 365, 366, 366, 1054, 792, 792, 372, 377, 377     
      , 377, 377, 1105, 793, 793, 793, 793, 378, 1126, 1126, 1126, 1126, 1126, 379, 794, 794    
      , 794, 794, 380, 795, 795, 795, 795, 381, 796, 796, 383, 797, 384, 385, 385, 385, 385      
      , 1252, 390, 390, 390, 390, 798, 393, 968, 1132, 1132, 1132, 1132, 1132, 396, 397, 1135   
      , 398, 398, 1128, 966, 400, 405, 846, 406, 406, 1115, 407, 407, 407, 407, 799, 800, 800    
      , 800, 800, 800, 800, 800, 800, 800, 408, 1186, 1186, 409, 1185, 1185, 410, 413, 413      
      , 413, 413, 801, 416, 1154, 417, 1155, 418, 418, 418, 1119, 1119, 1119, 802, 1119, 802    
      , 1119, 802, 802, 419, 803, 803, 803, 803, 420, 1119, 1119, 804, 1119, 804, 1119, 804     
      , 804, 421, 805, 805, 805, 805, 422, 806, 806, 806, 806, 423, 432, 432, 432, 432, 807      
      , 808, 808, 434, 436, 436, 926, 437, 437, 927, 809, 809, 809, 809, 809, 809, 809, 809      
      , 809, 440, 810, 810, 441)
if SANITY_CHECK and len(LOOK2) != LSIZE + 1:
    print('Bad LOOK2', file=sys.stderr)
    sys.exit(1)

APPLY2 = (0, 0, 367, 275, 276, 279, 584, 584, 584
      , 584, 584, 273, 292, 293, 294, 295, 296, 298, 275, 276, 282, 582, 596, 584, 582, 582
      , 586, 592, 597, 587, 289, 595, 303, 277, 593, 594, 281, 582, 582, 273, 273, 273, 589
      , 590, 583, 274, 585, 273, 588, 582, 304, 306, 582, 592, 290, 591, 581, 581, 580, 815
      , 817, 1056, 816, 818, 1057, 820, 814, 823, 822, 824, 574, 826, 560, 546, 624, 404, 608
      , 573, 845, 845, 845, 845, 845, 847, 959, 948, 843, 949, 848, 960, 1106, 646, 850, 850
      , 850, 850, 850, 846, 629, 355, 904, 905, 905, 906, 903, 376, 564, 564, 564, 229, 565
      , 229, 564, 566, 563, 612, 611, 232, 232, 232, 232, 232, 569, 234, 231, 568, 570, 567
      , 635, 635, 382, 637, 637, 638, 636, 930, 664, 663, 401, 402, 645, 399, 925, 924, 942
      , 945, 941, 392, 938, 902, 252, 253, 251, 252, 251, 251, 251, 251, 577, 576, 947, 336
      , 844, 603, 599, 548, 633, 598, 606, 606, 605, 374, 373, 257, 641, 967, 571, 205, 977
      , 600, 318, 387, 386, 256, 255, 315, 249, 309, 310, 311, 312, 308, 415, 414, 1098, 1002
      , 349, 347, 946, 1098, 348, 1226, 1226, 1001, 388, 388, 388, 388, 388, 388, 922, 994
      , 433, 988, 987, 1010, 1010, 989, 989, 267, 1096, 990, 268, 1096, 1227, 266, 1010, 265
      , 261, 262, 890, 258, 258, 258, 258, 258, 258, 923, 995, 260, 260, 260, 260, 260, 260
      , 260, 260, 260, 260, 260, 260, 260, 260, 260, 260, 260, 260, 260, 260, 260, 260, 259
      , 1011, 1011, 1246, 986, 317, 1248, 1245, 1011, 893, 1012, 1012, 1012, 839, 1013, 1013
      , 1013, 897, 1014, 1014, 1014, 933, 1015, 1015, 1015, 997, 996, 996, 996, 996, 996, 996
      , 996, 996, 996, 996, 996, 996, 996, 996, 996, 996, 996, 996, 996, 996, 996, 996, 1004
      , 1003, 1003, 1003, 1003, 1003, 1003, 1003, 1003, 307, 1039, 1039, 1003, 1003, 1003
      , 1003, 1003, 1003, 1003, 1003, 1003, 1003, 1003, 1003, 1003, 1003, 1003, 1003, 1003
      , 1003, 1003, 837, 931, 931, 931, 931, 931, 931, 931, 931, 931, 931, 931, 931, 931, 931
      , 931, 931, 931, 931, 931, 931, 931, 931, 931, 931, 931, 931, 1008, 1005, 1005, 1005
      , 1005, 1005, 1005, 1005, 1005, 1005, 1005, 1005, 1005, 1005, 1005, 1005, 1005, 1005
      , 1005, 1005, 1005, 1005, 1005, 1005, 1005, 1005, 1005, 1005, 892, 1006, 1006, 1006
      , 1006, 1006, 1006, 1006, 1006, 981, 982, 983, 1006, 1006, 1006, 1006, 1006, 1006
      , 1006, 1006, 1006, 1006, 1006, 1006, 1006, 1006, 1006, 1006, 1006, 1006, 1006, 894
      , 625, 625, 625, 625, 625, 625, 625, 625, 625, 625, 625, 625, 625, 625, 625, 625, 625
      , 625, 625, 625, 625, 625, 625, 625, 625, 625, 625, 625, 625, 625, 625, 625, 625, 625
      , 625, 625, 625, 625, 625, 625, 625, 625, 625, 625, 625, 625, 625, 625, 625, 359, 217
      , 214, 214, 214, 214, 218, 214, 214, 214, 214, 214, 212, 220, 221, 212, 212, 212, 214
      , 216, 214, 212, 214, 214, 218, 212, 219, 218, 215, 216, 215, 214, 215, 216, 216, 219
      , 219, 214, 214, 218, 214, 218, 214, 218, 221, 221, 218, 218, 218, 212, 212, 212, 212
      , 212, 214, 220, 214, 212, 212, 212, 212, 212, 216, 212, 212, 214, 214, 212, 218, 221
      , 222, 214, 212, 212, 212, 212, 212, 214, 213, 627, 627, 627, 627, 627, 627, 627, 627
      , 627, 627, 627, 627, 627, 627, 627, 627, 627, 627, 627, 627, 627, 627, 627, 627, 627
      , 627, 627, 628, 622, 602, 325, 326, 1020, 1028, 1027, 1026, 1029, 1022, 1023, 1021
      , 1024, 832, 323, 1025, 939, 601, 264, 1047, 631, 1051, 1050, 575, 630, 547, 545, 545
      , 184, 544, 552, 552, 551, 550, 550, 550, 550, 549, 557, 557, 557, 557, 557, 558, 198
      , 198, 198, 198, 198, 198, 198, 557, 198, 556, 553, 553, 553, 553, 553, 554, 554, 554
      , 554, 554, 555, 842, 1037, 620, 620, 619, 940, 201, 559, 389, 1236, 1236, 895, 1237
      , 1237, 932, 1099, 1099, 1097, 360, 375, 1093, 1092, 1095, 1094, 578, 607, 812, 813
      , 849, 615, 616, 614, 617, 613, 652, 640, 648, 661, 618, 391, 655, 656, 656, 656, 656
      , 656, 655, 658, 659, 660, 659, 660, 657, 394, 647, 634, 644, 1127, 1129, 1141, 643, 642
      , 395, 1137, 1136, 204, 203, 202, 1160, 1159, 371, 370, 247, 961, 1143, 369, 368, 654
      , 653, 346, 632, 1145, 435, 1161, 362, 362, 1187, 1166, 662, 1157, 356, 1156, 572, 1171
      , 337, 610, 609, 1174, 1176, 1133, 1134, 604, 248, 248, 248, 248, 1188, 314, 314, 314
      , 1189, 333, 333, 333, 333, 333, 1190, 621, 666, 426, 427, 428, 430, 425, 429, 424, 320
      , 321, 320, 1197, 1195, 411, 651, 650, 1210, 1210, 1210, 1209, 649, 439, 438, 626, 665
      , 1228, 891, 985, 207, 208, 209, 210, 211, 1038, 1038, 1234, 1234, 829, 237, 238, 239
      , 240, 241, 1242, 623, 403, 579, 639, 412, 431, 562, 561, 1257, 1255)
if SANITY_CHECK and len(APPLY2) != ASIZE + 1:
    print('Bad APPLY2', file=sys.stderr)
    sys.exit(1)

INDEX1 = (0, 1, 3, 59, 4, 1306, 1306, 1306, 5, 1306      
      , 18, 19, 49, 50, 50, 50, 50, 351, 942, 939, 942, 50, 151, 50, 52, 942, 942, 942, 351, 939    
      , 5, 5, 5, 5, 5, 56, 5, 778, 57, 58, 384, 939, 59, 59, 59, 70, 59, 71, 72, 74, 75, 76, 77, 78     
      , 59, 59, 59, 59, 904, 939, 5, 79, 87, 125, 126, 193, 127, 5, 942, 939, 128, 128, 129, 130    
      , 131, 942, 132, 132, 135, 132, 942, 142, 5, 1000, 143, 5, 144, 149, 5, 150, 151, 167, 939   
      , 5, 5, 5, 168, 171, 910, 172, 173, 175, 192, 193, 194, 193, 5, 195, 196, 198, 199, 200      
      , 201, 202, 203, 204, 205, 5, 206, 207, 910, 910, 910, 5, 193, 5, 208, 209, 210, 211, 212    
      , 213, 215, 193, 249, 249, 249, 250, 251, 252, 253, 910, 254, 255, 256, 285, 286, 287      
      , 910, 288, 289, 303, 290, 290, 301, 290, 303, 311, 312, 314, 193, 910, 315, 910, 316      
      , 317, 318, 256, 319, 910, 910, 320, 321, 322, 335, 337, 338, 339, 910, 341, 910, 910      
      , 910, 342, 346, 347, 59, 942, 351, 151, 351, 151, 351, 151, 384, 384, 401, 415, 429, 401   
      , 432, 433, 1049, 434, 435, 436, 437, 450, 451, 452, 453, 454, 455, 459, 461, 470, 461     
      , 461, 471, 459, 475, 481, 485, 486, 488, 490, 492, 490, 490, 492, 499, 499, 502, 499      
      , 505, 499, 499, 508, 509, 510, 511, 512, 5, 513, 541, 542, 543, 544, 546, 547, 490, 492    
      , 550, 553, 490, 561, 562, 563, 566, 571, 572, 573, 574, 575, 584, 588, 590, 591, 593      
      , 594, 609, 609, 614, 618, 627, 630, 630, 635, 638, 641, 651, 656, 659, 662, 609, 609      
      , 609, 609, 609, 665, 614, 609, 668, 671, 674, 677, 680, 609, 683, 609, 609, 686, 609      
      , 689, 692, 609, 695, 698, 699, 701, 703, 705, 707, 709, 737, 738, 709, 739, 740, 709      
      , 742, 744, 746, 761, 762, 764, 765, 709, 766, 351, 778, 804, 910, 843, 1306, 844, 867     
      , 868, 869, 869, 871, 871, 871, 871, 871, 900, 904, 905, 906, 907, 5, 5, 908, 910, 911      
      , 913, 915, 910, 917, 917, 919, 921, 938, 939, 942, 975, 991, 993, 996, 997, 998, 999      
      , 1000, 1014, 1015, 1016, 1018, 900, 1019, 1049, 151, 384, 1061, 5, 1063, 1066, 1070     
      , 1071, 566, 1072, 900, 1073, 1076, 1077, 1078, 1082, 1083, 1094, 1095, 1097, 499       
      , 1100, 1103, 1106, 1108, 1109, 1110, 900, 1112, 766, 766, 1146, 1159, 900, 1164, 1166   
      , 1168, 1168, 1169, 1172, 709, 1203, 1234, 1263, 1292, 1293, 1295, 1296, 1297, 1298     
      , 1299, 1300, 900, 1301, 1306, 904, 869, 869, 1302, 1304, 942, 1306, 1, 3, 6, 8, 11, 14     
      , 17, 20, 23, 32, 42, 52, 56, 66, 71, 76, 86, 96, 106, 116, 120, 123, 126, 129, 132, 135      
      , 137, 140, 147, 149, 154, 158, 161, 164, 167, 170, 172, 175, 178, 181, 184, 188, 191      
      , 196, 206, 208, 211, 221, 225, 227, 229, 239, 243, 247, 255, 257, 267, 269, 272, 275      
      , 278, 281, 286, 290, 293, 296, 299, 301, 303, 305, 310, 312, 314, 317, 320, 322, 324      
      , 326, 328, 331, 333, 336, 338, 348, 350, 352, 354, 356, 358, 360, 362, 364, 366, 368      
      , 370, 372, 374, 376, 378, 380, 382, 384, 386, 388, 390, 393, 403, 413, 418, 428, 433      
      , 443, 448, 453, 458, 463, 468, 473, 475, 491, 494, 496, 499, 507, 510, 513, 516, 518      
      , 521, 523, 526, 529, 531, 533, 535, 538, 541, 546, 549, 552, 555, 559, 563, 566, 570      
      , 573, 576, 578, 581, 584, 587, 590, 593, 596, 600, 603, 606, 611, 616, 621, 628, 631      
      , 636, 639, 649, 656, 666, 668, 671, 674, 677, 680, 685, 690, 695, 700, 705, 710, 713      
      , 716, 719, 721, 723, 725, 728, 735, 739, 749, 759, 762, 765, 770, 775, 781, 786, 791      
      , 794, 796, 801, 806, 808, 814, 816, 819, 821, 823, 826, 831, 841, 844, 847, 852, 854      
      , 856, 860, 869, 874, 883, 888, 893, 898, 901, 904, 907, 917, 1032, 1032, 1032, 1032      
      , 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032    
      , 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032    
      , 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032    
      , 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1040, 1032, 1032, 1032, 1032, 1032    
      , 1032, 1040, 1040, 1040, 1032, 1032, 1032, 1032, 1032, 1040, 1040, 1032, 1032, 1040    
      , 1040, 1040, 1040, 1040, 1040, 1040, 1040, 1032, 1032, 1032, 1032, 1032, 1032, 1032    
      , 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032    
      , 1032, 1032, 1032, 1032, 1032, 1032, 1040, 1032, 1032, 1032, 1032, 1032, 1032, 1104    
      , 1032, 1032, 1040, 1032, 1040, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032, 1032    
      , 1032, 1104, 1104, 1032, 1104, 1032, 1032, 1032, 1032, 1032, 1104, 1032, 1032, 1032    
      , 1, 2, 2, 3, 3, 3, 3, 3, 59, 59, 67, 67, 67, 67, 71, 71, 73, 74, 74, 74, 75, 75, 76, 76, 76, 76    
      , 77, 74, 77, 77, 77, 77, 78, 78, 78, 84, 84, 89, 89, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91     
      , 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91     
      , 91, 91, 91, 91, 91, 98, 98, 99, 99, 100, 100, 100, 100, 100, 100, 100, 100, 100, 105, 105   
      , 106, 106, 106, 106, 115, 115, 117, 117, 128, 128, 128, 128, 128, 128, 128, 128, 135      
      , 135, 135, 135, 135, 136, 136, 138, 138, 142, 142, 142, 144, 144, 144, 144, 144, 144      
      , 147, 147, 148, 148, 150, 150, 150, 150, 150, 160, 160, 162, 162, 163, 164, 164, 165      
      , 166, 166, 166, 166, 166, 166, 166, 166, 167, 168, 168, 171, 171, 173, 173, 174, 174      
      , 175, 175, 176, 176, 177, 177, 177, 179, 180, 180, 181, 181, 181, 183, 185, 186, 187      
      , 187, 192, 192, 194, 194, 194, 194, 194, 204, 204, 204, 204, 212, 213, 213, 215, 215      
      , 215, 215, 215, 215, 215, 228, 228, 228, 228, 228, 228, 231, 231, 231, 239, 262, 271      
      , 275, 279, 283, 287, 310, 341, 368, 396, 427, 427, 477, 477, 555, 583, 584, 584, 584      
      , 584, 584, 600, 600, 600, 600, 600, 601, 601, 602, 602, 602, 602, 603, 604, 604, 607      
      , 607, 607, 608, 609, 613, 613, 616, 616, 621, 621, 637, 637, 648, 648, 648, 650, 650      
      , 653, 654, 654, 654, 654, 656, 656, 657, 657, 657, 657, 657, 660, 660, 663, 663, 663      
      , 663, 663, 666, 666, 667, 667, 668, 668, 670, 670, 672, 672, 673, 674, 677, 677, 677      
      , 682, 682, 683, 684, 685, 686, 687, 687, 687, 687, 687, 688, 701, 701, 702, 702, 702      
      , 702, 702, 702, 702, 702, 702, 703, 704, 705, 705, 705, 706, 706, 706, 707, 710, 710      
      , 711, 713, 716, 716, 716, 716, 718, 719, 719, 720, 720, 721, 722, 723, 723, 725, 725      
      , 727, 728, 728, 729, 730, 730, 730, 731, 732, 735, 735, 736, 737, 737, 740, 740, 741      
      , 741, 741, 743, 743, 743, 743, 743, 744, 744, 745, 745, 745, 747, 747, 747, 747, 747      
      , 750, 750, 755, 759, 759, 759, 765, 765, 765, 765, 765, 766, 766, 767, 767, 774, 774      
      , 779, 779, 782, 782, 782, 782, 782, 782, 782, 782, 782, 782, 782, 782, 786, 786, 786      
      , 787, 787, 787, 787, 787, 789, 790, 790, 791, 791, 791, 791, 793, 793, 804, 804, 804      
      , 810, 810, 811, 811, 812, 813, 813, 813, 813, 814, 814, 814, 815, 815, 815, 816, 816      
      , 816, 817, 818, 818)
if SANITY_CHECK and len(INDEX1) != MAXSp + 1:
    print('Bad INDEX1', file=sys.stderr)
    sys.exit(1)

INDEX2 = (0, 2, 1, 11, 1, 14, 14, 14, 13, 14, 1, 30, 1      
      , 2, 2, 2, 2, 33, 33, 3, 33, 2, 16, 2, 4, 33, 33, 33, 33, 3, 13, 13, 13, 13, 13, 1, 13, 26, 1, 1     
      , 17, 3, 11, 11, 11, 1, 11, 1, 2, 1, 1, 1, 1, 1, 11, 11, 11, 11, 1, 3, 13, 8, 38, 1, 1, 1, 1, 13, 33   
      , 3, 1, 1, 1, 1, 1, 33, 3, 3, 7, 1, 33, 1, 13, 14, 1, 13, 5, 1, 13, 1, 16, 1, 3, 13, 13, 13, 3, 1, 1    
      , 1, 2, 17, 1, 1, 1, 1, 13, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 13, 1, 1, 1, 1, 1, 13, 1, 13, 1, 1, 1, 1, 1, 2   
      , 34, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 29, 1, 1, 1, 1, 1, 1, 7, 11, 10, 2, 9, 8, 1, 2, 1, 1, 1, 1, 1, 1    
      , 1, 1, 29, 1, 1, 1, 1, 1, 13, 2, 1, 1, 2, 1, 1, 1, 1, 1, 4, 1, 4, 11, 33, 33, 16, 33, 16, 33, 16, 17   
      , 17, 14, 14, 3, 14, 1, 1, 1, 1, 1, 1, 13, 1, 1, 1, 1, 1, 4, 2, 9, 1, 1, 8, 4, 1, 6, 4, 1, 2, 2, 2, 7, 2   
      , 2, 7, 2, 3, 3, 2, 3, 2, 2, 1, 1, 1, 1, 1, 13, 28, 1, 1, 1, 2, 1, 3, 2, 7, 3, 8, 2, 1, 1, 3, 5, 1, 1, 1    
      , 1, 9, 4, 2, 1, 2, 1, 15, 2, 5, 4, 9, 3, 3, 5, 3, 3, 10, 5, 3, 3, 3, 2, 2, 2, 2, 2, 3, 4, 2, 3, 3, 3, 3    
      , 3, 2, 3, 2, 2, 3, 2, 3, 3, 2, 3, 1, 2, 2, 2, 2, 2, 28, 1, 1, 28, 1, 2, 28, 2, 2, 15, 1, 2, 1, 1, 28     
      , 12, 33, 26, 39, 1, 1, 14, 23, 1, 1, 2, 2, 29, 29, 29, 29, 29, 4, 1, 1, 1, 1, 13, 13, 2, 1, 2, 2, 2   
      , 1, 2, 1, 2, 17, 1, 3, 33, 16, 2, 3, 1, 1, 1, 1, 14, 1, 1, 2, 1, 4, 30, 12, 16, 17, 2, 13, 3, 4, 1, 1   
      , 5, 1, 4, 3, 1, 1, 4, 1, 11, 1, 2, 3, 2, 3, 3, 2, 1, 1, 2, 4, 34, 12, 12, 13, 5, 4, 2, 2, 1, 1, 3, 31    
      , 28, 31, 29, 29, 1, 2, 1, 1, 1, 1, 1, 1, 4, 1, 14, 1, 2, 2, 2, 2, 33, 14, 2, 3, 2, 3, 3, 3, 3, 3, 9     
      , 10, 10, 4, 10, 5, 5, 10, 10, 10, 10, 4, 3, 3, 3, 3, 3, 2, 3, 7, 2, 5, 4, 3, 3, 3, 3, 2, 3, 3, 3, 3, 4   
      , 3, 5, 10, 2, 3, 10, 4, 2, 2, 10, 4, 4, 8, 2, 10, 2, 3, 3, 3, 3, 5, 4, 3, 3, 3, 2, 2, 2, 5, 2, 2, 3, 3    
      , 2, 2, 2, 2, 3, 2, 3, 2, 10, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 10, 10, 5   
      , 10, 5, 10, 5, 5, 5, 5, 5, 5, 2, 16, 3, 2, 3, 8, 3, 3, 3, 2, 3, 2, 3, 3, 2, 2, 2, 3, 3, 5, 3, 3, 3, 4, 4   
      , 3, 4, 3, 3, 2, 3, 3, 3, 3, 3, 3, 4, 3, 3, 5, 5, 5, 7, 3, 5, 3, 10, 7, 10, 2, 3, 3, 3, 3, 5, 5, 5, 5, 5    
      , 5, 3, 3, 3, 2, 2, 2, 3, 7, 4, 10, 10, 3, 3, 5, 5, 6, 5, 5, 3, 2, 5, 5, 2, 6, 2, 3, 2, 2, 3, 5, 10, 3, 3   
      , 5, 2, 2, 4, 9, 5, 9, 5, 5, 5, 3, 3, 3, 10, 3, 3, 5, 6, 7, 8, 9, 11, 17, 18, 19, 20, 22, 24, 25, 26    
      , 27, 28, 29, 30, 31, 32, 33, 34, 36, 37, 40, 41, 42, 43, 44, 46, 54, 55, 56, 57, 59, 60, 61     
      , 62, 65, 67, 68, 69, 75, 80, 82, 83, 85, 88, 90, 92, 93, 94, 95, 98, 100, 101, 103, 105, 106   
      , 117, 120, 121, 122, 123, 124, 125, 132, 133, 141, 148, 158, 160, 161, 163, 169, 170      
      , 178, 180, 181, 182, 183, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196      
      , 197, 199, 206, 242, 263, 269, 313, 316, 319, 322, 327, 329, 330, 331, 332, 334, 340      
      , 341, 342, 343, 344, 345, 350, 351, 353, 354, 358, 361, 363, 364, 365, 372, 378, 380      
      , 381, 383, 384, 390, 407, 408, 413, 419, 420, 421, 422, 423, 432, 434, 440, 441, 1, 0, 1    
      , 0, 1, 1, 2, 2, 0, 2, 0, 2, 2, 1, 0, 2, 0, 2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 3, 0, 1, 1, 0, 1, 0, 0, 0    
      , 0, 1, 1, 1, 2, 1, 2, 3, 0, 1, 4, 5, 8, 1, 2, 2, 1, 1, 1, 1, 3, 3, 3, 2, 3, 3, 1, 2, 4, 5, 1, 2, 1, 3, 1    
      , 3, 3, 1, 3, 1, 2, 0, 0, 0, 0, 0, 0, 2, 0, 3, 2, 3, 0, 1, 0, 2, 1, 3, 0, 2, 0, 2, 0, 1, 0, 0, 1, 1, 1, 1    
      , 2, 2, 2, 2, 2, 0, 2, 0, 2, 2, 3, 0, 0, 0, 0, 3, 3, 2, 0, 1, 0, 0, 0, 2, 2, 2, 2, 2, 2, 1, 1, 2, 2, 2, 0    
      , 1, 2, 3, 2, 3, 1, 1, 1, 4, 0, 0, 1, 1, 2, 1, 0, 2, 1, 3, 2, 3, 0, 1, 1, 2, 3, 3, 1, 1, 1, 3, 2, 1, 0, 2    
      , 0, 2, 0, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 2, 0, 0, 0, 0, 2, 0, 3, 0, 0, 0, 0, 0, 0, 3, 0, 3, 0, 2, 2, 2, 2    
      , 2, 1, 2, 2, 2, 2, 0, 2, 0, 1, 2, 0, 1, 0, 1, 1, 0, 1, 4, 1, 1, 1, 0, 1, 0, 0, 1, 2, 1, 0, 0, 0, 2, 2, 0    
      , 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 7, 0, 1, 4, 0, 0, 0, 0, 0, 3, 1, 0, 0, 0, 0, 0, 4, 3, 3, 3, 3, 3, 1, 2    
      , 1, 2, 0, 0, 0, 0, 3, 3, 3, 3, 0, 0, 1, 2, 1, 2, 2, 2, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0    
      , 1, 1, 1, 0, 0, 1, 0, 0, 1, 2, 0, 2, 1, 0, 0, 1, 0, 5, 3, 0, 3, 0, 2, 2, 2, 0, 2, 0, 1, 1, 0, 1, 2, 2, 3    
      , 3, 1, 1, 1, 2, 2, 0, 1, 0, 1, 1, 0, 0, 2, 0, 0, 0, 0, 1, 2, 0, 1, 0, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 1, 2    
      , 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 3, 0, 0, 2, 2, 0, 3, 1, 1, 2, 0, 1, 1, 2, 0, 1, 1, 2    
      , 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 2, 0, 1, 2, 2, 2, 0, 4, 1, 0, 0, 1, 2, 2, 0, 1, 1, 1)
if SANITY_CHECK and len(INDEX2) != MAXSp + 1:
    print('Bad INDEX2', file=sys.stderr)
    sys.exit(1)

CHARTYPE = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13, 4, 3, 3, 3, 7, 3, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 3, 8, 3, 3, 3, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 12, 0, 3,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 5, 3, 11, 0, 2, 2, 2, 2, 2, 2,
      2, 2, 2, 0, 10, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 10, 0, 0, 0,
      0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0,
      0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2,
      2, 2, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 9, 0)
if SANITY_CHECK and len(CHARTYPE) != 255 + 1:
    print('Bad CHARTYPE', file=sys.stderr)
    sys.exit(1)

TX = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 7, 8, 9, 10, 11, 12, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14, 0, 0, 15, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 17, 18, 0, 19, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
if SANITY_CHECK and len(TX) != 255 + 1:
    print('Bad TX', file=sys.stderr)
    sys.exit(1)

LETTER_OR_DIGIT = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,
      1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0,
      0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1,
      1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0,
      0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0)
if SANITY_CHECK and len(LETTER_OR_DIGIT) != 255 + 1:
    print('Bad LETTER_OR_DIGIT', file=sys.stderr)
    sys.exit(1)

SET_CONTEXT = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 1, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 11, 0, 1, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 5, 1, 0, 0, 0, 0, 8, 0, 1,
      0, 6, 0, 4, 0, 0, 1, 0, 0, 6, 0, 1, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0)
if SANITY_CHECK and len(SET_CONTEXT) != NT + 1:
    print('Bad SET_CONTEXT', file=sys.stderr)
    sys.exit(1)

ARITH_FUNC_TOKEN = 130
ARITH_TOKEN = 126
BIT_FUNC_TOKEN = 127
BIT_TOKEN = 110
CHARACTER_STRING = 132
CHAR_FUNC_TOKEN = 129
CHAR_TOKEN = 116
COMMA = 14
CONCATENATE = 20
CPD_NUMBER = 137
CROSS_TOKEN = 8
DECLARE_TOKEN = 103
DOLLAR = 7
DOT_TOKEN = 1
DO_TOKEN = 24
EOFILE = 31
EVENT_TOKEN = 128
EXPONENTIATE = 21
FACTOR = 156
ID_TOKEN = 131
LABEL_DEFINITION = 291
LAB_TOKEN = 98
LEFT_PAREN = 3
LEVEL = 99
NO_ARG_ARITH_FUNC = 141
NO_ARG_BIT_FUNC = 138
NO_ARG_CHAR_FUNC = 140
NO_ARG_STRUCT_FUNC = 142
NUMBER = 136
REPLACE_TEXT = 76
REPLACE_TOKEN = 109
RT_PAREN = 9
SEMI_COLON = 10
STRUCTURE_WORD = 123
STRUCT_FUNC_TOKEN = 133
STRUCT_TEMPLATE = 139
EXPONENT = 144
STRUC_TOKEN = 135
PERCENT_MACRO = 134
TEMPORARY = 124
EQUATE_TOKEN = 82

RESERVED_LIMIT = 9
IF_TOKEN = 26
SUB_START_TOKEN = 206

# DECLARATIONS FOR THE SCANNER

# TOKEN IS THE INDEX INTO THE VOCABULARY V() OF THE LAST SYMBOL SCANNED,
#   BCD IS THE LAST SYMBOL SCANNED (LITERAL CHARACTER STRING).
TOKEN = -1
BCD = ''
CLOSE_BCD = ''

EXPRESSION_CONTEXT = 1
DECLARE_CONTEXT = 5
PARM_CONTEXT = 6
ASSIGN_CONTEXT = 7
REPLACE_PARM_CONTEXT = 10
EQUATE_CONTEXT = 11
REPL_CONTEXT = 8

# SET UP SOME CONVENIENT ABBREVIATIONS FOR PRINTER CONTROL
PAGE = '1'


def EJECT_PAGE():
    OUTPUT(1, PAGE)


DOUBLE = '0'


def DOUBLE_SPACE():
    OUTPUT(1, DOUBLE)


PLUS = '+'
X70 = ' ' * 70
X256 = ' ' * 256

# CHARTYPE() IS USED TO DISTINGUISH CLASSES OF SYMBOLS IN THE SCANNER.
#   TX() IS A TABLE USED FOR TRANSLATING FROM ONE CHARACTER SET TO ANOTHER.
#   LETTER_OR_DIGIT IS SIMILAR TO CHARTYPE() BUT IS USED IN SCANNING
#   IDENTIFIERS ONLY. 

ERROR_COUNT = 0
MAX_SEVERITY = 0
STATEMENT_SEVERITY = -1
VALUE = 0

# DECLARATIONS FOR MACRO PROCESSING
MACRO_EXPAN_LIMIT = 8
MAX_PARAMETER = 12
PARM_EXPAN_LIMIT = 8
MACRO_EXPAN_LEVEL = 0
OLD_PR_PTR = 0
MACRO_CELL_LIM = 1000
M_TOKENS = [2] * (MACRO_EXPAN_LIMIT + 1)
OLD_MEL = 0
NEW_MEL = 0
TEMP_INDEX = 0
PARM_COUNT = 0
OLD_PEL = 0
MACRO_NAME = ''
TEMP_STRING = ''
MACRO_EXPAN_STACK = [0] * (MACRO_EXPAN_LIMIT + 1)
BASE_PARM_LEVEL = [0] * (MACRO_EXPAN_LIMIT + 1)
NUM_OF_PARM = [0] * (MACRO_EXPAN_LIMIT + 1)
M_BLANK_COUNT = [0] * (MACRO_EXPAN_LIMIT + 1)
M_CENT = [0] * (MACRO_EXPAN_LIMIT + 1)
P_CENT = [0] * (PARM_EXPAN_LIMIT + 1)
MAC_NUM = 0
MACRO_ARG_COUNT = 0
FIRST_TIME = [1] * 9 + [0] * (MACRO_EXPAN_LIMIT - 9 + 1)
FOUND_CENT = 0
MACRO_POINT = 0
OLD_MP = 0
M_P = [0] * (MACRO_EXPAN_LIMIT + 1)
MACRO_CALL_PARM_TABLE = [''] * (MACRO_EXPAN_LIMIT * MAX_PARAMETER + 1)
PARM_STACK_PTR = [0] * (PARM_EXPAN_LIMIT + 1)
PARM_REPLACE_PTR = [0] * (PARM_EXPAN_LIMIT + 1)
TOP_OF_PARM_STACK = 0
PARM_EXPAN_LEVEL = 0
ONE_BYTE = ''
SOME_BCD = ''
PASS = 0
RESTORE = 0
M_PRINT = [0] * (MACRO_EXPAN_LIMIT + 1)
T_INDEX = 0
START_POINT = 0
FIRST_TIME_PARM = [1] * 9 + [0] * (PARM_EXPAN_LIMIT - 9 + 1)
DONT_SET_WAIT = 0
MAC_XREF = [0] * (MACRO_EXPAN_LIMIT + 1)
MAC_CTR = -1
SAVE_PE = 0
OLD_TOPS = 0
SUPPRESS_THIS_TOKEN_ONLY = 0
MACRO_FOUND = 0
MACRO_ADDR = 0
MACRO_TEXT_LIM = 0
REPLACE_TEXT_PTR = 0


class macro_texts:

    def __init__(self):
        self.MAC_TXT = 0


MACRO_TEXTS = []  # Elements are macro_texts class objects.
        
COMPILING = 0
RECOVERING = 0
S = ''  # A TEMPORARY USED VARIOUS PLACES
C = [''] * 3  # TEMPORARIES USED VARIOUS PLACES
CURRENT_SCOPE = ''

CONTEXT = 0
PROCMARK = 0
REGULAR_PROCMARK = 0
MAIN_SCOPE = 0
DO_INIT = 0
IMPLIED_TYPE = 0

SYTSIZE = 0
XREF_LIM = 0


class link_sort:

    def __init__(self):
        self.SYM_HASHLINK = 0
        self.SYM_SORT = 0


LINK_SORT = []  # Elements are link_sort class objects.

PHASE1_FREESIZE = 0

BIT_TYPE = 1
CHAR_TYPE = 2
MAT_TYPE = 3
VEC_TYPE = 4
SCALAR_TYPE = 5
INT_TYPE = 6
IORS_TYPE = 8
EVENT_TYPE = 9
MAJ_STRUC = 10
ANY_TYPE = 11

TEMPL_NAME = 0x3E
STMT_LABEL = 0x42
UNSPEC_LABEL = 0x43
IND_CALL_LAB = 0x45
CALLED_LABEL = 0x46
PROC_LABEL = 0x47
TASK_LABEL = 0x48
PROG_LABEL = 0x49
COMPOOL_LABEL = 0x4A
EQUATE_LABEL = 0x4B


class init_apgarea:

    def __init__(self):
        self.AREAPG = [0] * 1260


INIT_APGAREA = []  # Elements are init_apgarea class objects.


class init_afcbarea:

    def __init__(self):
        self.AREAFCB = [0] * 128


INIT_AFCBAREA = []  # Elements are init_afcbarea class objects.


class save_patch:

    def __init__(self):
        self.SAVE_LINE = ''


SAVE_PATCH = []  # Elements are save_patch class objeccts


def PATCHSAVE(n, value=None):
    global SAVE_PATCH
    if value == None:
        return SAVE_PATCH[n].SAVE_LINE[:]
    SAVE_PATCH[n].SAVE_LINE = value[:]


# COMM EQUAIVALENCES
def LIT_CHAR_AD(value=None):
    addr = 0
    if value == None:
        return h.COMM[addr]
    h.COMM[addr] = value


def LIT_CHAR_USED(value=None):
    addr = 1
    if value == None:
        return h.COMM[addr]
    h.COMM[addr] = value


def LIT_TOP(value=None):
    addr = 2
    if value == None:
        return h.COMM[addr]
    h.COMM[addr] = value


def STMT_NUM(value=None):
    addr = 3
    if value == None:
        return h.COMM[addr]
    h.COMM[addr] = value


def FL_NO(value=None):
    addr = 4
    if value == None:
        return h.COMM[addr]
    h.COMM[addr] = value


def MAX_SCOPEp(value=None):
    addr = 5
    if value == None:
        return h.COMM[addr]
    h.COMM[addr] = value


def TOGGLE(value=None):
    addr = 6
    if value == None:
        return h.COMM[addr]
    h.COMM[addr] = value


def OPTIONS_CODE(value=None):
    addr = 7
    if value == None:
        return h.COMM[addr]
    h.COMM[addr] = value


def XREF_INDEX(value=None):
    addr = 8
    if value == None:
        return h.COMM[addr]
    h.COMM[addr] = value


def FIRST_FREE(value=None):
    addr = 9
    if value == None:
        return h.COMM[addr]
    h.COMM[addr] = value


def NDECSY(value=None):
    addr = 10
    if value == None:
        return h.COMM[addr]
    h.COMM[addr] = value


def FIRST_STMT(value=None):
    addr = 11
    if value == None:
        return h.COMM[addr]
    h.COMM[addr] = value


def TIME_OF_COMPILATION(value=None):
    addr = 12
    if value == None:
        return h.COMM[addr]
    h.COMM[addr] = value


def DATE_OF_COMPILATION(value=None):
    addr = 13
    if value == None:
        return h.COMM[addr]
    h.COMM[addr] = value


def INCLUDE_LIST_HEAD(value=None):
    addr = 14
    if value == None:
        return h.COMM[addr]
    h.COMM[addr] = value


def MACRO_BYTES(value=None):
    addr = 15
    if value == None:
        return h.COMM[addr]
    h.COMM[addr] = value


def STMT_DATA_HEAD(value=None):
    addr = 16
    if value == None:
        return h.COMM[addr]
    h.COMM[addr] = value


def BLOCK_SRN_DATA(value=None):
    addr = 18
    if value == None:
        return h.COMM[addr]
    h.COMM[addr] = value


SRN_BLOCK_RECORD = []  # Dynamically allocated list.


def COMSUB_END(value=None):
    addr = 17
    if value == None:
        return h.COMM[addr]
    h.COMM[addr] = value


VAR_CLASS = 1
LABEL_CLASS = 2
FUNC_CLASS = 3
REPL_ARG_CLASS = 5
REPL_CLASS = 6
TEMPLATE_CLASS = 7  # DONT REORDER ANY CLASSES
TPL_LAB_CLASS = 8  # BECAUSE OF SNEAKY
TPL_FUNC_CLASS = 9  # INDEXING


# VAR_CLASS through TPL_FUNC_CLASS are sometimes accessed in the XPL source 
# as an array called VAR_CLASS() with subscripts of 0 through 7.  I replace 
# that usage with a function:
def VAR_CLASSf(cl):
    if cl == 0: return VAR_CLASS;
    elif cl == 1: return LABEL_CLASS;
    elif cl == 2: return FUNC_CLASS;
    elif cl == 3: return REPL_ARG_CLASS;
    elif cl == 4: return REPL_CLASS;
    elif cl == 5: return TEMPLATE_CLASS;
    elif cl == 6: return TPL_LAB_CLASS;
    elif cl == 7: return TPL_FUNC_CLASS;
    print("Implementation error in VAR_CLASS(CLASS) (CLASS=%d)" % cl, \
          file=sys.stderr)
    sys.exit(1)


SCOPEp = 0
KIN = 0
QUALIFICATION = 0
SYT_INDEX = 0

X32 = ' ' * 32

SYT_HASHSIZE = 997
SYT_HASHSTART = [0] * (SYT_HASHSIZE + 1)

NEST_LIM = 16
NEST = 0

DEFAULT_TYPE = 5  # SCALAR
DEF_BIT_LENGTH = 1  # BOOLEAN
DEF_CHAR_LENGTH = 8
DEF_MAT_LENGTH = 0x0303
DEF_VEC_LENGTH = 3
DEFAULT_ATTR = 0x00800208

BLOCK_MODE = [0] * (NEST_LIM + 1)
BLOCK_SYTREF = [0] * (NEST_LIM + 1)
EXTERNAL_MODE = 0
PROC_MODE = 1
FUNC_MODE = 2
CMPL_MODE = 3
PROG_MODE = 4
TASK_MODE = 5
UPDATE_MODE = 6
INLINE_MODE = 7

HOST_BIT_LENGTH_LIM = 32  # FOR 360/370
BIT_LENGTH_LIM = HOST_BIT_LENGTH_LIM
CHAR_LENGTH_LIM = 255
VEC_LENGTH_LIM = 64
MAT_DIM_LIM = 64
ARRAY_DIM_LIM = 32767
N_DIM_LIM = 3
N_DIM_LIM_PLUS_1 = 4

PROCMARK_STACK = [0] * (NEST_LIM + 1)

SCOPEp_STACK = [0] * (NEST_LIM + 1)

INDENT_STACK = [0] * (NEST_LIM + 1)
NEST_LEVEL = 0
NEST_STACK = [0] * (NEST_LIM + 1)
FACTORING = 1
EXP_OVERFLOW = 0
FACTOR_LIM = 19
# FACTOR_LIM IS USED IN A LOOP IN SYNTHESIS
# AND IN RECOVER TO SET THE NEXT TWO DECLARES.  SO,
# THOSE DECLARES MUST PARALLEL EACH OTHER (I.E. THERE MUST
# BE A 'FACTORED_XXX' FOR EVERY 'XXX'), AND FACTOR_LIM
# MUST BE THE TOTAL NUMBER OF FIXED VARIABLES IN EACH
# DECLARE.
#
# ALSO, IF FACTORED_ATTRIBUTES2 IS TO BE USED FOR
# ANYTHING, YOU SHOULD CHECK MODULE CHECKCO2
# TO SEE IF A CHECK FOR CONFLICT NEEDS TO BE ADDED
# TO THAT MODULE.  IT WAS NOT NECESSARY FOR DR109024

'''
So, here's an apparent load of undocumented hilarity ....  On the face of it,
it *appears* as though the 20 values consisting of TYPE, ..., N_DIM plus 
S_ARRAY are independent of each other, as are the 20 values FACTORED_TYPE, ...,
FACTORED_N_DIM plus FACTORED_S_ARRAY.  And for the most part, they are.  But
*sometimes* the code treats TYPE as a 20-element array and FACTORED_TYPE as
another 20-element array.  The elements of the type array are themselves
TYPE (unindexed), BIT_LENGTH, ..., N_DIM, S_ARRAY[0], ..., S_ARRAY[3].  And
so on.  Fun, right?  Hilarious!  Well, there's no way I know of to handle this
cleanly in Python.  Fortunately, the usage as an array appears to occur only
within a couple of loops in the SYNTHESI and RECOVER modules that reinitialize
all of the variables to 0.  I handle this by coding the reinitialization as
non-array operations in SYNTHESI and RECOVER -- actually, I just cut-and-past
the code below into those modules -- so there's no need to make any other
special provisions for this dual-usage nonsense.

One case that can't be handled so congenially as that is for the ridiculous 
usage TYPE(TYPE), for which I introduce a new function, TYPEf(), used only in
the form TYPEf(TYPE).
'''

TYPE = 0
BIT_LENGTH = 0
CHAR_LENGTH = 0
MAT_LENGTH = 0
VEC_LENGTH = 0
ATTRIBUTES = 0
ATTRIBUTES2 = 0
ATTR_MASK = 0
STRUC_PTR = 0
STRUC_DIM = 0
CLASS = 0
NONHAL = 0
LOCKp = 0
IC_PTR = 0
IC_FND = 0
N_DIM = 0
S_ARRAY = [0] * (N_DIM_LIM + 1)


def TYPEf(t, value=None):
    global TYPE, BIT_LENGTH, CHAR_LENGTH, MAT_LENGTH, VEC_LENGTH, ATTRIBUTES, \
            ATTRIBUTES2, ATTR_MASK, STRUC_PTR, STRUC_DIM, CLASS, NONHAL, \
            LOCKp, IC_PTR, IC_FND, N_DIM, S_ARRAY
    if t < 0 or t > 16 + N_DIM_LIM:
        print("Implementation error in TYPE(TYPE) (TYPE=%d)" % t, \
              file=sys.stderr)
        sys.exit(1)
    if value == None:
        if   t == 0: return TYPE;
        elif t == 1: return BIT_LENGTH;
        elif t == 2: return CHAR_LENGTH;
        elif t == 3: return MAT_LENGTH;
        elif t == 4: return VEC_LENGTH;
        elif t == 5: return ATTRIBUTES;
        elif t == 6: return ATTRIBUTES2;
        elif t == 7: return ATTR_MASK;
        elif t == 8: return STRUC_PTR;
        elif t == 9: return STRUC_DIM;
        elif t == 10: return CLASS;
        elif t == 11: return NONHAL;
        elif t == 12: return LOCKp;
        elif t == 13: return IC_PTR;
        elif t == 14: return IC_FND;
        elif t == 15: return N_DIM;
        return S_ARRAY[t - 16];
    if   t == 0: TYPE = value;
    elif t == 1: BIT_LENGTH = value;
    elif t == 2: CHAR_LENGTH = value;
    elif t == 3: MAT_LENGTH = value;
    elif t == 4: VEC_LENGTH = value;
    elif t == 5: ATTRIBUTES = value;
    elif t == 6: ATTRIBUTES2 = value;
    elif t == 7: ATTR_MASK = value;
    elif t == 8: STRUC_PTR = value;
    elif t == 9: STRUC_DIM = value;
    elif t == 10: CLASS = value;
    elif t == 11: NONHAL = value;
    elif t == 12: LOCKp = value;
    elif t == 13: IC_PTR = value;
    elif t == 14: IC_FND = value;
    elif t == 15: N_DIM = value;
    else:
        S_ARRAY[t - 16] = value;


FACTORED_TYPE = 0
FACTORED_BIT_LENGTH = 0
FACTORED_CHAR_LENGTH = 0
FACTORED_MAT_LENGTH = 0
FACTORED_VEC_LENGTH = 0
FACTORED_ATTRIBUTES = 0
FACTORED_ATTRIBUTES2 = 0
FACTORED_ATTR_MASK = 0
FACTORED_STRUC_PTR = 0
FACTORED_STRUC_DIM = 0
FACTORED_CLASS = 0
FACTORED_NONHAL = 0
FACTORED_LOCKp = 0
FACTORED_IC_PTR = 0
FACTORED_IC_FND = 0
FACTORED_N_DIM = 0
FACTORED_S_ARRAY = [0] * (N_DIM_LIM + 1)

LOCK_LIM = 15
ASSIGN_ARG_LIST = 0
EXT_ARRAY_PTR = 1
STRUC_SIZE = 0
STARRED_DIMS = 0

# THE FOLLOWING ARE USED IN PARSING PRODUCTS
TERMP = 0
PP = 0
PPTEMP = 0
BEGINP = 0
SCALARP = 0
VECTORP = 0
MATRIXP = 0
MATRIX_PASSED = 0
CROSS_COUNT = 0
DOT_COUNT = 0
SCALAR_COUNT = 0
VECTOR_COUNT = 0
MATRIX_COUNT = 0
CROSS = 10
DOT = 11
CONTROL = [0] * (16 + 1)  # INPUT CONTROLABLE SWITCHES
if debug3:
    # Enable various debugging messages from the compiler.  Note that these
    # would *normally* be set within the HAL/S program itself, as described
    # in section 2.2.7 ("Debugging Aids") of the "HAL/S-FC & HAL/S-360
    # Compiler System Program Description", but I'm turning them on here via
    # command-line switches.
    CONTROL[0x00] = -1  # Interlist HALMAT in the primary listing
    CONTROL[0x03] = -1  # Phase 1 identifier trace
    CONTROL[0x04] = -1  # Phase 1 token trace
    CONTROL[0x08] = -1  # Phase 1 production trace
    # CONTROL[0x0B] = -1 # Print Phase 1 HALMAT by block.
    # CONTROL[0x0C] = -1  # Print Phase 1 state trace
    CONTROL[0x0D] = -1  # Standard Phase 1 listing
    CONTROL[0x0E] = -1  # Print literal table from Phase 1
XREF_FULL = 0
XREF_MASK = 0x1FFF
XREF_ASSIGN = 0x8000
XREF_REF = 0x4000
XREF_SUBSCR = 0x2000
OUTER_REF_LIM = 0
OUTER_REF_MAX = 0
OUTER_REF_INDEX = 0
PAGE_THROWN = 1  # PREVENT NEW PAGE ON PROG DEF


class outer_ref_table:

    def __init__(self):
        self.OUT_REF = 0
        self.OUT_REF_FLAGS = 0


OUTER_REF_TABLE = []  # Elements are outer_ref_table class objects.

OUTER_REF_PTR = [0] * (NEST_LIM + 1)
PROGRAM_LAYOUT_LIM = 255
PROGRAM_LAYOUT_INDEX = 0
PROGRAM_LAYOUT = [0] * (PROGRAM_LAYOUT_LIM + 1)
CASE_LEVEL_LIM = 10
CASE_STACK = [0] * (CASE_LEVEL_LIM + 1)
CASE_LEVEL = 0  # INITIALIZED TO -1 IN INITIALIZATION

ID_LOC = 0
REF_ID_LOC = 0

MAXSP = 0
REDUCTIONS = 0
SCAN_COUNT = 0
MAXNEST = 0
IDENT_COUNT = 0

# RECORD THE TIMES OF IMPORTANT POINTS DURING CHECKING
CLOCK = [0] * (5 + 1)

# COMMONLY USED STRINGS
X1 = ' ' * 1
X4 = ' ' * 4
X2 = ' ' * 2
X109 = ' ' * 109
PERIOD = '.'
SQUOTE = '\''

# TEMPORARIES USED THROUGHOUT THE COMPILER
I = 0
J = 0
K = 0
L = 0

TRUE = 1
FALSE = 0
# FOREVER

NO_LOOK_AHEAD_DONE = 0
# THE STACKS DECLARED BELOW ARE USED TO DRIVE THE SYNTACTIC
# ANALYSIS ALGORITHM AND STORE INFORMATION RELEVANT TO THE INTERPRETATION
# OF THE TEXT.  THE STACKS ARE ALL POINTED TO BY THE STACK POINTER SP.

STACKSIZE = 75  # SIZE OF STACK
PARSE_STACK = [0] * (STACKSIZE + 1)  # TOKENS OF THE PARTIALLY PARSED TEXT
LOOK = 0
LOOK_STACK = [0] * (STACKSIZE + 1)
STATE_STACK = [0] * (STACKSIZE + 1)
STATE = 0
VAR = [''] * (STACKSIZE + 1)
FIXV = [0] * (STACKSIZE + 1)
FIXL = [0] * (STACKSIZE + 1)
FIXF = [0] * (STACKSIZE + 1)
PTR = [0] * (STACKSIZE + 1)

# SP POINTS TO THE RIGHT END OF THE REDUCIBLE STRING IN THE PARSE STACK,
# MP POINTS TO THE LEFT END, AND  MPP1 = MP+1.
SP = 0
MP = 0
MPP1 = 0

NT_PLUS_1 = 0

SAVE_OVER_PUNCH = 0
SAVE_NEXT_CHAR = 0
OLD_LEVEL = 0
NEW_LEVEL = 0
NEXT_CHAR = 0
OVER_PUNCH = 0
TEMP1 = 0
TEMP2 = 0
TEMP3 = 0
EXP_TYPE = 0
BLANK_COUNT = 0
SAVE_BLANK_COUNT = 0
STRING_OVERFLOW = 0
LABEL_IMPLIED = 0
TEMPLATE_IMPLIED = 0
EQUATE_IMPLIED = 0
IMPLIED_UPDATE_LABEL = 0
NAME_HASH = 0
INLINE_LEVEL = 0
INLINE_LABEL = 0
MAX_STRUC_LEVEL = 5
OVER_PUNCH_SIZE = 4
ID_LIMIT = 32
MAX_STRING_SIZE = 256
OVER_PUNCH_TYPE = [0x40, 0x4B, 0x6B, 0x5C, 0x60, 0x40, 0x40,
                   0x40, 0x40, 0x40, 0x4E]
CARD_COUNT = 0
# DECLARE ALMOST_DISASTER LABEL;

# THE INDIRECT STACKS AND POINTER ARE DEFINED BELOW
PTR_MAX = STACKSIZE
INX = [0] * (PTR_MAX + 1)
LOC_P = [0] * (PTR_MAX + 1)
VAL_P = [0] * (PTR_MAX + 1)
EXT_P = [0] * (PTR_MAX + 1)
PSEUDO_TYPE = [0] * (PTR_MAX + 1)
PSEUDO_FORM = [0] * (PTR_MAX + 1)
PSEUDO_LENGTH = [0] * (PTR_MAX + 1)
PTR_TOP = 1  # 1ST ENTRY DUMMY,CONTAINS LAST PTR USED
MAX_PTR_TOP = 0
BI_LIMIT = 9
BIp = 63


def BI_XREF_CELL(value=None):
    global COMM
    if value == None:
        return COMM[29]
    COMM[29] = value


# LITERALS FOR SHAPING FUNCTION INDEXES INTO BI_XREF AND BI_XREF#
BIT_NDX = 57
SBIT_NDX = 58
INT_NDX = 59
SCLR_NDX = 60
VEC_NDX = 61
MTX_NDX = 62
CHAR_NDX = 63

SYT_MAX = 32765 - BIp
# THE SYMBOL TABLE IS INDEXED INTO BY A BIT(16), AND THE UPPER POSSI          
#   SYMBOL TABLE INDEXES ARE USED TO DISTINGUISH BUILT-IN FUNCTIONS
NEXTIME_LOC = 50
BI_FUNC_FLAG = 0
BI_INDEX = [0, 1, 1, 17, 28, 35, 44, 53, 54, 57]
BI_INFO = [
      0x00000000,  # UNUSED                                                  
      0x08010001,  # ABS                                                     
      0x05012709,  # COS                                                     
      0x0501000C,  # DET                                                     
      0x06020007,  # DIV                                                     
      0x05010909,  # EXP                                                     
      0x05014A09,  # LOG                                                     
      0x08010001,  # MAX                                                     
      0x08010001,  # MIN                                                     
      0x08020001,  # MOD                                                     
      0x01010007,  # ODD                                                     
      0x06020007,  # SHL                                                     
      0x06020007,  # SHR                                                     
      0x05012609,  # SIN                                                     
      0x08010001,  # SUM                                                     
      0x05012809,  # TAN                                                     
      0x01020003,  # XOR                                                     
      0x05010009,  # COSH                                                    
      0x06000100,  # DATE                                                    
      0x06000000,  # PRIO                                                    
      0x08010001,  # PROD                                                    
      0x08010001,  # SIGN                                                    
      0x05010009,  # SINH                                                    
      0x0601000D,  # SIZE                                                    
      0x05010B09,  # SQRT                                                    
      0x05010009,  # TANH                                                    
      0x02010005,  # TRIM                                                    
      0x0401000E,  # UNIT                                                    
      0x0501000E,  # ABVAL                                                   
      0x06010001,  # FLOOR                                                   
      0x06020005,  # INDEX                                                   
      0x02020006,  # LJUST                                                   
      0x02020006,  # RJUST                                                   
      0x06010001,  # ROUND                                                   
      0x0501000C,  # TRACE                                                   
      0x05010009,  # ARCCOS                                                  
      0x05010009,  # ARCSIN                                                  
      0x05010009,  # ARCTAN                                                  
      0x06000000,  # ERRGRP                                                  
      0x06000000,  # ERRNUM                                                  
      0x06010005,  # LENGTH                                                  
      0x05030009,  # MIDVAL                                                  
      0x05000000,  # RANDOM                                                  
      0x08010001,  # SIGNUM                                                  
      0x05010009,  # ARCCOSH                                                 
      0x05010009,  # ARCSINH                                                 
      0x05010009,  # ARCTANH                                                 
      0x05020009,  # ARCTAN2                                                 
      0x06010001,  # CEILING                                                 
      0x0301000C,  # INVERSE                                                 
      0x05010003,  # NEXTIME                                                 
      0x05000000,  # RANDOMG                                                 
      0x05000000,  # RUNTIME                                                 
      0x06010001,  # TRUNCATE                                                
      0x05000200,  # CLOCKTIME                                               
      0x06020007,  # REMAINDER                                               
      0x0301000C,  # TRANSPOSE
      0, 0, 0, 0, 0, 0, 0                                               
    ]
if SANITY_CHECK and len(BI_INFO) != BIp + 1:
    print('Bad BI_INFO', file=sys.stderr)
    sys.exit(1)
    
BI_ARG = [
      0,  # (0) UNUSED                                                    
      8,  # (1) IORS                                                      
      8,  # (2) IORS                                                      
      1,  # (3) BIT                                                       
      1,  # (4) BIT                                                       
      2,  # (5) CHARACTER                                                 
      2,  # (6) CHARACTER                                                 
      6,  # (7) INTEGER                                                   
      6,  # (8) INTEGER                                                   
      5,  # (9) SCALAR                                                    
      5,  # (A) SCALAR                                                    
      5,  # (B) SCALAR                                                    
      3,  # (C) MATRIX                                                    
      0xB,  # (D) ANY                                                       
      4  # (E) VECTOR                                                    
    ]
if SANITY_CHECK and len(BI_ARG) != 14 + 1:
    print('Bad BI_ARG', file=sys.stderr)
    sys.exit(1)
    
BI_FLAGS = [
      0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x20, 0x20, 0x00,  #  0- 9   
      0x00, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00, 0x10, 0x00,  # 10-19   
      0x20, 0x00, 0x00, 0x30, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  # 20-29   
      0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00,  # 30-39   
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40,  # 40-49   
      0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x80,  # 50-56   
      0, 0, 0, 0, 0, 0, 0
    ]
if SANITY_CHECK and len(BI_FLAGS) != BIp + 1:
    print('Bad BI_FLAGS', file=sys.stderr)
    sys.exit(1)
    
BI_XREF = [0] * (BIp + 1)
BI_XREFp = [0] * (BIp + 1)
# BI_LOC & BI_INDX WERE CREATED TO LOCATE THE BUILT-IN FUNCTION
# NAME IN BI_NAME. BI_NAME WAS CHANGED FROM A 63 STRING ARRAY TO
# A 3 STRING ARRAY BECAUSE PASS1 WAS CLOSE TO REACHING THE
# MAXIMUM NUMBER OF ALLOWABLE STRINGS.
BI_LOC = [0, 0, 10, 20, 30, 40, 50, 60, 70, 80, 90,
   100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 0, 10, 20, 30, 40, 50, 60,
   70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 0, 10, 20, 30,
   40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 0,
   10, 20]
if SANITY_CHECK and len(BI_LOC) != BIp + 1:
    print('Bad BI_LOC', file=sys.stderr)
    sys.exit(1)
BI_INDX = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
   0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
   1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3]
if SANITY_CHECK and len(BI_INDX) != BIp + 1:
    print('Bad BI_INDX', file=sys.stderr)
    sys.exit(1)
    
BI_NAME = [
       'ABS       COS       DET       DIV       EXP       LOG       MAX    ' + \
    '   MIN       MOD       ODD       SHL       SHR       SIN       SUM       TAN    ' + \
    '   XOR       COSH      DATE      PRIO      PROD      ',
       'SIGN      SINH      SIZE      SQRT      TANH      TRIM      UNIT      ABVAL  ' + \
    '   FLOOR     INDEX     LJUST     RJUST     ROUND     TRACE     ARCCOS    ARCSIN ' + \
    '   ARCTAN    ERRGRP    ERRNUM    LENGTH    ',
       'MIDVAL    RANDOM    SIGNUM    ARCCOSH   ARCSINH   ARCTANH   ARCTAN2   CEILING' + \
    '   INVERSE   NEXTIME   RANDOMG   RUNTIME   TRUNCATE  CLOCKTIME REMAINDER TRANSPO' + \
    'SE BIT       SUBBIT    INTEGER   SCALAR    ',
       'VECTOR    MATRIX    CHARACTER '
    ]

# CURRENT ARRAYNESS DECLARATIONS
CURRENT_ARRAYNESS = [0] * (N_DIM_LIM_PLUS_1 + 1)
ARRAYNESS_FLAG = 0
AS_PTR_MAX = 20
AS_PTR = 0
VAR_ARRAYNESS = [0] * (N_DIM_LIM_PLUS_1 + 1)
SAVE_ARRAYNESS_FLAG = 0
ARRAYNESS_STACK = [0] * (AS_PTR_MAX + 1)

SUBSCRIPT_LEVEL = 0
EXPONENT_LEVEL = 0
NEXT_SUB = 0
DEVICE_LIMIT = 9
ON_ERROR_PTR = h.EXT_SIZE
TEMP = 0  # TEMPORARY FULL WORD
TEMP_SYN = 0  # TEMPORARY USED ONLY ON SYTH DO CASE LEVEL, NOT IN CALLED ROUTINES
REL_OP = 0
NUM_ELEMENTS = 0  # COUNTS DISPLACEMENT FOR I/C LIST
NUM_FL_NO = 0  # COUNTS NO OF FL_NO NEEDED BY I/C LIST
NUM_STACKS = 0  # COUNTS NO INDIRECT STACKS I/C LIST NEEDS
IC_FOUND = 0  # 1 -> FACTORED,2 -> NORMAL I/C LIST. (1|2)
IC_PTR1 = 0  # CONTAINS FACTORED I/C LIST PTR(...) VALUE
IC_PTR2 = 0  # CONTAINS NORMAL I/C LIST PTR(...) VALUE
INIT_EMISSION = 0

# DO GROUP FLOW STACKS 
DO_LEVEL_LIM = 25
DO_LEVEL = 1
DO_LOC = [0] * (DO_LEVEL_LIM + 1)
DO_PARSE = [0] * (DO_LEVEL_LIM + 1)
DO_CHAIN = [0] * (DO_LEVEL_LIM + 1)
DO_STMTp = [0] * (DO_LEVEL_LIM + 1)
DO_INX = [0] * (DO_LEVEL_LIM + 1)

FCN_LV_MAX = 10
FCN_LV = 0
FCN_MODE = [0] * (FCN_LV_MAX + 1)
FCN_LOC = [0] * (FCN_LV_MAX + 1)
FCN_ARG = [0] * (FCN_LV_MAX + 1)
UPDATE_BLOCK_LEVEL = 0
IND_LINK = 0
FIX_DIM = 0
LIST_EXP_LIM = 32767
REFER_LOC = 0
SUB_SEEN = 0


def SUB_COUNT(value=None):
    global INX
    if value == None:
        return INX[PTR[MP]]
    INX[PTR[MP]] = value


def STRUCTURE_SUB_COUNT(value=None):
    global PSEUDO_LENGTH
    if value == None:
        return PSEUDO_LENGTH[PTR[MP]]
    PSEUDO_LENGTH[PTR[MP]] = value


def ARRAY_SUB_COUNT(value=None):
    global VAL_P
    if value == None:
        return VAL_P[PTR[MP]]
    VAL_P[PTR[MP]] = value


# THE FOLLOWING ARE USED FOR PSEUDO_FORM AND IN HALMAT OUTPUT
XSYT = 1
XINL = 2
XVAC = 3
XXPT = 4
XLIT = 5
XIMD = 6
XAST = 7
XCSZ = 8
XASZ = 9
XOFF = 10
# FOLLOWING ARE THE HALMAT OUTPUT OPERATOR CODES
XEXTN = 0x001
XXREC = 0x002
XSMRK = 0x004
XIFHD = 0x007
XLBL = 0x008
XBRA = 0x009
XFBRA = 0x00A
XDCAS = 0x00B
XECAS = 0x00C
XCLBL = 0x00D
XDTST = 0x00E
XETST = 0x00F
XDFOR = 0x010
XEFOR = 0x011
XCFOR = 0x012
XDSMP = 0x013
XESMP = 0x014
XAFOR = 0x015
XCTST = 0x016
XADLP = 0x017
XDLPE = 0x018
XDSUB = 0x019
XIDLP = 0x01A
XTSUB = 0x01B
XPCAL = 0x01D
XFCAL = 0x01E
XREAD = (0x01F, 0x020, 0x021)
XFILE = 0x022
XXXST = 0x025
XXXND = 0x026
XXXAR = 0x027
XTDEF = 0x02A
XMDEF = 0x02B
XFDEF = 0x02C
XPDEF = 0x02D
XUDEF = 0x02E
XCDEF = 0x02F
XCLOS = 0x030
XEDCL = 0x031
XRTRN = 0x032
XTDCL = 0x033
XWAIT = 0x034
XSGNL = 0x035
XCANC = 0x036
XTERM = 0x037
XPRIO = 0x038
XSCHD = 0x039
XERON = 0x03C
XERSE = 0x03D
XMSHP = (0x040, 0x041, 0x042, 0x043)
XSFST = 0x045
XSFND = 0x046
XSFAR = 0x047
XBFNC = 0x04A
XLFNC = 0x04B
XIMRK = 0x003
XIDEF = 0x051
XICLS = 0x052
XNEQU = (0x056, 0x055)
XNASN = 0x057
XPMHD = 0x059
XPMAR = 0x05A
XPMIN = 0x05B
XXASN = (0, 0x0101, 0x0201, 0x0301, 0x0401, 0x0501, 0x0601, 0, 0, 0, 0x04F)
# FOLLOWING ARE NOT LITERALS TO SAVE ON 100 POSSIBLE USAGE ONLY          
XMEQU = (0x0766, 0x0765)
XVEQU = (0x0786, 0x0785)
XSEQU = (0x07A6, 0x07A5, 0x07AA, 0x07A8, 0x07A7, 0x07A9)
XIEQU = (0x07C6, 0x07C5, 0x07CA, 0x07C8, 0x07C7, 0x07C9)
XBEQU = (0x0726, 0x0725)
XCEQU = (0x0746, 0x0745, 0x074A, 0x0748, 0x0747, 0x0749)
XTEQU = (0x04E, 0x04D)
XMNEG = (0x0344, 0x0444, 0x05B0, 0x06D0)
xmadd = (0x0362, 0x0482)
XSADD = (0x05AB, 0x06CB)


def XMADD(n):
    if n < 2:
        return xmadd[n]
    return XSADD[n - 2]


xmsub = (0x0363, 0x0483)
XSSUB = (0x05AC, 0x06CC)


def XMSUB(n):
    if n < 2:
        return xmsub[n]
    return XSSUB[n - 2]


XMSDV = (0x03A6, 0x04A6, 0x05AE)
XSSPR = (0x05AD, 0x06CD)
# FOLLOWING ARE NOT LITERALS TO SAVE ON THE 100 POSSIBLE USAGE ONLY      
XVSPR = 0x04A5
XMSPR = 0x03A5
XVDOT = 0x058E
XVVPR = 0x0387
XVMPR = 0x046D
XMVPR = 0x046C
XMMPR = 0x0368
XVCRS = 0x048B
XMTRA = 0x0329
XMINV = 0x03CA
XSEXP = 0x05AF
XSIEX = 0x0571
XSPEX = (0x0572, 0x06D2)
# FOLLOWING AND NOT LITERALS ONLY TO SAVE ON THE 100 POSSIBLE USAGE      
XCAND = 0x07E2
XCOR = 0x07E3
XCNOT = 0x07E4
XSTOI = 0x06A1
XITOS = 0x05C1
XBTOI = (0x0621, 0x0641, 0x0, 0x0, 0x06A1, 0x06C1)
XBTOS = (0x0521, 0x0541, 0x0, 0x0, 0x05A1, 0x05C1)
XCCAT = 0x0202
XBCAT = 0x0105
XBAND = 0x0102
XBOR = 0x0103
XBNOT = 0x0104
XSTRI = 0x0801
XSLRI = 0x0802
XETRI = 0x0804
XELRI = 0x0803
XBINT = (0x0821, 0x0841, 0x0861, 0x0881, 0x08A1, 0x08C1)
XTINT = 0x8E2
XEINT = 0x8E3
XNINT = 0x8E1
XMTOM = (0x341, 0x441, 0x5A1, 0x6C1)
XBTRU = 0x720
XBTOC = (0x0221, 0x0241, 0x0, 0x0, 0x02A1, 0x02C1)
XBTOB = (0x0121, 0x0141, 0x0, 0x0, 0x01A1, 0x01C1)
XBTOQ = (0x0122, 0x0142, 0x0, 0x0, 0x01A2, 0x01C2)

# FOLLOWING ARE THE 'CODE OPTIMIZER' BIT VALUES
XCO_N = 0x01
XCO_D = 0x02
# ASSIGNMENT TYPE-- MATCH VALIDITY CHECK TABLE
ASSIGN_TYPE = (
      0b0000000000000000,  # NULL
      0b0000000000000010,  # BIT
      0b0000000001100101,  # CHAR
      0b0000000000001001,  # MAT
      0b0000000000010001,  # VEC
      0b0000000001100001,  # SCA
      0b0000000001100001,  # INT
      0b0000000000000000,  # BORC
      0b0000000001100000,  # IORS
      0b0000000000000000,  # EVENT
      0b0000010000000000,  # STRUCTURE
      0b0000011111111110  # ANY TYPE
      )
STRING_MASK = 0b1100110

IC_SIZE = 200
IC_SIZ = 199
IC_VAL = [0] * (IC_SIZ + 1)
IC_LOC = [0] * (IC_SIZ + 1)
IC_LEN = [0] * (IC_SIZ + 1)
IC_FORM = [0] * (IC_SIZ + 1)
IC_TYPE = [0] * (IC_SIZ + 1)
IC_FILE = 3
ICQ = 0
NUM_EL_MAX = 32767
IC_ORG = 0
IC_LIM = 0
IC_MAX = 0
CUR_IC_BLK = 0
IC_LINE = 0
LIT_TOP_MAX = 32767
LIT_CHAR_SIZE = 0
LIT_BUF_SIZE = 130
LITFILE = 2
LIT_PTR = 0
LITORG = 0
LITMAX = 0
CURLBLK = 0
LITLIM = LIT_BUF_SIZE
DW_AD = 0

LOCK_FLAG = 0x0001
REENTRANT_FLAG = 0x0002
DENSE_FLAG = 0x0004
ALIGNED_FLAG = 0x0008
IMP_DECL = 0x0010
ASSIGN_PARM = 0x0020
DEFINED_LABEL = 0x0040
REMOTE_FLAG = 0x00000080
AUTO_FLAG = 0x0100
STATIC_FLAG = 0x0200
INPUT_PARM = 0x0400
INIT_FLAG = 0x0800
CONSTANT_FLAG = 0x1000
ARRAY_FLAG = 0x2000
ENDSCOPE_FLAG = 0x4000
INACTIVE_FLAG = 0x00008000
ACCESS_FLAG = 0x00010000
LATCHED_FLAG = 0x00020000
IMPL_T_FLAG = 0x00040000
EXCLUSIVE_FLAG = 0x00080000
EXTERNAL_FLAG = 0x00100000
EVIL_FLAG = 0x00200000
DOUBLE_FLAG = 0x00400000
SINGLE_FLAG = 0x00800000
DUMMY_FLAG = 0x01000000
INCLUDED_REMOTE = 0x02000000
DUPL_FLAG = 0x04000000
TEMPORARY_FLAG = 0x08000000
NAME_FLAG = 0x10000000
READ_ACCESS_FLAG = 0x20000000
MISC_NAME_FLAG = 0x40000000
RIGID_FLAG = 0x80000000
NONHAL_FLAG = 0x01

PARM_FLAGS = 0x00000420
SDF_INCL_FLAG = INIT_FLAG
SDF_INCL_LIST = CONSTANT_FLAG
SDF_INCL_OFF = 0xFFFFE7FF
ALDENSE_FLAGS = 0x000C
AUTSTAT_FLAGS = 0x0300
INIT_CONST = 0x1800
SD_FLAGS = 0x00C00000
SM_FLAGS = 0x90C2008C
INP_OR_CONST = 0x1400
MOVEABLE = 1
UNMOVEABLE = 0


# LITERALS TO CHANGE REFERENCES TO VARIABLES TO RECORD FORMAT
def MACRO_TEXT(n, value=None):
    global MACRO_TEXTS
    if value == None:
        return MACRO_TEXTS[n].MAC_TXT
    MACRO_TEXTS[n].MAC_TXT = value


countSYM_TAB = 0


def debugSYM_TAB():
    global countSYM_TAB
    countSYM_TAB += 1
    print("\n" + ("-" * 80))
    print("debug SYM_TAB (%d)" % countSYM_TAB)
    for e in h.SYM_TAB:
        print("\t", e.__dict__)
    print("-" * 80)


def enlargeSYM_TAB(n):
    while len(h.SYM_TAB) <= n:
        h.SYM_TAB.append(h.sym_tab())


def SYT_NAME(n, value=None):
    if value == None:
        return h.SYM_TAB[n].SYM_NAME[:]
    enlargeSYM_TAB(n)
    h.SYM_TAB[n].SYM_NAME = value[:]


def SYT_ADDR(n, value=None):
    if value == None:
        return h.SYM_TAB[n].SYM_ADDR
    enlargeSYM_TAB(n)
    h.SYM_TAB[n].SYM_ADDR = value


def SYT_XREF(n, value=None):
    if value == None:
        return h.SYM_TAB[n].SYM_XREF
    enlargeSYM_TAB(n)
    h.SYM_TAB[n].SYM_XREF = value


def SYT_NEST(n, value=None):
    if value == None:
        return h.SYM_TAB[n].SYM_NEST
    enlargeSYM_TAB(n)
    h.SYM_TAB[n].SYM_NEST = value


def SYT_SCOPE(n, value=None):
    if value == None:
        return h.SYM_TAB[n].SYM_SCOPE
    enlargeSYM_TAB(n)
    h.SYM_TAB[n].SYM_SCOPE = value


def VAR_LENGTH(n, value=None):
    if value == None:
        return h.SYM_TAB[n].SYM_LENGTH
    enlargeSYM_TAB(n)
    h.SYM_TAB[n].SYM_LENGTH = value


def SYT_ARRAY(n, value=None):
    if value == None:
        return h.SYM_TAB[n].SYM_ARRAY
    h.SYM_TAB[n].SYM_ARRAY = value


def SYT_PTR(n, value=None):
    if value == None:
        return h.SYM_TAB[n].SYM_PTR
    h.SYM_TAB[n].SYM_PTR = value


def SYT_LINK1(n, value=None):
    if value == None:
        return h.SYM_TAB[n].SYM_LINK1
    enlargeSYM_TAB(n)
    h.SYM_TAB[n].SYM_LINK1 = value


def SYT_LINK2(n, value=None):
    if value == None:
        return h.SYM_TAB[n].SYM_LINK2
    enlargeSYM_TAB(n)
    h.SYM_TAB[n].SYM_LINK2 = value


def SYT_CLASS(n, value=None):
    if value == None:
        return h.SYM_TAB[n].SYM_CLASS
    enlargeSYM_TAB(n)
    h.SYM_TAB[n].SYM_CLASS = value


def SYT_FLAGS(n, value=None):
    if value == None:
        return h.SYM_TAB[n].SYM_FLAGS
    enlargeSYM_TAB(n)
    h.SYM_TAB[n].SYM_FLAGS = value


def SYT_FLAGS2(n, value=None):
    if value == None:
        return h.SYM_TAB[n].SYM_FLAGS2
    h.SYM_TAB[n].SYM_FLAGS2 = value


def SYT_LOCKp(n, value=None):
    if value == None:
        return h.SYM_TAB[n].SYM_LOCKp
    enlargeSYM_TAB(n)
    h.SYM_TAB[n].SYM_LOCKp = value


def SYT_TYPE(n, value=None):
    if value == None:
        return h.SYM_TAB[n].SYM_TYPE
    enlargeSYM_TAB(n)
    h.SYM_TAB[n].SYM_TYPE = value


def EXTENT(n, value=None):
    if value == None:
        return h.SYM_TAB[n].XTNT
    h.SYM_TAB[n].XTNT = value


def SYT_HASHLINK(n, value=None):
    if value == None:
        return h.SYM_TAB[n].SYM_HASHLINK
    h.SYM_TAB[n].SYM_HASHLINK = value


def SYT_SORT(n, value=None):
    if value == None:
        return h.SYM_TAB[n].SYM_SORT
    enlargeSYM_TAB(n)
    h.SYM_TAB[n].SYM_SORT = value


def OUTER_REF(n, value=None):
    global OUTER_REF_TABLE
    if value == None:
        return OUTER_REF_TABLE[n].OUT_REF
    OUTER_REF_TABLE[n].OUT_REF = value


def OUTER_REF_FLAGS(n, value=None):
    global OUTER_REF_TABLE
    if value == None:
        return OUTER_REF_TABLE[n].OUT_REF_FLAGS
    OUTER_REF_TABLE[n].OUT_REF_FLAGS = value


def LIT_CHAR(n, value=None):
    while len(h.LIT_NDX) <= n:
        h.LIT_NDX.append(h.lit_ndx())
    if value == None:
        return h.LIT_NDX[n].CHAR_LIT
    h.LIT_NDX[n].CHAR_LIT = value


def LIT1(n, value=None):
    while len(h.LIT_PG) <= n:
        h.LIT_PG.append(h.lit_pg())
    if value == None:
        return h.LIT_PG[n].LITERAL1
    h.LIT_PG[n].LITERAL1 = value[:]


def LIT2(n, value=None):
    while len(h.LIT_PG) <= n:
        h.LIT_PG.append(h.lit_pg())
    if value == None:
        return h.LIT_PG[n].LITERAL2
    h.LIT_PG[n].LITERAL2 = value[:]


def LIT3(n, value=None):
    while len(h.LIT_PG) <= n:
        h.LIT_PG.append(h.lit_pg())
    if value == None:
        return h.LIT_PG[n].LITERAL3
    h.LIT_PG[n].LITERAL3 = value[:]


def XREF(n, value=None):
    # Logically, the while-loop should *follow* the return from the conditional
    # below.  However, the calling program appears to ask for a value from 
    # XREF prior to any being assigned to it, so I've placed it before.
    while len(h.CROSS_REF) <= n:
        h.CROSS_REF.append(h.cross_ref())
    if value == None:
        return h.CROSS_REF[n].CR_REF
    h.CROSS_REF[n].CR_REF = value


def ATOMS(n, value=None):
    if value == None:
        return h.FOR_ATOMS[n].CONST_ATOMS
    while len(h.FOR_ATOMS) <= n:
        h.FOR_ATOMS.append(h.for_atoms())
    h.FOR_ATOMS[n].CONST_ATOMS = value


DW = [0] * 56

ILL_ATTR = (0x0, 0x00C20000, 0x00C20000, 0x00020000, 0x00020000, 0x00020000,
            0x00020000, 0x0, 0x0, 0x00C01181, 0x00C20000)
ILL_LATCHED_ATTR = 0x02C01000
ILL_CLASS_ATTR = (0x00000000, 0x80C3208D, 0x8003208D)
ILL_TEMPL_ATTR = 0x02033B81
ILL_MINOR_STRUC = 0x02C31B81
ILL_TERM_ATTR = (0x02011B81, 0x02011B01)
ILL_NAME_ATTR = 0x02010000
ILL_INIT_ATTR = 0x00001B00
ILL_EQUATE_ATTR = 0x0A180462
ILL_TEMPORARY_ATTR = 0x82051B8D

NAME_IMPLIED = 0
BUILDING_TEMPLATE = 0
LOOKUP_ONLY = 0
NAMING = 0
FIXING = 0
DELAY_CONTEXT_CHECK = 0
NAME_PSEUDOS = 0
NAME_BIT = 0
FACTOR_FOUND = 0
ERRLIM = 102
IND_ERR_p = 0
SAVE_SEVERITY = [0] * (ERRLIM + 1)
SAVE_LINE_p = [0] * (ERRLIM + 1)
INCLUDING = 0
INCLUDE_LIST = 0
INCLUDE_LIST2 = TRUE
INCLUDE_END = 0
INCLUDE_OPENED = 0
INPUT_DEV = 0
INCLUDE_CHAR = ''
INCLUDE_OFFSET = 0
INCLUDE_COUNT = 0
INCLUDE_FILEp = 0
SAVEp = 19
LINE_LIM = 59
LINE_MAX = 0
LISTING2_COUNT = LINE_LIM
SAVE_GROUP = [''] * (SAVEp + 1)
SAVE_ERROR_LIM = 19
SAVE_ERROR_MESSAGE = [''] * (SAVE_ERROR_LIM + 1)
TOO_MANY_LINES = 0
TOO_MANY_ERRORS = 0
CURRENT_CARD = ''
END_GROUP = FALSE
NONBLANK_FOUND = 0
GROUP_NEEDED = TRUE
LRECL = [0, 0]
INPUT_REC = ['', '']
MEMORY_FAILURE = 0
SYSIN_COMPRESSED = 0
INCLUDE_COMPRESSED = 0
LOOKED_RECORD_AHEAD = 0
INITIAL_INCLUDE_RECORD = 0
NOT_ASSIGNED_FLAG = 0
INFORMATION = ''
X8 = '        '
VBAR = '| '
STARS = '*****'
SUBHEADING = '2'
NEXT = 0
LAST = 0
SAVE_CARD = ''
COMMENTING = 0
SQUEEZING = 0
LISTING2 = 0
TEXT_LIMIT = [0, 0]
PATCH_TEXT_LIMIT = [0, 0]
ACCESS_FOUND = 0
SDF_OPEN = 0
PROGRAM_ID = ''
INCLUDE_MSG = ''
CARD_TYPE = [0] * (255 + 1)
STACK_PTR = [0] * (STACKSIZE + 1)
ELSEIF_PTR = 0
OUTPUT_STACK_MAX = 1799
SAVE_BCD_MAX = 256
STMT_STACK = [0] * (OUTPUT_STACK_MAX + 1)
ERROR_PTR = [0] * (OUTPUT_STACK_MAX + 1)

# THE FOLLOWING DECLARATION MUST OCCUR IN THIS EXACT ORDER.
#       THE UNFLO ENTRY IS USED TO ABSORB THE RESULTS OF
#       A PRODUCTION TRYING TO FORCE NO SPACING OF A TOKEN
#       IN THE OUTPUT WRITER LISTING WHEN THAT TOKEN IS
#       THE RESULT OF A REPLACE EXPANSION. THE CORRESPONDING
#       ENTRY IN STACK_PTR WILL CONTAIN A -1 THUS SELECTING
#       THE UNFLO ELEMENT.
# (Huh? Whatever this is trying to say, it seems unlikely it's going to work.
# I think it may be talking about writing to TOKEN_FLAGS[-1] and 
# GRAMMAR_FLAGS[-1], which definitely won't work as expected in Python.  TBD)
TOKEN_FLAGS_UNFLOW = 0
TOKEN_FLAGS = [0] * (OUTPUT_STACK_MAX + 1)
GRAMMAR_FLAGS_UNFLOW = 0
GRAMMAR_FLAGS = [0] * (OUTPUT_STACK_MAX + 1)
ATTR_LOC = 0
ATTR_INDENT = 0
ATTR_FOUND = 0
END_OF_INPUT = 0
SAVE_BCD = [''] * (SAVE_BCD_MAX + 1)
STMT_PTR = 0
BCD_PTR = 0
STMT_END_PTR = 0
SUB_END_PTR = 0
SAVE_SCOPE = ''


def NOSPACE():
    global TOKEN_FLAGS
    TOKEN_FLAGS[STACK_PTR[MP]] |= 0x20

    
LABEL_FLAG = 0x0001
ATTR_BEGIN_FLAG = 0x0002
STMT_END_FLAG = 0x0004
INLINE_FLAG = 0x0200
FUNC_FLAG = 0x0008
LEFT_BRACKET_FLAG = 0x0010
RIGHT_BRACKET_FLAG = 0x0020
LEFT_BRACE_FLAG = 0x0040
RIGHT_BRACE_FLAG = 0x0080
MACRO_ARG_FLAG = 0x0100
PRINT_FLAG = 0x0400
PRINT_FLAG_OFF = 0xFBFF
PRINTING_ENABLED = 0x0400
COMMENT_COUNT = 0
SAVE_COMMENT = ' ' * 256

LAST_SPACE = 0
LAST_WRITE = 0
SPACE_FLAGS = (
    0x00, 0x00, 0x00, 0x12, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20,  #  0-  9
    0x20, 0x02, 0x00, 0x00, 0x20, 0x00, 0x20, 0x22, 0x00, 0x00,  # 10- 19
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  # 20- 29
    0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x02, 0x00, 0x00, 0x02,  # 30- 39
    0x00, 0x02, 0x00, 0x00, 0x02, 0x00, 0x00, 0x02, 0x00, 0x00,  # 40- 49
    0x02, 0x02, 0x02, 0x01, 0x00, 0x02, 0x02, 0x00, 0x02, 0x00,  # 50- 59
    0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00,  # 60- 69
    0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x02, 0x00, 0x02,  # 70- 80
    0x00, 0x00, 0x50, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  # 81- 91
    0x00, 0x02, 0x50, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00,  # 92-102
    0x00, 0x02, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x02, 0x00,  # 103-112
    0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00,  # 113-122
    0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x01, 0x00, 0x00,  # 123-132
    0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  # 133-142
    #  END OF FIRST PART OF SPACE TABLE USED FOR M-LINE SPACING
    0x22, 0x22, 0x12, 0x22, 0x22, 0x22, 0x22, 0x22, 0x20,  #  0-  9
    0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22,  # 10- 19
    0x00, 0x22, 0x55, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  # 20- 29
    0x55, 0x00, 0x00, 0x02, 0x00, 0x00, 0x02, 0x00, 0x00, 0x02,  # 30- 39
    0x00, 0x02, 0x00, 0x00, 0x02, 0x00, 0x00, 0x02, 0x00, 0x00,  # 40- 49
    0x02, 0x02, 0x02, 0x01, 0x00, 0x02, 0x02, 0x00, 0x02, 0x00,  # 50- 59
    0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00,  # 60- 69
    0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x02, 0x00, 0x02,  # 70- 80
    0x00, 0x00, 0x50, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  # 81-91
    0x00, 0x02, 0x50, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00,  # 92-102
    0x00, 0x02, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x02, 0x00,  # 103-112
    0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00,  # 113-122
    0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x01, 0x00, 0x00,  # 123-132
    0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  # 133-142
    )
if SANITY_CHECK and len(SPACE_FLAGS) != 284 + 1:
    print('Bad SPACE_FLAGS', file=sys.stderr)
    sys.exit(1)

# THE ARRAY TRANS_IN IS USED TO DETERMINE THE RESULT OF APPLYING THE
# 'ESCAPE' CHARACTER TO ONE OF THE STANDARD HAL/S CHARACTER CODES.
# THE ARRAY IS INDEXED BY THE BINARY VALUE OF AN INPUT CHARACTER.
# THE VALUE AT A PARTICULAR INDEX HAS THE LEVEL 1 ESCAPE TRANSLATION
# CHARACTER IN THE RIGHT BYTE AND THE LEVEL 2 CHARACTER IN THE LEFT BYTE.
# A ZERO VALUE IN A PARTICULAR BYTE INDICATES THAT THE REQUESTED
# ESCAPE TRANSLATION HAS NOT BEEN DEFINED. (THE ZERO VALUE HAS THIS MEANING
# IN ALL CASES EXCEPT THE ONE IN WHICH THE ESCAPED VALUE IS TO BE 0x00.
# THIS SPECIAL CASE IS DETECTED IN THE SCANNER LOGIC BY USING THE
# VALUES OF 'VALID_00_OP' AND 'VALID_00_CHAR'
TRANS_IN = (
    0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  #  0- 7
    0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  #  8- F
    0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # 10-17
    0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # 18-1F
    0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # 20-27
    0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # 28-2F
    0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # 30-37
    0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # 38-3F
    0xFF4A, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # 40-47
    0x0000, 0x0000, 0x0000, 0xDCAF, 0xEA21, 0x0000, 0xD044, 0xDE0D,  # 48-4F
    0xE048, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # 50-57
    0x0000, 0x0000, 0x0000, 0xEE53, 0xDB46, 0x0000, 0xFA55, 0xDF47,  # 58-5F
    0xDA45, 0xDD0E, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # 60-67
    0x0000, 0x0000, 0x0000, 0xEF54, 0xFD00, 0xFC16, 0xEB20, 0x0000,  # 68-6F
    0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # 70-77
    0x0000, 0x0000, 0xFB56, 0xEC51, 0xED52, 0x0000, 0xE149, 0xFE00,  # 78-7F
    0x0000, 0x8E29, 0x8F2A, 0x902B, 0x9A2C, 0x9C2D, 0x9D2E, 0x9E2F,  # 80-87
    0x9F30, 0xA031, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # 88-8F
    0x0000, 0xA132, 0xAA33, 0xAB34, 0xAC35, 0xAE36, 0xB037, 0xB138,  # 90-97
    0xB239, 0xB33A, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # 98-9F
    0x0000, 0x0000, 0xB43B, 0xB53C, 0xB63D, 0xB73E, 0xB83F, 0xB941,  # A0-A7
    0xBA42, 0xBB43, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # A8-AF
    0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # B0-B7
    0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # B8-BF
    0x0000, 0x5710, 0x5811, 0x5919, 0x6213, 0x6314, 0x641A, 0x6512,  # C0-C7
    0x660B, 0x670C, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # C8-CF
    0x0000, 0x680F, 0x6922, 0x6A1F, 0x7023, 0x7124, 0x721C, 0x7317,  # D0-D7
    0x7425, 0x751E, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # D8-DF
    0x0000, 0x0000, 0x7618, 0x7715, 0x7826, 0x790A, 0x801D, 0x8A27,  # E0-E7
    0x8C1B, 0x8D28, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # E8-EF
    0xBC00, 0xBE01, 0xBF02, 0xC003, 0xCA04, 0xCB05, 0xCC06, 0xCD07,  # F0-F7
    0xCE08, 0xCF09, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000  # F8-FF
    )
if SANITY_CHECK and len(TRANS_IN) != 255 + 1:
    print('Bad TRANS_IN', file=sys.stderr)
    sys.exit(1)

# THE TRANS_OUT ARRAY IS USED BY THE OUTPUT WRITER TO OBTAIN THE PROPER
# OVER PUNCH (IF ANY) FOR A GIVEN INTERNAL CHARACTER REPRESENTATION. THE
# ARRAY IS INDEXED BY THE BINARY VALUE OF AN INTERNAL CHARACTER AS
# GENERATED BY SCAN USING THE TRANS_IN ARRAY. THE RIGHT HAND BYTE OF
# EACH ENTRY CONTAINS THE CHARACTER IN THE STANDARD HAL/S CHARACTER
# SET WHICH IS 'ESCAPED' TO PRODUCE THE CHARACTER WHOSE BINARY VALUE
# IS THE INDEX OF THAT ENTRY. A ZERO VALUE INDICATES THAT THE CHARACTER
# IS NOT GENERATED VIA AN ESCAPE. THE LEFT HAND BYTE (IF THE RH BYTE IS
# NON-ZERO) CONTAINS THE ESCAPE LEVEL WHICH MUST BE APPLIED TO THE
# RH CHARACTER TO ACHIEVE THE INDEXING CHARACTER VALUE. AN ESCAPE LEVEL
# OF 1 IS INDECATED BY 0x00, A LEVEL OF 2 BY 0x01, ETC.
TRANS_OUT = (
    0x00F0, 0x00F1, 0x00F2, 0x00F3, 0x00F4, 0x00F5, 0x00F6, 0x00F7,  #  0- 7
    0x00F8, 0x00F9, 0x00E5, 0x00C8, 0x00C9, 0x004F, 0x0061, 0x00D1,  #  8- F
    0x00C1, 0x00C2, 0x00C7, 0x00C4, 0x00C5, 0x00E3, 0x006D, 0x00D7,  # 10-17
    0x00E2, 0x00C3, 0x00C6, 0x00E8, 0x00D6, 0x00E6, 0x00D9, 0x00D3,  # 18-1F
    0x006E, 0x004C, 0x00D2, 0x00D4, 0x00D5, 0x00D8, 0x00E4, 0x00E7,  # 20-27
    0x00E9, 0x0081, 0x0082, 0x0083, 0x0084, 0x0085, 0x0086, 0x0087,  # 27-2F
    0x0088, 0x0089, 0x0091, 0x0092, 0x0093, 0x0094, 0x0095, 0x0096,  # 30-37
    0x0097, 0x0098, 0x0099, 0x00A2, 0x00A3, 0x00A4, 0x00A5, 0x00A6,  # 38-3F
    0x0000, 0x00A7, 0x00A8, 0x00A9, 0x004E, 0x0060, 0x005C, 0x005F,  # 40-47
    0x0050, 0x007E, 0x0040, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # 48-4F
    0x0000, 0x007B, 0x007C, 0x005B, 0x006B, 0x005E, 0x007A, 0x01C1,  # 50-57
    0x01C2, 0x01C3, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # 58-5F
    0x0000, 0x0000, 0x01C4, 0x01C5, 0x01C6, 0x01C7, 0x01C8, 0x01C9,  # 60-67
    0x01D1, 0x01D2, 0x01D3, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # 68-6F
    0x01D4, 0x01D5, 0x01D6, 0x01D7, 0x01D8, 0x01D9, 0x01E2, 0x01E3,  # 70-77
    0x01E4, 0x01E5, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # 78-7F
    0x01E6, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # 80-87
    0x0000, 0x0000, 0x01E7, 0x0000, 0x01E8, 0x01E9, 0x0181, 0x0182,  # 88-8F
    0x0183, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # 90-97
    0x0000, 0x0000, 0x0184, 0x0000, 0x0185, 0x0186, 0x0187, 0x0188,  # 98-9F
    0x0189, 0x0191, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # A0-A7
    0x0000, 0x0000, 0x0192, 0x0193, 0x0194, 0x0000, 0x0195, 0x004B,  # A8-AF
    0x0196, 0x0197, 0x0198, 0x0199, 0x01A2, 0x01A3, 0x01A4, 0x01A5,  # B0-B7
    0x01A6, 0x01A7, 0x01A8, 0x01A9, 0x01F0, 0x0000, 0x01F1, 0x01F2,  # B8-BF
    0x01F3, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # C0-C7
    0x0000, 0x0000, 0x01F4, 0x01F5, 0x01F6, 0x01F7, 0x01F8, 0x01F9,  # C8-CF
    0x014E, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # D0-D7
    0x0000, 0x0000, 0x0160, 0x015C, 0x014B, 0x0161, 0x014F, 0x015F,  # D8-DF
    0x0150, 0x017E, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # E0-E7
    0x0000, 0x0000, 0x014C, 0x016E, 0x017B, 0x017C, 0x015B, 0x016B,  # E8-EF
    0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,  # F0-F7
    0x0000, 0x0000, 0x015E, 0x017A, 0x016D, 0x016C, 0x017F, 0x0140  # F8-FF
    )
if SANITY_CHECK and len(TRANS_OUT) != 255 + 1:
    print('Bad TRANS_OUT', file=sys.stderr)
    sys.exit(1)

# Recall that the backtick replaces the cent character (missing from ASCII).
ESCP = BYTE('`')  # THE ESCAPE CHARACTER
CHAR_OP = (BYTE('_'), BYTE('='))  # OVER PUNCH ESCAPES
VALID_00_OP = BYTE('_')  # THE OVERPUNCH VALID IN GENERATING
                           # THE X'00' CHARACTER
VALID_00_CHAR = BYTE('0')  # THE CHARACTER WHICH, WHEN
                             # 'ESCAPED' BY THE PROPER OP CHAR
                             # GENERATES X'00' INTERNALLY

STACK_DUMPED = 0
SEVERITY = 0
PARTIAL_PARSE = 0
TEMPORARY_IMPLIED = 0
RESERVED_WORD = 0
IMPLICIT_T = 0
WAIT = 0
OUT_PREV_ERROR = 0
INDENT_LEVEL = 0
LABEL_COUNT = 0
INDENT_INCR = 0
INLINE_INDENT = 0
INLINE_STMT_RESET = 0
INLINE_INDENT_RESET = -1
STACK_DUMP_MAX = 10
SAVE_STACK_DUMP = [''] * (STACK_DUMP_MAX + 1)
STACK_DUMP_PTR = 0
SAVE_INDENT_LEVEL = 0
OUTPUT_WRITER_DISASTER = 'OUTPUT_WRITER_DISASTER'
PAD1 = ''
PAD2 = ''
SMRK_FLAG = 0

# TEMPLATE EMISSION DECLARATIONS
EXTERNALIZE = 0
TPL_VERSION = 0
TPL_FLAG = 3
TPL_NAME = ''
PARMS_PRESENT = 0
PARMS_WATCH = 0
TPL_REMOTE = 0
TPL_LRECL = 80

# HALMAT DECLARATIONS
NEXT_ATOMp = 0
ATOMp_FAULT = 0
LAST_POPp = 0
CURRENT_ATOM = 0
ATOMp_LIM = 1799  # SIZE OF BLOCK IN WORDS -1
HALMAT_BLOCK = 0
HALMAT_OK = 0
HALMAT_CRAP = 0
HALMAT_FILE = 1
HALMAT_RELOCATE_FLAG = 0

#  DECLARATIONS FOR STATEMENT FILE
STAB_STACKLIM = 128
STAB_STACK = [0] * (STAB_STACKLIM + 1)
STAB2_STACK = [0] * (STAB_STACKLIM + 1)
STAB_STACKTOP = 0
STAB_MARK = 0
STAB2_STACKTOP = 0
STAB2_MARK = 0
LAST_STAB_CELL_PTR = -1
STMT_TYPE = 0
SIMULATING = 0


def XSET(flags):
    global STMT_TYPE
    STMT_TYPE |= flags


SRN = [''] * (2 + 1)
INCL_SRN = [''] * (2 + 1)
SRN_PRESENT = 0
ADDR_PRESENT = 0
SDL_OPTION = 0
SREF_OPTION = 0
SRN_FLAG = 0
SRN_MARK = ''
INCL_SRN_MARK = ''
SRN_COUNT_MARK = 0
SRN_COUNT = [0] * (2 + 1)
SAVE_SRN_COUNT1 = 0
SAVE_SRN_COUNT2 = 0
#  %MACRO DECLARATIONS
PC_STMT_TYPE_BASE = 0x1E  # FIRST IS 0x1F
#*********************************************
# THE PASS SYSTEM SUPPORTS THE NAMEADD MACRO,
# WHILE THE BFS SYSTEM DOES NOT.
#*********************************************
if pfs:
    PCNAME = '                %NAMEBIAS       %SVC            ' + \
             '%NAMECOPY       %COPY           %SVCI           %NAMEADD        '
else:
    PCNAME = '                                %SVC            ' + \
             '%NAMECOPY       %COPY           %SVCI           '
PCCOPY_INDEX = 3
PC_LIMIT = 9  # LONGEST NAME
if pfs:
    PC_INDEX = 6  # NUMBER OF NAMES
    ALT_PCARGp = (0, 2, 1, 2, 2, 1, 3)
    PCARGp = (0, 2, 1, 2, 3, 1, 3)
    PCARGOFF = (0, 1, 3, 5, 7, 10, 11)
    PCARG_MAX = 13  # TOTAL NUMBER OF ARGS
else:
    PC_INDEX = 5  # NUMBER OF NAMES
    ALT_PCARGp = (0, 0, 1, 2, 2, 1)
    PCARGp = (0, 0, 1, 2, 3, 1)
    PCARGOFF = (0, 0, 1, 3, 5, 8)
    PCARG_MAX = 8  # TOTAL NUMBER OF ARGS
if pfs:
    PCARGTYPE = (0,
        0b00001000000,
        0b11001111110,
        0b11001111110,
        0,  # SPACE FOR SECOND %SVC ARG
        0b10000000000,
        0b10000000000,
        0b11001111110,
        0b11001111110,
        0b100000000000000000001000000,
        0,  # %SVCI UNIMPLEMENTED
        0b11001111110,
        0b11001111110,
        0b100000000000000000001000000)
    PCARGBITS = (0,
        0b101110101,
        0b000000101,
        0b100001101,
        0,  # SECOND %SVC ARG
        0b11010001,
        0b11000001,
        0b00010101,
        0b00000101,
        0b101101101,
        0,  # %SVCI UNIMPLEMENTED
        0b11010001,
        0b11000001,
        0b101101101)
else:
    PCARGTYPE = (0,
        0b11001111110,
        0,  # SPACE FOR SECOND %SVC ARG
        0b10000000000,
        0b10000000000,
        0b11001111110,
        0b11001111110,
        0b100000000000000000001000000,
        0b100000000000000000001000000)
    PCARGBITS = (0,
        0b100001101,
        0,  # SECOND %SVC ARG
        0b11010001,
        0b11000001,
        0b00010101,
        0b00000101,
        0b101101101,
        0b101101101)
if SANITY_CHECK and len(PCARGTYPE) != PCARG_MAX + 1:
    print('Bad PCARGTYPE', file=sys.stderr)
    sys.exit(1)
if SANITY_CHECK and len(PCARGBITS) != PCARG_MAX + 1:
    print('Bad PCARGBITS', file=sys.stderr)
    sys.exit(1)

MORE = 0
UPDATING = 0
REPLACING = 0
ADDING = 0
DELETING = 0
LIST_INCLUDE = 0
PATCH_COUNT = 0
REV_CAT = 0
MEMBER = ''
CURRENT_SRN = ''
PATCH_SRN = ''
PATCH_CARD = ''
PAT_CARD = ''
CUR_CARD = ''
COMPARE_SOURCE = 1
UPDATE_INPUT_DEV = 0
ADDED = '+++ ADDED'
DELETED = '--- DELETED'
PRINT_INCL_HEAD = 0
PRINT_INCL_TAIL = 0
INCL_LOG_MSG = ''
PATCH_INCL_HEAD = ''
NO_MORE_SOURCE = 0
NO_MORE_PATCH = 0
FIRST_CARD = 0
HMAT_OPT = 0
INCREMENT_DOWN_STMT = 0
PREV_STMT_NUM = -1
INCLUDE_STMT = -1


def fixup_DOWN_INFO(n):
    while len(h.DOWN_INFO) <= n:
        h.DOWN_INFO.append(h.down_info())


def DWN_STMT(n, value=None):
    if n < 0:
        n = 0
    fixup_DOWN_INFO(n)
    if value == None:
        return h.DOWN_INFO[n].DOWN_STMT[:]
    else:
        h.DOWN_INFO[n].DOWN_STMT = value[:]


def DWN_ERR(n, value=None):
    if n < 0:
        n = 0
    fixup_DOWN_INFO(n)
    if value == None:
        return h.DOWN_INFO[n].DOWN_ERR[:]
    else:
        h.DOWN_INFO[n].DOWN_ERR = value[:]


def DWN_CLS(n, value=None):
    if n < 0:
        n = 0
    fixup_DOWN_INFO(n)
    if value == None:
        return h.DOWN_INFO[n].DOWN_CLS[:]
    else:
        h.DOWN_INFO[n].DOWN_CLS = value[:]


def DWN_UNKN(n, value=None):
    if n < 0:
        n = 0
    fixup_DOWN_INFO(n)
    if value == None:
        return h.DOWN_INFO[n].DOWN_UNKN[:]
    else:
        h.DOWN_INFO[n].DOWN_UNKN = value[:]


def DWN_VER(n, value=None):
    if n < 0:
        n = 0
    fixup_DOWN_INFO(n)
    if value == None:
        return h.DOWN_INFO[n].DOWN_VER[:]
    else:
        h.DOWN_INFO[n].DOWN_VER = value[:]


PREV_ELINE = FALSE
NEXT_CC = ''
SAVE_DO_LEVEL = -1
IFDO_FLAG = [0] * (DO_LEVEL_LIM + 1)
IF_FLAG = FALSE
ELSE_FLAG = FALSE
END_FLAG = FALSE
MOVE_ELSE = TRUE
SAVE1 = 0
SAVE2 = 0
SAVE_SRN1 = ''
SAVE_SRN2 = ''
RVL = ['', '']
NEXT_CHAR_RVL = ''
RVL_STACK1 = [0] * (OUTPUT_STACK_MAX + 1)
RVL_STACK2 = [0] * (OUTPUT_STACK_MAX + 1)
DOUBLELIT = 0
NO_NEW_XREF = FALSE


def ADV_STMTp(n, value=None):
    if value == None:
        return h.ADVISE[n].STMTp
    h.ADVISE[n].STMTp = value


def ADV_ERRORp(n, value=None):
    if value == None:
        return h.ADVISE[n].ERRORp[:]
    h.ADVISE[n].ERRORp = value[:]

# The idea behind the following is that there's a command-line parameter which
# activates a test that helps to debug the port of the compiler by seeing if
# there's any overlap between names of variables in two different scopes.  
# The concern is that most variables from the original XPL (say, X) have to 
# be ported to forms like g.X (indicating that they reside in g.py), h.X
# (usually indicating that they reside in HALINCL.COMMON), or l.X or ll.X 
# (usually indicating that they reside in classes representing "local variables"
# of a function) ... but sometimes they really are ported simply as true local
# Python variables and therefore retain the original name (X).  But because 
# that's actually a rare case, it's easy to make mistakes in which both forms
# like X and g.X reside in a single Python function, and that's always going to
# be incorrect, thought not *necessarily* in a way detectable merely 
# syntactically.  So I'd prefer to have some automation that helps to detect
# that such overlaps could have occurred.

# A typical use, of the varIntersect() function defined below is from inside of 
# a function (in a module into which g.py has been IMPORT'ed):
#    import g
#    ...
#    def FUNC():
#        ...
#        # Usually just before a return from FUNC.
#        g.varIntersect(locals())
# A less-common use would be in a situation where I've implemented the
# local variables from the original XPL as a Python class rather than as actual
# Python local varialble, thusly:
#    class cFUNC:
#        ...
#    lFUNC = cFUNC()
#    def FUNC():
#        ll = lFUNC
#        g.varIntersect(locals(), "...", ll)
#        ...
# In this case, the intersection of the cFUNC class is checked vs the actual
# locals of the Python function.  Or even
#    g.varIntersect(ll, "...")
# in which case the cFUNC class is checked against the variables of g.py.
# Or
#    import HALINCL.COMMON as h
#    g.varIntersect(locals(), ..., h.globals())
# where the locals are checked vs the variables in HALINCL.COMMON.
# And so on.
if intersection:
    g = set(globals().keys())
    gCount = 0
    def varIntersect(l, msg = "", ll=None):
        global gCount
        gCount += 1
        l = set(l.keys())
        if ll == None:
            intersection = g.intersection(l)
        else:
            intersection = set(ll).intersection(l)
        if len(intersection) != 0:
            print("\nIntersection (%d, '%s')" % (gCount, msg), intersection)

