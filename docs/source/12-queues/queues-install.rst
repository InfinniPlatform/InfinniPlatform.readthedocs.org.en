Installing and Configuring Message Queue
========================================

Installing RabbitMQ
-------------------

#. Download and setup `Erlang OTP 19.0 Windows 64-bit Binary File <http://www.erlang.org/download.html>`_.
#. Download and setup `RabbitMQ Server <https://www.rabbitmq.com/download.html>`_.
#. RabbitMQ Server is ready to use.

You may read manual at their officail web-site  `for Windows <https://www.rabbitmq.com/install-windows.html>`_
and `for Ubuntu/Debian <https://www.rabbitmq.com/install-debian.html>`_


Enabling Management Plugin
~~~~~~~~~~~~~~~~~~~~~~~~~~

To manage and monitor status of RabbitMQ there is Management Plugin.
To enable it one should from the folder :file:`C:\\Program Files\\RabbitMQ Server\\rabbitmq_server-3.6.2\\sbin` execute the following command:

.. code-block:: bash

    > rabbitmq-plugins enable rabbitmq_management

Management Plugin will be accessible at http://localhost:15672 .
You may download manuals from `the official web site <https://www.rabbitmq.com/management.html>`_.


.. _queue-settings:

Configuring RabbitMQ for Application
------------------------------------

Example of RabbitMQ settings in :doc:`app configuration file </04-settings/index>`.

.. code-block:: javascript

    "rabbitmq": {
      "HostName": "localhost",
      "Port": 5672,
      "UserName": "guest",
      "Password": "guest",
      "ManagementApiPort": 15672б
      "PrefetchCount": 1000,
      "MaxConcurrentThreads": 200
    }

Where:

* *HostName* - server name where RabbitMQ is installed.
* *Port* - RabbitMQ port number.
* *UserName* - RabbitMQ user name.
* *Password* - RabbitMQ user password.
* *ManagementApiPort* - Management API port number.
* *PrefetchCount* - number of messages simultaneously transferred to client. Value 0 will transfer all messages to client. П
* *MaxConcurrentThreads* - Max number of threads to proccess messages.
