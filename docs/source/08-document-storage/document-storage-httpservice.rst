Document HTTP Service
=====================

There is possibility to expose the storage via HTTP as is. Be careful, it provide powerful mechanism for quick start but to build clear and
understandable RESTful API better create own :doc:`HTTP services </07-services/index>`.


.. index:: DocumentHttpService
.. index:: DocumentHttpService<TDocument>

Configuring Document HTTP Service
---------------------------------

**1.** Install ``InfinniPlatform.DocumentStorage.HttpService`` package:

.. code-block:: bash

    dotnet add package InfinniPlatform.DocumentStorage.HttpService \
        -s https://www.myget.org/F/infinniplatform/

**2.** Call `AddDocumentStorageHttpService()`_ in ``ConfigureServices()``:

.. code-block:: csharp
   :emphasize-lines: 11

    using System;

    using InfinniPlatform.AspNetCore;

    using Microsoft.Extensions.DependencyInjection;

    public class Startup
    {
        public IServiceProvider ConfigureServices(IServiceCollection services)
        {
            services.AddDocumentStorageHttpService();

            // ...

            return services.BuildProvider();
        }

        // ...
    }

**3.** :doc:`Register in IoC-container </02-ioc/container-builder>` the document HTTP service:

.. code-block:: csharp

    builder.RegisterDocumentHttpService<MyDocument>();

**4.** Run application and browse to http://localhost:5000/documents/MyDocument/


.. _`AddDocumentStorageHttpService()`: ../api/reference/InfinniPlatform.AspNetCore.DocumentStorageHttpServiceExtensions.html#InfinniPlatform_AspNetCore_DocumentStorageHttpServiceExtensions_AddDocumentStorageHttpService_IServiceCollection_


Document HTTP Service API
-------------------------

.. http:get:: /documents/(string:documentType)/(string:id)

    Returns the document of the specified type and with given identifier.

    :param string documentType: The document type name.
    :param string id: The document unique identifier.
    :resheader Content-Type: application/json
    :statuscode 200: OK
    :statuscode 400: Validation Error
    :statuscode 500: Internal Server Error


.. http:get:: /documents/(string:documentType)/

    Returns documents of the specified type.

    :param string documentType: The document type name.
    :query string search: Optional. The text for full text search.
    :query string filter: Optional. The :ref:`filter query <filter-query>`.
    :query string select: Optional. The :ref:`select query <select-query>`.
    :query string order: Optional. The :ref:`order query <order-query>`.
    :query boolean count: Optional. By default - ``false``. The flag whether to return the number of documents.
    :query int skip: Optional. By default - ``0``. The number of documents to skip before returning the remaining elements.
    :query int take: Optional. By default - ``10``, maximum - ``1000``. The number of documents to return.
    :resheader Content-Type: application/json
    :statuscode 200: OK
    :statuscode 400: Validation Error
    :statuscode 500: Internal Server Error


.. http:post:: /documents/(string:documentType)/

    Creates or updates specified document.

    :param string documentType: The document type name.
    :form body: The document and optionally the document attachments (files).
    :reqheader Content-Type: application/json
    :reqheader Content-Type: multipart/form-data
    :reqheader Content-Type: application/x-www-form-urlencoded
    :resheader Content-Type: application/json
    :statuscode 200: OK
    :statuscode 400: Validation Error
    :statuscode 500: Internal Server Error


.. http:delete:: /documents/(string:documentType)/(string:id)

    Deletes the document of the specified type and with given identifier.

    :param string documentType: The document type name.
    :param string id: The document unique identifier.
    :resheader Content-Type: application/json
    :statuscode 200: OK
    :statuscode 400: Validation Error
    :statuscode 500: Internal Server Error


.. http:delete:: /documents/(string:documentType)/

    Deletes documents of the specified type.

    :param string documentType: The document type name.
    :query string filter: Optional. The :ref:`filter query <filter-query>`.
    :resheader Content-Type: application/json
    :statuscode 200: OK
    :statuscode 400: Validation Error
    :statuscode 500: Internal Server Error


.. _filter-query:

Filter Query
~~~~~~~~~~~~

It's coming soon...


.. _select-query:

Select Query
~~~~~~~~~~~~

It's coming soon...


.. _order-query:

Order Query
~~~~~~~~~~~

It's coming soon...
