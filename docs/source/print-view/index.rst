Print View
==========

Print View is the mechanism for generating a textual representation of data. Data can be any format, structured and semi-structured as well as binary.
The textual representation is generated with predefined **template** and specified data. The template is an instance of the PrintDocument_ class which
is usually stored as a JSON file. To creating templates is used the special WYSIWYG editor - :doc:`Print View Designer </print-view/print-view-designer>`.

Unlike most of reporting engines Print View is more flexible but at the same time is low-level mechanism. The main concept is the flow content, i.e.
generation a textual representation depending on data, while the reporting engines based on fixed templates. In other words, Print View allows to build
human-readable representation of the specified data.

Currently Print View provides two formats: HTML and PDF.


.. toctree::

    print-view-using.rst
    print-view-designer.rst


.. _`PrintDocument`: ../api/reference/InfinniPlatform.PrintView.PrintDocument.html
