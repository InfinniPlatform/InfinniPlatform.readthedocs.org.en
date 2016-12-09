Static Content
==============

InfinniPlatform can host static files such as HTML, CSS, JavaScript, images and so on.

* Client can retrieve content by a direct link.
* Browser cache will reduce number of requests and accordingly server load.


Static Content Configuration
----------------------------

Configuration file ``AppExtension.json`` contains section ``staticContent``  where you must define path mapping for both paths on your hard drive and
virtual paths used for web addressing in ``StaticContentMapping``.

.. code-block:: javascript

  "staticContent": {
    "StaticContentMapping": {
      "/metadata": "content/metadata",
      "/": "content/www"
    }
  }

Thus files from the directory ``content/metadata`` will be available at ``http://<app address>/metadata``. Paths to files and folders will be correspond
with structure on the hard drive.

.. important:: For security reasons static files can only be placed inside of the working folder so paths like ``../content/metadata`` are invalid.


Static Content Configuration for UI
-----------------------------------

Hosting engine can be used to host UI making thus redundant usage of web-servers like IIS, nginx.

.. code-block:: javascript

  "staticContent": {
    "StaticContentMapping": {
      /* www - folder, containing UI files */
      "/": "content/www"
    }
  }

.. warning:: One should clearly define an app entry point, ex. ``http//<app address>/index.html`` (instead of ``http//<app address>/``).


.. _resources-hosting:

Static Content Configuration for Resources
------------------------------------------

To host files stored in the assembly resources, configuration file ``AppExtension.json`` in section ``staticContent`` should have defined mapping
of both physical paths (assembly resource) and virtual (url) in ``ResourceContentMapping``.

.. code-block:: javascript

  "staticContent": {
    "ResourceContentMapping": {
      "/resources/MyResources": "MyAssembly.ResourceFolder"
    }
  }

Relative path to resource derives the resource name by replacing symbols from ``'.'`` to ``'/'``. Assembly name gets replaced to path defined in the
configuration file.
