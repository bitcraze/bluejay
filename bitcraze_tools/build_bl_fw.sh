#!/usr/bin/env bash
# Builds the ESC firmware for the Crazyflie brushless 2.1

run_dir=$(pwd)

# Get this script's directory
script_dir=$(dirname $(realpath $0))
source_path=$script_dir/..

pushd $source_path > /dev/null

# Change the default direction to clockwise
sed -i 's/^DEFAULT_PGM_DIRECTION EQU ./DEFAULT_PGM_DIRECTION EQU 1/' src/Settings/BluejaySettings.asm
touch src/Settings/BluejaySettings.asm

make clean single_target
cp build/hex/O_H_10_48_v0.21.1-RC1.hex $run_dir/cfbl2.1_esc_normal_m1-m3.hex

# Change the default direction to counter-clockwise
sed -i 's/^DEFAULT_PGM_DIRECTION EQU ./DEFAULT_PGM_DIRECTION EQU 2/' src/Settings/BluejaySettings.asm
touch src/Settings/BluejaySettings.asm

make clean single_target
cp build/hex/O_H_10_48_v0.21.1-RC1.hex $run_dir/cfbl2.1_esc_reverse_m2-m4.hex

# Restore the original file
git checkout src/Settings/BluejaySettings.asm

popd > /dev/null