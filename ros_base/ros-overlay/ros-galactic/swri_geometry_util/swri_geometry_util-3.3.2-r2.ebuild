# Copyright 2021 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

EAPI=7
PYTHON_COMPAT=( python{3_8,3_9,3_10} )

inherit ament-cmake

DESCRIPTION="swri_geometry_util"
HOMEPAGE="https://github.com/swri-robotics/marti_common"
SRC_URI="https://github.com/swri-robotics-gbp/marti_common-release/archive/release/galactic/${PN}/3.3.2-2.tar.gz -> ${PN}-galactic-release-${PV}.tar.gz"

LICENSE="BSD"

KEYWORDS="~x86 ~amd64 ~arm ~arm64"
IUSE="test"
RDEPEND="
	ros-galactic/cv_bridge
	ros-galactic/rclcpp
	ros-galactic/tf2
	test? ( ros-galactic/ament_cmake_gtest )
	dev-cpp/eigen
	sci-libs/geos
"
DEPEND="${RDEPEND}
	ros-galactic/ament_cmake
	virtual/pkgconfig
"

SLOT="0"
ROS_DISTRO="galactic"
ROS_PREFIX="opt/ros/${ROS_DISTRO}"
