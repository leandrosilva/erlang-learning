#!/bin/sh

echo "Compiling source code for getting_system_info..."

exec erlc -o ebin/ src/system_info.erl test/system_info_test.erl