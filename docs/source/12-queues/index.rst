Message Queue
=============

Message queues are the linking part between various processes and provide reliable and scalable interface to interact with other connected systems and
devices. Next features can be outlined as advantages of implementing queues.

* **Weak binding** creates independent process interfaces of data exchange.

* **Scalability** distributes information processing mechanisms which allows to rise performance queue processing.

* **Asynchronous processing** represents functionality to process data asynchronously which gives ability to put a message in queue and process it
  later upon allocation of computable resources.

InfinniPlatform utilizes `RabbitMQ <https://www.rabbitmq.com/>`_ to exchange messages among its components based on `AMQP <http://www.amqp.org/>`_
standard. Message queuing in InfinniPlatform features the following:

* Tolerant to connectivity loss that is messages are persistently retained if clients are disconnected.

* Tolerant to message errors handling that is messages are held in the queue until they get successfully handled. 

.. toctree::

    queues-install.rst
    queues-types.rst
    queues-classes.rst
