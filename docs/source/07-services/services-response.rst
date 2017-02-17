.. index:: IHttpResponse
.. index:: HttpResponse
.. index:: HttpResponse.Ok
.. index:: TextHttpResponse
.. index:: StreamHttpResponse
.. index:: JsonHttpResponse
.. index:: IHttpServiceBuilder.ResultConverter
.. index:: DefaultHttpResultConverter

Response Building
=================

The response can be any model and the final result will be determined by the `ResultConverter`_ which defines conversion rules from the source model
to the `IHttpResponse`_ instance. If a :doc:`module </07-services/services-module>` does not set the `ResultConverter`_ then the default conversion
rules are used. They are represented in the `DefaultHttpResultConverter`_ class:

* `IHttpResponse`_ will be returned as is;

* ``null`` will be interpreted as `HttpResponse.Ok`_;

* `int`_ will be interpreted as a `HTTP status code`_;

* `string`_ will be interpreted as `TextHttpResponse`_;

* `byte[]`_, `Stream`_ and `Func<Stream>`_ will be interpreted as `StreamHttpResponse`_;

* `Exception`_ will be interpreted as `500 Internal Server Error`_ with the exception message;

* other objects will be interpreted as `JsonHttpResponse`_.

Next converter wraps a result to the JSON object with a single property ``Result``.

.. code-block:: csharp
   :emphasize-lines: 1

    builder.ResultConverter = result =>
    {
        return (result is IHttpResponse)
            ? (IHttpResponse)result
            : new JsonHttpResponse(new { Result = result });
    };

    builder.Get["/some"] = request =>
    {
        return Task.FromResult<object>(123); // {"Result":123 }
    };


.. _`HTTP status code`: https://tools.ietf.org/html/rfc7231#section-6
.. _`500 Internal Server Error`: https://tools.ietf.org/html/rfc7231#section-6.6.1

.. _`ResultConverter`: /api/reference/InfinniPlatform.Sdk.Http.Services.IHttpServiceBuilder.html#InfinniPlatform_Sdk_Http_Services_IHttpServiceBuilder_ResultConverter
.. _`IHttpResponse`: /api/reference/InfinniPlatform.Sdk.Http.Services.IHttpResponse.html
.. _`DefaultHttpResultConverter`: /api/reference/InfinniPlatform.Sdk.Http.Services.DefaultHttpResultConverter.html
.. _`HttpResponse.Ok`: /api/reference/InfinniPlatform.Sdk.Http.Services.HttpResponse.html#InfinniPlatform_Sdk_Http_Services_HttpResponse_Ok
.. _`TextHttpResponse`: /api/reference/InfinniPlatform.Sdk.Http.Services.TextHttpResponse.html
.. _`StreamHttpResponse`: /api/reference/InfinniPlatform.Sdk.Http.Services.StreamHttpResponse.html
.. _`JsonHttpResponse`: /api/reference/InfinniPlatform.Sdk.Http.Services.JsonHttpResponse.html

.. _`int`: https://msdn.microsoft.com/en-US/library/system.int32(v=vs.110).aspx
.. _`string`: https://msdn.microsoft.com/en-US/library/system.string(v=vs.110).aspx
.. _`byte[]`: https://msdn.microsoft.com/en-US/library/system.byte(v=vs.110).aspx
.. _`Stream`: https://msdn.microsoft.com/en-US/library/system.io.stream(v=vs.110).aspx
.. _`Func<Stream>`: https://msdn.microsoft.com/en-US/library/system.io.stream(v=vs.110).aspx
.. _`Exception`: https://msdn.microsoft.com/en-US/library/system.exception(v=vs.110).aspx
