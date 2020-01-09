#!/bin/bash

long_version=`jhbuild run nip2 --version`

if [[ ! $long_version =~ ^nip2-([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
	echo bad version number from nip2 --version
fi

version=${BASH_REMATCH[1]}.${BASH_REMATCH[2]}.${BASH_REMATCH[3]}

year=`date +%Y`
copyright="© $year Imperial College, London"

# nip2.bundle writes here
dst=~/Desktop/nip2.app
dst_prefix=$dst/Contents/Resources

# jhbuild installs to here
src=~/gtk/inst

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

rm -rf $dst 
rm -rf ~/Desktop/nip2-$version.app

echo bundling nip2.app ...

jhbuild run gtk-mac-bundler nip2.bundle

# current pango does not need any of this stuff
# cp $src/lib/pango/1.8.0/modules.cache $dst_prefix/lib/pango/1.8.0
# new
# sub "$src/lib/pango/1.8.0/modules/" ""
# patch $dst_prefix/lib/pango/1.8.0/modules.cache

rm $dst_prefix/etc/fonts/conf.d/*.conf
( cd $dst_prefix/etc/fonts/conf.d ; \
	ln -s ../../../share/fontconfig/conf.avail/*.conf . )

# we can't copy the IM share with nip2.bundle because it drops the directory
# name, annoyingly
cp -r $src/share/ImageMagick-* $dst_prefix/share

cp $src/lib/resample.plg $dst_prefix/lib

mv $dst ~/Desktop/nip2-$version.app

echo built ~/Desktop/nip2-$version.app

echo building .dmg
rm -f ~/Desktop/nip2-$version.app.dmg
hdiutil create -srcfolder ~/Desktop/nip2-$version.app -o ~/Desktop/nip2-$version.app.dmg
echo built ~/Desktop/nip2-$version.app.dmg
