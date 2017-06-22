BLOB HTTP Service
=================

There is possibility to expose the storage via HTTP as is. Be careful, it provide powerful mechanism for quick start but to build clear and
understandable RESTful API better create own :doc:`HTTP services </services/index>`.

**1.** Install ``InfinniPlatform.BlobStorage.HttpService`` package:

.. code-block:: bash

    dotnet add package InfinniPlatform.BlobStorage.HttpService \
        -s https://www.myget.org/F/infinniplatform/

**2.** Call `AddBlobStorageHttpService()`_ in ``ConfigureServices()``:

.. code-block:: csharp
   :emphasize-lines: 11

    using System;

    using InfinniPlatform.AspNetCore;

    using Microsoft.Extensions.DependencyInjection;

    public class Startup
    {
        public IServiceProvider ConfigureServices(IServiceCollection services)
        {
            services.AddBlobStorageHttpService();

            // ...

            return services.BuildProvider();
        }

        // ...
    }

**3.** Run application and browse to http://localhost:5000/blob/<id_> (where id_ is BLOB's identifier)


.. _`id`: ../api/reference/InfinniPlatform.BlobStorage.BlobInfo.html#InfinniPlatform_BlobStorage_BlobInfo_Id
.. _`AddBlobStorageHttpService()`: ../api/reference/InfinniPlatform.AspNetCore.BlobStorageHttpServiceExtensions.html#InfinniPlatform_AspNetCore_BlobStorageHttpServiceExtensions_AddBlobStorageHttpService_IServiceCollection_
