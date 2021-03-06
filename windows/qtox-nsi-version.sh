#!/bin/bash
#
#    Copyright © 2016 Zetok Zalbavar <zetok@openmailbox.org>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

# script to append correct qTox version to `.nsi` files from
# `git describe`
#
# NOTE: it checkouts the files before appending a version to them!
#
# requires:
#  * files `qtox.nsi` and `qtox64.nsi` in working dir
#  * git – tags in format `v0.0.0`
#  * GNU sed

# usage:
#
#   ./$script

set -eu -o pipefail

# uses `get_version()`
source "../tools/lib/git.source"


# append version to .nsi files after a certain line
append_version() {
    local after_line='	${WriteRegStr} ${REG_ROOT} "${UNINSTALL_PATH}" "DisplayName" "qTox"'
    local append='	${WriteRegStr} ${REG_ROOT} "${UNINSTALL_PATH}" "DisplayVersion"'

    for nsi in *.nsi
    do
        git checkout "$nsi"
        sed -i "/$after_line/a\\$append \"$(get_version)\"" "$nsi"
    done
}

append_version
