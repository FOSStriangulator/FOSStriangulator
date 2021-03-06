#!/bin/bash

# have the directory containing processing-java as the first argument if it's not in $PATH
if [ "$#" -eq 1 ]; then
    PROCESSING_DIR = $1
	if ! command -v $PROCESSING_DIR/processing-java &> /dev/null
	then
		echo "processing-java could not be found in $PROCESSING_DIR."
		exit 2
	fi
fi

SCRIPTDIR=`dirname "$0"`
SRCDIR="$SCRIPTDIR/../FOSStriangulator"
SRCDIR="$(cd "$(dirname $SRCDIR)"; pwd -P)/$(basename "$SRCDIR")"
TEMPDIR="$SCRIPTDIR/temp"

if [ "$#" -eq 1 ]; then
	$(cd $PROCESSING_DIR && processing-java --force --sketch=$SRCDIR --output=$TEMPDIR --export --platform='linux')
else
	processing-java --force --sketch=$SRCDIR --output=$TEMPDIR --export --platform='linux'
fi

unzip -o controlP5.jar -d $TEMPDIR/lib/FOSStriangulator
unzip -o core.jar -d $TEMPDIR/lib/FOSStriangulator
unzip -o itext.jar -d $TEMPDIR/lib/FOSStriangulator
unzip -o pdf.jar -d $TEMPDIR/lib/FOSStriangulator
unzip -o FOSStriangulator.jar -d $TEMPDIR/lib/FOSStriangulator
cp $SCRIPTDIR/icons/* $TEMPDIR/lib/FOSStriangulator/icon/
zip -r FOSStriangulator.jar $TEMPDIR/lib/FOSStriangulator/*