Welcome to InfinniPlatform Documentation!
=========================================

.. image:: _images/logo.png

InfinniPlatform is an infrastructure framework designed to solve several most common problems when you try to build a scalable web-application.
For example, authentication and authorization, data storage, caching, logging, messaging, push notification and etc. It offers to a developer
a unified solution which covers majority of challenges the developer may encounter while working on the project. Ready-to-use infrastructure
is what makes the platform tick right out of the box.

InfinniPlatform is a cross-platform open source project based on .NET Core and well integrated with ASP.NET Core. Moreover, InfinniPlatform was
designed as set of loosely coupled flexible components so that you can use them separately. In our work we use the most modern and advanced
industry-grade open source components such as MongoDB_, Redis_, RabbitMQ_ and etc. This approach ensures you avoid vendor lock-in for the core
parts of both middleware and application. It is worth noting, however, that flexibility of the framework allows you using any other components.

This solution is distributed under AGPLv3_ license which means you may use it free of charge and exceptionally all components employed are free
to use as well to all.

.. toctree::
   :maxdepth: 2

   getting-started/index.rst
   dynamic/index.rst
   ioc/index.rst
   hosting/index.rst
   settings/index.rst
   logging/index.rst
   serialization/index.rst
   services/index.rst
   document-storage/index.rst
   blob-storage/index.rst
   cache/index.rst
   queues/index.rst
   auth/index.rst
   scheduler/index.rst
   print-view/index.rst
   API Reference <../api/reference/index.html#://>
   release-notes/index.rst

Indices and tables
==================

* :ref:`genindex`
* :ref:`search`

.. _MongoDB: https://www.mongodb.com/download-center
.. _RabbitMQ: https://www.rabbitmq.com/download.html
.. _Redis: http://redis.io/download
.. _ELK: https://www.elastic.co/products
.. _AGPLv3: https://raw.githubusercontent.com/InfinniPlatform/InfinniPlatform/master/LICENSE
