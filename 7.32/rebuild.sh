#!/bin/bash

rm -rf ~/gtk

jhbuild bootstrap --ignore-system
jhbuild build meta-gtk-osx-bootstrap
jhbuild build meta-gtk-osx-core
jhbuild build nip2
./package-nip2.sh

