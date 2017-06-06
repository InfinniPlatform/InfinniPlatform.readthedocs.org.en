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

To handle the application events there are two type of handlers represented by IAppStartedHandler_ and IAppStoppedHandler_ interfaces. The first is
invoked when the application has started, the last is invoked when the application has stopped. All you need is to implement an appropriate handler
and :doc:`register </02-ioc/container-builder>` it in :doc:`IoC container </02-ioc/container-module>`.

Next example shows a handler which handles the application startup event.

.. code-block:: csharp

    public class MyAppStartedHandler : IAppStartedHandler
    {
        public void Handle()
        {
            // App initialization code
        }
    }

    // ...

    builder.RegisterType<MyAppStartedHandler>().As<IAppStartedHandler>().SingleInstance();


Asynchronous Event Handling
---------------------------

The application events is handled synchronously that is they don't return result until completed. Such behavior is intentionally predefined so
the application could control the launch-stop-launch transitions on its own. For instance, in the case when status of event handling is unnecessary
you may enclose event handling in ``try/catch`` block, nevertheless it is highly recommended to recorded exception into the application
:doc:`log </05-logging/index>`. If part of logics can be executed asynchronously it is recommended to run it in a new thread.

.. note:: It is the good practice when you minimize duration of the application start and stop. Accordingly this will improve the speed of app
          deployment and its re-launch.

.. _`IAppStartedHandler`: ../api/reference/InfinniPlatform.Hosting.IAppStartedHandler.html
.. _`IAppStoppedHandler`: ../api/reference/InfinniPlatform.Hosting.IAppStoppedHandler.html
