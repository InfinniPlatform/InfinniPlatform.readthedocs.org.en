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


.. index:: IDocumentStorageInterceptor
.. index:: IDocumentStorageInterceptor<TDocument>

Interception of Document HTTP Service
-------------------------------------

The document HTTP service provides default behavior which may be a little different than what you want. In this case you can use interceptor of the
document HTTP service. Implement `IDocumentStorageInterceptor<TDocument>`_ (typed context) or IDocumentStorageInterceptor_ (dynamic context) and
register the implementation :doc:`in IoC-container </02-ioc/container-builder>`.

.. _`IDocumentStorageInterceptor`: ../api/reference/InfinniPlatform.DocumentStorage.Interceptors.IDocumentStorageInterceptor.html
.. _`IDocumentStorageInterceptor<TDocument>`: ../api/reference/InfinniPlatform.DocumentStorage.Interceptors.IDocumentStorageInterceptor-1.html


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

The filter query is a string with contains a filter expression:

.. code-block:: csharp

    func(args)

where ``func`` - the filter function name, ``args`` - the function arguments.

There are a lot of function, most of them accepts a document property name as the first parameter and an appropriate value as the second parameter
which is used to compare with the property. Some functions can accept other functions as arguments such as composing function - ``and`` and ``or``,
other functions can have no arguments, have one or any amount. Below the filter query functions are presented.


**Logical Query Functions**

.. js:function:: not(filter)

    The logical negation of the specified expression.

    Example:

    .. code-block:: js

        not(eq('status', 'published'))

    :param filter: The filter query.

.. js:function:: and(filters)

    The logical conjunction of the specified expression.

    Example:

    .. code-block:: js

        and(eq('status', 'published'), eq('author', 'John Smith'))

    :param filters: The list of filter queries separated by comma.

.. js:function:: or(filters)

    The logical disjunction of the specified expression.

    .. code-block:: js

        and(eq('status', 'published'), eq('status', 'signed'))

    :param filters: The list of filter queries separated by comma.


**Element Query Functions**

.. js:function:: exists(field[, exists = true])

    When ``exists`` is ``true``, matches the documents that contain the field, including documents where the field value is null; if ``exists`` is
    ``false``, the query returns only the documents that do not contain the field.

    :param string field: The document field name.
    :param boolean exists: The flag of existings.

.. js:function:: type(field, valueType)

    Selects the documents where the value of the field is an instance of the specified type. Querying by data type is useful when dealing with highly
    unstructured data where data types are not predictable.

    Available Types:
    
        * Boolean
        * Int32
        * Int64
        * Double
        * String
        * DateTime
        * Timestamp
        * Binary
        * Object
        * Array

    Example:

    .. code-block:: js

        type('zipCode', 'String')

    :param string field: The document field name.
    :param string valueType: The document field type.


**Comparison Query Functions**

.. js:function:: in(field, values)

    Selects the documents where the value of a field equals any value in the specified array.

    Example:

    .. code-block:: js

        in('tags', '.net', 'asp.net', 'c#')

    :param string field: The document field name.
    :param values: The field values.

.. js:function:: notIn(field, values)

    Selects the documents where the field value is not in the specified array or the field does not exist.

    Example:

    .. code-block:: js

        notIn('tags', '.net', 'asp.net', 'c#')

    :param string field: The document field name.
    :param values: The field values.

.. js:function:: eq(field, value)

    Specifies equality condition, matches documents where the value of a field equals the specified value.

    Example:

    .. code-block:: js

        eq('status', 'published')

    :param string field: The document field name.
    :param value: The field value.

.. js:function:: notEq(field, value)

    Selects the documents where the value of the field is not equal to the specified value. This includes documents that do not contain the field.

    Example:

    .. code-block:: js

        notEq('status', 'published')

    :param string field: The document field name.
    :param value: The field value.

.. js:function:: gt(field, value)

    Selects those documents where the value of the field is greater than the specified value.

    Example:

    .. code-block:: js

        gt('price', 9.99)

    :param string field: The document field name.
    :param value: The field value.

