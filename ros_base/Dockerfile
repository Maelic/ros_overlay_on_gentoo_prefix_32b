# Just Ubuntu 16.04 with a user called user and some basic tools
FROM 32bit/ubuntu:16.04

RUN apt-get update
# Add sudo
RUN apt-get install apt-utils sudo -y

# Create user
RUN useradd --create-home --shell=/bin/bash user
RUN chown -R user /home/user/
# Add the user to sudoers
RUN chmod -R o-w /etc/sudoers.d/
RUN usermod -aG sudo user
# Give the user a password
RUN echo user:user | chpasswd

# Instal basic stuff
RUN apt-get install build-essential -y

# Nice tools to have
RUN apt-get install python-pip python-dev -y
RUN apt-get install bash-completion nano net-tools less iputils-ping vim emacs -y
# Download stuff
RUN apt-get install wget curl aria2 -y
# To enable ssh
RUN apt-get install openssh-server -y

WORKDIR /tmp
USER user

# Let's get some specs of the machine that is running this job
RUN cat /proc/cpuinfo; cat /proc/meminfo; df -h

# Note that we always use the same one
# This command will visit the latest release page and will look for the url of the artifact to download and download it
RUN aria2c -x 10 http://github.com`curl -s -L https://github.com/awesomebytes/gentoo_prefix_ci_32b/releases/latest | grep "download/release" | cut -d '"' -f2`

RUN tar xvf gentoo_on_tmp-*.tar.*; rm gentoo_on_tmp-*.tar.*

# Make sure it works
RUN bash gentoo/executeonprefix emerge --version

# All commands to run in the Gentoo Prefix environment must
# be preprended by $PREFIXED
ENV PREFIXED="linux32 /tmp/gentoo/executeonprefix"
ENV EPREFIX=/tmp/gentoo
ENV CHOST i686-pc-linux-gnu

# So we dont get complains
RUN echo "en_US.UTF-8 UTF-8" >> $EPREFIX/etc/locale.gen
RUN $PREFIXED locale-gen

# Let's make the compilations faster when possible
# Substitute the default -j2 with -j<NUM_CORES/2>
RUN sed -i -e 's/j2/j'"$((`grep -c \^processor \/proc\/cpuinfo` / 2))"'/g' $EPREFIX/etc/portage/make.conf
# Add extra jobs if we have enough CPUs
RUN echo "EMERGE_DEFAULT_OPTS=\"--jobs $((`grep -c \^processor \/proc\/cpuinfo` / 2)) --load-average `grep -c \^processor \/proc\/cpuinfo`\"" >> $EPREFIX/etc/portage/make.conf
RUN cat $EPREFIX/etc/portage/make.conf

RUN $PREFIXED update-ca-certificates

# We got this on dev-libs/gobject-introspection, so we need to fix the softlink to gm4
# It's surprising it happens here now, as it was happening in the next phase beforehand
# 2020-03-09T13:29:38.1931278Z flex: fatal internal error, exec of /tmp/gentoo/usr/bin/gm4 failed
# 2020-03-09T13:29:38.1931639Z ninja: build stopped: subcommand failed.
# 2020-03-09T13:29:38.1953512Z  * ERROR: dev-libs/gobject-introspection-1.62.0::gentoo failed (compile phase):
RUN unlink $EPREFIX/usr/bin/gm4 \
    && ln -s $EPREFIX/usr/bin/m4 $EPREFIX/usr/bin/gm4

# Emerging git
RUN $PREFIXED emerge dev-vcs/git

# Setting EAPI to 6 as explained in http://wiki.ros.org/Installation/Gentoo
RUN mkdir -p $EPREFIX/etc/portage/profile/ && echo "8" > $EPREFIX/etc/portage/profile/eapi

# Setting up ros-overlay https://github.com/ros/ros-overlay
RUN mkdir -p $EPREFIX/etc/portage/repos.conf && echo "[ros-overlay]\n\
location = $EPREFIX/usr/local/portage\n\
sync-type = git\n\
sync-uri = https://github.com/ros/ros-overlay\n\
auto-sync = yes\n\
masters = gentoo" > $EPREFIX/etc/portage/repos.conf/ros-overlay.conf

# Set up Gentoo to sync via git (way faster)
RUN rm -rf $EPREFIX/usr/portage && echo "[DEFAULT]\n\
main-repo = gentoo\n\
\n\
[gentoo]\n\
location = /tmp/gentoo/usr/portage\n\
sync-type = git\n\
sync-uri = https://github.com/gentoo-mirror/gentoo \n\
auto-sync = yes" > $EPREFIX/etc/portage/repos.conf/gentoo.conf

RUN echo ">=sys-devel/binutils-2.36.1-r1" >> $EPREFIX/etc/portage/package.unmask

# Sync everything
RUN $PREFIXED emaint sync -a

RUN echo "# required by dev-python/setuptools-60.9.2::gentoo\n\
>=dev-python/jaraco-text-3.7.0-r1[python_targets_pypy3(-)?,python_targets_python3_8(-)?,python_targets_python3_9(-)?,python_targets_python3_10(-)?]" >> $EPREFIX/etc/portage/package.use


