.. index:: IContainerModule

IoC Container Module
====================

Before any InfinniPlatform application is run the platform initiates search of IoC-container modules. It scans all assemblies (``*.dll``) in the current
app directory and selectively picks up all classes that implement IContainerModule_ interface. Those classes must be public and have got parameterless
constructor. Then comes automatic module creation and a method `Load()_` is called in the end of this procedure.


.. index:: IContainerModule.Load()

Loading of IoC Container Module
-------------------------------

Method `Load()`_ designed to register app components and must not contain any other logic due to the fact it is posed in inconsistent state.
To register components into `Load()`_ interface IContainerBuilder_ is passed.

.. note:: If there is necessity to execute some logic immediately after the app is run one should use methods described in the article :doc:`/03-hosting/index`.

Common structure of IoC-container module may look like this:

.. code-block:: csharp

    public class ContainerModule : IContainerModule
    {
        public void Load(IContainerBuilder builder)
        {
            // Registering components...
        }
    }


.. _`IContainerModule`: /api/reference/InfinniPlatform.IoC.IContainerModule.html
.. _`Load()`: /api/reference/InfinniPlatform.IoC.IContainerModule.html#InfinniPlatform_IoC_IContainerModule_Load_InfinniPlatform_IoC_IContainerBuilder_
.. _`IContainerBuilder`: /api/reference/InfinniPlatform.IoC.IContainerBuilder.html

