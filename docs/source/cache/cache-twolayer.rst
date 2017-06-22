Using ITwoLayerCache
====================

If cached data that changes infrequently that the best solution can be ITwoLayerCache_, which assumes keeping data in a database but duplicates it
in the memory of the web server. Thus you reduce interactions with a database and consequently improve performance. There is one implementation of
this abstraction - TwoLayerCache_. The TwoLayerCache_ depends on IInMemoryCache_ and ISharedCache_ implicitly. The former is the first layer of
the caching, the latter is the second. To avoid cache consistency problems you also need to provide ITwoLayerCacheStateObserver_ implementation.

Next instruction shows how to use ITwoLayerCache_ based on Redis_ as the second layer of caching and RabbitMQ_ for the cache synchronization.

**1.** Install Redis_

**2.** Install RabbitMQ_

**3.** Install next packages:

.. code-block:: bash

    dotnet add package InfinniPlatform.Cache.Memory -s https://www.myget.org/F/infinniplatform/
    dotnet add package InfinniPlatform.Cache.Redis -s https://www.myget.org/F/infinniplatform/
    dotnet add package InfinniPlatform.Cache.TwoLayer -s https://www.myget.org/F/infinniplatform/
    dotnet add package InfinniPlatform.MessageQueue.RabbitMQ -s https://www.myget.org/F/infinniplatform/

**4.** Update ``ConfigureServices()`` as below:

.. code-block:: csharp
   :emphasize-lines: 11-14

    using System;

    using InfinniPlatform.AspNetCore;

    using Microsoft.Extensions.DependencyInjection;

    public class Startup
    {
        public IServiceProvider ConfigureServices(IServiceCollection services)
        {
            services.AddInMemoryCache();
            services.AddRedisSharedCache();
            services.AddTwoLayerCache();
            services.AddRabbitMqMessageQueue();

            // ...

            return services.BuildProvider();
        }

        // ...
    }

**5.** Request the ITwoLayerCache_ instance in the constructor:

.. code-block:: csharp
   :emphasize-lines: 5

    class MyComponent
    {
        private readonly ITwoLayerCache _cache;

        public MyComponent(ITwoLayerCache cache)
        {
            _cache = cache;
        }

        // ...
    }


.. _`Redis`: https://redis.io/
.. _`RabbitMQ`: https://www.rabbitmq.com/

.. _`IInMemoryCache`: ../api/reference/InfinniPlatform.Cache.IInMemoryCache.html
.. _`ISharedCache`: ../api/reference/InfinniPlatform.Cache.ISharedCache.html
.. _`ITwoLayerCache`: ../api/reference/InfinniPlatform.Cache.ITwoLayerCache.html
.. _`TwoLayerCache`: ../api/reference/InfinniPlatform.Cache.TwoLayerCache.html
.. _`ITwoLayerCacheStateObserver`: ../api/reference/InfinniPlatform.Cache.ITwoLayerCacheStateObserver.html
