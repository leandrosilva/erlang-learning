#!/bin/sh
echo "Running tests for getting_system_info..."

exec erl -sname test -pa ebin/ -noshell -run system_info_test test -run init stop