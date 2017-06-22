Internal Authentication
=======================

Internal Authentication provides the authentication mechanism based on its own user storage. Thus you must install
the :doc:`Document Storage </document-storage/document-storage-using>` or define own storage for the users.

**1.** Install ``InfinniPlatform.Auth`` package:

.. code-block:: bash

    dotnet add package InfinniPlatform.Auth -s https://www.myget.org/F/infinniplatform/

**2.** Call `AddAuthInternal()`_ in ``ConfigureServices()``:

.. code-block:: csharp
   :emphasize-lines: 11

    using System;

    using InfinniPlatform.AspNetCore;

    using Microsoft.Extensions.DependencyInjection;

    public class Startup
    {
        public IServiceProvider ConfigureServices(IServiceCollection services)
        {
            services.AddAuthInternal();

            // ...

            return services.BuildProvider();
        }

        // ...
    }


.. _`AddAuthInternal()`: ../api/reference/InfinniPlatform.AspNetCore.AuthExtensions.html#InfinniPlatform_AspNetCore_AuthExtensions_AddAuthInternal_IServiceCollection_
