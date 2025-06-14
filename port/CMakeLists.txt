# CMake build for libtiff
#
# Copyright © 2015 Open Microscopy Environment / University of Dundee
# Written by Roger Leigh <rleigh@codelibre.net>
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

# Generate headers
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/libport_config.h.cmake.in
        ${CMAKE_CURRENT_BINARY_DIR}/libport_config.h
        @ONLY)

set(port_HEADERS libport.h)

# Only build if any needed features are missing
if(NOT HAVE_GETOPT)
  add_library(tiff_port STATIC ../placeholder.h)

  # Add getopt if missing
  if(NOT HAVE_GETOPT)
    target_sources(tiff_port PRIVATE
            ${CMAKE_CURRENT_SOURCE_DIR}/getopt.c)
  endif()

  target_include_directories(tiff_port PUBLIC
          ${CMAKE_CURRENT_BINARY_DIR}
          ${CMAKE_CURRENT_SOURCE_DIR})
else()
  # Dummy interface library
  add_library(tiff_port INTERFACE)
  target_include_directories(tiff_port INTERFACE
          ${CMAKE_CURRENT_BINARY_DIR}
          ${CMAKE_CURRENT_SOURCE_DIR})
endif()
