Document Attributes
===================

There are several helpful attributes that can make work with documents more convenient.


.. index:: DocumentTypeAttribute

DocumentTypeAttribute
---------------------

The DocumentTypeAttribute_ attribute defines the storage name of the specified document type. By default without its attribute the storage name equals
an appropriate type name. It is not always reasonable especially you use existing database or other naming convention. Also this attribute eliminates
possibility of accidental renaming the storage during renaming the document class name.

.. code-block:: csharp
   :emphasize-lines: 1

    [DocumentType("orders")]
    class Order : Document
    {
        // ...
    }


.. index:: DocumentIgnoreAttribute

DocumentIgnoreAttribute
-----------------------

The DocumentIgnoreAttribute_ attribute forces the storage to ignore the specified property of the document class. Properties are marked with this
attribute will not be stored in a database. It is most applicable for calculated properties, that is properties which values can be calculated based
on values of other properties; or when data can not or should not be serialized to be stored in a database.

.. code-block:: csharp
   :emphasize-lines: 6,7

    class Order : Document
    {
        public double Count { get; set; }
        public double Price { get; set; }

        [DocumentIgnore]
        public double Total => Count * Price;

        // ...
    }


.. index:: DocumentPropertyNameAttribute

DocumentPropertyNameAttribute
-----------------------------

The DocumentPropertyNameAttribute_ attribute forces the storage to use other name for the specified property of the document class. By default without
its attribute field names in a database equal appropriate property names.  It is not always reasonable especially you use existing database or other
naming convention. Also this attribute eliminates possibility of accidental renaming the field during renaming the document property name.

.. code-block:: csharp
   :emphasize-lines: 3,6

    class Order : Document
    {
        [DocumentPropertyName("count")]
        public double Count { get; set; }

        [DocumentPropertyName("price")]
        public double Price { get; set; }

        // ...
    }


.. _`DocumentTypeAttribute`: ../api/reference/InfinniPlatform.DocumentStorage.DocumentTypeAttribute.html
.. _`DocumentIgnoreAttribute`: ../api/reference/InfinniPlatform.DocumentStorage.Attributes.DocumentIgnoreAttribute.html
.. _`DocumentPropertyNameAttribute`: ../api/reference/InfinniPlatform.DocumentStorage.Attributes.DocumentPropertyNameAttribute.html
