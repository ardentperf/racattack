#!/bin/bash

sudo apt-get -y update
sudo apt-get -y install vnc4server twm xterm synaptic chromium-browser
sudo apt-get -y install subversion ghc libghc6-regex-compat-dev libghc6-http-dev python3.2 texlive-latex-extra texlive-fonts-extra librsvg2-bin imagemagick texlive-games texlive-fonts-recommended texlive-lang-cyrillic texlive-lang-greek arabtex texlive-science texlive-humanities python3.2-tk texlive-full libghc6-missingh-dev ttf-freefont cm-super libghc6-split-dev cabal-install libghc6-hxt-dev latex-cjk-all cm-super-minimal ttf-unifont libghc6-utility-ht-dev ttf-wqy-zenhei python-fontforge ttf-mph-2b-damase
sudo apt-get -y install python3-pyqt4 p7zip-full pdftk texmaker

cabal update
cd
svn co https://wb2pdf.svn.sourceforge.net/svnroot/wb2pdf@1390 wb2pdf

cd wb2pdf/trunk; cabal install --root-cmd=sudo --force-reinstalls
cd src; python3.2 makelinuxbins.py
sudo mkdir -p /usr/share/texmf-texlive/fonts/truetype/
cd ../font/; sudo python3.2 installunifont.py

sudo cp /usr/share/texmf/web2c/texmf.cnf /usr/share/texmf/web2c/texmf.cnf.orig
sudo sh -c "sed 's|\(^TTFONTS.*\)|\1;/usr/share/texmf-texlive/fonts/truetype//|' /usr/share/texmf/web2c/texmf.cnf.orig  >/usr/share/texmf/web2c/texmf.cnf"
sudo sh -c "echo map +megafont.map >> /usr/share/texmf-config/pdftex/config/pdftex.cfg"
sudo mkdir -p /usr/share/texmf-texlive/fonts/map/ttf2pk/config/
sudo sh -c "echo megafont@Unicode@  megafont.ttf Pid = 3 Eid = 1 >> /usr/share/texmf-texlive/fonts/map/ttf2pk/config/ttfonts.map"
sudo texhash

cd ../document/main/
wget http://upload.wikimedia.org/wikipedia/commons/5/52/Racattack-book-title.png

cd ../../
wget https://raw.github.com/ardentperf/racattack/master/makebook/wb2pdf-racattack.diff
patch -b -p0 -i wb2pdf-racattack.diff

cd ../..
wget https://raw.github.com/ardentperf/racattack/master/makebook/make-racattack-book.sh

