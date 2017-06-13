.. index:: IInMemoryCache

Using IInMemoryCache
====================

The simplest cache is based on the IInMemoryCache_, which represents a cache stored in the memory of the web server. Apps which run on a server farm
of multiple servers should ensure that sessions are *sticky* when using the in-memory cache. *Sticky sessions* ensure that subsequent requests from
a client all go to the same server.

.. note:: Some HTTP servers allow *sticky sessions*. For example, nginx_ supports `session persistence`_, but there is no guarantee that the same
          client will be always directed to the same server. Thus we recommend using IInMemoryCache_ if and only if you have a single app server
          otherwise you should use some kind distributed cache, for instance, ISharedCache_ or ITwoLayerCache_. Nonetheless, the in-memory cache
          can store any object; the distributed cache is limited by a database format.

To work with IInMemoryCache_ you need to make next steps.

**1.** Install ``InfinniPlatform.Cache.Memory`` package:

.. code-block:: bash

    dotnet add package InfinniPlatform.Cache.Memory -s https://www.myget.org/F/infinniplatform/

**2.** Call `AddInMemoryCache()`_ in ``ConfigureServices()``:

.. code-block:: csharp
   :emphasize-lines: 11

    using System;

    using InfinniPlatform.AspNetCore;

    using Microsoft.Extensions.DependencyInjection;

    public class Startup
    {
        public IServiceProvider ConfigureServices(IServiceCollection services)
        {
            services.AddInMemoryCache();

            // ...

            return services.BuildProvider();
        }

        // ...
    }

**3.** Request the IInMemoryCache_ instance in the constructor:

.. code-block:: csharp
   :emphasize-lines: 5

    class MyComponent
    {
        private readonly IInMemoryCache _cache;

        public MyComponent(IInMemoryCache cache)
        {
            _cache = cache;
        }

        // ...
    }


.. _`nginx`: http://nginx.org/
.. _`session persistence`: http://nginx.org/en/docs/http/load_balancing.html#nginx_load_balancing_with_ip_hash

.. _`IInMemoryCache`: ../api/reference/InfinniPlatform.Cache.IInMemoryCache.html
.. _`ISharedCache`: ../api/reference/InfinniPlatform.Cache.ISharedCache.html
.. _`ITwoLayerCache`: ../api/reference/InfinniPlatform.Cache.ITwoLayerCache.html
.. _`AddInMemoryCache()`: ../api/reference/InfinniPlatform.AspNetCore.InMemoryCacheExtensions.html#InfinniPlatform_AspNetCore_InMemoryCacheExtensions_AddInMemoryCache_IServiceCollection_
