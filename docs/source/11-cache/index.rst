Data Caching
============

Caching allow save time to generate frequently requested static data. InfinniPlatform has functionality to work with both types of cache:

* In-memory cache (Memory)
* Distributed cache (Shared)

In-memory Cache
---------------

This type of cache is retained in memory while an app is working and disposed as the app is stopped.

Distributed Cache
-----------------

Cache retained in memory getting duplicated in Redis database which makes it to be accessible by other apps instances of the cluster.

.. important:: To utilize distributed cache you must install Redis (ref. :doc:`/11-cache/redis-install`) and RabbitMQ (ref. :doc:`/12-queues/queues-install`).

.. toctree::

    redis-install.rst
    cache-examples.rst
