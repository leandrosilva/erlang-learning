#!/bin/sh
cd `dirname $0`
exec erl -sname sticky -pa $PWD/ebin $PWD/deps/*/ebin -boot start_sasl -s reloader -s stickyNotes -mnesia dir '"db/dev"' $1
