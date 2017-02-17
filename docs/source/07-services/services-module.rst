.. index:: IHttpService
.. index:: IHttpServiceBuilder

Defining Modules
================

Modules are key concept and the one thing which you have to know to develop HTTP services. A module is created by inheriting from the `IHttpService`_
interface. Each module implements the ``Load()`` method where you can define the behaviors of your HTTP service, in the form of routes and the actions
they should perform if they are invoked.

The ``Load()`` method gets an instance of the `IHttpServiceBuilder`_ interface which with using `DSL`_ style allows define routes and their actions.
Each action gets an information about request and handles it asynchronously. Requests are represented as the `IHttpRequest`_ interface and give a
comprehensive information to their handling.

Next example shows the registration of two handlers for ``GET`` requests.

.. code-block:: csharp

    public class SomeHttpService : IHttpService
    {
        public void Load(IHttpServiceBuilder builder)
        {
            builder.Get["/resource1"] = request => Task.FromResult<object>("Resource1");
            builder.Get["/resource2"] = request => Task.FromResult<object>("Resource2");
        }
    }


.. note:: The ``Load()`` method will be invoked only once on an application startup.


Modules can be declared anywhere you like just register them in :doc:`IoC Container </02-ioc/index>`.

.. code-block:: csharp

    builder.RegisterType<SomeHttpService>()
           .As<IHttpService>()
           .SingleInstance();


.. note:: All modules should be registered as :doc:`a single instance </02-ioc/container-lifetime>`.


If you have lots of modules in an assembly you can register them all using `RegisterHttpServices()`_.

.. code-block:: csharp

    builder.RegisterHttpServices(assembly);


Asynchronous Handling
---------------------

Request handlers are asynchronous by default so you can use ``async``/``await`` keywords.

.. code-block:: csharp

    public class SomeHttpService : IHttpService
    {
        public void Load(IHttpServiceBuilder builder)
        {
            builder.Get["/resource1"] = OnResource1;
            builder.Get["/resource2"] = OnResource2;
        }

        private async Task<object> OnResource1(IHttpRequest request)
        {
            // Do something asynchronously
            return await Task.FromResult<object>("Resource1");
        }

        private async Task<object> OnResource2(IHttpRequest request)
        {
            // Do something asynchronously
            return await Task.FromResult<object>("Resource2");
        }
    }


.. index:: IHttpServiceBuilder.ServicePath

Declaring Service Path
----------------------

Usually modules combine some common functionality which are available on the same base path. So you can define a module path and each route will be
subordinate to the path of the module. This saves you from having to repeat the common parts of the route patterns and also to nicely group your
routes together based on their relationship.

.. code-block:: csharp
   :emphasize-lines: 5

    public class SomeHttpService : IHttpService
    {
        public void Load(IHttpServiceBuilder builder)
        {
            builder.ServicePath = "/base/path/to";
            builder.Get["/resource1"] = OnResource1;
            builder.Get["/resource2"] = OnResource2;
        }

        // ...
    }


.. _DSL: https://en.wikipedia.org/wiki/Domain-specific_language
.. _`IHttpService`: /api/reference/InfinniPlatform.Sdk.Http.Services.IHttpService.html
.. _`IHttpServiceBuilder`: /api/reference/InfinniPlatform.Sdk.Http.Services.IHttpServiceBuilder.html
.. _`IHttpRequest`: /api/reference/InfinniPlatform.Sdk.Http.Services.IHttpRequest.html
.. _`RegisterHttpServices()`: /api/reference/InfinniPlatform.Sdk.Http.Services.ServiceExtentions.html#InfinniPlatform_Sdk_Http_Services_ServiceExtentions_RegisterHttpServices_InfinniPlatform_Sdk_IoC_IContainerBuilder_System_Reflection_Assembly_
