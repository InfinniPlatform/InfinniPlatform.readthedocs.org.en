Message Queue Types
===================

In general may select two types of the queues: :ref:`task queues <taskQueue>` and :ref:`broadcast queues <broadcastQueue>`.


.. _taskQueue:
.. index:: ITaskProducer
.. index:: ITaskConsumer

Task Queue
----------

Messages from the task queue are distributed among **all** subscribers but each message is received and handled by only **one** subscriber. This queue
may be used to organize parallel processing of tasks or data.

.. image:: /_images/taskQueue.png

In InfinniPlatform the ITaskProducer_ interface represents producer and the ITaskConsumer_ interface represents consumer for the task queues.


.. _broadcastQueue:
.. index:: IBroadcastProducer
.. index:: IBroadcastConsumer

Broadcast Queue
---------------

Messages from the broadcast queue are received and handled by **each** subscriber. This queue may be used for mixed processing of the same message.

.. image:: /_images/broadcastQueue.png

In InfinniPlatform the IBroadcastProducer_ interface represents producer and the IBroadcastConsumer_ interface represents consumer for the task queues.


.. _`ITaskProducer`: ../api/reference/InfinniPlatform.MessageQueue.ITaskProducer.html
.. _`ITaskConsumer`: ../api/reference/InfinniPlatform.MessageQueue.ITaskConsumer.html
.. _`IBroadcastProducer`: ../api/reference/InfinniPlatform.MessageQueue.IBroadcastProducer.html
.. _`IBroadcastConsumer`: ../api/reference/InfinniPlatform.MessageQueue.IBroadcastConsumer.html
