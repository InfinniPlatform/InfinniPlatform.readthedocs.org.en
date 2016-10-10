Examples of Using Cache
=======================

.. code-block:: csharp

    public class CacheExample
    {
        public CacheHttpService(ICache cache)
        {
            // Getting cache instance ref. :doc:`/11-cache/cache-setup`
            _cache = cache;
        }

        private readonly ICache _cache;

        private void SomeMethod()
        {
            // Setting key and value to cache
            _cache.Set("key", "value");
        }
    }
