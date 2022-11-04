# Copyright 2021 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

EAPI=7
PYTHON_COMPAT=( python{3_8,3_9,3_10} )

inherit ament-cmake

DESCRIPTION="A controller/manager for the lifecycle nodes of the Navigation 2 system"
HOMEPAGE="https://wiki.ros.org"
SRC_URI="https://github.com/SteveMacenski/navigation2-release/archive/release/galactic/${PN}/1.0.7-1.tar.gz -> ${PN}-galactic-release-${PV}.tar.gz"

LICENSE="Apache-2.0"

KEYWORDS="~x86 ~amd64 ~arm ~arm64"
IUSE="test"
RDEPEND="
	ros-galactic/bondcpp
	ros-galactic/geometry_msgs
	ros-galactic/lifecycle_msgs
	ros-galactic/nav2_msgs
	ros-galactic/nav2_util
	ros-galactic/rclcpp_action
	ros-galactic/rclcpp_lifecycle
	ros-galactic/std_msgs
	ros-galactic/std_srvs
	ros-galactic/tf2_geometry_msgs
	test? ( ros-galactic/ament_cmake_gtest )
	test? ( ros-galactic/ament_cmake_pytest )
	test? ( ros-galactic/ament_lint_auto )
	test? ( ros-galactic/ament_lint_common )
"
DEPEND="${RDEPEND}
	ros-galactic/ament_cmake
	ros-galactic/nav2_common
"

SLOT="0"
ROS_DISTRO="galactic"
ROS_PREFIX="opt/ros/${ROS_DISTRO}"
