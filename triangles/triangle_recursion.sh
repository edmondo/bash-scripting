#!/bin/bash
#
# 2016 Edmondo Tommasina

# Get parm, set defaul if not defined
COLS=${1:-17}
N=${2:-1}

# Make the number odd
COLS=$(( COLS / 2 * 2 + 1 ))

print_triangle() {
    local cols=${1:-1}
    local offx=${2:-0}
    local offy=${3:-0}

    test ${cols} -le 0 && cols=1

    local rows=$(( cols / 2 + 1 ))
    local axe=$(( (cols - 1) / 2 ))

    for r in $(seq 0 $(( rows - 1 )) ); do
        for c in $(seq 0 $(( cols - 1 )) ); do

            if [[ ${r} -eq ${axe} ]] || [[ $(( axe - c )) -eq ${r} ]] || [[ $(( axe - c )) -eq "-${r}" ]]; then
                tput cup $(( offy + r )) $(( offx + c ))
                echo -n '*'
            fi

        done
    done
}

recurse_triangle() {
    local cols=${1:-0}
    local offx=${2:-0}
    local offy=${3:-0}
    local n=${4:-1}

    if [[ ${n} -eq 1 ]]; then
        print_triangle ${cols} ${offx} ${offy}
    else
        local rows0=$(( cols / 2 ))
        local rows1=$(( rows0 / 2 + rows0 % 2 ))
        local rows2=$(( rows0 / 2 ))

        local cols1=$(( rows1 * 2 + 1 ))
        local cols2=$(( rows2 * 2 + 1 ))

        local offx1=$(( rows2 ))
        local offx2=$(( offx1 + cols1 ))

        local offy2=$(( rows1 ))

        recurse_triangle $(( cols1 )) $(( offx + offx1     )) $(( offy         )) $(( n - 1 ))
        recurse_triangle $(( cols2 )) $(( offx             )) $(( offy + offy2 )) $(( n - 1 ))
        recurse_triangle $(( cols2 )) $(( offx + cols1 - 1 )) $(( offy + offy2 )) $(( n - 1 ))
    fi
}

clear
recurse_triangle ${COLS} 0 0 ${N}

tput cup $(( ${COLS} / 2 + 1 )) 0
