Using Document Storage
======================

Next instruction shows how to use the document storage API in conjunction with MongoDB_.

Configuring Document Storage
----------------------------

**1.** Install MongoDB_

**2.** Install ``InfinniPlatform.DocumentStorage.MongoDB`` package:

.. code-block:: bash

    dotnet add package InfinniPlatform.DocumentStorage.MongoDB -s https://www.myget.org/F/infinniplatform

**3.** Call `AddMongoDocumentStorage()`_ in ``ConfigureServices()``:

.. code-block:: csharp
   :emphasize-lines: 11

    using System;

    using InfinniPlatform.AspNetCore;

    using Microsoft.Extensions.DependencyInjection;

    public class Startup
    {
        public IServiceProvider ConfigureServices(IServiceCollection services)
        {
            services.AddMongoDocumentStorage();

            // ...

            return services.BuildProvider();
        }

        // ...
    }

Next using of the document storage differs depending on context: typed_ or dynamic_.


.. _typed:

Typed Context
-------------

When a document can be presented as a normal .NET class then better use the typed context. In this case you will have all the power static code analysis.

**1.** Create MyDocument.cs and define a descendant of the Document_ class:

.. code-block:: csharp
   :emphasize-lines: 3

    using InfinniPlatform.DocumentStorage;

    class MyDocument : Document
    {
        public string Property1 { get; set; }
    
        // ...
    }

**2.** Request the IDocumentStorageFactory_ instance in the constructor:

.. code-block:: csharp
   :emphasize-lines: 7,9

    using InfinniPlatform.DocumentStorage;

    class MyComponent
    {
        private readonly IDocumentStorage<MyDocument> _storage;

        public MyComponent(IDocumentStorageFactory factory)
        {
            _storage = factory.GetStorage<MyDocument>();
        }

        // ...
    }

**3.** To access to the documents use `IDocumentStorage<TDocument>`_:

.. code-block:: csharp

    var document = new MyDocument { _id = 1, Property1 = "Hello!" };

    // Create
    _storage.InsertOne(document);

    // Read
    var document = _storage.Find(i => i._id.Equals(1)).First();

    // Update
    _storage.UpdateOne(u => u.Set(i => i.Property1, "Hello, World!"), i => i._id.Equals(1));

    // Delete
    _storage.DeleteOne(i => i._id.Equals(1));


.. _dynamic:

Dynamic Context
---------------

When a document can not be presented as a normal .NET class because semi-structured data, you can use the dynamic context. In this case you you will
have more flexibility but there is a chance to make mistake and find it only at runtime.

**1.** Use DynamicDocument_ to declare dynamic objects

**2.** Request the IDocumentStorageFactory_ instance in the constructor:

.. code-block:: csharp
   :emphasize-lines: 7,9

    using InfinniPlatform.DocumentStorage;

    class MyComponent
    {
        private readonly IDocumentStorage _storage;

        public MyComponent(IDocumentStorageFactory factory)
        {
            _storage = factory.GetStorage("MyDocument");
        }

        // ...
    }

**3.** To access to the documents use `IDocumentStorage`_:

.. code-block:: csharp

    var document = new DynamicDocument { { "_id", 1 }, { "Property1", "Hello!" } };

    // Create
    _storage.InsertOne(document);

    // Read
    var document = _storage.Find(f => f.Eq("_id", 1)).First();

    // Update
    _storage.UpdateOne(u => u.Set("Property1", "Hello, World!"), f => f.Eq("_id", 1));

    // Delete
    _storage.DeleteOne(f => f.Eq("_id", 1));


.. _`MongoDB`: https://www.mongodb.com/
.. _`Document`: ../api/reference/InfinniPlatform.DocumentStorage.Document.html
.. _`DynamicDocument`: ../api/reference/InfinniPlatform.Dynamic.DynamicDocument.html
.. _`IDocumentStorage`: ../api/reference/InfinniPlatform.DocumentStorage.IDocumentStorage.html
.. _`IDocumentStorage<TDocument>`: ../api/reference/InfinniPlatform.DocumentStorage.IDocumentStorage-1.html
.. _`IDocumentStorageFactory`: ../api/reference/InfinniPlatform.DocumentStorage.IDocumentStorageFactory.html
.. _`AddMongoDocumentStorage()`: ../api/reference/InfinniPlatform.AspNetCore.MongoDocumentStorageExtensions.html#InfinniPlatform_AspNetCore_MongoDocumentStorageExtensions_AddMongoDocumentStorage_IServiceCollection_
