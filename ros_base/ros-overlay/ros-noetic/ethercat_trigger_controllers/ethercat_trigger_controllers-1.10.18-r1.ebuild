# Copyright 2021 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

EAPI=7
PYTHON_COMPAT=( python{3_8,3_9,3_10} )

inherit ros-cmake

DESCRIPTION="Controllers to operate the digital output of the motor controller\
	boar[...]"
HOMEPAGE="http://www.ros.org/wiki/ethercat_trigger_controllers"
SRC_URI="https://github.com/pr2-gbp/pr2_controllers-release/archive/release/noetic/${PN}/1.10.18-1.tar.gz -> ${PN}-noetic-release-${PV}.tar.gz"

LICENSE="BSD"

KEYWORDS="~x86 ~amd64 ~arm ~arm64"
RDEPEND="
	ros-noetic/diagnostic_msgs
	ros-noetic/message_runtime
	ros-noetic/pluginlib
	ros-noetic/pr2_controller_interface
	ros-noetic/realtime_tools
	ros-noetic/roscpp
	ros-noetic/rospy
	ros-noetic/std_msgs
	sys-devel/libtool
"
DEPEND="${RDEPEND}
	ros-noetic/catkin
	ros-noetic/message_generation
"

SLOT="0"
ROS_DISTRO="noetic"
ROS_PREFIX="opt/ros/${ROS_DISTRO}"
