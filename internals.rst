Modifying The TIFF Library
==========================

.. image:: images/dave.gif
    :width: 107
    :alt: dave

This chapter provides information about the internal structure of
the library, how to control the configuration when building it, and
how to add new support to the library.
The following sections are found in this chapter:

Library Configuration
---------------------

Information on compiling the library is given :doc:`build`
elsewhere in this documentation.
This section describes the low-level mechanisms used to control
the optional parts of the library that are configured at build
time.  Control is based on
a collection of C defines that are specified either on the compiler
command line or in a configuration file such as :file:`port.h`
(as generated by the :program:`configure` script for UNIX systems)
or :file:`tiffconf.h`.

Configuration defines are split into three areas:

* those that control which compression schemes are
  configured as part of the builtin codecs,
* those that control support for groups of tags that
  are considered optional, and
* those that control operating system or machine-specific support.

If the define :c:macro:`COMPRESSION_SUPPORT` is **not defined**
then a default set of compression schemes is automatically
configured:

* CCITT Group 3 and 4 algorithms (compression codes 2, 3, 4, and 32771),
* the Macintosh PackBits algorithm (compression 32773),
* a 4-bit run-length encoding scheme from ThunderScan (compression 32809),
* a 2-bit encoding scheme used by NeXT (compression 32766), and
* two experimental schemes intended for images with high dynamic range
  (compression 34676 and 34677).

To override the default compression behaviour define
:c:macro:`COMPRESSION_SUPPORT` and then one or more additional defines
to enable configuration of the appropriate codecs (see the table
below); e.g.

.. highlight:: c

::

    #define COMPRESSION_SUPPORT
    #define CCITT_SUPPORT
    #define PACKBITS_SUPPORT

Several other compression schemes are configured separately from
the default set because they depend on ancillary software
packages that are not distributed with LibTIFF.

Support for JPEG compression is controlled by :c:macro:`JPEG_SUPPORT`.
The JPEG codec that comes with LibTIFF is designed for
use with release 5 or later of the Independent JPEG Group's freely
available software distribution.

This software can be retrieved from
`<https://ijg.org/>`_ or as an alternative from `<https://libjpeg-turbo.org/>`_.

.. note::

    Enabling JPEG support automatically enables support for
    the TIFF 6.0 colorimetry and YCbCr-related tags.

Experimental support for the deflate algorithm is controlled by
:c:macro:`DEFLATE_SUPPORT`.
The deflate codec that comes with LibTIFF is designed
for use with version 0.99 or later of the freely available
``libz`` library written by Jean-loup Gailly and Mark Adler.

The data format used by the zlib library is described by RFCs (Request for
Comments) 1950 to 1952 in the files http://tools.ietf.org/html/rfc1950
(zlib format), rfc1951 (deflate format) and rfc1952 (gzip format).

The ``libz`` library can be fetched from `<https://www.zlib.net/>`_,
and ``libdeflate`` from  `<https://github.com/ebiggers/libdeflate>`_

Other codec libraries supported by LibTIFF are:

* JBIG:    `<https://www.cl.cam.ac.uk/~mgk25/jbigkit/>`_
* ESRI Lerc: `<https://github.com/Esri/lerc>`_
* LZMA2:   `<https://tukaani.org/xz/>`_
* | ZSTD:  info at `<https://facebook.github.io/zstd/>`_
  | and can be retrieved from `<https://github.com/facebook/zstd>`_
* WebP:  `<https://developers.google.com/speed/webp>`_

By default :file:`tiffconf.h` defines
:c:macro:`COLORIMETRY_SUPPORT`,
:c:macro:`YCBCR_SUPPORT`,
and 
:c:macro:`CMYK_SUPPORT`.

