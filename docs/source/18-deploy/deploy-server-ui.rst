Web interface
=============

Infinni.Server provides web-interface to manage ``Infinni.Agent`` applications on remote machines.
To open Infinni.Server hosts UI by itself at http://<agent_address>/index.html (e.g. `http://localhost:9900/index.html <http://link>`_).

Home view
---------

Home view of Infinni.Server UI:

.. image:: /_images/18-deploy/server_ui_main_view.png
    :target: ../_images/server_ui_main_view.png

#. Agent list - shows list of ``Infinni.Agent`` instances connected with current server instance, 
   provides a means of adding, editing and removing ``Infinni.Agents'`` information.

   .. image:: /_images/18-deploy/agents.png
      :scale: 90

#. Agent commands - provides information about ``Infinni.Agent's`` machine environment.

   .. image:: /_images/18-deploy/agent_env.png 
      :scale: 90

#. Apps list - shows applications installed on current ``Infinni.Agent`` instance.

   .. image:: /_images/18-deploy/apps_list.png

#. Application commands - provides a means of managing and monitoring applications' state.

   .. image:: /_images/18-deploy/app_commands.png

#. Tasks list - shows status of currently running and recently completed tasks (such as application installation/initialization) 
   on current ``Infinni.Agent`` instance.

   .. image:: /_images/18-deploy/tasks_list.png

Agent add/edit view
-------------------

Allow to add new or edit existed ``Infinni.Agent`` info.

.. image:: /_images/18-deploy/agent_add_edit_view.png


Environment variables view
--------------------------

Show environment variables of current ``Infinni.Agent's`` machine.

.. image:: /_images/18-deploy/env_var_view.png

Infinni.Node and applications logs view
---------------------------------------

Infinni.Node log can be open in browser tab or download as file (see gif below, click to watch fullscreen).

.. image:: /_images/18-deploy/infinni_node_log.gif    
    :target: ../_images/infinni_node_log.gif

You can get application logs using the same way by clicking ``Events log`` and ``Performance log`` buttons in application panel.


Application configuration files view
------------------------------------

Open ``AppCommon.json`` for viewing and ``AppExtension.json`` for editing.
 
.. image:: /_images/18-deploy/app_config.gif
    :target: ../_images/app_config.gif
    

