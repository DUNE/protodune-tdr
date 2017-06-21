#!/bin/bash

# This script will use the state of the current checked in HEAD in a
# fresh temporary directory to make sure the document builds.

# usage:
#
# ./arxiv-it.sh [main.tex]
#
# if main.tex is not given it is assumed to be named as the current
# working directory (+ .tex)

mydir=$(dirname $(readlink -f $BASH_SOURCE))
name=$(basename $mydir)

main={$1:-${name}.tex}


workdir=$(mktemp -d /tmp/arxiv-it-XXXXXX)
echo $workdir


tarball=${name}.tar
git archive --format=tar --prefix=$name/ -o $workdir/$tarball HEAD || exit 1

cd $workdir/
tar -xf $tarball
cd $name
# don't add -bibtex because arXiv doesn't
latexmk -pdf ${name}.tex  || exit 2

echo "Results are in:"
echo $workdir/$name


