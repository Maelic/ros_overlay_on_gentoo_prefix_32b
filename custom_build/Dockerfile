# Pull ros-noetic/ros_base already emerged
FROM noetic-desktop-2

########## Global Configuration Parameters ############

RUN echo "ACCEPT_LICENSE=\"*\"" >> $EPREFIX/etc/portage/make.conf 

################################################

########## ROS dependencies and required keywords ############

RUN echo ">=sci-libs/octomap-1.9.7::gentoo **" >>  $EPREFIX/etc/portage/package.accept_keywords

RUN echo "# required by media-gfx/graphviz-2.49.0::gentoo\n\
# required by ros-noetic/tf-1.13.2-r1::ros-overlay\n\
# required by ros-noetic/octomap_ros-0.4.1-r1::ros-overlay\n\
# required by ros-noetic/octomap_ros (argument)\n\
>=media-libs/gd-2.3.3-r1 fontconfig truetype" >>  $EPREFIX/etc/portage/package.use

################################################

########## Patches and source build ############

RUN rm -r /tmp/gentoo/usr/local/portage/ros-noetic/octomap_ros/ && mkdir -p /tmp/gentoo/usr/local/portage/ros-noetic/octomap_ros/
ADD ebuilds/octomap_ros /tmp/gentoo/usr/local/portage/ros-noetic/octomap_ros
RUN $PREFIXED ebuild /tmp/gentoo/usr/local/portage/ros-noetic/octomap_ros/octomap_ros-0.4.1-r1.ebuild manifest

################################################

########## ROS packages ############

RUN FETCHCOMMAND="wget -t 5 --no-check-certificate \${URI} -O \${DISTDIR}/\${FILE}"  $PREFIXED emerge ros-noetic/octomap_ros
RUN $PREFIXED emerge ros-melodic/perception

################################################
 

########## Python packages ############

RUN $PREFIXED python3.8 -m pip install nltk pillow speech_recognition

################################################



ENTRYPOINT ["/bin/bash"]
