# Checks for LERC codec support
#
# Copyright © 2021 Antonio Valentino <antonio.valentino@tiscali.it>
# Written by Antonio Valentino <antonio.valentino@tiscali.it>
#
# Permission to use, copy, modify, distribute, and sell this software and
# its documentation for any purpose is hereby granted without fee, provided
# that (i) the above copyright notices and this permission notice appear in
# all copies of the software and related documentation, and (ii) the names of
# Sam Leffler and Silicon Graphics may not be used in any advertising or
# publicity relating to the software without the specific, prior written
# permission of Sam Leffler and Silicon Graphics.
#
# THE SOFTWARE IS PROVIDED "AS-IS" AND WITHOUT WARRANTY OF ANY KIND,
# EXPRESS, IMPLIED OR OTHERWISE, INCLUDING WITHOUT LIMITATION, ANY
# WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
#
# IN NO EVENT SHALL SAM LEFFLER OR SILICON GRAPHICS BE LIABLE FOR
# ANY SPECIAL, INCIDENTAL, INDIRECT OR CONSEQUENTIAL DAMAGES OF ANY KIND,
# OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
# WHETHER OR NOT ADVISED OF THE POSSIBILITY OF DAMAGE, AND ON ANY THEORY OF
# LIABILITY, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE
# OF THIS SOFTWARE.


# libLerc
set(LERC_SUPPORT FALSE)
set(LERC_STATIC FALSE)
find_package(LERC)
option(lerc "use libLerc (required for LERC compression)" ${LERC_FOUND})
if (lerc AND LERC_FOUND AND ZIP_SUPPORT)
    set(LERC_SUPPORT TRUE)
    if(NOT BUILD_SHARED_LIBS)
        set(LERC_STATIC TRUE)
    endif()
endif()
