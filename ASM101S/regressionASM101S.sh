#!/bin/bash
# This script performs a regression test on the AP-101S assembler, ASM101S,
# by compiling lots of legacy AP-101S assembly-language source code for which
# contemporary assembly listings are available, and doing a byte-by-byte
# comparison of the generated code.

cd "../yaShuttle/Source Code/PASS.REL32V0/RUNASM"
for f in *.asm
do 
    n=${f%.*}
    if [[ "$1" != "" ]]
    then
        echo -n -e "\033[0;33m$n\033[0m "
    fi
    ASM101S.py --library=../RUNMAC --tolerable=4 --compare=../RUNLST/$n.txt $n.asm \
    | tail -n1 | grep --invert-match "0 bytes mismatched and 0 bytes missing"
done
echo ""
cd - &>/dev/null
