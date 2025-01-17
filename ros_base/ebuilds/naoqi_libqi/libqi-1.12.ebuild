# Copyright 2020 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{6,7,8}} )

inherit ros-cmake

DESCRIPTION="Aldebaran\'s libqi: a core library for NAOqiOS development"
HOMEPAGE="http://doc.aldebaran.com/libqi"
SRC_URI="https://github.com/ros-naoqi/libqi/archive/v1.12.0-noetic/v1.12.0-noetic.tar.gz -> naoqi_libqi_1_12_0.tar.gz"

LICENSE="BSD"

KEYWORDS="~x86 ~amd64 ~arm ~arm64"
RDEPEND="
	dev-libs/boost[python]
	dev-libs/openssl
"
DEPEND="${RDEPEND}
	ros-noetic/catkin
"

SLOT="0"
ROS_DISTRO="noetic"
ROS_PREFIX="opt/ros/${ROS_DISTRO}"
