Cache Configuration
===================

To work with the application cache one should use interface ``InfinniPlatform.Sdk.Cache.ICache``. Shared and memory caches do the same things so they
implement the same interface - ``ICache``. Type of the application cache can be declared in the configuration file ``AppExtension.json`` as in example
below.

.. code-block:: javascript

    /* Cache settings */
    "cache": {
        /* Cache type ('Memory' or 'Shared', by default - 'Memory') */
        /* It is recommended to use 'Shared' in production environment */
        "Type": "Memory"
    }
