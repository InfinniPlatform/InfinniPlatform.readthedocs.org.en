Using BLOB Storage
==================

Next instruction shows how to use the BLOB storage API.

**1.** Install ``InfinniPlatform.BlobStorage.FileSystem`` package:

.. code-block:: bash

    dotnet add package InfinniPlatform.BlobStorage.FileSystem \
        -s https://www.myget.org/F/infinniplatform/

**2.** Call `AddFileSystemBlobStorage()`_ in ``ConfigureServices()``:

.. code-block:: csharp
   :emphasize-lines: 11

    using System;

    using InfinniPlatform.AspNetCore;

    using Microsoft.Extensions.DependencyInjection;

    public class Startup
    {
        public IServiceProvider ConfigureServices(IServiceCollection services)
        {
            services.AddFileSystemBlobStorage();

            // ...

            return services.BuildProvider();
        }

        // ...
    }

**3.** Request the IBlobStorage_ instance in the constructor:

.. code-block:: csharp
   :emphasize-lines: 5

    class MyComponent
    {
        private readonly IBlobStorage _storage;

        public MyComponent(IBlobStorage storage)
        {
            _storage = storage;
        }

        // ...
    }

**4.** Use IBlobStorage_ to access BLOBs:

.. code-block:: csharp

    // Create
    Stream blobStream;
    BlobInfo blobInfo = _storage.CreateBlob("document.pdf", "application/pdf", blobStream);

    // Read
    string blobId = blobInfo.Id;
    BlobData blobData = _storage.GetBlobData(blobId);

    // Update
    Stream newBlobStream;
    BlobInfo newBlobInfo = UpdateBlob(blobId, "new_document.pdf", "application/pdf", newBlobStream);

    // Delete
    _storage.DeleteBlob(blobId);


.. _`IBlobStorage`: ../api/reference/InfinniPlatform.BlobStorage.IBlobStorage.html
.. _`AddFileSystemBlobStorage()`: ../api/reference/InfinniPlatform.AspNetCore.FileSystemBlobStorageExtensions.html#InfinniPlatform_AspNetCore_FileSystemBlobStorageExtensions_AddFileSystemBlobStorage_IServiceCollection_
