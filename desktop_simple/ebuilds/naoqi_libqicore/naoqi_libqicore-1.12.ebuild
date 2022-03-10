# Copyright 2020 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{6,7,8}} )

inherit ros-cmake

DESCRIPTION="Aldebaran\'s libqicore: a layer on top of libqi"
HOMEPAGE="https://github.com/aldebaran/libqicore"
SRC_URI="https://github.com/ros-naoqi/libqicore/archive/v1.12.0-noetic/v1.12.0-noetic.tar.gz -> naoqi_libqicore-1.12.0.tar.gz"
S="${WORKDIR}/libqicore-1.12.0-noetic/"

LICENSE="BSD"

KEYWORDS="~x86 ~amd64 ~arm ~arm64"
RDEPEND="
	ros-noetic/naoqi_libqi
"
DEPEND="${RDEPEND}
	ros-noetic/catkin
"

SLOT="0"
ROS_DISTRO="noetic"
ROS_PREFIX="opt/ros/${ROS_DISTRO}"
