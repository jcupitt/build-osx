# todo

- check how the bundler makes pango.modules, could this help our pangoft2 
  issues?

	bin/gdk-pixbuf-query-loaders > lib/gdk-pixbuf-2.0/2.10.0/loaders.cache
	bin/gtk-query-immodules-2.0 > etc/gtk-2.0/gtk.immodules
	bin/pango-querymodules > etc/pango/pango.modules

See:

  https://github.com/jcupitt/libvips/wiki/Build-for-macOS

# Steps

## reset download, build and install area

If you had a previous gtk-osx build system you are updating, flush the
whole of the old build area, but keep downloaded tarballs, if possible

		mv ~/gtk/source/pkgs .
		rm -rf ~/gtk/inst
		rm -rf ~/gtk/source/*
		mv pkgs ~/gtk/source

Stale files here will cause a range of annoying problems.

If you are using homebrew or macports or fink, make sure those systems
are turned off. For example

		cd /usr/local
		sudo mkdir x
		sudo mv * x

Remove the optional Apple X11 libs as well:

    sudo mv /opt/X11 /opt/x
    
we don't want any configure files picking them up either.

Check your environment too.

## install gtk-osx

Remove any old .jhbuild files first.  Remove ~/.local.  Remove ~/Source.

See:

		https://wiki.gnome.org/Projects/GTK%2B/OSX/Building

Download and run the latest gtk-osx-build-setup.sh to update your
build system.

Append

    setup_release()

to your ~/.jhbuildrc-custom to enable optimisation

## jhbuild bootstrap 

This has to be first, since it builds .xz support for extracting 
archives.

## jhbuild build python

Some of the later modules, for example gobject-introspection, assume 
you are using the jhbuild python, you need this.

It installs to ~/gtk/inst and that area is added to the jhbuild shell
for you, so no need to touch your .profile.

Make sure ~/gtk/inst/bin is NOT in your path, you don't want to use
this new python to run jhbuild itself.

## add pip

Later, gtk-doc needs six to install, so you need to add this module to the
jhbuild python.

    jhbuild shell
    python -m ensurepip
    pip install --user six

or possibly

    jhbuild shell
    curl https://bootstrap.pypa.io/get-pip.py > get-pip.py
    python ~/get-pip.py
    pip install --user six

## jhbuild build meta-gtk-osx-bootstrap

## jhbuild build meta-gtk-osx-core

This is a good time to take a snapshot.

   	cp -r ~/gtk ~/gtk-snapshot

Now you won't need to rebuild the universe for a new vips change, or perhaps
a new imagemagick version test.

To enable the vips modules, append:

    moduleset = "file:///Users/john/GIT/build-osx/8.6/vips-osx.modules"

adjusted appropriately to `~/.jhbuildrc-custom`.

## jhbuild build nip2

## jhbuild run nip2 

	To test the build.

## install the bundler:

	https://wiki.gnome.org/Projects/GTK%2B/OSX/Bundling

  https://github.com/jralls/gtk-mac-bundler

  cd GIT
  git clone https://github.com/jralls/gtk-mac-bundler.git
  cd gtk-mac-bundler
  make install

Installs `gtk-mac-bundler` to `~/.local/bin`.

## build resample.plg

	jhbuild shell
	cd ~/package/vips/transform-7.30
	make clean
	make
	cp resample.plg ~/gtk/inst/lib
	^D

## ./package-nip2.sh

## open ~/Desktop/nip2-x.x.x.app

	to test the packaged app.

	Try renaming ~/gtk to something else to make sure you're not
	accidentally picking up files users may not have. "mv ~/gtk ~/x".

	Test application text (menus etc.), rendering in nip2 windows (drag a
	region, verify that labels are drawn correctly) and pango ft2 text
	(load the businesscard.ws example).

	Verify that in-app icons work, eg. the nip2 icon in the background of
	the "About" dialog. 

	Verify that goffice plots work: Hist / New etc. 



