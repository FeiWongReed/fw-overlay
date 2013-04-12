# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit eutils versionator

SLOT="$(get_major_version)"
RDEPEND=">=virtual/jdk-1.6"

RESTRICT="strip"

DESCRIPTION="JProfiler java profiling tool"
HOMEPAGE="http://www.ej-technologies.com/products/jprofiler/overview.html"
SRC_URI="http://download-aws.ej-technologies.com/jprofiler/jprofiler_linux_${PV//./_}.tar.gz"
LICENSE="jprofiler"
IUSE=""
KEYWORDS="~x86 ~amd64"
S="${WORKDIR}/jprofiler${SLOT}"

pkg_postinst() {
    local dir="/opt/${PN}"
    local wrapper="${dir}/${PN}.sh"
    touch ${wrapper}
    echo "#!/bin/sh" > ${wrapper}
    echo "cd ${dir}/jprofiler7/bin" >> ${wrapper}
    echo "/bin/sh jprofiler" >> ${wrapper}
    chmod 755 ${wrapper}
}

src_prepare() {
    cd "${S}"
    case "${ARCH}" in
        amd64)
          find . \( -name "*.so" -and -not -wholename "*linux-x64/*.so" \) -delete
          ;;
        *)
          find . \( -name "*.so" -and -not -wholename "*linux-${ARCH}/*.so" \) -delete
          ;;
    esac
}

src_install() {
    local dir="/opt/${PN}"
    insinto "${dir}"
    doins -r *

    newicon "jprofiler7/.install4j/i4j_extf_3_198c2a3_8mtf09.png" "${PN}.png"
    make_wrapper "${PN}" "${dir}/${PN}.sh"
    make_desktop_entry "${PN}" "JProfiler" "${PN}" "Development;Profiling"
}
