# Copyright 2021 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

EAPI=7
PYTHON_COMPAT=( python{3_8,3_9,3_10} )

inherit ros-cmake

DESCRIPTION="Configuration files for PR2 controllers."
HOMEPAGE="http://ros.org/wiki/pr2_controller_configuration"
SRC_URI="https://github.com/pr2-gbp/pr2_robot-release/archive/release/noetic/${PN}/1.6.32-1.tar.gz -> ${PN}-noetic-release-${PV}.tar.gz"

LICENSE="BSD"

KEYWORDS="~x86 ~amd64 ~arm ~arm64"
RDEPEND="
	ros-noetic/pr2_controller_manager
	ros-noetic/pr2_gripper_action
	ros-noetic/pr2_head_action
	ros-noetic/pr2_machine
	ros-noetic/robot_mechanism_controllers
	ros-noetic/single_joint_position_action
"
DEPEND="${RDEPEND}
	ros-noetic/catkin
	ros-noetic/roslaunch
"

SLOT="0"
ROS_DISTRO="noetic"
ROS_PREFIX="opt/ros/${ROS_DISTRO}"
