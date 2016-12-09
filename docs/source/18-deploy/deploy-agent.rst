Infinni.Agent
=============

``Infinni.Agent`` is ``InfinniPlatform`` based application that provides REST API for controlling local Infinni.Node instance.

Key features:

#. Provide information about installed applications
#. Install, uninstall, start and stop applications on the remote machine.

Installation
------------

``Infinni.Agent`` can be installed via ``Infinni.Node`` utility:

.. code-block:: console

    Infinni.Node install -i Infinni.Agent 

Configuration
-------------

Agent can be configured in ``agent`` serction of ``AppExtension.json`` file:

.. code-block:: javascript

    "agent": {
      "NodeDirectory": "..\\..",                    // Absolute or relative path to Infinni.Node      
      "Token": "cc670bc2b2124011a3f92056487f2cf3",  // Authentication token for connecting with Infinni.Server
      "CacheTimeout": 600                           // Task's log reset timeout      
    }