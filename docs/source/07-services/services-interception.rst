Intercepting Requests
=====================

Besides defining handlers for specific :doc:`routes </07-services/services-routing>`, a :doc:`module </07-services/services-module>` can also intercept
requests that match one of its routes, both before and after the route is invoked. It is important to understand that these interceptors will only be
invoked if the incoming request matches one of the routes in the module.

.. note:: The interceptors are very useful when you want to perform tasks, per-request, on a module level for things like security, caching and
          rewriting requests and responses.

Below is shown the statechart with existing extension points. Each point is a stage of the request handling pipeline and you can intercept all of them
to customize the handling. The :ref:`ResultConverter <resultconverter-ref>` is described previously so here :ref:`OnBefore <onbefore-ref>`,
:ref:`OnAfter <onafter-ref>` and :ref:`OnError <onerror-ref>` are described.

.. _RequestHandlingFlow-Ref:

.. image:: /_images/requestHandlingFlow.png
   :alt: The Request Handling Flow


.. index:: IHttpServiceBuilder.OnBefore

.. _OnBefore-Ref:

OnBefore interceptor
--------------------

The `OnBefore`_ interceptor enables you to intercept the request before it is passed to the appropriate route handler - `Action`. This gives you
a couple of possibilities such as modifying parts of the request or even prematurely aborting the request by returning a response that will be sent
back to the caller.

.. code-block:: csharp

    builder.OnBefore = async (IHttpRequest request) =>
    {
        // Do something asynchronously and return null or a result object
    };

Since the interceptor will be invoked for all routes in the module, there is no need to define a pattern to match. The parameter that is passed into
the interceptor is an instance of the current `IHttpRequest`_. A return value of `null` means that no action is taken by the interceptor and that
the request should proceed to be processed by the matching route. However, if the interceptor returns some result of its own, the route will never
be processed by the route and the response will be sent back to the client.


.. index:: IHttpServiceBuilder.OnAfter

.. _OnAfter-Ref:

OnAfter interceptor
-------------------

The `OnAfter`_ gets an instance of the current `IHttpRequest`_ and a result from previous stage. While an `OnBefore`_ interceptor is called before
the route handler an `OnAfter`_ interceptor is called when the route has already been handled and a response has been generated. So here you can
modify or replace the result.

.. code-block:: csharp

    builder.OnAfter = async (IHttpRequest request, object result) =>
    {
        // Do something asynchronously and return a modified result
    };


.. index:: IHttpServiceBuilder.OnError

.. _OnError-Ref:

OnError interceptor
-------------------

The `OnError`_ interceptor enables you to execute code whenever an exception occurs in any of the module routes that are being invoked. It gives you
access to the current `IHttpRequest`_ and the exception that took place. So here you can handle an exception and build an error result.

.. code-block:: csharp

    builder.OnError = async (IHttpRequest request, Exception exception) =>
    {
        // Do something asynchronously and return an error result
    };


.. index:: IHttpGlobalHandler
.. index:: IHttpGlobalHandler.OnBefore
.. index:: IHttpGlobalHandler.OnAfter
.. index:: IHttpGlobalHandler.OnError
.. index:: IHttpGlobalHandler.ResultConverter

Global interceptors
-------------------

The application pipelines enable you to perform tasks before and after routes are executed, and in the event of an error in any of the routes in
the application. They behave `the same way` as the module pipelines (see :ref:`the statechart above <requesthandlingflow-ref>`) but they are executed
for all invoked routes, not just for the ones that are the module of the route that is being invoked.

To define the application level HTTP handler you need to implement the `IHttpGlobalHandler`_ interface and :doc:`register </02-ioc/container-builder>`
the implementation in :doc:`IoC Container </02-ioc/index>`.


.. _`OnBefore`: /api/reference/InfinniPlatform.Sdk.Http.Services.IHttpServiceBuilder.html#InfinniPlatform_Sdk_Http_Services_IHttpServiceBuilder_OnBefore
.. _`OnAfter`: /api/reference/InfinniPlatform.Sdk.Http.Services.IHttpServiceBuilder.html#InfinniPlatform_Sdk_Http_Services_IHttpServiceBuilder_OnAfter
.. _`OnError`: /api/reference/InfinniPlatform.Sdk.Http.Services.IHttpServiceBuilder.html#InfinniPlatform_Sdk_Http_Services_IHttpServiceBuilder_OnError
.. _`IHttpRequest`: /api/reference/InfinniPlatform.Sdk.Http.Services.IHttpRequest.html
.. _`IHttpGlobalHandler`: /api/reference/InfinniPlatform.Sdk.Http.Services.IHttpGlobalHandler.html
