.. index:: IContainerModule

IoC Container Module
====================

Before any InfinniPlatform application is run the platform initiates search of IoC-container modules. It scans all app containers (``*.dll``) in the current app folder and selectively picks up all classes that implement ``InfinniPlatform.Sdk.IoC.IContainerModule`` interface. Those classes must be public and have got parameterless constructor. Then comes automatic module creation and a method ``Load()`` is called in the end of this procedure.

.. index:: IContainerModule.Load()

Loading of IoC Container Module
-------------------------------

Method ``Load()`` designed to register app components and must not contain any other logic due to the fact it is posed in incoherent state. To Register components into ``Load()`` interface ``InfinniPlatform.Sdk.IoC.IContainerBuilder`` is transferred.

.. note:: If there is necessity to execute some logic immediately after the app is run one should use methods described in the article :doc:`/03-hosting/index`.

Commom structure of IoC-container module may look like this:

.. code-block:: csharp

    public class ContainerModule : InfinniPlatform.Sdk.IoC.IContainerModule
    {
        public void Load(InfinniPlatform.Sdk.IoC.IContainerBuilder builder)
        {
            // registering components...
        }
    }
