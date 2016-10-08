Static Content
==============

InfinniPlatform can host static files such as HTML, CSS, JavaScript, images and so on.

Features:

#. Client can retrieve content by a direct link.
#. Browser cache will reduce number of requests and accordingly server load.


Static Content Configuration
----------------------------

Configuration file AppExtension.json contains section ``staticContent``  where you must define path mapping for both paths on your hard drive and virtual paths used for web addressing in ``StaticContentMapping``.
Пример конфигурации по умолчанию:

.. code-block:: json

  "staticContent": {
    "StaticContentMapping": {
      "/metadata": "content/metadata",
      "/": "content/www"
    }
  }

Thus files from the folder ``<working folder>\content\metadata`` will be available at ``http://<app address>/metadata``.
Paths to files and folders should coincide with files and folder structure on the hard drive.


.. important:: For security reasons static files can only be placed inside of the working folder so paths like "../content/metadata" are invalid.

Static Content Configuration for UI
-----------------------------------

Hosting engine can be used to host UI making thus redundant usage of web-servers like IIs, nginx.

Configuration example:

.. code-block:: json

  "staticContent": {
    "StaticContentMapping": {
      /* www - folder, containing UI files */
      "/": "content/www"
    }
  }

.. warning:: One should clearly define an app entry point, eg http//<app address>/index.html (instead of http//<app address>/).


.. _resources-hosting:

Static Content Configuration for Resources
------------------------------------------

To host files stored in the app container resources, configuration file AppExtension.json in section ``staticContent`` should have defined mapping of both physical paths (hard drive) and virtual (web) in ``ResourceContentMapping``.

Example:

.. code-block:: json

  "staticContent": {
    "ResourceContentMapping": {
      "/Resources/Sdk": "Sdk",
      "/ServiceHostResources": "ServiceHost"
    }
  }

Relative path to resource derives the path to resource inside the app by replacing symbols from ``'.'`` to ``'/'``. 
App container name gets replaced to path defined in the configuration file.

.. csv-table:: Path mapping example Пример преобразования путей до ресурсов сборки
   :header: "Path inside app container", "Relative path"

    "Sdk.ResourceFile.txt", "/Resources/Sdk/ResourceFile.txt"
    "ServiceHost.ResourceFolder.ResourceFile.txt", "/ServiceHostResources/ResourceFolder/ResourceFile.txt"
