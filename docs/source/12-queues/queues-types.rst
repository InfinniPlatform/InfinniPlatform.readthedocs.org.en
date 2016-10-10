Message Queue Types
===================

Task Queue
----------

Messages from the task queue are distributed among **all** subscribers but each message is received and handled by only **one** subscriber. This queue
may be used to organize parallel processing of tasks or data.


.. image:: /_images/taskQueue.png

Broadcast Queue
---------------

Messages from the broadcast queue are received and handled by **each** subscriber. This queue may be used for mixed processing of the same message.

.. image:: /_images/broadcastQueue.png
