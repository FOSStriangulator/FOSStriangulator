#!/bin/bash
SCRIPTDIR=`dirname "$0"`
SCRIPTDIR="$(cd "$(dirname $SCRIPTDIR)"; pwd -P)/$(basename "$SCRIPTDIR")"
SRCDIR="$SCRIPTDIR/../FOSStriangulator"
TEMPDIR="$SCRIPTDIR/temp-fosstriangulator-flatpak"

mkdir "$TEMPDIR"

mv "$SRCDIR/constsPlatform.pde" $TEMPDIR
cp "$SCRIPTDIR/flatpak-src/constsPlatform.pde" $SRCDIR

# Generate JAR

# have the directory containing processing-java as the first argument if it's not in $PATH
if [ "$#" -eq 1 ]; then
	$(cd "$TEMPDIR" && "$SCRIPTDIR"/generate-jar.sh $1)
else
	$(cd "$TEMPDIR" && "$SCRIPTDIR"/generate-jar.sh)
fi
rm "$SRCDIR/constsPlatform.pde"
mv "$TEMPDIR/constsPlatform.pde" $SRCDIR

# Copy over other files
cp "$SCRIPTDIR/flatpak-src/FOSStriangulator" $TEMPDIR
cp "$SRCDIR/assets/"* $TEMPDIR
cp "$SRCDIR/assets/"* $TEMPDIR
mkdir "$TEMPDIR/meta"
cp "$SCRIPTDIR/../meta/linux/"* "$TEMPDIR/meta"

# Make compressed archive
$(cd "$TEMPDIR" && tar -cJf FOSStriangulator.tar.xz *)
mv "$TEMPDIR"/FOSStriangulator.tar.xz .

# Clean up
rm "$TEMPDIR/meta"/*
rm -r "$TEMPDIR/meta"
rm "$TEMPDIR"/*
rm -r "$TEMPDIR"