.. list-table:: :file:`tiffconf.h` defines
    :widths: 5 20
    :header-rows: 1

    * - Define
      - Description

    * - :c:macro:`CCITT_SUPPORT`
      - CCITT Group 3 and 4 algorithms (compression codes 2, 3, 4, and 32771)

    * - :c:macro:`PACKBITS_SUPPORT`
      - Macintosh PackBits algorithm (compression 32773)

    * - :c:macro:`LZW_SUPPORT`
      - Lempel-Ziv & Welch (LZW) algorithm (compression 5)

    * - :c:macro:`THUNDER_SUPPORT`
      - 4-bit run-length encoding scheme from ThunderScan (compression 32809)

    * - :c:macro:`NEXT_SUPPORT`
      - 2-bit encoding scheme used by NeXT (compression 32766)

    * - :c:macro:`OJPEG_SUPPORT`
      - obsolete JPEG scheme defined in the 6.0 spec (compression 6)
        (requires JPEG library with old JPEG support)

    * - :c:macro:`JPEG_SUPPORT`
      - current JPEG scheme defined in TTN2 (compression 7)
        (requires JPEG library)

    * - :c:macro:`JBIG_SUPPORT`
      - current JBIG (compression 9=T85, 10=43 and 34661=ISO)
        (requires JBIG-KIT library)

    * - :c:macro:`LERC_SUPPORT`
      - current LERC (compression 34887)
        (requires LERC and Zlib library)

    * - :c:macro:`ZIP_SUPPORT`
      - experimental Deflate scheme (compression 32946)
        (requires Zlib)

    * - :c:macro:`LIBDEFLATE_SUPPORT`
      - support libdeflate enhanced compression (compression 32946)
        (requires libdeflate and Zlib)

    * - :c:macro:`LZMA_SUPPORT`
      - Lempel–Ziv–Markov chain algorithm (LZMA2) (compression 34925)
        (requires liblzma)

    * - :c:macro:`ZSTD_SUPPORT`
      - ZStandard (ZSTD) deflate like scheme
        (compression 50000 - not registered in Adobe-maintained registry)
        (requires zstd library)

    * - :c:macro:`WEBP_SUPPORT`
      - WebP raster graphic compression support
        (compression 50001 - not registered in Adobe-maintained registry)
        (requires webp library)

    * - :c:macro:`PIXARLOG_SUPPORT`
      - Pixar's compression scheme for high-resolution color images
        (compression 32909) (requires Zlib)

    * - :c:macro:`SGILOG_SUPPORT`
      - SGI's compression scheme for high-resolution color images
        (compression 34676 and 34677)

    * - :c:macro:`COLORIMETRY_SUPPORT`
      - support for the TIFF 6.0 colorimetry tags

    * - :c:macro:`YCBCR_SUPPORT`
      - support for the TIFF 6.0 YCbCr-related tags

    * - :c:macro:`CMYK_SUPPORT`
      - support for the TIFF 6.0 CMYK-related tags

    * - :c:macro:`ICC_SUPPORT`
      - support for the ICC Profile tag; see
        *The ICC Profile Format Specification*,
        Annex B.3 "Embedding ICC Profiles in TIFF Files";
        available at
        `<http://www.color.org/>`_

General Portability Comments
----------------------------

This software is developed on Silicon Graphics UNIX
systems (big-endian, MIPS CPU, 32-bit ints,
IEEE floating point). 
The :program:`configure` shell script generates the appropriate
include files and make files for UNIX systems.
Makefiles exist for non-UNIX platforms that the
code runs on---this work has mostly been done by other people.

In general, the code is guaranteed to work only on SGI machines.
In practice it is highly portable to any 32-bit or 64-bit system and much
work has been done to insure portability to 16-bit systems.
If you encounter portability problems please return fixes so
that future distributions can be improved.

The software is written to assume an ANSI C compilation environment.
If your compiler does not support ANSI function prototypes, ``const``,
and :file:`<stdarg.h>` then you will have to make modifications to the
software.  In the past I have tried to support compilers without ``const``
and systems without :file:`<stdarg.h>`, but I am
**no longer interested in these
antiquated environments**.  With the general availability of
the freely available GCC compiler, I
see no reason to incorporate modifications to the software for these
purposes.

An effort has been made to isolate as many of the
operating system-dependencies
as possible in two files: :file:`tiffcomp.h` and
:file:`libtiff/tif_<os>.c`.  The latter file contains
operating system-specific routines to do I/O and I/O-related operations.
The UNIX (:file:`tif_unix.c`) code has had the most use.

