# Pull ros-noetic/ros_base already emerged
FROM ros_base:latest

RUN echo "ACCEPT_LICENSE=\"*\"" >> $EPREFIX/etc/portage/make.conf 

RUN echo "# required by dev-qt/qtgui-5.15.5-r2::gentoo[-gles2-only]\n\
# required by dev-qt/qtwidgets-5.15.5-r1::gentoo\n\
# required by dev-qt/qtwidgets (argument)\n\
>=media-libs/libglvnd-1.4.0 X\n\
# required by dev-qt/qtgui-5.15.5-r2::gentoo[X]\n\
# required by dev-qt/qtwidgets-5.15.5-r1::gentoo\n\
# required by dev-qt/qtwidgets (argument)\n\
>=x11-libs/libxkbcommon-1.4.1 X" >> /tmp/gentoo/etc/portage/package.use 

RUN $PREFIXED emerge dev-qt/qtcore dev-qt/qttest dev-qt/qtconcurrent dev-qt/qtwidgets 
RUN $PREFIXED USE="pcre16*" emerge dev-libs/libpcre2

# Hard fix for PyQt5 not compiling with threads IUSE
RUN mkdir -p /tmp/gentoo/usr/local/portage/dev-python/PyQt5
ADD ebuilds/PyQt5 $EPREFIX/usr/local/portage/dev-python/PyQt5
RUN $PREFIXED ebuild $EPREFIX/usr/local/portage/dev-python/PyQt5/PyQt5-5.15.6.ebuild manifest
RUN echo "# required by =dev-python/PyQt5-5.15.6[gui,widgets] (argument)\n\
>=dev-python/PyQt5-5.15.6 gui widgets" >> $EPREFIX/etc/portage/package.use

RUN $PREFIXED emerge  =dev-python/PyQt5-5.15.6[gui,widgets]

RUN echo ">=dev-python/PyQt5-5.15.6 gui widgets webkit network printsupport opengl" >> $EPREFIX/etc/portage/package.use
RUN ln -s /tmp/gentoo/usr/lib/qt5/bin/qmake qmake
RUN qt_install_libs_path=/tmp/gentoo/usr/lib; sed -i 's@$$\[QT_INSTALL_LIBS\]@'$qt_install_libs_path'@' $EPREFIX/usr/lib/libQt5Gui.prl
RUN cd /tmp/gentoo/usr/lib/cmake/Qt5Gui; find ./ -type f -exec sed -i -e 's@/home/user@/tmp@g' {} \;

# Without this perl not compiling, don't ask me why
RUN $PREFIXED USE="cpu_flags_x86_sse2" emerge virtual/rust && \
$PREFIXED perl-cleaner --backtrack=100 --all 
RUN $PREFIXED emaint sync -a

