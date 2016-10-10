Controlling Lifetime
====================

**Lifetime** of the component is defined by the fact how long the component instance are available to use in application, from the moment of its
creation and to the moment of its :ref:`disposal <dispose>`. Accordingly to lifetime of the InfinniPlatform app components may be divided into the
following types:

* Created at each retrieving
* Created for the time of request processing
* Created for the time of app execution

If component has no internal state and being used during app execution then it makes sense to create shareable component instance at the start of app
execution and dispose it in the end. Otherwise if component has an internal state but not bound by request processing such instance should be created
before first call and be disposed right after its usage. It is recommended to created stateless components so it will decrease a number of error and
reduce resources utilized.


.. index:: IContainerRegistrationRule.InstancePerDependency()
.. index:: IContainerRegistrationRule.InstancePerRequest()
.. index:: IContainerRegistrationRule.SingleInstance()

Defining Component Lifetime
---------------------------

IoC-container performs automatic lifetime components control thus their lifetime is defined during :doc:`registration <container-builder>`.
All registered components are created each time they are received by default.

.. code-block:: csharp

    // Component will be created at each retrieving (by default)
    builder.RegisterType<MyComponent>().As<IMyService>().InstancePerDependency();

    // Component will be created for the time of HTTP-request execution
    builder.RegisterType<MyComponent>().As<IMyService>().InstancePerRequest();

    // Component will be created once for the time of the app execution
    builder.RegisterType<MyComponent>().As<IMyService>().SingleInstance();

In the end of lifetime cycle IoC-container :ref:`disposes <dispose>` component instance which makes it no longer available for further usage. This is
the reason that definition of the lifetime must take into account their dependency. For example, component ``SingleInstance()`` is not able to directly
be dependant on component ``InstancePerDependency()``

.. table:: Possible direct dependencies

    +-----------------------------+-------------------------------+
    | Initial type                | May refer to                  |
    +=============================+===============================+
    | ``InstancePerDependency()`` | * ``InstancePerDependency()`` |
    |                             | * ``InstancePerRequest()``    |
    |                             | * ``SingleInstance()``        |
    +-----------------------------+-------------------------------+
    | ``InstancePerRequest()``    | * ``InstancePerRequest()``    |
    |                             | * ``SingleInstance()``        |
    +-----------------------------+-------------------------------+
    | ``SingleInstance()``        | * ``SingleInstance()``        |
    +-----------------------------+-------------------------------+

If component's lifetime is more than lifetime of the component it depends on to retrieve dependency one should use :ref:`factory function <resolve-func>`.
Next example shows component ``A`` depends on component ``B`` but retrieves its dependency right before usage due to the fact that the lifetime of
component ``A`` is longer than lifetime of component ``B``.

.. code-block:: csharp
   :emphasize-lines: 1,2,10,17

    builder.RegisterType<A>().AsSelf().SingleInstance();
    builder.RegisterType<B>().AsSelf().InstancePerDependency();

    // ...

    public class A
    {
        private readonly Func<B> _b;
    
        public A(Func<B> b)
        {
            _b = b;
        }
    
        public void SomeMethod()
        {
            var b = _b();
    
            b.DoSomething();
        }
    }


.. _dispose:
.. index:: IContainerRegistrationRule.ExternallyOwned()

Components Disposing
--------------------

App may get resources which temporary created for the time of execution. For example a connection to a database, file stream an so on. .NET model
offers ``IDisposable`` interface which brings all resources to be disposed.

In the end of component lifetime IoC-container checks whether it implements ``IDisposable`` interface and if it does then it calls method ``Dispose()``.
Afterwards the current component instance becomes unavailable for further usage.

To deny automatic disposal one should directly call method ``ExternallyOwned()``. This may be frequently used when the component lifetime is owned by
external component.

.. code-block:: csharp

    public class DisposableComponent : IDisposable { /* ... */ }

    // ...

    builder.RegisterType<DisposableComponent>().ExternallyOwned();
