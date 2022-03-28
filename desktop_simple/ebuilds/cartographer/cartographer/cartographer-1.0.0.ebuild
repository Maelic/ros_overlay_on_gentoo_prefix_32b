# Copyright 2018 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{6,7,8}} )

inherit ros-cmake

DESCRIPTION="Cartographer is a system that provides real-time simultaneous localization\[...]"
HOMEPAGE="https://github.com/googlecartographer/cartographer"
SRC_URI="https://github.com/ros-gbp/${PN}-release/archive/release/melodic/${PN}/1.0.0-0.tar.gz -> ${PN}-noetic-release-${PV}.tar.gz"

LICENSE="Apache-2.0"

KEYWORDS="~x86 ~amd64 ~arm ~arm64"
RDEPEND="
	dev-libs/boost
	dev-cpp/eigen
	x11-libs/cairo
	sci-libs/ceres-solver[sparse,lapack]
	dev-cpp/gflags
	dev-cpp/glog
	dev-lang/lua
	dev-libs/protobuf
"
DEPEND="${RDEPEND}
	ros-noetic/catkin
	sys-devel/gcc
	dev-cpp/gtest
	dev-python/sphinx
"

SLOT="0"
ROS_DISTRO="noetic"
ROS_PREFIX="opt/ros/${ROS_DISTRO}"

src_prepare() {
	cd ${P}
	EPATCH_SOURCE="${FILESDIR}" EPATCH_SUFFIX="patch" \
	EPATCH_FORCE="yes" epatch
	ros-cmake_src_prepare
}