RUN $PREFIXED emerge -C virtual/perl* && \
$PREFIXED emerge -C perl-core/* && \
$PREFIXED emerge -C perl && \
$PREFIXED emerge dev-lang/perl

RUN $PREFIXED perl-cleaner --modules && \
$PREFIXED perl-cleaner --allmodules  && \ 
$PREFIXED perl-cleaner --libperl && \
$PREFIXED perl-cleaner --ph-clean && \
$PREFIXED perl-cleaner --ph-clean 

# Hard fix for dwz, because the required version isn't in the official gentoo repotitory anymore
RUN echo ">=sys-devel/dwz-0.14 **" >> $EPREFIX/etc/portage/package.accept_keywords
RUN mkdir -p /tmp/gentoo/var/cache/distfiles/ && cd /tmp/gentoo/var/cache/distfiles/ && wget --no-check-certificate 'https://drive.google.com/uc?export=download&id=1iC3nkmNAnWWNeFBZ5UbuX3TnWMmOOiht' -O dwz-0.14.tar.xz
RUN mkdir -p $EPREFIX/usr/local/portage/sys-devel/dwz
ADD ebuilds/dwz $EPREFIX/usr/local/portage/sys-devel/dwz
RUN $PREFIXED ebuild $EPREFIX/usr/local/portage/sys-devel/dwz/dwz-0.14.ebuild manifest
RUN $PREFIXED emerge sys-devel/dwz

RUN $PREFIXED emerge dev-lang/python-exec
RUN echo ">=dev-libs/urdfdom_headers-1.0.5 **\n\
>=dev-python/python_orocos_kdl-1.5.0 **\n\
>=dev-libs/urdfdom-1.0.4-r1 **">> $EPREFIX/etc/portage/package.accept_keywords


RUN $PREFIXED emerge media-libs/opencv

# Hard fix for cv_bridge to find boost 1.71
RUN cd $EPREFIX/usr/lib && ln -s libboost_python-3.8.so libboost_python.so
RUN rm -rf $EPREFIX/usr/local/portage/ros-noetic/cv_bridge && mkdir $EPREFIX/usr/local/portage/ros-noetic/cv_bridge
ADD ebuilds/cv_bridge $EPREFIX/usr/local/portage/ros-noetic/cv_bridge
RUN $PREFIXED ebuild $EPREFIX/usr/local/portage/ros-noetic/cv_bridge/cv_bridge-1.15.0-r1.ebuild manifest


RUN $PREFIXED emerge ros-noetic/desktop

# qtwebkit has been removed from the gentoo official overlay, need to add it manualy
RUN mkdir -p /tmp/gentoo/usr/local/portage/dev-qt/qtwebkit
ADD ebuilds/qtwebkit $EPREFIX/usr/local/portage/dev-qt/qtwebkit
RUN $PREFIXED ebuild $EPREFIX/usr/local/portage/dev-qt/qtwebkit/qtwebkit-5.212.0_pre20200309-r2.ebuild manifest && \
$PREFIXED emerge dev-qt/qtwebkit && \
$PREFIXED emerge =ros-noetic/diagnostics-1.10.4-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/robot-1.5.0-r1  && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/diagnostics-1.10.4-r1 && rm /tmp/gentoo/usr/bin/tmp 

RUN echo ">=dev-libs/libpcre2-10.32 pcre16" >> /tmp/gentoo/etc/portage/package.use 

RUN echo "# required by ros-noetic/rviz-1.14.11-r1::ros-overlay\n\
# required by ros-noetic/viz-1.5.0-r1::ros-overlay\n\
# required by ros-noetic/desktop-1.5.0-r1::ros-overlay\n\
# required by ros-noetic/desktop (argument)\n\
=dev-libs/urdfdom-3.0.1::gentoo **" >> $EPREFIX/etc/portage/package.accept_keywords

RUN echo "# required by ros-noetic/rviz-1.14.11-r1::ros-overlay\n\
# required by ros-noetic/viz-1.5.0-r1::ros-overlay\n\
# required by ros-noetic/desktop-1.5.0-r1::ros-overlay\n\
# required by ros-noetic/desktop (argument)\n\
=dev-libs/urdfdom_headers-1.0.5::gentoo **" >> $EPREFIX/etc/portage/package.accept_keywords

RUN echo "# required by dev-libs/collada-dom-2.5.0::gentoo\n\
# required by media-libs/assimp-5.0.1::gentoo\n\
# required by ros-noetic/collada_urdf-1.12.12::ros-overlay\n\
# required by ros-noetic/robot_model-1.12.11::ros-overlay\n\
# required by ros-noetic/robot-1.3.2::ros-overlay\n\
# required by ros-noetic/desktop-1.5.0-r1::ros-overlay\n\
# required by ros-noetic/desktop (argument)\n\
>=sys-libs/zlib-1.2.11-r4 minizip static-libs" >> $EPREFIX/etc/portage/package.accept_keywords

RUN echo ">=dev-python/python_orocos_kdl-1.5.0 **" >>  $EPREFIX/etc/portage/package.accept_keywords

RUN echo "# required by x11-libs/gtk+-3.24.31::gentoo\n\
# required by ros-noetic/desktop-1.5.0-r1::ros-overlay\n\
# required by ros-noetic/desktop (argument)\n\
>=x11-libs/cairo-1.16.0-r5 X glib svg -debug -opengl -static-libs -utils -valgrind" >> $EPREFIX/etc/portage/package.accept_keywords

RUN $PREFIXED USE="pcre16*" emerge =dev-libs/libpcre2-10.39
RUN $PREFIXED emerge =app-text/docbook-xml-dtd-4.3-r2

RUN echo "# required by dev-qt/qtgui-5.15.2-r16::gentoo[-gles2-only]\n\
# required by dev-qt/qtwidgets-5.15.2-r12::gentoo\n\
# required by dev-qt/qtwidgets (argument)\n\
>=media-libs/libglvnd-1.4.0 X\n\
# required by dev-qt/qtgui-5.15.2-r16::gentoo[X]\n\
# required by dev-qt/qtwidgets-5.15.2-r12::gentoo\n\
# required by dev-qt/qtwidgets (argument)\n\
>=x11-libs/libxkbcommon-1.4.0 X">> /tmp/gentoo/etc/portage/package.use

# To build qt successfully
RUN echo "# For ROS stuff that uses qt\n\
# dev-qt/qtgui udev\n\
dev-qt/qtgui -libinput -udev" >> /tmp/gentoo/etc/portage/package.use

RUN $PREFIXED emerge dev-qt/qtcore dev-qt/qtgui dev-qt/qttest dev-qt/qtconcurrent dev-qt/qtwidgets

RUN echo ">=virtual/ruby-ssl-11 ruby_targets_ruby27" >> $EPREFIX/etc/portage/package.use

# Hard fix for PyQt5 not compiling with threads IUSE
RUN mkdir -p /tmp/gentoo/usr/local/portage/dev-python/PyQt5
ADD ebuilds/PyQt5 $EPREFIX/usr/local/portage/dev-python/PyQt5
RUN $PREFIXED ebuild $EPREFIX/usr/local/portage/dev-python/PyQt5/PyQt5-5.15.6.ebuild manifest
RUN echo "# required by =dev-python/PyQt5-5.15.6[gui,widgets] (argument)\n\
>=dev-python/PyQt5-5.15.6 gui widgets" >> $EPREFIX/etc/portage/package.use

RUN $PREFIXED emerge  =dev-python/PyQt5-5.15.6[gui,widgets]

RUN echo ">=dev-python/PyQt5-5.15.6 gui widgets webkit network printsupport opengl" >> $EPREFIX/etc/portage/package.use

RUN echo "# required by ros-noetic/webkit_dependency-1.1.2-r1::ros-overlay\n\
# required by ros-noetic/rqt_web-0.4.10-r1::ros-overlay\n\
# required by ros-noetic/rqt_common_plugins-0.4.9-r1::ros-overlay\n\
# required by ros-noetic/viz-1.5.0-r1::ros-overlay\n\
# required by ros-noetic/desktop-1.5.0-r1::ros-overlay\n\
# required by ros-noetic/desktop (argument)\n\
=dev-python/PyQt5-5.15.6 webkit" >> $EPREFIX/etc/portage/package.use

RUN cd /tmp/gentoo/usr/bin && \
    unlink qmake && \
    ln -s /tmp/gentoo/usr/lib/qt5/bin/qmake qmake
RUN qt_install_libs_path=/tmp/gentoo/usr/lib; sed -i 's@$$\[QT_INSTALL_LIBS\]@'$qt_install_libs_path'@' $EPREFIX/usr/lib/libQt5Gui.prl
RUN cd /tmp/gentoo/usr/lib/cmake/Qt5Gui; find ./ -type f -exec sed -i -e 's@/home/user@/tmp@g' {} \;


RUN echo "# required by media-libs/assimp-5.0.1::gentoo\n\
# required by ros-noetic/rviz-1.14.11-r1::ros-overlay\n\
# required by ros-noetic/viz-1.5.0-r1::ros-overlay\n\
# required by ros-noetic/desktop-1.5.0-r1::ros-overlay\n\
# required by ros-noetic/desktop (argument)\n\
=sys-libs/zlib-1.2.11-r4 minizip" >> /tmp/gentoo/etc/portage/package.use

RUN echo "# required by media-gfx/graphviz-2.49.0::gentoo\n\
# required by dev-python/pydot-1.4.2-r3::gentoo\n\
# required by ros-noetic/qt_dotgraph-0.4.2-r1::ros-overlay\n\
# required by ros-noetic/rqt_graph-0.4.14-r1::ros-overlay\n\
# required by ros-noetic/rqt_tf_tree-0.6.2-r1::ros-overlay\n\
# required by ros-noetic/rqt_robot_plugins-0.5.8-r1::ros-overlay\n\
# required by ros-noetic/viz-1.5.0-r1::ros-overlay\n\
# required by ros-noetic/desktop-1.5.0-r1::ros-overlay\n\
# required by ros-noetic/desktop (argument)\n\
>=media-libs/gd-2.3.3-r1 truetype fontconfig\n\
# required by x11-libs/gtk+-3.24.31::gentoo\n\
# required by x11-themes/adwaita-icon-theme-41.0::gentoo\n\
# required by x11-themes/tango-icon-theme-0.8.90-r1::gentoo[-minimal]\n\
# required by ros-noetic/qt_gui-0.4.2-r1::ros-overlay\n\
# required by ros-noetic/rqt_robot_dashboard-0.5.8-r1::ros-overlay\n\
# required by ros-noetic/rqt_robot_plugins-0.5.8-r1::ros-overlay\n\
# required by ros-noetic/viz-1.5.0-r1::ros-overlay\n\
# required by ros-noetic/desktop-1.5.0-r1::ros-overlay\n\
# required by ros-noetic/desktop (argument)\n\
>=x11-libs/cairo-1.16.0-r5 X" >> $EPREFIX/etc/portage/package.use

RUN echo ">=dev-python/PyQt5-5.15.6 gui widgets webkit network printsupport opengl" >> $EPREFIX/etc/portage/package.use



RUN echo "# required by dev-python/matplotlib-3.5.1::gentoo[-test]\n\
# required by ros-noetic/rqt_plot-0.4.13-r1::ros-overlay\n\
# required by ros-noetic/rqt_bag_plugins-0.5.1-r1::ros-overlay\n\
# required by ros-noetic/rqt_common_plugins-0.4.9-r1::ros-overlay\n\
# required by ros-noetic/viz-1.5.0-r1::ros-overlay\n\
# required by ros-noetic/desktop-1.5.0-r1::ros-overlay\n\
# required by ros-noetic/desktop (argument)\n\
>=virtual/imagemagick-tools-0 jpeg tiff\n\
# required by virtual/imagemagick-tools-0::gentoo\n\
# required by dev-python/matplotlib-3.5.1::gentoo[-test]\n\
# required by ros-noetic/rqt_plot-0.4.13-r1::ros-overlay\n\
# required by ros-noetic/rqt_bag_plugins-0.5.1-r1::ros-overlay\n\
# required by ros-noetic/rqt_common_plugins-0.4.9-r1::ros-overlay\n\
# required by ros-noetic/viz-1.5.0-r1::ros-overlay\n\
# required by ros-noetic/desktop-1.5.0-r1::ros-overlay\n\
# required by ros-noetic/desktop (argument)\n\
>=media-gfx/imagemagick-7.1.0.20 jpeg tiff\n\
# required by dev-lang/ruby-3.0.3::gentoo\n\
# required by virtual/rubygems-16::gentoo[ruby_targets_ruby30]\n\
# required by dev-lang/ruby-2.6.9::gentoo\n\
# required by virtual/ruby-ssl-11::gentoo[ruby_targets_ruby26]\n\
# required by dev-ruby/racc-1.5.2-r1::gentoo\n\
# required by dev-ruby/rdoc-6.3.3-r1::gentoo[ruby_targets_ruby26]\n\
# required by dev-lang/ruby-2.7.5::gentoo[rdoc]\n\
>=dev-ruby/minitest-5.15.0 ruby_targets_ruby30 ruby_targets_ruby27\n\
# required by dev-lang/ruby-3.0.3::gentoo\n\
# required by virtual/rubygems-16::gentoo[ruby_targets_ruby30]\n\
# required by dev-lang/ruby-2.6.9::gentoo\n\
# required by virtual/ruby-ssl-11::gentoo[ruby_targets_ruby26]\n\
# required by dev-ruby/racc-1.5.2-r1::gentoo\n\
# required by dev-ruby/rdoc-6.3.3-r1::gentoo[ruby_targets_ruby26]\n\
# required by dev-lang/ruby-2.7.5::gentoo[rdoc]\n\
>=dev-ruby/power_assert-2.0.1 ruby_targets_ruby30 ruby_targets_ruby27\n\
# required by dev-lang/ruby-3.0.3::gentoo\n\
# required by virtual/rubygems-16::gentoo[ruby_targets_ruby30]\n\
# required by dev-lang/ruby-2.6.9::gentoo\n\
# required by virtual/ruby-ssl-11::gentoo[ruby_targets_ruby26]\n\
# required by dev-ruby/racc-1.5.2-r1::gentoo\n\
# required by dev-ruby/rdoc-6.3.3-r1::gentoo[ruby_targets_ruby26]\n\
# required by dev-lang/ruby-2.7.5::gentoo[rdoc]\n\
>=dev-ruby/rake-13.0.6 ruby_targets_ruby30 ruby_targets_ruby27\n\
# required by dev-ruby/typeprof-0.21.2::gentoo[ruby_targets_ruby30]\n\
# required by dev-lang/ruby-3.0.3::gentoo\n\
# required by virtual/rubygems-16::gentoo[ruby_targets_ruby30]\n\
# required by dev-lang/ruby-2.6.9::gentoo\n\
# required by virtual/ruby-ssl-11::gentoo[ruby_targets_ruby26]\n\
# required by dev-ruby/racc-1.5.2-r1::gentoo\n\
# required by dev-ruby/rdoc-6.3.3-r1::gentoo[ruby_targets_ruby26]\n\
# required by dev-lang/ruby-2.7.5::gentoo[rdoc]\n\
>=dev-ruby/rbs-2.2.2 ruby_targets_ruby30\n\
# required by dev-lang/ruby-3.0.3::gentoo\n\
# required by virtual/rubygems-16::gentoo[ruby_targets_ruby30]\n\
# required by dev-lang/ruby-2.6.9::gentoo\n\
# required by virtual/ruby-ssl-11::gentoo[ruby_targets_ruby26]\n\
# required by dev-ruby/racc-1.5.2-r1::gentoo\n\
# required by dev-ruby/rdoc-6.3.3-r1::gentoo[ruby_targets_ruby26]\n\
# required by dev-lang/ruby-2.7.5::gentoo[rdoc]\n\
>=dev-ruby/rexml-3.2.5 ruby_targets_ruby30\n\
# required by dev-lang/ruby-3.0.3::gentoo\n\
# required by virtual/rubygems-16::gentoo[ruby_targets_ruby30]\n\
# required by dev-lang/ruby-2.6.9::gentoo\n\
# required by virtual/ruby-ssl-11::gentoo[ruby_targets_ruby26]\n\
# required by dev-ruby/racc-1.5.2-r1::gentoo\n\
# required by dev-ruby/rdoc-6.3.3-r1::gentoo[ruby_targets_ruby26]\n\
# required by dev-lang/ruby-2.7.5::gentoo[rdoc]\n\
>=dev-ruby/rss-0.2.9 ruby_targets_ruby30\n\
# required by dev-lang/ruby-3.0.3::gentoo\n\
# required by virtual/rubygems-16::gentoo[ruby_targets_ruby30]\n\
# required by dev-lang/ruby-2.6.9::gentoo\n\
# required by virtual/ruby-ssl-11::gentoo[ruby_targets_ruby26]\n\
# required by dev-ruby/racc-1.5.2-r1::gentoo\n\
# required by dev-ruby/rdoc-6.3.3-r1::gentoo[ruby_targets_ruby26]\n\
# required by dev-lang/ruby-2.7.5::gentoo[rdoc]\n\
>=dev-ruby/test-unit-3.5.3 ruby_targets_ruby30 ruby_targets_ruby27\n\
# required by dev-lang/ruby-3.0.3::gentoo\n\
# required by virtual/rubygems-16::gentoo[ruby_targets_ruby30]\n\
# required by dev-lang/ruby-2.6.9::gentoo\n\
# required by virtual/ruby-ssl-11::gentoo[ruby_targets_ruby26]\n\
# required by dev-ruby/racc-1.5.2-r1::gentoo\n\
# required by dev-ruby/rdoc-6.3.3-r1::gentoo[ruby_targets_ruby26]\n\
# required by dev-lang/ruby-2.7.5::gentoo[rdoc]\n\
>=dev-ruby/typeprof-0.21.2 ruby_targets_ruby30\n\
# required by dev-lang/ruby-3.0.3::gentoo\n\
# required by virtual/rubygems-16::gentoo[ruby_targets_ruby30]\n\
# required by dev-lang/ruby-2.6.9::gentoo\n\
# required by virtual/ruby-ssl-11::gentoo[ruby_targets_ruby26]\n\
# required by dev-ruby/racc-1.5.2-r1::gentoo\n\
# required by dev-ruby/rdoc-6.3.3-r1::gentoo[ruby_targets_ruby26]\n\
# required by dev-lang/ruby-2.7.5::gentoo[rdoc]\n\
>=dev-ruby/bundler-2.2.33 ruby_targets_ruby30 ruby_targets_ruby27\n\
# required by dev-lang/ruby-3.0.3::gentoo\n\
# required by virtual/rubygems-16::gentoo[ruby_targets_ruby30]\n\
# required by dev-lang/ruby-2.6.9::gentoo\n\
# required by virtual/ruby-ssl-11::gentoo[ruby_targets_ruby26]\n\
# required by dev-ruby/racc-1.5.2-r1::gentoo\n\
# required by dev-ruby/rdoc-6.3.3-r1::gentoo[ruby_targets_ruby26]\n\
# required by dev-lang/ruby-2.7.5::gentoo[rdoc]\n\
>=dev-ruby/did_you_mean-1.6.1 ruby_targets_ruby30 ruby_targets_ruby27\n\
# required by dev-lang/ruby-3.0.3::gentoo\n\
# required by virtual/rubygems-16::gentoo[ruby_targets_ruby30]\n\
# required by dev-lang/ruby-2.6.9::gentoo\n\
# required by virtual/ruby-ssl-11::gentoo[ruby_targets_ruby26]\n\
# required by dev-ruby/racc-1.5.2-r1::gentoo\n\
# required by dev-ruby/rdoc-6.3.3-r1::gentoo[ruby_targets_ruby26]\n\
# required by dev-lang/ruby-2.7.5::gentoo[rdoc]\n\
>=dev-ruby/json-2.6.1 ruby_targets_ruby30 ruby_targets_ruby27\n\
# required by dev-lang/ruby-3.0.3::gentoo[rdoc]\n\
# required by virtual/rubygems-16::gentoo[ruby_targets_ruby30]\n\
# required by dev-lang/ruby-2.6.9::gentoo\n\
# required by virtual/ruby-ssl-11::gentoo[ruby_targets_ruby26]\n\
# required by dev-ruby/racc-1.5.2-r1::gentoo\n\
>=dev-ruby/rdoc-6.3.3-r1 ruby_targets_ruby30 ruby_targets_ruby27\n\
# required by dev-lang/python-3.10.2-r1::gentoo\n\
# required by media-libs/mesa-22.0.0_rc2::gentoo\n\
# required by virtual/opengl-7.0-r2::gentoo\n\
# required by dev-python/pyopengl-3.1.6::gentoo[-test]\n\
# required by ros-noetic/rqt_pose_view-0.5.11-r1::ros-overlay\n\
# required by ros-noetic/rqt_robot_plugins-0.5.8-r1::ros-overlay\n\
# required by ros-noetic/viz-1.5.0-r1::ros-overlay\n\
# required by ros-noetic/desktop-1.5.0-r1::ros-overlay\n\
# required by ros-noetic/desktop (argument)\n\
>=dev-lang/python-exec-2.4.8 python_targets_python3_10\n\
# required by dev-ruby/typeprof-0.21.2::gentoo[-test,ruby_targets_ruby30]\n\
# required by dev-lang/ruby-3.0.3::gentoo\n\
# required by dev-ruby/rbs-2.2.2::gentoo[ruby_targets_ruby30]\n\
>=virtual/rubygems-16 ruby_targets_ruby30 ruby_targets_ruby27\n\
# required by virtual/rubygems-16::gentoo[ruby_targets_ruby27]\n\
# required by dev-lang/ruby-2.6.9::gentoo\n\
# required by virtual/ruby-ssl-11::gentoo[ruby_targets_ruby26]\n\
# required by dev-ruby/racc-1.5.2-r1::gentoo\n\
# required by dev-ruby/rdoc-6.3.3-r1::gentoo[ruby_targets_ruby26]\n\
# required by dev-lang/ruby-2.7.5::gentoo[rdoc]\n\
>=dev-ruby/rubygems-3.2.33 ruby_targets_ruby30 ruby_targets_ruby27\n\
# required by dev-lang/ruby-2.7.5::gentoo\n\
# required by virtual/rubygems-16::gentoo[ruby_targets_ruby27]\n\
# required by dev-lang/ruby-2.6.9::gentoo\n\
# required by virtual/ruby-ssl-11::gentoo[ruby_targets_ruby26]\n\
# required by dev-ruby/racc-1.5.2-r1::gentoo\n\
# required by dev-ruby/rdoc-6.3.3-r1::gentoo[ruby_targets_ruby26]\n\
# required by dev-lang/ruby-3.0.3::gentoo[rdoc]\n\
# required by dev-ruby/rbs-2.2.2::gentoo[ruby_targets_ruby30]\n\
# required by dev-ruby/typeprof-0.21.2::gentoo[ruby_targets_ruby30]\n\
>=dev-ruby/net-telnet-0.2.0-r1 ruby_targets_ruby27\n\
# required by dev-lang/ruby-2.7.5::gentoo\n\
# required by virtual/rubygems-16::gentoo[ruby_targets_ruby27]\n\
# required by dev-lang/ruby-2.6.9::gentoo\n\
# required by virtual/ruby-ssl-11::gentoo[ruby_targets_ruby26]\n\
# required by dev-ruby/racc-1.5.2-r1::gentoo\n\
# required by dev-ruby/rdoc-6.3.3-r1::gentoo[ruby_targets_ruby26]\n\
# required by dev-lang/ruby-3.0.3::gentoo[rdoc]\n\
# required by dev-ruby/rbs-2.2.2::gentoo[ruby_targets_ruby30]\n\
# required by dev-ruby/typeprof-0.21.2::gentoo[ruby_targets_ruby30]\n\
>=dev-ruby/xmlrpc-0.3.2-r1 ruby_targets_ruby27\n\
# required by dev-ruby/rdoc-6.3.3-r1::gentoo[ruby_targets_ruby30]\n\
# required by dev-lang/ruby-3.0.3::gentoo[rdoc]\n\
# required by virtual/ruby-ssl-11::gentoo[ruby_targets_ruby30]\n\
# required by dev-ruby/racc-1.5.2-r1::gentoo[ruby_targets_ruby27]\n\
>=dev-ruby/kpeg-1.3.1 ruby_targets_ruby27 ruby_targets_ruby30\n\
# required by dev-ruby/rdoc-6.3.3-r1::gentoo[ruby_targets_ruby30]\n\
# required by dev-lang/ruby-3.0.3::gentoo[rdoc]\n\
# required by virtual/ruby-ssl-11::gentoo[ruby_targets_ruby30]\n\
# required by dev-ruby/rubygems-3.2.33::gentoo[ruby_targets_ruby30]\n\
# required by virtual/rubygems-16::gentoo[ruby_targets_ruby30]\n\
# required by dev-lang/ruby-2.7.5::gentoo\n\
# required by dev-ruby/minitest-5.15.0::gentoo[ruby_targets_ruby27]\n\
# required by dev-lang/ruby-2.6.9::gentoo\n\
# required by dev-ruby/rbs-2.2.2::gentoo[ruby_targets_ruby26]\n\
# required by dev-ruby/typeprof-0.21.2::gentoo[ruby_targets_ruby30]\n\
>=dev-ruby/racc-1.5.2-r1 ruby_targets_ruby27 ruby_targets_ruby30\n\
# required by dev-ruby/xmlrpc-0.3.2-r1::gentoo[ruby_targets_ruby27]\n\
# required by dev-lang/ruby-2.6.9::gentoo\n\
# required by virtual/ruby-ssl-11::gentoo[ruby_targets_ruby26]\n\
# required by dev-ruby/racc-1.5.2-r1::gentoo[ruby_targets_ruby27]\n\
# required by dev-ruby/rdoc-6.3.3-r1::gentoo[ruby_targets_ruby26]\n\
# required by dev-lang/ruby-3.0.3::gentoo[rdoc]\n\
# required by dev-ruby/rbs-2.2.2::gentoo[ruby_targets_ruby30]\n\
# required by dev-ruby/typeprof-0.21.2::gentoo[ruby_targets_ruby30]\n\
>=dev-ruby/webrick-1.7.0 ruby_targets_ruby27\n\
# required by dev-ruby/racc-1.5.2-r1::gentoo[ruby_targets_ruby30]\n\
# required by dev-ruby/rdoc-6.3.3-r1::gentoo[ruby_targets_ruby26]\n\
# required by dev-lang/ruby-3.0.3::gentoo[rdoc]\n\
# required by dev-ruby/rbs-2.2.2::gentoo[ruby_targets_ruby30]\n\
# required by dev-ruby/typeprof-0.21.2::gentoo[ruby_targets_ruby30]\n\
>=virtual/ruby-ssl-11 ruby_targets_ruby30" >> $EPREFIX/etc/portage/package.use

RUN $PREFIXED USE="cpu_flags_x86_sse2" emerge =virtual/rust-1.58.1
RUN $PREFIXED perl-cleaner --all
RUN $PREFIXED emaint sync -a

RUN $PREFIXED emerge -C virtual/perl*
RUN $PREFIXED emerge -C perl-core/*
RUN $PREFIXED emerge -C perl
RUN $PREFIXED emerge =dev-lang/perl-5.34.0-r8
RUN $PREFIXED perl-cleaner --modules 
RUN $PREFIXED perl-cleaner --allmodules 
RUN $PREFIXED perl-cleaner --libperl 
RUN $PREFIXED perl-cleaner --ph-clean
RUN $PREFIXED perl-cleaner --ph-clean 


RUN echo ">=sys-devel/dwz-0.14 **" >> $EPREFIX/etc/portage/package.accept_keywords
RUN mkdir -p /tmp/gentoo/var/cache/distfiles/ && cd /tmp/gentoo/var/cache/distfiles/ && wget --no-check-certificate 'https://drive.google.com/uc?export=download&id=1iC3nkmNAnWWNeFBZ5UbuX3TnWMmOOiht' -O dwz-0.14.tar.xz
RUN mkdir -p $EPREFIX/usr/local/portage/sys-devel/dwz
ADD ebuilds/dwz $EPREFIX/usr/local/portage/sys-devel/dwz
RUN $PREFIXED ebuild $EPREFIX/usr/local/portage/sys-devel/dwz/dwz-0.14.ebuild manifest
RUN $PREFIXED emerge sys-devel/dwz

RUN $PREFIXED emerge =dev-lang/python-exec-2.4.8


# Somehow there is a collision file /tmp/gentoo/usr/bin/tmp so we need to remove it, and this between every package emerge
# This is maybe the ugliest fix you've seen so far, sorry for that
RUN rm /tmp/gentoo/usr/bin/tmp 
RUN $PREFIXED emerge =ros-noetic/angles-1.9.13-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/urdf_parser_plugin-1.13.2-r1 && rm /tmp/gentoo/usr/bin/tmp  && \
$PREFIXED emerge =ros-noetic/media_export-0.3.0-r1 && rm /tmp/gentoo/usr/bin/tmp  && \
$PREFIXED emerge =ros-noetic/qwt_dependency-1.1.1-r1 && rm /tmp/gentoo/usr/bin/tmp  && \
$PREFIXED emerge =ros-noetic/roslint-0.12.0-r1 && rm /tmp/gentoo/usr/bin/tmp  && \
$PREFIXED emerge =ros-noetic/kdl_conversions-1.13.2-r1 && rm /tmp/gentoo/usr/bin/tmp && \ 
$PREFIXED emerge =ros-noetic/eigen_conversions-1.13.2-r1 && rm /tmp/gentoo/usr/bin/tmp  && \
$PREFIXED emerge =ros-noetic/smach_msgs-2.5.0-r1 && rm /tmp/gentoo/usr/bin/tmp  && \
$PREFIXED emerge =ros-noetic/tf2_msgs-0.7.5-r1 && rm /tmp/gentoo/usr/bin/tmp  && \
$PREFIXED emerge =ros-noetic/map_msgs-1.14.1-r1 && rm /tmp/gentoo/usr/bin/tmp  && \
$PREFIXED emerge =ros-noetic/control_msgs-1.5.2-r1 && rm /tmp/gentoo/usr/bin/tmp  && \
$PREFIXED emerge =ros-noetic/visualization_marker_tutorials-0.11.0-r1 && rm /tmp/gentoo/usr/bin/tmp  && \
$PREFIXED emerge =ros-noetic/tf2-0.7.5-r1 && rm /tmp/gentoo/usr/bin/tmp  && \
$PREFIXED emerge =ros-noetic/roscpp_tutorials-0.10.2-r1 && rm /tmp/gentoo/usr/bin/tmp  && \
$PREFIXED emerge =ros-noetic/resource_retriever-1.12.6-r1 && rm /tmp/gentoo/usr/bin/tmp  && \
$PREFIXED emerge =ros-noetic/urdf-1.13.2-r1 && rm /tmp/gentoo/usr/bin/tmp  

RUN $PREFIXED emerge =ros-noetic/joint_state_publisher-1.15.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/image_transport-1.12.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/tf2_py-0.7.5-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/pluginlib_tutorials-0.2.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/xacro-1.14.10-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/nodelet_tutorial_math-0.2.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/kdl_parser-1.14.1-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/rospy_tutorials-0.10.2-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/cv_bridge-1.15.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/diagnostic_updater-1.10.4-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/filters-1.9.1-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/diagnostic_aggregator-1.10.4-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/self_test-1.10.4-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/tf2_ros-0.7.5-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/diagnostic_analysis-1.10.4-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/actionlib_tutorials-0.2.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/smach-2.5.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/smach_msgs-2.5.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/smach_ros-2.5.0-r1 && rm /tmp/gentoo/usr/bin/tmp

RUN $PREFIXED emerge =ros-noetic/tf-1.13.2-r1 && rm /tmp/gentoo/usr/bin/tmp

RUN echo "# required by ros-noetic/urdf-1.13.2-r1::ros-overlay\n\
# required by ros-noetic/kdl_parser-1.14.1-r1::ros-overlay\n\
# required by ros-noetic/robot_state_publisher-1.15.2-r1::ros-overlay\n\
# required by ros-noetic/robot_state_publisher-1.15.2-r1 (argument)\n\
>=dev-libs/urdfdom-1.0.4-r1::gentoo **" >> $EPREFIX/etc/portage/package.accept_keywords

RUN $PREFIXED emerge =ros-noetic/tf2_kdl-0.7.5-r1 && rm /tmp/gentoo/usr/bin/tmp

RUN $PREFIXED emerge =ros-noetic/robot_state_publisher-1.15.2-r1 && rm /tmp/gentoo/usr/bin/tmp

RUN $PREFIXED emerge =ros-noetic/executive_smach-2.5.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/tf2_geometry_msgs-0.7.5-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/interactive_markers-1.12.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/laser_geometry-1.6.7-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/tf_conversions-1.13.2-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/diagnostic_common_diagnostics-1.10.4-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/geometry-1.13.2-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/interactive_marker_tutorials-0.11.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/turtlesim-0.10.2-r1 && rm /tmp/gentoo/usr/bin/tmp

# qtwebkit has been removed from the gentoo official overlay, need to add it manualy
RUN mkdir -p /tmp/gentoo/usr/local/portage/dev-qt/qtwebkit
ADD ebuilds/qtwebkit $EPREFIX/usr/local/portage/dev-qt/qtwebkit
RUN $PREFIXED ebuild $EPREFIX/usr/local/portage/dev-qt/qtwebkit/qtwebkit-5.212.0_pre20200309-r2.ebuild manifest
RUN $PREFIXED emerge dev-qt/qtwebkit


RUN $PREFIXED emerge =ros-noetic/diagnostics-1.10.4-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/robot-1.5.0-r1  && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/ros_tutorials-0.10.2-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/turtle_actionlib-0.2.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/turtle_tf2-0.2.3-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/turtle_tf-0.2.3-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/geometry_tutorials-0.2.3-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/turtle_tf-0.2.3-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/diagnostics-1.10.4-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/turtle_tf2-0.2.3-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/turtle_actionlib-0.2.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/python_qt_binding-0.4.4-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/qt_gui-0.4.2-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/gl_dependency-1.1.2-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/webkit_dependency-1.1.2-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/common_tutorials-0.2.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/qt_gui_py_common-0.4.2-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/joint_state_publisher_gui-1.15.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/rqt_gui-0.5.2-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/rqt_py_common-0.5.2-r1 && rm /tmp/gentoo/usr/bin/tmp

RUN echo "# required by ros-noetic/pcl_ros-1.7.3-r1::ros-overlay\n\
# required by ros-noetic/perception-1.5.0-r1::ros-overlay\n\
# required by ros-noetic/perception_pcl-1.7.3-r1::ros-overlay\n\
# required by ros-noetic/perception (argument)\n\
>=sci-libs/pcl-1.12.0::gentoo **"  >> $EPREFIX/etc/portage/package.accept_keywords

# ROS perception
RUN $PREFIXED emerge =ros-noetic/image_geometry-1.15.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/pcl_msgs-0.3.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/tf2_eigen-0.7.5-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/compressed_depth_image_transport-1.14.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/laser_filters-1.9.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/compressed_image_transport-1.14.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/image_rotate-1.16.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/image_proc-1.16.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/camera_calibration-1.16.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/polled_camera-1.12.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/depth_image_proc-1.16.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/laser_assembler-1.7.8-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/vision_opencv-1.15.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/stereo_image_proc-1.16.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/theora_image_transport-1.14.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/camera_calibration_parsers-1.12.0-r1 && rm /tmp/gentoo/usr/bin/tmp  && \
$PREFIXED emerge =ros-noetic/laser_pipeline-1.6.4-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/camera_info_manager-1.12.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/image_view-1.16.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/image_transport_plugins-1.14.0-r1&& rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/image_publisher-1.16.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/image_pipeline-1.16.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =sci-libs/flann-1.9.1-r5 

RUN $PREFIXED emerge =ros-noetic/image_common-1.12.0-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =sci-libs/pcl-1.12.0 && \
$PREFIXED emerge =ros-noetic/pcl_conversions-1.7.3-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/pcl_ros-1.7.3-r1 && rm /tmp/gentoo/usr/bin/tmp && \
$PREFIXED emerge =ros-noetic/perception_pcl-1.7.3-r1 && rm /tmp/gentoo/usr/bin/tmp
RUN $PREFIXED emerge ros-noetic/perception

RUN tar cvzf /tmp/gentoo_on_tmp.tar.gz gentoo

ENTRYPOINT ["/bin/bash"]