Native CPU byte order is determined through the :c:macro:`WORDS_BIGENDIAN`
definition, which must be set to the appropriate value in :file:`tif_config.h`
by the build system.

The following defines control general portability:

.. list-table:: Portability defines
    :widths: 5 20
    :header-rows: 1

    * - Define
      - Description

    * - :c:macro:`BSDTYPES`
      - Define this if your system does **not** define the
        usual BSD typedefs: :c:type:`u_char`,
        :c:type:`u_short`, :c:type:`u_int`, :c:type:`u_long`.

    * - :c:macro:`HAVE_IEEEFP`
      - Define this as 0 or 1 according to the floating point
        format supported by the machine.  If your machine does
        not support IEEE floating point then you will need to
        add support to tif_machdep.c to convert between the
        native format and IEEE format.

    * - :c:macro:`HAVE_MMAP`
      - Define this if there is *mmap-style* support for
        mapping files into memory (used only to read data).

    * - :c:macro:`HOST_FILLORDER`
      - Define the native CPU bit order: one of :c:macro:`FILLORDER_MSB2LSB`
        or :c:macro:`FILLORDER_LSB2MSB`

    * - :c:macro:`HOST_BIGENDIAN`
      - Define the native CPU byte order: 1 if big-endian (Motorola)
        or 0 if little-endian (Intel); this may be used
        in codecs to optimize code

On UNIX systems :c:macro:`HAVE_MMAP` is defined through the running of
the :program:`configure` script; otherwise support for memory-mapped
files is disabled.
Note that :file:`tiffcomp.h` defines :c:macro:`HAVE_IEEEFP` to be
1 (:c:macro:`BSDTYPES` is not defined).

Types and Portability
---------------------

The software makes extensive use of C typedefs to promote portability.
Two sets of typedefs are used, one for communication with clients
of the library and one for internal data structures and parsing of the
TIFF format.  There are interactions between these two to be careful
of, but for the most part you should be able to deal with portability
purely by fiddling with the following machine-dependent typedefs:

.. list-table:: Portability typedefs
    :widths: 5 15 5
    :header-rows: 1

    * - Typedef
      - Description
      - Header

    * - :c:type:`uint8_t`
      - 8-bit unsigned integer
      - :file:`tiff.h`

    * - :c:type:`int8_t`
      - 8-bit signed integer
      - :file:`tiff.h`

    * - :c:type:`uint16_t`
      - 16-bit unsigned integer
      - :file:`tiff.h`

    * - :c:type:`int16_t`
      - 16-bit signed integer
      - :file:`tiff.h`

    * - :c:type:`uint32_t`
      - 32-bit unsigned integer
      - :file:`tiff.h`

    * - :c:type:`int32_t`
      - 32-bit signed integer
      - :file:`tiff.h`

    * - :c:type:`uint64_t`
      - 64-bit unsigned integer
      - :file:`tiff.h`

    * - :c:type:`int64_t`
      - 64-bit signed integer
      - :file:`tiff.h`


Most of the previously used type definitions that refer to
specific objects are deprecated.
For more information about typedefs see :ref:`Data Types <DataTypes>`.

General Comments
----------------

The library is designed to hide as much of the details of TIFF from
applications as
possible.  In particular, TIFF directories are read in their entirety
into an internal format.  Only the tags known by the library are
available to a user and certain tag data may be maintained that a user
does not care about (e.g. transfer function tables).

Adding New Builtin Codecs
-------------------------

To add builtin support for a new compression algorithm, you can either
use the "tag-extension" trick to override the handling of the
TIFF Compression tag (see :doc:`addingtags`),
or do the following to add support directly to the core library:

* Define the tag value in :file:`tiff.h`.
* Edit the file :file:`tif_codec.c` to add an entry to the
  :c:var:`_TIFFBuiltinCODECS` array (see how other algorithms are handled).
* Add the appropriate function prototype declaration to
  :file:`tiffiop.h` (close to the bottom).
