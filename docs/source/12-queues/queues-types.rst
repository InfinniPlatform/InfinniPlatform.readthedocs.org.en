Message Queue Types
===================

Task Queue
----------

Messages from the queue are distributed among **all** subscribers but each message is recieved and processed by only **one** subscriber. This queue may be used to organize parallel processinf of tasks or data.


.. image:: /_images/taskQueue.png

Broadcast Queue
---------------

Broadcasting messages are recieved and processed by **each** subscriber. This queue may be used for heterogenous processing of the same message.

.. image:: /_images/broadcastQueue.png
