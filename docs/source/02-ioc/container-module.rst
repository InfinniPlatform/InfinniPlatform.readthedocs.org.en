.. index:: IContainerModule

IoC Container Module
====================

Before an application will be run you need to register all components in the IoC container. Modules can add a set of related components to a container.
Each module implements the IContainerModule_ interface and contains only the `Load()`_ method for registering components.


.. index:: IContainerModule.Load()

Loading of IoC Container Module
-------------------------------

Method `Load()`_ designed to register app components and must not contain any other logic due to the fact it is posed in inconsistent state.
To register components into `Load()`_ an instance of the IContainerBuilder_ interface is passed.

.. note:: If there is necessity to execute some logic immediately after the app is run one should use methods described in the article :doc:`/03-hosting/index`.

Common structure of IoC-container module may look like this:

.. code-block:: csharp

    public class MyAppContainerModule : IContainerModule
    {
        public void Load(IContainerBuilder builder)
        {
            // Registering components...
        }
    }


Configuration IoC Container on Startup
--------------------------------------

To configure the IoC container in an ASP.NET Core application you need to create an instance of the IServiceProvider_ interface and return one
from the `ConfigureServices()`_ method. For features that require substantial setup there are ``Add[Component]`` extension methods on IServiceCollection_.
User defined modules are added by the `AddContainerModule()`_ extension method. The `BuildProvider()`_ extension method builds and returns an
instance of the IServiceProvider_ interface.

.. code-block:: csharp
   :emphasize-lines: 5,7

    public class Startup
    {
        public IServiceProvider ConfigureServices(IServiceCollection services)
        {
            services.AddContainerModule(new MyAppContainerModule());

            return services.BuildProvider();
        }

        // ...
    }


.. _`IContainerModule`: ../api/reference/InfinniPlatform.IoC.IContainerModule.html
.. _`Load()`: ../api/reference/InfinniPlatform.IoC.IContainerModule.html#InfinniPlatform_IoC_IContainerModule_Load_InfinniPlatform_IoC_IContainerBuilder_
.. _`IContainerBuilder`: ../api/reference/InfinniPlatform.IoC.IContainerBuilder.html
.. _`AddContainerModule()`: ../api/reference/InfinniPlatform.AspNetCore.CoreExtensions.html#InfinniPlatform_AspNetCore_CoreExtensions_AddContainerModule_IServiceCollection_InfinniPlatform_IoC_IContainerModule_
.. _`BuildProvider()`: ../api/reference/InfinniPlatform.AspNetCore.CoreExtensions.html#InfinniPlatform_AspNetCore_CoreExtensions_BuildProvider_IServiceCollection_

.. _`IServiceCollection`: https://docs.microsoft.com/en-us/aspnet/core/api/microsoft.extensions.dependencyinjection.iservicecollection
.. _`IServiceProvider`: https://docs.microsoft.com/en-us/aspnet/core/fundamentals/dependency-injection
.. _`ConfigureServices()`: https://docs.microsoft.com/en-us/aspnet/core/fundamentals/startup#the-configureservices-method
