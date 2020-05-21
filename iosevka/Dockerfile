FROM archlinux:20200505

# iosevka deps are:
# afdko
# otfcc
# ttfautohint
# npm
# nodejs


# add building tools
RUN pacman -Syy && \
    pacman --noconfirm -Su
RUN pacman --needed --noconfirm -S base base-devel && \
    pacman --noconfirm -S git python-fs python2-pip python-pip python2-wheel python-wheel python-pytest python2-pytest


# add user for compiling packages and fonts
# makepkg does not work as root and pikaur needs a home for its tmp files
RUN useradd -m --shell=/bin/false build && \
    usermod -L build && \
    echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers


# add pikaur to install packages from the AUR easily
USER build
WORKDIR /home/build
RUN git clone --depth=1 --recursive 'https://aur.archlinux.org/pikaur.git'
WORKDIR ./pikaur
RUN makepkg --noconfirm --syncdeps -i


# to work-around the following error installing afdko
# -- error: Dependency cycle detected between {'python-fontparts': 7, 'python-fontpens': 6, 'python-booleanoperations': 6} --
# install one of afdko deps, fontpens, manually with no explicit deps
WORKDIR /home/build
RUN git clone --depth=1 --recursive 'https://aur.archlinux.org/python-fontpens.git'
WORKDIR ./python-fontpens
RUN sed -i PKGBUILD -e '/^depends=/d' && \
    makepkg --noconfirm --syncdeps -i


# finally install deps
RUN pikaur --noconfirm -S afdko
RUN pikaur --noconfirm -S otfcc && \
    pikaur --noconfirm --mflags=--skippgpcheck -S ttfautohint && \
    pikaur --noconfirm -S nodejs npm
RUN pikaur --noconfirm -S hicolor-icon-theme-git
#RUN pikaur --noconfirm -S fontforge


WORKDIR /home/build
RUN git clone -b dev --recursive --depth=1 'https://github.com/be5invis/Iosevka.git'
WORKDIR ./Iosevka
RUN npm install

# toggle the folowing line to update the image to the lastest Iosevka
#RUN true
RUN git pull

# make directory for input and output
WORKDIR /home/build
RUN mkdir external


# clean up
USER root
#RUN pacman --noconfirm -Rns python2-pip python-pip python2-wheel python-wheel python-pytest python2-pytest pikaur autoconf automake binutils bison fakeroot flex gcc groff m4 make patch pkgconf texinfo && \
RUN pacman --noconfirm -Rns python2-pip python-pip python2-wheel python-wheel python-pytest python2-pytest pikaur autoconf automake binutils bison fakeroot flex gcc groff libtool m4 make patch pkgconf texinfo && \
    rm -rf /home/build/.cache /home/build/python-fontpens /home/build/pikaur /home/build/.local && \
    yes | pacman -Scc

COPY start.sh /
RUN chmod 755 /start.sh


USER build
CMD [ '/start.sh' ]
