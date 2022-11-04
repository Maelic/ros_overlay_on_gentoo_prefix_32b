# Copyright 2021 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

EAPI=7
PYTHON_COMPAT=( python{3_8,3_9,3_10} )

inherit ros-cmake

DESCRIPTION="URDF robot description for Jackal"
HOMEPAGE="https://wiki.ros.org"
SRC_URI="https://github.com/clearpath-gbp/jackal-release/archive/release/noetic/${PN}/0.8.0-2.tar.gz -> ${PN}-noetic-release-${PV}.tar.gz"

LICENSE="BSD"

KEYWORDS="~x86 ~amd64 ~arm ~arm64"
RDEPEND="
	ros-noetic/lms1xx
	ros-noetic/pointgrey_camera_description
	ros-noetic/robot_state_publisher
	ros-noetic/urdf
	ros-noetic/velodyne_description
	ros-noetic/xacro
"
DEPEND="${RDEPEND}
	ros-noetic/catkin
	ros-noetic/roslaunch
"

SLOT="0"
ROS_DISTRO="noetic"
ROS_PREFIX="opt/ros/${ROS_DISTRO}"