.. js:function:: gte(field, value)

    Selects the documents where the value of the field is greater than or equal to a specified value.

    Example:

    .. code-block:: js

        gte('price', 9.99)

    :param string field: The document field name.
    :param value: The field value.

.. js:function:: lt(field, value)

    Selects the documents where the value of the field is less than the specified value.

    Example:

    .. code-block:: js

        lt('price', 9.99)

    :param string field: The document field name.
    :param value: The field value.

.. js:function:: lte(field, value)

    Selects the documents where the value of the field is less than or equal to the specified value.

    Example:

    .. code-block:: js

        lte('price', 9.99)

    :param string field: The document field name.
    :param value: The field value.

.. js:function:: regex(field, pattern)

    Selects documents where the value of the field matches a specified regular expression.

    Example:

    .. code-block:: js

        regex('phone', '^+123')

    :param string field: The document field name.
    :param string pattern: The regular expression.

.. js:function:: startsWith(field, value[, ignoreCase = true])

    Selects documents where the value of the field starts with a specified substring.

    Example:

    .. code-block:: js

        startsWith('phone', '+123')

    :param string field: The document field name.
    :param string value: The substring to matching.
    :param boolean ignoreCase: The flag of ignoring case.

.. js:function:: endsWith(field, value[, ignoreCase = true])

    Selects documents where the value of the field ends with a specified substring.

    Example:

    .. code-block:: js

        endsWith('phone', '789')

    :param string field: The document field name.
    :param string value: The substring to matching.
    :param boolean ignoreCase: The flag of ignoring case.

.. js:function:: contains(field, value[, ignoreCase = true])

    Selects documents where the value of the field contains a specified substring.

    Example:

    .. code-block:: js

        contains('phone', '456')

    :param string field: The document field name.
    :param string value: The substring to matching.
    :param boolean ignoreCase: The flag of ignoring case.


**Array Query Functions**

.. js:function:: match(arrayField, filter)

    Selects documents where the value of the field is an array which contains elements that satisfy the specified filter. 

    Example:

    .. code-block:: js

        match('addresses', eq('street', 'Broadway'))

    :param string arrayField: The document field which contains an array.
    :param filter: The filter query.

.. js:function:: all(arrayField, elements)

    Selects the documents where the value of a field is an array that contains all the specified elements.

    Example:

    .. code-block:: js

        all('tags', '.net', 'asp.net', 'c#')

    :param string arrayField: The document field which contains an array.
    :param elements: The list of elements to matching.

.. js:function:: anyIn(arrayField, elements)

    Selects the documents where the value of a field is an array that contains at least one of the specified elements.

    Example:

    .. code-block:: js

        anyIn('tags', '.net', 'asp.net', 'c#')

    :param string arrayField: The document field which contains an array.
    :param elements: The list of elements to matching.

.. js:function:: anyNotIn(arrayField, elements)

    Selects the documents where the value of a field is an array that does not contains the specified elements.

    Example:

    .. code-block:: js

        anyNotIn('tags', '.net', 'asp.net', 'c#')

    :param string arrayField: The document field which contains an array.
    :param elements: The list of elements to matching.

.. js:function:: anyEq(arrayField, element)

    Selects the documents where the value of a field is an array that contains at least one element that equals the specified.

    Example:

    .. code-block:: js

        anyEq('tags', '.net')

    :param string arrayField: The document field which contains an array.
    :param element: The element to matching.

.. js:function:: anyNotEq(arrayField, element)

    Selects the documents where the value of a field is an array that contains at least one element that does not equal the specified.

    Example:

    .. code-block:: js

        anyNotEq('tags', '.net')

    :param string arrayField: The document field which contains an array.
    :param element: The element to matching.

.. js:function:: anyGt(arrayField, element)

    Selects the documents where the value of a field is an array that contains at least one element that is greater than the specified.

    Example:

    .. code-block:: js

        anyGt('scores', 42)

    :param string arrayField: The document field which contains an array.
    :param element: The element to matching.

