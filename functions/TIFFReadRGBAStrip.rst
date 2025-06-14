TIFFReadRGBAStrip
=================

Synopsis
--------

.. highlight:: c

::

    #include <tiffio.h>

.. c:function:: int TIFFReadRGBAStrip(TIFF* tif, uint32_t row, uint32_t* raster)

.. c:function:: int TIFFReadRGBAStripExt(TIFF* tif, uint32_t row, uint32_t * raster, int stop_on_error)

Description
-----------

:c:func:`TIFFReadRGBAStrip` reads a single strip of a strip-based image
into memory, storing the result in the user supplied RGBA *raster*.
The raster is assumed to be an array of ``ImageWidth`` × ``RowsPerStrip``
32-bit entries, where ``ImageWidth`` is the width of the image
(:c:macro:`TIFFTAG_IMAGEWIDTH`) and ``RowsPerStrip`` is the maximum lines
in a strip (:c:macro:`TIFFTAG_ROWSPERSTRIP`).

:c:func:`TIFFReadRGBAStripExt` provides the parameter `stop_on_error`.
Its behaviour is described at :doc:`TIFFReadRGBAImage`.

The *row* value should be the row of the first row in the strip
(*strip* × ``RowsPerStrip``, zero based).

Note that the raster is assume to be organized such that the pixel at location
(*x*, *y*) is *raster* [ *y* × *width* + *x* ]; with the raster origin in the
*lower-left hand corner* of the strip. That is bottom to top organization.
When reading a partial last strip in the file the last line of the image will
begin at the beginning of the buffer.

Raster pixels are 8-bit packed red, green, blue, alpha samples. The macros
:c:macro:`TIFFGetR`, :c:macro:`TIFFGetG`, :c:macro:`TIFFGetB`, and
:c:macro:`TIFFGetA` should be used to access individual samples. Images
without Associated Alpha matting information have a constant Alpha of 1.0
(255).

See the :doc:`TIFFRGBAImage` page for more details on how various image types
are converted to RGBA values.

Notes
-----

:c:func:`TIFFReadRGBAStrip` is just a wrapper around the more general
:doc:`TIFFRGBAImage` facilities.  It's main advantage over the similar
:c:func:`TIFFReadRGBAImage` function is that for large images a single
buffer capable of holding the whole image doesn't need to be allocated,
only enough for one strip.  The :c:func:`TIFFReadRGBATile` function
does a similar operation for tiled images.

For general notes see
:ref:`TIFFRGBImage notes <TIFFRGBAImage_Restriction_Notes>`.

Return values
-------------

1 is returned if the image was successfully read and converted.
Otherwise, 0 is returned if an error was encountered.

Diagnostics
-----------

All error messages are directed to the :c:func:`TIFFErrorExtR` routine.

``"Sorry, can not handle %d-bit pictures"``:

  The image had ``BitsPerSample`` other than 1, 2, 4, 8, or 16.

``"Sorry, can not handle %d-channel images"``:

  The image had ``SamplesPerPixel`` other than 1, 3, or 4.

``Missing needed "PhotometricInterpretation" tag``:

  The image did not have a tag that describes how to display the data.

``No "PhotometricInterpretation" tag, assuming RGB``:

  The image was missing a tag that describes how to display it, but because it
  has 3 or 4 samples/pixel, it is assumed to be RGB.

``No "PhotometricInterpretation" tag, assuming min-is-black\fP``:

  The image was missing a tag that describes how to display it, but
  because it has 1 sample/pixel, it is assumed to be a grayscale or
  bilevel image.

``"No space for photometric conversion table"``:

  There was insufficient memory for a table used to convert image samples to
  8-bit RGB.

``Missing required "Colormap" tag``:

  A Palette image did not have a required ``Colormap`` tag.

``"No space for tile buffer"``:

  There was insufficient memory to allocate an i/o buffer.

``"No space for strip buffer"``:

  There was insufficient memory to allocate an i/o buffer.

``"Can not handle format"``:

  The image has a format (combination of ``BitsPerSample``,
  ``SamplesPerPixel``, and ``PhotometricInterpretation``)
  that :c:func:`TIFFReadRGBAImage` can not handle.

``"No space for B&W mapping table"``:

  There was insufficient memory to allocate a table used to map grayscale data
  to RGB.

``"No space for Palette mapping table"``:

  There was insufficient memory to allocate a table used to map data to 8-bit
  RGB.

See also
--------

:doc:`TIFFOpen` (3tiff),
:doc:`TIFFRGBAImage` (3tiff),
:doc:`TIFFReadRGBAImage` (3tiff),
:doc:`TIFFReadRGBATile` (3tiff),
:doc:`libtiff` (3tiff)
