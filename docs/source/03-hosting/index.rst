Application Events
==================

Some applications may require initialization at the start and deinitialization in the end of app execution. First this implies that app may have
pre-defined settings, for instance allocation of particular resources, data migration, cache pre-filling and so on. Second, at the stage of
deinitialization, a reverse process take place, that is disposing allocated resources. Both stages are optional and depend on app logic and
resources it manipulates.


Application Events Types
------------------------

InfinniPlatfrom apps may handle the following events:

* After the application host has fully started and is about to wait for a graceful shutdown
* After the application host has fully stopped and is not wait for new requests

When the application host has fully **started** you have a chance to execute any kind of background tasks such as pre-filling data :doc:`cache </11-cache/index>`,
data indexing and etc. When the application host has fully **stopped** you may dispose resources, save data retaining in memory and etc.

.. note:: You should pay attention that application may stop by exception or forcefully unloaded by administrative tools. Don't rely that aforementioned
          event handlers will be invoked anyway. Instead of this the **restoration logic** should be implemented to help handle those emergencies.


.. index:: IAppStartedHandler
.. index:: IAppStartedHandler.Handle()
.. index:: IAppStoppedHandler
.. index:: IAppStoppedHandler.Handle()

Application Event Handler
-------------------------

To write an event handler to implement ``InfinniPlatform.Sdk.Hosting.IApplicationEventHandler`` interface and :doc:`register </02-ioc/container-builder>`
its implementation in :doc:`IoC-container module </02-ioc/container-module>`. However the most simple way is to inherit the event handler from the
abstract class ``InfinniPlatform.Sdk.Hosting.ApplicationEventHandler`` and override the most applicable methods.

Interface ``InfinniPlatform.Sdk.Hosting.IApplicationEventHandler`` describes methods of handling for each event type:

* ``OnBeforeStart()`` - to handle events before app launch
* ``OnAfterStart()`` - to handle events after app launch
* ``OnBeforeStop()`` - to handle events before app stop
* ``OnAfterStop()`` - to handle events after app stop 

Next example shows a handler which handles an event before app launch.

.. code-block:: csharp
   :emphasize-lines: 1,3,12

    public class MyApplicationEventHandler : InfinniPlatform.Sdk.Hosting.ApplicationEventHandler
    {
        public override void OnBeforeStart()
        {
            // App initialization code
        }
    }

    // ...

    builder.RegisterType<MyApplicationEventHandler>()
           .As<InfinniPlatform.Sdk.Hosting.IApplicationEventHandler>()
           .SingleInstance();


Asynchronous Event Handling
---------------------------

All methods defined in the ``InfinniPlatform.Sdk.Hosting.IApplicationEventHandler`` interface are called synchronously that is they don't return result
until completed. Exceptions may occur in those methods are recorded in app log. Such behavior is intentionally predefined so the app could control
the launch-stop-launch transitions on its own.

In the case when status of event handling is unnecessary you may enclose event handling in ``try/catch`` block, nevertheless it is highly recommended
to recorded exception into :doc:`app log </05-logging/index>`. If part of logics can be executed asynchronously it is recommended to run it in a new
thread.

:ref:`You can see below <app-events>` listed a number of recommended ways to handle events depending on its type. For example, method code ``OnBeforeStart()``
must be synchronous and execute mandatory actions before app launch. Method code ``OnAfterStart()`` must be asynchronous and not treat an exception as
emergency, in addition to that, execute optional actions.

.. note:: It is the good practice when you minimize execution time of ``OnBeforeStart()`` и ``OnAfterStop()``, so that can help to reduce launch and
          stop time. Accordingly this will improve the speed of app deployment and its re-launch.


.. _app-events:

.. csv-table:: Recommended ways to handle app events
   :header: "Handler method", "Handler type", "Can throw exception"

    "``OnBeforeStart()``", "Synchronous", "Yes"
    "``OnAfterStart()``", "Asynchronous", "No" 
    "``OnBeforeStop()``", "Asynchronous", "No"
    "``OnAfterStop()``", "Synchronous", "No"

You can view an example below of asynchronous event handling ``OnAfterStart()`` using method `Task.Run()`_.

.. code-block:: csharp
   :emphasize-lines: 3,5,13

    public class MyApplicationEventHandler : InfinniPlatform.Sdk.Hosting.ApplicationEventHandler
    {
        public override void OnAfterStart()
        {
            Task.Run(() =>
                     {
                         try
                         {
                             // Initialize app code
                         }
                         catch (Exception exception)
                         {
                             // Record exception into log
                         }
                     });
        }
    }


.. _`Task.Run()`: https://docs.microsoft.com/en-us/dotnet/api/system.threading.tasks.task.run?view=netcore-1.1#System_Threading_Tasks_Task_Run_System_Action_
