# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{6,7,8,9}} )

inherit slotted-boost-r70

BOOST_PATCHES=(
	"1.48.0-disable_icu_rpath.patch"
	"1.56.0-build-auto_index-tool.patch"
	"1.69.0-context-x32.patch"
	"1.72.0-boost-mpi-python.patch"
	"1.72.0-missing-serialization-split_member-include.patch"
	"1.72.0-revert-cease-dependence-on-range.patch"
)
