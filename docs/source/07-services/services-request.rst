.. index:: IHttpRequest

Request Handling
================

Actions handle requests getting an instance of the `IHttpRequest`_ which gives a comprehensive information about current request. At least it allows
to get a request data from the URL or from the message body.


.. index:: IHttpRequest.Parameters
.. index:: IHttpRequest.Query

Parameters and Query
--------------------

To retrieve information from a URL you can use properties `Parameters`_ and `Query`_. Both return :doc:`dynamic object </01-dynamic/index>` with
information from different parts of the URL. The `Parameters`_ contains values of :ref:`named segments <routing-pattern-ref>` of the path while
the `Query`_ contains values of the query string.

.. image:: /_images/urlStructure.png
   :alt: The URL Structure

Next example shows how to extract values from a URL which looks like on previous image.

.. code-block:: csharp

    builder.Get["/{segment1}/{segment2}/{segment3}"] = async request =>
    {
        string segment1 = request.Parameters.segment1; // segment1 == "path"
        string segment2 = request.Parameters.segment2; // segment2 == "to"
        string segment3 = request.Parameters.segment3; // segment3 == "resource"

        string key1 = request.Query.key1; // key1 == "value1"
        string key2 = request.Query.key2; // key2 == "value2"

        // ...
    };


.. index:: IHttpRequest.Form
.. index:: IHttpRequest.Content

Form and Content
----------------

Such methods as ``POST``, ``PUT`` and ``PATCH`` can contains the body. Depending on the `Content-Type`_ header the message body can be parsed as an
object. In this case the `Form`_ property returns :doc:`dynamic object </01-dynamic/index>`. For instance the request body will be considered as an
object if the `Content-Type`_ equals ``application/json`` (see `Media Types`_).

.. code-block:: csharp

    // curl -X POST -H 'Content-Type: application/json' \
    // -d'{"Title":"Title1","Content":"Content1"}' \
    // http://www.example.com:80/articles

    builder.Post["/articles"] = async request =>
    {
        string title = request.Form.Title; // title == "Title1"
        string content = request.Form.Content; // content == "Content1"

        // ...
    };

If you have a strongly typed model you can :doc:`deserialize </06-serialization/index>` it from the request body. For example if the `Content-Type`_
equals ``application/json`` the deserialization can be performed using `IJsonObjectSerializer`_. The `Content`_ property allows you to get a `Stream`_
object representing the incoming HTTP body. Also important to note the `Content`_ can be used for a custom handling of the request body.

.. code-block:: csharp
   :emphasize-lines: 18

    public class ArticlesHttpService : IHttpService
    {
        private readonly IJsonObjectSerializer _serializer;

        public ArticlesHttpService(IJsonObjectSerializer serializer)
        {
            _serializer = serializer;
        }

        public void Load(IHttpServiceBuilder builder)
        {
            // curl -X POST -H 'Content-Type: application/json' \
            // -d'{"Title":"Title1","Content":"Content1"}' \
            // http://www.example.com:80/articles

            builder.Post["/articles"] = async request =>
            {
                var article = _serializer.Deserialize<Article>(request.Content);

                // ...
            };
        }
    }


    public class Article
    {
        public string Title { get; set; }
        public string Content { get; set; }
    }


.. note:: Both the `Form`_ and the `Content`_ can not be used at the same time because they read the same request stream. So if you get the `Form`_
          the request stream will be read and the `Content`_ will poit to the end.


.. index:: IHttpRequest.Files
.. index:: IHttpRequestFile

Files
-----

In more complex cases a request can contains one or few files which are available via the `Files`_ property. The `Files`_ returns an enumerable items
of type `IHttpRequestFile`_ and each of them allows to get the file name and the file data stream.

.. code-block:: csharp
   :emphasize-lines: 3

    builder.Post["/albums/{id}"] = async request =>
    {
        foreach (IHttpRequestFile photo in request.Files)
        {
            // Do something
        }

        // ...
    };


.. _`Content-Type`: https://www.w3.org/Protocols/rfc1341/4_Content-Type.html
.. _`Media Types`: http://www.iana.org/assignments/media-types/media-types.xhtml
.. _`Stream`: https://docs.microsoft.com/en-us/dotnet/api/system.io.stream?view=netcore-1.1

.. _`IHttpRequest`: ../api/reference/InfinniPlatform.Http.IHttpRequest.html
.. _`Parameters`: ../api/reference/InfinniPlatform.Http.IHttpRequest.html#InfinniPlatform_Http_IHttpRequest_Parameters
.. _`Query`: ../api/reference/InfinniPlatform.Http.IHttpRequest.html#InfinniPlatform_Http_IHttpRequest_Query
.. _`Form`: ../api/reference/InfinniPlatform.Http.IHttpRequest.html#InfinniPlatform_Http_IHttpRequest_Form
.. _`Content`: ../api/reference/InfinniPlatform.Http.IHttpRequest.html#InfinniPlatform_Http_IHttpRequest_Content
.. _`Files`: ../api/reference/InfinniPlatform.Http.IHttpRequest.html#InfinniPlatform_Http_IHttpRequest_Files
.. _`IHttpRequestFile`: ../api/reference/InfinniPlatform.Http.IHttpRequestFile.html
.. _`IJsonObjectSerializer`: ../api/reference/InfinniPlatform.Serialization.IJsonObjectSerializer.html