RUN echo ">=dev-python/jaraco-text-3.7.0-r1" >> $EPREFIX/etc/portage/package.mask

RUN $PREFIXED emerge -1 portage

# # bug 674830
# RUN echo ">=sys-apps/dbus-1.12.10" >> $EPREFIX/etc/portage/package.mask
#RUN $PREFIXED emerge sys-apps/dbus

RUN $PREFIXED emerge =dev-libs/libical-3.0.12

RUN $PREFIXED emerge python:3.8

RUN echo ">=net-wireless/bluez-5.63-r1" >> $EPREFIX/etc/portage/package.unmask

# Build python with sqlite and bluetooth support
# I find very surprising sqlite is not mandatory
# Also enable PGO and LTO optimizations
RUN echo "dev-lang/python sqlite bluetooth readline" >> $EPREFIX/etc/portage/package.use
# To build succesfully the bluetooth support
RUN echo "net-wireless/bluez -udev" >> $EPREFIX/etc/portage/package.use &&\
    echo ">=dev-libs/libxml2-2.9.9-r3 python" >> $EPREFIX/etc/portage/package.use
RUN EXTRA_ECONF="--enable-optimizations --with-lto" $PREFIXED emerge python:3.8[sqlite,bluetooth,readline]

# Could be good to have pip running with python3.8
RUN wget https://bootstrap.pypa.io/get-pip.py && $PREFIXED python3.8 get-pip.py && rm get-pip.py 

# It's also needed to not run in problems later on (on ros-melodic/desktop)
# This can't be done anymore, the oldest version is 3.13.5 as of writing this comment
# RUN echo ">dev-util/cmake-3.12.3" >> $EPREFIX/etc/portage/package.mask
# Make sure we emerge that version
RUN $PREFIXED emerge dev-util/cmake


RUN echo "=dev-python/rospkg-1.3.0 **" >> $EPREFIX/etc/portage/package.accept_keywords
RUN echo "=dev-python/rosdistro-0.8.3 **" >> $EPREFIX/etc/portage/package.accept_keywords

RUN echo "=dev-util/rosdep-9999 **" >> $EPREFIX/etc/portage/package.accept_keywords

RUN $PREFIXED emerge dev-util/rosdep 
RUN echo ">=sys-devel/binutils-2.36.1-r1" >> $EPREFIX/etc/portage/package.unmask

RUN echo ">=dev-python/jaraco-text-3.7.0-r1"  >> $EPREFIX/etc/portage/package.unmask

RUN echo "sys-libs/libcap -pam" >> $EPREFIX/etc/portage/package.use

RUN $PREFIXED emerge sys-devel/llvm

# Patch issue https://github.com/ros/ros-overlay/issues/607
#RUN mkdir -p $EPREFIX/etc/portage/patches/ros-noetic/catkin
#ADD catkin_patchs/0001-Add-lib64-to-LD_LIBRARY_PATH.patch $EPREFIX/etc/portage/patches/ros-noetic/catkin/0001-Add-lib64-to-LD_LIBRARY_PATH.patch
#ADD catkin_patchs/0002-Add-DESTDIR-for-Gentoo.patch $EPREFIX/etc/portage/patches/ros-noetic/catkin/0002-Add-DESTDIR-for-Gentoo.patch
#ADD catkin_patchs/0003-Force-non-debian-layout.patch $EPREFIX/etc/portage/patches/ros-noetic/catkin/0003-Force-non-debian-layout.patch
#ADD catkin_patchs/0004-ADd-CATKIN_PREFIX_PATH-if-not-found.patch $EPREFIX/etc/portage/patches/ros-noetic/catkin/0004-ADd-CATKIN_PREFIX_PATH-if-not-found.patch

#RUN  $PREFIXED emerge ros-noetic/catkin


RUN echo ">=dev-libs/boost-1.77.0" >> $EPREFIX/etc/portage/package.mask
RUN echo "=dev-libs/boost-1.76.0-r1 threads python" >> $EPREFIX/etc/portage/package.use 

# Hard fix for boost not compiling with threads IUSE
RUN mkdir -p /tmp/gentoo/usr/local/portage/dev-libs/boost
ADD ebuilds/boost $EPREFIX/usr/local/portage/dev-libs/boost
RUN $PREFIXED ebuild $EPREFIX/usr/local/portage/dev-libs/boost/boost-1.76.0-r1.ebuild manifest

RUN $PREFIXED emerge =dev-libs/boost-1.76.0-r1

RUN echo "# required by ros-noetic/nodelet-1.10.2-r1::ros-overlay\n\
# required by ros-noetic/nodelet_topic_tools-1.10.2-r1::ros-overlay\n\
# required by ros-noetic/nodelet_core-1.10.2-r1::ros-overlay\n\
# required by ros-noetic/ros_base-1.5.0-r1::ros-overlay\n\
# required by ros-noetic/ros_base (argument)\n\
>=dev-libs/boost-1.76.0-r1 python threads" >> $EPREFIX/etc/portage/package.use

ENTRYPOINT ["/bin/bash"]