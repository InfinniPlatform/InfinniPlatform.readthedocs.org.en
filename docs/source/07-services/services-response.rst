.. index:: IHttpResponse
.. index:: HttpResponse

.. index:: TextHttpResponse
.. index:: JsonHttpResponse
.. index:: StreamHttpResponse
.. index:: RedirectHttpResponse
.. index:: ViewHttpResponce
.. index:: PrintViewHttpResponse

.. index:: HttpResponse.Ok
.. index:: HttpResponse.Unauthorized
.. index:: HttpResponse.Forbidden
.. index:: HttpResponse.NotFound

Response Building
=================

The response is represented as the `IHttpResponse`_ interface which defines `HTTP status code`_, `HTTP headers`_ and HTTP body content. The basic
implementation of the `HttpResponse`_ provides universal constructors to build any type of response. Also there are a few implementations to increase
usability.

* `TextHttpResponse`_ represents a text response;
* `JsonHttpResponse`_ represents a JSON response;
* `StreamHttpResponse`_ represents a stream response of a given `Content-Type`_;
* `RedirectHttpResponse`_ represents an HTTP redirect response;
* `ViewHttpResponce`_ represents a response of the :doc:`View Engine </14-view-engine/index>`;
* `PrintViewHttpResponse`_ represents a response of the :doc:`Print View </15-print-view/index>`.

Besides several prepared responses were added which are used very often:

* `HttpResponse.Ok`_ represents the `200 OK`_ response;
* `HttpResponse.Unauthorized`_ represents the `401 Unauthorized`_ response;
* `HttpResponse.Forbidden`_ represents the `403 Forbidden`_ response;
* `HttpResponse.NotFound`_ represents the `404 Not Found`_ response.


.. index:: IHttpServiceBuilder.ResultConverter
.. index:: DefaultHttpResultConverter

.. _ResultConverter-ref:

Result Converters
-----------------

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
.. _`200 OK`: https://tools.ietf.org/html/rfc7231#section-6.3.1
.. _`401 Unauthorized`: https://tools.ietf.org/html/rfc7235#section-3.1
.. _`403 Forbidden`: https://tools.ietf.org/html/rfc7231#section-6.5.3
.. _`404 Not Found`: https://tools.ietf.org/html/rfc7231#section-6.5.4
.. _`500 Internal Server Error`: https://tools.ietf.org/html/rfc7231#section-6.6.1
.. _`HTTP headers`: http://www.iana.org/assignments/message-headers/message-headers.xml
.. _`Content-Type`: https://www.w3.org/Protocols/rfc1341/4_Content-Type.html

.. _`ResultConverter`: /api/reference/InfinniPlatform.Sdk.Http.Services.IHttpServiceBuilder.html#InfinniPlatform_Sdk_Http_Services_IHttpServiceBuilder_ResultConverter
.. _`IHttpResponse`: /api/reference/InfinniPlatform.Sdk.Http.Services.IHttpResponse.html
.. _`DefaultHttpResultConverter`: /api/reference/InfinniPlatform.Sdk.Http.Services.DefaultHttpResultConverter.html
.. _`HttpResponse`: /api/reference/InfinniPlatform.Sdk.Http.Services.HttpResponse.html
.. _`HttpResponse.Ok`: /api/reference/InfinniPlatform.Sdk.Http.Services.HttpResponse.html#InfinniPlatform_Sdk_Http_Services_HttpResponse_Ok
.. _`HttpResponse.NotFound`: /api/reference/InfinniPlatform.Sdk.Http.Services.HttpResponse.html#InfinniPlatform_Sdk_Http_Services_HttpResponse_NotFound
.. _`HttpResponse.Unauthorized`: /api/reference/InfinniPlatform.Sdk.Http.Services.HttpResponse.html#InfinniPlatform_Sdk_Http_Services_HttpResponse_Unauthorized
.. _`HttpResponse.Forbidden`: /api/reference/InfinniPlatform.Sdk.Http.Services.HttpResponse.html#InfinniPlatform_Sdk_Http_Services_HttpResponse_Forbidden
.. _`TextHttpResponse`: /api/reference/InfinniPlatform.Sdk.Http.Services.TextHttpResponse.html
.. _`StreamHttpResponse`: /api/reference/InfinniPlatform.Sdk.Http.Services.StreamHttpResponse.html
.. _`JsonHttpResponse`: /api/reference/InfinniPlatform.Sdk.Http.Services.JsonHttpResponse.html
.. _`RedirectHttpResponse`: /api/reference/InfinniPlatform.Sdk.Http.Services.RedirectHttpResponse.html
.. _`ViewHttpResponce`: /api/reference/InfinniPlatform.Sdk.Http.Services.ViewHttpResponce.html
.. _`PrintViewHttpResponse`: /api/reference/InfinniPlatform.PrintView.Contract.PrintViewHttpResponse.html

.. _`int`: https://msdn.microsoft.com/en-US/library/system.int32(v=vs.110).aspx
.. _`string`: https://msdn.microsoft.com/en-US/library/system.string(v=vs.110).aspx
.. _`byte[]`: https://msdn.microsoft.com/en-US/library/system.byte(v=vs.110).aspx
.. _`Stream`: https://msdn.microsoft.com/en-US/library/system.io.stream(v=vs.110).aspx
.. _`Func<Stream>`: https://msdn.microsoft.com/en-US/library/system.io.stream(v=vs.110).aspx
.. _`Exception`: https://msdn.microsoft.com/en-US/library/system.exception(v=vs.110).aspx
