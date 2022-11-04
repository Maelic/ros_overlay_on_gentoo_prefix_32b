# Copyright 2021 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

EAPI=7
PYTHON_COMPAT=( python{3_8,3_9,3_10} )

inherit ros-cmake

DESCRIPTION="IKFast plugin for the PhantomX Pincher arm"
HOMEPAGE="https://wiki.ros.org"
SRC_URI="https://github.com/fictionlab-gbp/pincher_arm-release/archive/release/noetic/${PN}/0.2.0-1.tar.gz -> ${PN}-noetic-release-${PV}.tar.gz"

LICENSE="( BSD Apache-2.0 )"
KEYWORDS="~x86 ~amd64 ~arm ~arm64"
RDEPEND="
	ros-noetic/eigen_conversions
	ros-noetic/moveit_core
	ros-noetic/pluginlib
	ros-noetic/roscpp
	virtual/lapack
"
DEPEND="${RDEPEND}
	ros-noetic/catkin
	ros-noetic/tf2_eigen
	ros-noetic/tf2_kdl
"

SLOT="0"
ROS_DISTRO="noetic"
ROS_PREFIX="opt/ros/${ROS_DISTRO}"
