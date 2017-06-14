Message Queue
=============

Message queues are the linking part between various processes and provide reliable and scalable interface to interact with other connected systems and
devices. There are several advantages using queues and further is listed the most important.

Firstly the queues allow to implement `loosely coupled`_ systems and thus satisfy one of GRASP_ pattern. Components in a loosely coupled system can be
replaced with alternative implementations that provide the same services. Also such components are less constrained to the same platform, language,
operating system, or build environment.

Secondly the queues provide a way of horizontal scalability_. An important advantage of horizontal scalability is that it can provide administrators
with the ability to increase capacity on the fly. Another advantage is that in theory, horizontal scalability is only limited by how many entities
can be connected successfully. Thereby you can implement fault tolerant and do not have a single point of failure.

Thirdly the queues ensure asynchronous processing. Asynchronous processing enables various processes to run at the same time. In general processes
might be processed faster and the uniform load distribution is ensured.

Also there are disadvantages of the queues. If systems are decoupled in time, it is difficult to also provide transactional integrity; additional
coordination protocols are required. Furthermore, if the order is important for some processes the queues are not appropriate tool.

.. toctree::

    queues-types.rst
    queues-using.rst


.. _`GRASP`: https://en.wikipedia.org/wiki/GRASP_(object-oriented_design)#Low_coupling
.. _`loosely coupled`: https://en.wikipedia.org/wiki/Loose_coupling
.. _`scalability`: https://en.wikipedia.org/wiki/Scalability

