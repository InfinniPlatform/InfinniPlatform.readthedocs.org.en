Using ISharedCache
==================

Apps which run on a server farm of multiple servers should ensure that sessions are *sticky* when using the in-memory cache. *Sticky sessions*
ensure that subsequent requests from a client all go to the same server. Non-sticky sessions in a web farm require a distributed cache to avoid
cache consistency problems. For some apps, a distributed cache can support higher scale out than an in-memory cache. Using a distributed cache
offloads the cache memory to an external process.

InfinniPlatform has an abstraction for distributed caching - ISharedCache_, which assumes keeping data in a database. There is one implementation
based on Redis_ and to use this implementation you need to make next steps.

**1.** Install Redis_

**2.** Install ``InfinniPlatform.Cache.Redis`` package:

.. code-block:: bash

    dotnet add package InfinniPlatform.Cache.Redis -s https://www.myget.org/F/infinniplatform/

**3.** Call `AddRedisSharedCache()`_ in ``ConfigureServices()``:

.. code-block:: csharp
   :emphasize-lines: 11

    using System;

    using InfinniPlatform.AspNetCore;

    using Microsoft.Extensions.DependencyInjection;

    public class Startup
    {
        public IServiceProvider ConfigureServices(IServiceCollection services)
        {
            services.AddRedisSharedCache();

            // ...

            return services.BuildProvider();
        }

        // ...
    }

**4.** Request the ISharedCache_ instance in the constructor:

.. code-block:: csharp
   :emphasize-lines: 5

    class MyComponent
    {
        private readonly ISharedCache _cache;

        public MyComponent(ISharedCache cache)
        {
            _cache = cache;
        }

        // ...
    }


.. _`Redis`: https://redis.io/

.. _`ISharedCache`: ../api/reference/InfinniPlatform.Cache.ISharedCache.html
.. _`AddRedisSharedCache()`: /api/reference/InfinniPlatform.AspNetCore.RedisSharedCacheExtensions.html#InfinniPlatform_AspNetCore_RedisSharedCacheExtensions_AddRedisSharedCache_IServiceCollection_
