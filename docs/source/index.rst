Welcome to InfinniPlatform Documentation!
=========================================

.. image:: _images/logo.png

InfinniPlatform is a robust high-level framework designed to quickly create and implement modern highly scalable middleware and end-user applications. It proposes to a developer a unified and integer solution which covers majority of challenges the developer may encounter while working on the project. Ready-to-use infrastructure is what makes the platform tick right out of the box. Moreover platform usage significantly eases process of deployment and makes it as simple as a click of a mouse. Administrative tools shall allow you automate the process of application deployment in cluster-ready infrastructure and easily maintain and administer your applications featuring versioning control ability.

InfinniPlatform is a cross-platform open source project written with .NET Framework and can be run on Linux/Mono. Based on the most modern and advance industry-grade opeen source components it makes use of state-of-the-art RabbitMQ_, Redis_, ELK_ and MongoDB_. This approach ensures you avoid vendor lock-in for the core parts of both middleware and application.

This software is distributed under AGLPv3_ license which means you may use it free of charge and exceptionally all components employed are free to use as well to all.

.. warning:: We started out to prepare our documentation in English. Please have a little patience.
   We are working on it and make it available to you as soon as possible.

.. toctree::
   :maxdepth: 2

   00-getting-started/index.rst
   01-dynamic/index.rst
   02-ioc/index.rst
   03-hosting/index.rst
   04-settings/index.rst
   05-logging/index.rst
   06-serialization/index.rst
   07-services/index.rst
   08-document-storage/index.rst
   09-document-services/index.rst
   10-blob-storage/index.rst
   11-cache/index.rst
   12-queues/index.rst
   13-static-files/index.rst
   14-view-engine/index.rst
   15-print-view/index.rst
   16-security/index.rst
   17-scheduler/index.rst
   18-deploy/index.rst
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
