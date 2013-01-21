#!/bin/bash

long_version=`jhbuild run vips --version`

major=`jhbuild run vips im_version 0`
minor=`jhbuild run vips im_version 1`
micro=`jhbuild run vips im_version 2`

version="$major.$minor.$micro"

year=`date +%Y`
copyright="© $year Imperial College, London"

function escape () {
        # escape slashes
	tmp=${1//\//\\\/}

	# escape colon
	tmp=${tmp//\:/\\:}

	# escape tilda
	tmp=${tmp//\~/\\~}

	# escape percent
	tmp=${tmp//\%/\\%}

	echo -n $tmp
}

function new () {
	echo > script.sed
}

function sub () {
        echo -n s/ >> script.sed
	escape "$1" >> script.sed
	echo -n / >> script.sed
	escape "$2" >> script.sed
	echo /g >> script.sed
}

function patch () {
	echo patching "$1"

	sed -f script.sed -i "" "$1"
}

cp Info.plist.in Info.plist
new
sub @LONG_VERSION@ "$long_version"
sub @VERSION@ "$version"
sub @COPYRIGHT@ "$copyright"
patch Info.plist

rm -rf ~/Desktop/nip2.app ~/Desktop/nip2-$version.app

jhbuild run gtk-mac-bundler nip2.bundle

cp ~/package/vips/transform-7.22/resample.plg ~/Desktop/nip2.app/Contents/Resources/lib
mv ~/Desktop/nip2.app ~/Desktop/nip2-$version.app

echo built ~/Desktop/nip2-$version.app

echo building .dmg
rm -f ~/Desktop/nip2-$version.app.dmg
hdiutil create -srcfolder ~/Desktop/nip2-$version.app -o ~/Desktop/nip2-$version.app.dmg
echo built ~/Desktop/nip2-$version.app.dmg
