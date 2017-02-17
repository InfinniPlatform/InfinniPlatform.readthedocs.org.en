.. index:: Routing

Defining Routes
===============

Routes are defined in the `Load()`_ method. In order to define a route you need to specify a `Method` + `Pattern` + `Action`.

.. code-block:: csharp
   :emphasize-lines: 5

    public class ProductsHttpService : IHttpService
    {
        public void Load(IHttpServiceBuilder builder)
        {
            builder.Get["/products/{id}"] = async request =>
            {
                // Do something
            };
        }
    }


Method
------

The `Method` is the `HTTP method`_ that is used to access the resource. You can handle ``GET``, ``POST``, ``PUT``, ``PATCH`` and ``DELETE`` methods.
The `IHttpServiceBuilder`_ interface contains a definition for each of these methods.


.. _routing-pattern-ref:

Pattern
-------

The `Pattern` declares the application-relative URL that the route answers to.

* `Literal segment`, ``/some``, requires an exact match.

* `Capture segment`, ``/{name}``, captures whatever is passed into the given segment.

* `Capture optional segment`, ``/{name?}``, by adding ``?`` at the end of the segment name the segment can be made optional.

* `Capture optional/default segment`, ``/{name?unnamed}``, by adding a value after ``?`` we can turn an optional segment into a segment with a default value.

* `RegEx segment`, ``/(?<id>[\d]{1,2})``, using `Named Capture Grouped`_ Regular Expressions, you can get a little more control out of the segment pattern.

* `Greedy segment`, ``/{name*}``, by adding ``*`` to the end of the segment name, the pattern will match any value from the current forward slash onward.

* `Multiple captures segment`, ``/{file}.{extension}`` or ``/{file}.ext``, a segment containing a mix of captures and literals.

Pattern segments can be combined, in any order, to create a complex `Pattern` for a route.

.. note:: It's worth noting that `capture segments` are greedy, meaning they will match anything in the requested URL until another segment matches or
          until the end of the URL is reached. Sometimes you may end up with two routes which end up giving a positive match. Each pattern has a `score`
          which is used to resolve the conflicts. But we do not recommend to use conflicted routes. For more information see `NancyFx documentation`_.


.. index:: IHttpServiceRouteBuilder

Action
------

A route `Action` is the behavior which is invoked when a request is matched to a route. It is represented as a delegate of type `Func<IHttpRequest,Task<object>>`_
where the input argument is an information about request (`IHttpRequest`_) and the result is a task (`Task<object>`_) to retrieving response.
The response can be :doc:`any model </07-services/services-response>`.


.. _`HTTP method`: https://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html
.. _`Named Capture Grouped`: http://www.regular-expressions.info/named.html
.. _`NancyFx documentation`: https://github.com/NancyFx/Nancy/wiki/Defining-routes#pattern-scoring

.. _`Load()`: /api/reference/InfinniPlatform.Sdk.Http.Services.IHttpService.html#InfinniPlatform_Sdk_Http_Services_IHttpService_Load_InfinniPlatform_Sdk_Http_Services_IHttpServiceBuilder_
.. _`IHttpServiceBuilder`: /api/reference/InfinniPlatform.Sdk.Http.Services.IHttpServiceBuilder.html
.. _`Func<IHttpRequest,Task<object>>`: /api/reference/InfinniPlatform.Sdk.Http.Services.IHttpServiceRouteBuilder.html
.. _`IHttpRequest`: /api/reference/InfinniPlatform.Sdk.Http.Services.IHttpRequest.html

.. _`Task<object>`: https://msdn.microsoft.com/en-US/library/bb549151(v=vs.110).aspx
