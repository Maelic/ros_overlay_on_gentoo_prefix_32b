# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{5,6,7,8}} )
inherit flag-o-matic prefix python-single-r1 toolchain-funcs

MY_PV="$(ver_rs 1- _)"

DESCRIPTION="A system for large project software construction, simple to use and powerful"
HOMEPAGE="https://boostorg.github.io/build/"
SRC_URI="https://boostorg.jfrog.io/artifactory/main/release/1.71.0/source/boost_1_71_0.tar.gz -> boost_1_71_0.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="examples python test"
RESTRICT="test"

RDEPEND="python? ( ${PYTHON_DEPS} )
	!<dev-libs/boost-1.35.0
	!<=dev-util/boost-build-1.35.0-r1"
DEPEND="${RDEPEND}
	test? (
		sys-apps/diffutils
		${PYTHON_DEPS}
	)"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	test? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}/boost_${MY_PV}/tools/build/src"

PATCHES=(
	"${FILESDIR}"/${PN}-1.48.0-disable_python_rpath.patch
	"${FILESDIR}"/${PN}-1.49.0-darwin-gentoo-toolchain.patch
	"${FILESDIR}"/${PN}-1.62.0-sparc-no-default-flags.patch
	"${FILESDIR}"/${PN}-1.66.0-add-none-feature-options.patch
	"${FILESDIR}"/${PN}-1.71.0-respect-c_ld-flags.patch
)

pkg_setup() {
	if use python || use test; then
		python-single-r1_pkg_setup
	fi
}

src_unpack() {
	tar xzvf "${DISTDIR}/${A}" boost_${MY_PV}/tools/build || die "unpacking tar failed"
}

src_prepare() {
	default

	pushd .. >/dev/null || die
	eapply "${FILESDIR}/${PN}-1.54.0-fix-test.patch"
	popd >/dev/null || die

	# remove default -march/-mcpu definitions
	# bjam is trying to be clever and injects -march= in order to
	# optimize code for you. This breaks on 32-bit builds, because
	# -march=i686 will not work on an i486 CHOST.
	# https://bugs.gentoo.org/624616
	sed -e '/^cpu-flags\s*gcc\s*OPTIONS/d' \
		-e '/toolset\.flags\s*gcc\s*OPTIONS/d' \
		-e "/cpu_flags('gcc',\s*'OPTIONS'/d" \
		-i tools/gcc.{jam,py} || die "Failed removing -march/-mcpu"
}

src_configure() {
	hprefixify engine/Jambase
	tc-export CXX
}

src_compile() {
	cd engine || die
	./build.sh cxx -d+2 $(use_with python python "${ESYSROOT}"/usr) || die "building bjam failed"
}

src_test() {
	cd ../test || die

	local -x TMP="${T}"

	DO_DIFF="${EPREFIX}/usr/bin/diff" "${EPYTHON}" test_all.py

	if [[ -s test_results.txt ]]; then
		eerror "At least one test failed: $(<test_results.txt)"
		die "tests failed"
	fi
}

src_install() {
	dobin engine/{bjam,b2}

	insinto /usr/share/boost-build
	doins -r "${FILESDIR}/site-config.jam" \
		../boost-build.jam bootstrap.jam build-system.jam ../example/user-config.jam *.py \
		build kernel options tools util

	if ! use python; then
		find "${ED}/usr/share/boost-build" -iname "*.py" -delete || die "removing experimental python files failed"
	fi

	dodoc ../notes/{changes,release_procedure,build_dir_option,relative_source_paths}.txt

	if use examples; then
		docinto examples
		dodoc -r ../example/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
}