.. index:: IContainerBuilder

Registration Concepts
=====================

Interface IContainerBuilder_ represents a few overloadings of the method ``Register()``, designed to register IoC-container components. Registration
methods also define the way of creating **instances** of components. Instances components may be made via reflection_ by means IoC-container itself;
may be represented by beforehand created instance; may be created by a factory function or a lambda_-expression. Each component may represent one or
a few **services** defined with using one of the methods `As()`_.

.. code-block:: csharp
   :emphasize-lines: 16

    public interface IMyService
    {
        // ...
    }


    public class MyComponent : IMyService
    {
        // ...
    }

    public class ContainerModule : IContainerModule
    {
        public void Load(IContainerBuilder builder)
        {
            builder.RegisterType<MyComponent>().As<IMyService>();

            // ...
        }
    }


.. index:: IContainerBuilder.RegisterType()

Register Types
--------------

Component instances registered with method `RegisterType()`_ created by reflection_ and class constructor with the most number of parameters
retrievable from container.

.. code-block:: csharp

    // Способ 1
    builder.RegisterType<MyComponent>().As<IMyService>();

    // Способ 2
    builder.RegisterType(typeof(MyComponent)).As(typeof(IMyService));


.. index:: IContainerBuilder.RegisterGeneric()

Register Generic Types
----------------------

If component presented as generic_-type to register one should use method `RegisterGeneric()`_. As in case of regular types, instances of
generic-components created by reflection_ and class constructor with the most number of parameters retrievable from container. 

.. code-block:: csharp
   :emphasize-lines: 7

    public interface IRepository<T> { /* ... */ }

    public class MyRepository<T> : IRepository<T> { /* ... */ }

    // ...

    builder.RegisterGeneric(typeof(MyRepository<>)).As(typeof(IRepository<>));


.. index:: IContainerBuilder.RegisterInstance()

Register Instances
------------------

In some cases you may want to register an instance component created beforehand. For example, if creation of the component requires a lot of resources
or is a technically complicated task. To register such components one should use method `RegisterInstance()`_.

.. code-block:: csharp

    builder.RegisterInstance(new MyComponent()).As<IMyService>();


.. index:: IContainerBuilder.RegisterFactory()

Register Factory Functions
--------------------------

Component may be registered by a factory function or lambda_-expression. This way suits well when creation of component instance should be accompanied
by preliminary calculations or is impossible to be created by class constructor. Such components should be registered via method `RegisterFactory()`_. 

.. code-block:: csharp

    builder.RegisterFactory(r => new MyComponent()).As<IMyService>();

Input parameter ``r`` represents :ref:`context of IoC-container <container-resolver>`, which can be used to get all dependencies required to create
component. This approach is the most fitting rather than obtaining dependencies via closure because this ensures a unified way of managing the life
cycle of all dependencies.

.. code-block:: csharp

    builder.RegisterFactory(r => new A(r.Resolve<B>()));


.. _`IContainerBuilder`: ../api/reference/InfinniPlatform.IoC.IContainerBuilder.html
.. _`RegisterType()`: ../api/reference/InfinniPlatform.IoC.IContainerBuilder.html#InfinniPlatform_IoC_IContainerBuilder_RegisterType_Type_
.. _`RegisterGeneric()`: ../api/reference/InfinniPlatform.IoC.IContainerBuilder.html#InfinniPlatform_IoC_IContainerBuilder_RegisterGeneric_Type_
.. _`RegisterInstance()`: ../api/reference/InfinniPlatform.IoC.IContainerBuilder.html#InfinniPlatform_IoC_IContainerBuilder_RegisterInstance__1___0_
.. _`RegisterFactory()`: ../api/reference/InfinniPlatform.IoC.IContainerBuilder.html#InfinniPlatform_IoC_IContainerBuilder_RegisterFactory__1_Func_InfinniPlatform_IoC_IContainerResolver___0__
.. _`As()`: ../api/reference/InfinniPlatform.IoC.IContainerRegistrationRule.html#InfinniPlatform_IoC_IContainerRegistrationRule_As_Type___

.. _reflection: https://msdn.microsoft.com/en-us/library/f7ykdhsy(v=vs.110).aspx
.. _generic: https://msdn.microsoft.com/en-US/library/512aeb7t.aspx
.. _lambda: https://msdn.microsoft.com/en-US/library/bb397687.aspx
