#!/bin/bash

# have the directory containing processing-java as the first argument if it's not in $PATH
if [ "$#" -eq 1 ]; then
    PROCESSING_DIR=$1
	if ! command -v $PROCESSING_DIR/processing-java &> /dev/null
	then
		echo "processing-java could not be found in $PROCESSING_DIR."
		exit 2
	fi
fi

SCRIPTDIR=`dirname "$0"`
SCRIPTDIR="$(cd "$(dirname $SCRIPTDIR)"; pwd -P)/$(basename "$SCRIPTDIR")"
SRCDIR="$SCRIPTDIR/../FOSStriangulator"
TEMPDIR="$SCRIPTDIR/temp-fosstriangulator-jar"
LIBDIR="$TEMPDIR/lib"

if [ "$#" -eq 1 ]; then
	$(cd $PROCESSING_DIR && ./processing-java --force --sketch=$SRCDIR --output=$TEMPDIR --export --platform='linux')
else
	processing-java --force --sketch=$SRCDIR --output=$TEMPDIR --export --platform='linux'
fi

unzip -o $LIBDIR/controlP5.jar -d $LIBDIR/FOSStriangulator
unzip -o $LIBDIR/core.jar -d $LIBDIR/FOSStriangulator
unzip -o $LIBDIR/itext.jar -d $LIBDIR/FOSStriangulator
unzip -o $LIBDIR/pdf.jar -d $LIBDIR/FOSStriangulator
unzip -o $LIBDIR/FOSStriangulator.jar -d $LIBDIR/FOSStriangulator
cp $SCRIPTDIR/icons/* $LIBDIR/FOSStriangulator/icon/
$(cd $LIBDIR/FOSStriangulator && zip -r FOSStriangulator.jar *)
mv $LIBDIR/FOSStriangulator/FOSStriangulator.jar .

# Remove temp directory
rm -rf "$TEMPDIR/java"
rm -rf "$TEMPDIR/lib/FOSStriangulator"
rm "$TEMPDIR/lib"/*
rm -r "$TEMPDIR/lib"
rm -rf "$TEMPDIR/source"
rm -r "$TEMPDIR"
