#!/usr/bin/env bash
# Builds the ESC firmware for the Crazyflie brushless 2.1

run_dir=$(pwd)

# Get this script's directory
script_dir=$(dirname $(realpath $0))
source_path=$script_dir/..
tmpdir=$(mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir')

trap clean INT

function clean() {
    echo "Cleaning patched sources"
    # Restore the original file
    git checkout src/Settings/BluejaySettings.asm
    # Restore the original file
    git checkout src/Bluejay.asm

    exit
}

pushd $source_path > /dev/null

# Disable default startup melody (doing it here helps pulling new versions of upstream)
sed -i 's/Eep_Pgm_Beep_Melody: .*/Eep_Pgm_Beep_Melody: DB 255/' src/Bluejay.asm

# Change the default direction to clockwise
sed -i 's/^DEFAULT_PGM_DIRECTION EQU ./DEFAULT_PGM_DIRECTION EQU 1/' src/Settings/BluejaySettings.asm
touch src/Settings/BluejaySettings.asm

rm -Rf build
make clean single_target
built_file=`ls build/hex/*.hex | cut -f 1 | head -n 1`
cp $built_file $run_dir/cfbl2.1_esc_normal_m1-m3.hex

# Change the default direction to counter-clockwise
sed -i 's/^DEFAULT_PGM_DIRECTION EQU ./DEFAULT_PGM_DIRECTION EQU 2/' src/Settings/BluejaySettings.asm
touch src/Settings/BluejaySettings.asm

rm -Rf build
make clean single_target
cp $built_file $run_dir/cfbl2.1_esc_reverse_m2-m4.hex

clean

popd > /dev/null