* Create a file with the compression scheme code, by convention files
  are named :file:`tif_*.c` (except perhaps on some systems where the
  ``tif_`` prefix pushes some filenames over 14 chars.
* Update build configuration to include new source file.

A codec, say ``foo``, can have many different entry points:

::

    TIFFInitfoo(tif, scheme) /* initialize scheme and setup entry points in tif */
    fooSetupDecode(tif)	/* called once per IFD after tags has been frozen */
    fooPreDecode(tif, sample) /* called once per strip/tile, after data is read,
                                 but before the first row is decoded */
    fooDecode*(tif, bp, cc, sample) /* decode cc bytes of data into the buffer */
        fooDecodeRow(...)	/* called to decode a single scanline */
        fooDecodeStrip(...)	/* called to decode an entire strip */
        fooDecodeTile(...)	/* called to decode an entire tile */
        fooSetupEncode(tif)	/* called once per IFD after tags has been frozen */
        fooPreEncode(tif, sample) /* called once per strip/tile, before the first row in
                                     a strip/tile is encoded */
    fooEncode*(tif, bp, cc, sample)/* encode cc bytes of user data (bp) */
        fooEncodeRow(...)	/* called to decode a single scanline */
        fooEncodeStrip(...)	/* called to decode an entire strip */
        fooEncodeTile(...)	/* called to decode an entire tile */
    fooPostEncode(tif)	/* called once per strip/tile, just before data is written */
    fooSeek(tif, row)	/* seek forwards row scanlines from the beginning
                           of a strip (row will always be <0 and >rows/strip */
    fooCleanup(tif) /* called when compression scheme is replaced by user */

Note that the encoding and decoding variants are only needed when
a compression algorithm is dependent on the structure of the data.
For example, Group 3 2D encoding and decoding maintains a reference
scanline.  The sample parameter identifies which sample is to be
encoded or decoded if the image is organized with ``PlanarConfig=2``
(separate planes).  This is important for algorithms such as JPEG.
If ``PlanarConfig=1`` (interleaved), then sample will always be 0.

Other Comments
--------------

The library handles most I/O buffering.  There are two data buffers
when decoding data: a raw data buffer that holds all the data in a
strip, and a user-supplied scanline buffer that compression schemes
place decoded data into.  When encoding data the data in the
user-supplied scanline buffer is encoded into the raw data buffer (from
where it is written).  Decoding routines should never have to explicitly
read data -- a full strip/tile's worth of raw data is read and scanlines
never cross strip boundaries.  Encoding routines must be cognizant of
the raw data buffer size and call :c:func:`TIFFFlushData1` when necessary.
Note that any pending data is automatically flushed when a new strip/tile is
started, so there's no need do that in the tif_postencode routine (if
one exists).  Bit order is automatically handled by the library when
a raw strip or tile is filled.  If the decoded samples are interpreted
by the decoding routine before they are passed back to the user, then
the decoding logic must handle byte-swapping by overriding the
:c:member:`tif_postdecode`
routine (set it to :c:func:`TIFFNoPostDecode`) and doing the required work
internally.  For an example of doing this look at the horizontal
differencing code in the routines in :file:`tif_predict.c`.

The variables :c:member:`tif_rawcc`, :c:member:`tif_rawdata`, and
:c:member:`tif_rawcp` in a :c:struct:`TIFF` structure
are associated with the raw data buffer.  :c:member:`tif_rawcc` must be non-zero
for the library to automatically flush data.  The variable
:c:member:`tif_scanlinesize` is the size a user's scanline buffer should be.  The
variable :c:member:`tif_tilesize` is the size of a tile for tiled images.  This
should not normally be used by compression routines, except where it
relates to the compression algorithm.  That is, the ``cc`` parameter to the
:c:expr:`tif_decode*` and :c:expr:`tif_encode*`
routines should be used in terminating
decompression/compression.  This ensures these routines can be used,
for example, to decode/encode entire strips of data.

In general, if you have a new compression algorithm to add, work from
the code for an existing routine.  In particular,
:file:`tif_dumpmode.c`
has the trivial code for the "nil" compression scheme,
:file:`tif_packbits.c` is a
simple byte-oriented scheme that has to watch out for buffer
boundaries, and :file:`tif_lzw.c` has the LZW scheme that has the most
complexity -- it tracks the buffer boundary at a bit level.
Of course, using a private compression scheme (or private tags) limits
the portability of your TIFF files.
