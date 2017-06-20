Document Storage Interceptors
=============================

Document Storage Interceptors allow to intercept invocations to the `IDocumentStorage<TDocument>`_ or IDocumentStorage_ instances. This useful feature
can help you implement some infrastructure mechanism, for instance, log an audit event when user accessing a document, validate documents and arguments
of the accessing, inject or restrict data and so forth.


.. _typed-interceptor:

.. index:: IDocumentStorageInterceptor<TDocument>
.. index:: DocumentStorageInterceptor<TDocument>
.. index:: IDocumentStorageInterceptor
.. index:: DocumentStorageInterceptor

Intercept Typed Documents
-------------------------

When a document is presented as a normal .NET class and working with it goes through the `IDocumentStorage<TDocument>`_, to define the interceptor for
this document implement the `IDocumentStorageInterceptor<TDocument>`_ interface:

.. code-block:: csharp

    class MyDocumentStorageInterceptor : DocumentStorageInterceptor<MyDocument>
    {
        public override void OnAfterInsertOne(DocumentInsertOneCommand<MyDocument> command,
                                              DocumentStorageWriteResult<object> result,
                                              Exception exception)
        {
            // Handling the invocations IDocumentStorage<MyDocument>.InsertOne()...
        }

        // ...
    }

After that register the interceptor :doc:`in IoC-container </02-ioc/container-builder>`:

.. code-block:: csharp

    builder.RegisterType<MyDocumentStorageInterceptor>()
           .As<IDocumentStorageInterceptor>()
           .SingleInstance();


.. _dynamic-interceptor:

Intercept Dynamic Documents
---------------------------

When a document is presented as the DynamicDocument_ class and working with it goes through the `IDocumentStorage`_, to define the interceptor for
this document implement the `IDocumentStorageInterceptor`_ interface:

.. code-block:: csharp

    class MyDocumentStorageInterceptor : DocumentStorageInterceptor
    {
        public override void OnAfterInsertOne(DocumentInsertOneCommand command,
                                              DocumentStorageWriteResult<object> result,
                                              Exception exception)
        {
            // Handling the invocations IDocumentStorage<MyDocument>.InsertOne()...
        }

        // ...
    }

After that register the interceptor :doc:`in IoC-container </02-ioc/container-builder>`:

.. code-block:: csharp

    builder.RegisterType<MyDocumentStorageInterceptor>()
           .As<IDocumentStorageInterceptor>()
           .SingleInstance();


.. _`Document`: ../api/reference/InfinniPlatform.DocumentStorage.Document.html
.. _`DynamicDocument`: ../api/reference/InfinniPlatform.Dynamic.DynamicDocument.html
.. _`IDocumentStorage`: ../api/reference/InfinniPlatform.DocumentStorage.IDocumentStorage.html
.. _`IDocumentStorage<TDocument>`: ../api/reference/InfinniPlatform.DocumentStorage.IDocumentStorage-1.html
.. _`IDocumentStorageInterceptor`: ../api/reference/InfinniPlatform.DocumentStorage.Interceptors.IDocumentStorageInterceptor.html
.. _`IDocumentStorageInterceptor<TDocument>`: ../api/reference/InfinniPlatform.DocumentStorage.Interceptors.IDocumentStorageInterceptor-1.html
