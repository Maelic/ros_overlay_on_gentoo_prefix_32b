# Copyright 2021 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

EAPI=7
PYTHON_COMPAT=( python{3_8,3_9,3_10} )

inherit ament-cmake

DESCRIPTION="Wraps FMUs for co-simulation"
HOMEPAGE="http://wiki.ros.org/fmi_adapter"
SRC_URI="https://github.com/ros2-gbp/${PN}-release/archive/release/galactic/${PN}/2.1.1-1.tar.gz -> ${PN}-galactic-release-${PV}.tar.gz"

LICENSE="Apache-2.0"

KEYWORDS="~x86 ~amd64 ~arm ~arm64"
IUSE="test"
RDEPEND="
	ros-galactic/launch
	ros-galactic/launch_ros
	ros-galactic/rcl_interfaces
	ros-galactic/rclcpp
	ros-galactic/rclcpp_components
	ros-galactic/rclcpp_lifecycle
	ros-galactic/std_msgs
	test? ( ros-galactic/ament_cmake_gmock )
	test? ( ros-galactic/ament_cmake_gtest )
	test? ( ros-galactic/ament_cmake_pytest )
	test? ( ros-galactic/ament_lint_auto )
	test? ( ros-galactic/ament_lint_common )
	test? ( ros-galactic/launch_testing )
	test? ( ros-galactic/rcutils )
"
DEPEND="${RDEPEND}
	ros-galactic/ament_cmake
	ros-galactic/fmilibrary_vendor
"

SLOT="0"
ROS_DISTRO="galactic"
ROS_PREFIX="opt/ros/${ROS_DISTRO}"
