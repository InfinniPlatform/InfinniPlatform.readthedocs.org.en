Application Events
==================

Any application may require initialization at the start and de-initialization in the end of app excecution. First this implies that app may have pre-defined settings, for instance allocation of particular resources, data migration, cache pre-filling and so on. Second, at the stage of deinitialization, a reverse process take place, that is purging allocated resources. Both stages are optional and depend on app logic and resources it manipulates.

Application Events Types
------------------------

InfinniPlatfrom apps may handle the following events occuring:

* before app services launch
* after app services launch
* before app services stop
* after app services stop

Event **before launch** :doc:`app services </07-services/index>` empowers creation of configurable actions before app will start to respond the queries. This event handlers define a mandatory stage for successful app launch. For example, to inceptionally perform data migration.

Event **after launch** :doc:`app services </07-services/index>` may run backgrund tasks optional at the app start. For example, :doc:`cache </11-cache/index>` pre-filling with data set or perform indexing can be done at this stage.

Event **before stop** :doc:`app services </07-services/index>` helps to handle query to stop the app. For example, an  :doc:`app log </05-logging/index>` record action can be initiated and inform other cluster nodes about this event to prepare app for shutdown.

Event **after stop** :doc:`app services </07-services/index>` ensures activation of pre-defined actions when, for instance, app stops responding. This type event handlers practically command and then manage to correctly shutdown the app. You may free resources, save data retaining in memory and :doc:`inform </12-queues/index>` other cluster's nodes about this event.

.. note:: You should pay attention that application may stop by exception or forcefully un-loaded by administrative tools. App service stop handles may not tick in such curcmstances one should keep in mind. In this case, the app **restoration logic** should be implemented to help handle those emergencies.
       

.. index:: ApplicationEventHandler
.. index:: IApplicationEventHandler
.. index:: IApplicationEventHandler.OnBeforeStart()
.. index:: IApplicationEventHandler.OnAfterStart()
.. index:: IApplicationEventHandler.OnBeforeStop()
.. index:: IApplicationEventHandler.OnAfterStop()

Application Event Handler
-------------------------

To write an event handler start with ``InfinniPlatform.Sdk.Hosting.IApplicationEventHandler`` interface and 
:doc:`register </02-ioc/container-builder>` its instance in :doc:`IoC-container module </02-ioc/container-module>`.
However the most simple way is to inherit the event handler from the abstract class ``InfinniPlatform.Sdk.Hosting.ApplicationEventHandler`` and redefine method that handles each particular event.

Interface ``InfinniPlatform.Sdk.Hosting.IApplicationEventHandler`` describes four methods of handling for each event type:

* ``OnBeforeStart()`` - to handle events before app launch
* ``OnAfterStart()`` - to handle events after app launch
* ``OnBeforeStop()`` - to handle events before app stop
* ``OnAfterStop()`` - to handle events after app stop 

Next example indicates a handler which handles an event before app lauch

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

All methods defined in the ``InfinniPlatform.Sdk.Hosting.IApplicationEventHandler`` interface are called synchronously that is they don't return result until completed. Exceptions may occur in those methods are recorded in app log. Such behavior is intentionally pre-defined so the app could control the lauch-stop-launch transitions on its own.

In the case when status of event handling is unnecessary you may enclose event handling in ``try/catch`` area, nevertheless it is highly recommended to recored exception into :doc:`app log </05-logging/index>`. If part of logics can be excecuted asynchronously it is recommended to run it in a single thread.

:ref:`You can see below <app-events>` listed a number of recommended ways to handle events depending on its type. For example, method code ``OnBeforeStart()`` must be synchronous and excecute mandatory actions before app launch. Method code ``OnAfterStart()`` must be asynchronous and not treat an exception as emergency, in addition to that, excecute optional actions.

.. note:: It is the good practice when you minimize excecution time of ``OnBeforeStart()`` и ``OnAfterStop()``, so that can help to reduce launch and stop time. Accordingly this will assist the speed of app deployment and its re-launch.
      
      
.. _app-events:

.. csv-table:: Recommended ways to handle app events
   :header: "Handler method", "Handler type", "Can throw exception"

    "``OnBeforeStart()``", "Synchronous", "Yes"
    "``OnAfterStart()``", "Asynchronous", "No" 
    "``OnBeforeStop()``", "Asynchronous", "No"
    "``OnAfterStop()``", "Synchronous", "No"

You can view an example below of asynchrous event handling ``OnAfterStart()`` using method `Task.Run()`_.

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


.. _`Task.Run()`: https://msdn.microsoft.com/en-US/library/system.threading.tasks.task.run(v=vs.110).aspx