.. js:function:: anyGte(arrayField, element)

    Selects the documents where the value of a field is an array that contains at least one element that is greater than or equal to the specified.

    Example:

    .. code-block:: js

        anyGte('scores', 42)

    :param string arrayField: The document field which contains an array.
    :param element: The element to matching.

.. js:function:: anyLt(arrayField, element)

    Selects the documents where the value of a field is an array that contains at least one element that is less than the specified.

    Example:

    .. code-block:: js

        anyLt('scores', 42)

    :param string arrayField: The document field which contains an array.
    :param element: The element to matching.

.. js:function:: anyLte(arrayField, element)

    Selects the documents where the value of a field is an array that contains at least one element that is less than or equal to the specified.

    Example:

    .. code-block:: js

        anyLte('scores', 42)

    :param string arrayField: The document field which contains an array.
    :param element: The element to matching.

.. js:function:: sizeEq(arrayField, size)

    Selects the documents where the value of a field is an array which size equals the specified.

    Example:

    .. code-block:: js

        sizeEq('scores', 42)

    :param string arrayField: The document field which contains an array.
    :param int size: The element to matching.

.. js:function:: sizeGt(arrayField, size)

    Selects the documents where the value of a field is an array which size is greater than the specified.

    Example:

    .. code-block:: js

        sizeGt('scores', 42)

    :param string arrayField: The document field which contains an array.
    :param int size: The element to matching.

.. js:function:: sizeGte(arrayField, size)

    Selects the documents where the value of a field is an array which size is greater than or equal to the specified.

    Example:

    .. code-block:: js

        sizeGte('scores', 42)

    :param string arrayField: The document field which contains an array.
    :param int size: The element to matching.

.. js:function:: sizeLt(arrayField, size)

    Selects the documents where the value of a field is an array which size is less than the specified.

    Example:

    .. code-block:: js

        sizeLt('scores', 42)

    :param string arrayField: The document field which contains an array.
    :param int size: The element to matching.

.. js:function:: sizeLte(arrayField, size)

    Selects the documents where the value of a field is an array which size is less than or equal to the specified.

    Example:

    .. code-block:: js

        sizeLte('scores', 42)

    :param string arrayField: The document field which contains an array.
    :param int size: The element to matching.


**Constant Query Functions**

.. js:function:: date(value)

    Specifies a date and time constant using `ISO 8601`_ format.

    Example:

    .. code-block:: js

        date('2017-06-21')

    :param string value: The date and time in `ISO 8601`_ format.


.. _select-query:

Select Query
~~~~~~~~~~~~

The select query allows to request the only specified fields of the document or vice versa exclude specified fields of the document. The select query
is a string with contains a list of expressions separated by comma:

.. code-block:: csharp

    func(args), func(args), ...

where ``func`` - the select function name, ``args`` - the function arguments.

Below the select query functions are presented.

.. js:function:: include(field)

    Specifies that the specified field should be included in the response.

    Example:

    .. code-block:: js

        include('addresses')

    :param string field: The document field name.

.. js:function:: exclude(field)

    Specifies that the specified field should be excluded from the response.

    Example:

    .. code-block:: js

        exclude('addresses')

    :param string field: The document field name.


.. _order-query:

Order Query
~~~~~~~~~~~

The order query specifies the order in which the query returns matching documents. The order query is a string with contains a list of expressions
separated by comma:

.. code-block:: csharp

    func(args), func(args), ...

where ``func`` - the order function name, ``args`` - the function arguments.

Below the order query functions are presented.

.. js:function:: asc(field)

    Specifies an ascending sort for the specified field.

    Example:

    .. code-block:: js

        asc('creationDate')

    :param string field: The document field name.

.. js:function:: desc(field)

    Specifies an descending sort for the specified field.

    Example:

    .. code-block:: js

        desc('creationDate')

    :param string field: The document field name.


.. _`ISO 8601`: https://en.wikipedia.org/wiki/ISO_8601
