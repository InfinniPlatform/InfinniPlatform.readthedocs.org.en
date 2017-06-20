Document Storage Management
===========================

Each storage can have additional settings at least each storage has unique name. Besides it there is support of the indexes. Indexes support the
efficient execution of queries. Without indexes the storage must scan every document in a collection, to select those documents that match the query
statement. If an appropriate index exists for a query, the storage can use the index to limit the number of documents it must inspect.

Indexes are special data structures that store a small portion of the storage's data set in an easy to traverse form. The index stores the value of
a specific field or set of fields, ordered by the value of the field. The ordering of the index entries supports efficient equality matches and
range-based query operations.


.. index:: Document
.. index:: DocumentHeader

Default Indexes
---------------

The `IDocumentStorage<TDocument>`_ interface implementation works with descendants of the Document_ class which defines two mandatory fields: `_id`_
and `_header`_, respectively, the unique identifier and the system information of the document. By default the `_id`_ is Guid_ but it is possible
to use any other type. The `_header`_ is described using DocumentHeader_ class.

The DocumentHeader_ class contains system information which is used by an implementation of the storage to organize and control access to the documents.
For example, the `_tenant`_ field helps to organize multitenancy_ and that field is used upon each query execution as an additional filter. Thus each
document contains at least two indexes:

* ``_id`` - for primary key

* ``_header._tenant`` and ``_header._deleted`` - for multitenancy_

.. note:: The IDocumentStorage_ interface implementation works the same but instead of the Document_ it uses DynamicDocument_.


.. index:: DocumentMetadata
.. index:: DocumentIndex
.. index:: Indexes
.. index:: IDocumentStorageManager
.. index:: IDocumentStorageManager.CreateStorageAsync()

Additional Indexes
------------------

To define additional indexes you must create an instance of the DocumentMetadata_ class and set the Indexes_ property. Next example defines index
by ``UserName`` field.

.. code-block:: csharp

    var userNameIndex = new DocumentIndex
                        {
                            Key = new Dictionary<string, DocumentIndexKeyType>
                                  {
                                      { "UserName", DocumentIndexKeyType.Asc }
                                  }
                        };

    var userStoreMetadata = new DocumentMetadata
                            {
                                Type = "UserStore",
                                Indexes = new[] { userNameIndex }
                            };

After that you must get IDocumentStorageManager_ and invoke the `CreateStorageAsync()`_ method:

.. code-block:: csharp

    IDocumentStorageManager_ storageManager;

    // ...

    storageManager.CreateStorageAsync(userStoreMetadata);


.. index:: IDocumentStorageProvider<TDocument>
.. index:: IDocumentStorageProvider

Storage Provider
----------------

The `IDocumentStorage<TDocument>`_ and IDocumentStorage_ are used to access documents of the storage but besides data access they do additional logic.
For example, providing :doc:`interception </08-document-storage/document-storage-interceptors>` mechanism and organizing multitenancy_. And this logic
can be a barrier to realize some system procedures such as data migration. To direct access to the storage without additional logic (interception,
multitenancy and etc.), use `IDocumentStorageProvider<TDocument>`_ or IDocumentStorageProvider_. To get them, use IDocumentStorageProviderFactory_.


.. _`multitenancy`: https://en.wikipedia.org/wiki/Multitenancy
.. _`Guid`: https://docs.microsoft.com/en-us/dotnet/api/system.guid?view=netcore-1.1
.. _`Document`: ../api/reference/InfinniPlatform.DocumentStorage.Document.html
.. _`_id`: ../api/reference/InfinniPlatform.DocumentStorage.Document.html#InfinniPlatform_DocumentStorage_Document__id
.. _`_header`: ../api/reference/InfinniPlatform.DocumentStorage.Document.html#InfinniPlatform_DocumentStorage_Document__header
.. _`DocumentHeader`: ../api/reference/InfinniPlatform.DocumentStorage.DocumentHeader.html
.. _`_tenant`: ../api/reference/InfinniPlatform.DocumentStorage.DocumentHeader.html#InfinniPlatform_DocumentStorage_DocumentHeader__tenant
.. _`DynamicDocument`: ../api/reference/InfinniPlatform.Dynamic.DynamicDocument.html
.. _`DocumentMetadata`: ../api/reference/InfinniPlatform.DocumentStorage.Metadata.DocumentMetadata.html
.. _`Indexes`: ../api/reference/InfinniPlatform.DocumentStorage.Metadata.DocumentMetadata.html#InfinniPlatform_DocumentStorage_Metadata_DocumentMetadata_Indexes
.. _`IDocumentStorage`: ../api/reference/InfinniPlatform.DocumentStorage.IDocumentStorage.html
.. _`IDocumentStorage<TDocument>`: ../api/reference/InfinniPlatform.DocumentStorage.IDocumentStorage-1.html
.. _`IDocumentStorageManager`: ../api/reference/InfinniPlatform.DocumentStorage.IDocumentStorageManager.html
.. _`CreateStorageAsync()`: ../api/reference/InfinniPlatform.DocumentStorage.IDocumentStorageManager.html#InfinniPlatform_DocumentStorage_IDocumentStorageManager_CreateStorageAsync_InfinniPlatform_DocumentStorage_Metadata_DocumentMetadata_
.. _`IDocumentStorageProvider<TDocument>`: ../api/reference/InfinniPlatform.DocumentStorage.IDocumentStorageProvider-1.html
.. _`IDocumentStorageProvider`: ../api/reference/InfinniPlatform.DocumentStorage.IDocumentStorageProvider.html
.. _`IDocumentStorageProviderFactory`: ../api/reference/InfinniPlatform.DocumentStorage.IDocumentStorageProviderFactory.html
