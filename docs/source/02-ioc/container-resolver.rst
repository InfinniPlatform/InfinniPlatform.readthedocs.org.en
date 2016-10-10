Resolving dependencies
======================

Once components :doc:`registered </02-ioc/container-builder>` they can be retrieved. Retrieving process of a single component instance by another using IoC-container is called **dependency resolving**. In InfinniPlatform apps all dependencies transited via class constructors.


Resolving Direct Dependency
---------------------------

In most cases a direct dependency is defined between components. Next example component ``A`` depends on component ``B``.
In the very moment when app requests component ``A``. first IoC-container creates component ``B`` then transit newly created component into constructor of component ``A``. If component ``B`` depends on other components they will be created beforehand.

.. code-block:: csharp
   :emphasize-lines: 5

    public class A
    {
        private readonly B _b;
    
        public A(B b)
        {
            _b = b;
        }
    
        public void SomeMethod()
        {
            _b.DoSomething();
        }
    }


Resolving Enumeration of Dependencies
-------------------------------------

In case if one wants to get a number of typical components one should place a list of required type. Next example component ``A`` is dependant on all components of type ``B``. All components of type ``B`` will be created and transferred to component ``A`` constructor as an enumerator list   `IEnumerable<T>`_.

.. code-block:: csharp
   :emphasize-lines: 5

    public class A
    {
        private readonly IEnumerable<B> _list;
    
        public A(IEnumerable<B> list)
        {
            _list = list;
        }
    
        public void SomeMethod()
        {
            foreach (var b in _list)
            {
                b.DoSomething();
            }
        }
    }


Resolving with Delayed Instantiation
------------------------------------

In case if getting a dependency requires a lot of computing resources or it rarely is  used one should use a postponed initializaton which is made with class  `Lazy<T>`_.
Next example shows component ``A`` depends on component ``B`` but gets that dependency via postponed initialization while requesting a property `Lazy<T>.Value`_ for the first time.     

.. code-block:: csharp
   :emphasize-lines: 5,12

    public class A
    {
        private readonly Lazy<B> _b;
    
        public A(Lazy<B> b)
        {
            _b = b;
        }
    
        public void SomeMethod()
        {
            _b.Value.DoSomething();
        }
    }


.. _resolve-func:

Resolving Factory Functions
---------------------------

In case if it is required to create more than one instance of dependecy or decision to create dependency can be done when the app is executed one should use a factory function. Next example shows that component ``A`` depends on component ``B`` however it gets this dependency right before its usage.

.. code-block:: csharp
   :emphasize-lines: 5,12

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


Resolving Parameterized Factory Functions
-----------------------------------------

In case if it is required to create more than one instance of dependency or decision to create dependency can be done when app is executed one should use a parameterized factory function. Next component ``A`` depends on component ``B`` but gets this dependency right before its usage having transferred to the factory function parameter values required to create component ``B``.

.. code-block:: csharp
   :emphasize-lines: 5,12

    public class A
    {
        private readonly Func<int, B> _b;
    
        public A(Func<int, B> b)
        {
            _b = b;
        }
    
        public void SomeMethod()
        {
            var b = _b(42);
    
            b.DoSomething();
        }
    }
    
    
    public class B
    {
        public B(int v) { /* ... */ }
    
        public void DoSomething() { /* ... */ }
    }

If factory function must create a few typical parameters one should define its delegate.

.. code-block:: csharp
   :emphasize-lines: 5,12,27

    public class A
    {
        private readonly FactoryB _b;
    
        public A(FactoryB b)
        {
            _b = b;
        }
    
        public void SomeMethod()
        {
            var b = _b(42, 43);
    
            b.DoSomething();
        }
    }
    
    
    public class B
    {
        public B(int v1, int v2) { /* ... */ }
    
        public void DoSomething() { /* ... */ }
    }


    public delegate B FactoryB(int v1, int v2);


.. index:: IContainerResolver

.. _container-resolver:

Getting Direct Access to IoC Container
--------------------------------------

In case if it is required to make a univeral factory of components which type is knowable when app being executed, for example as in generic-type case, or working component logic depends on configuration of IoC-container, one can obtain a direct access to container if interface dependency ``InfinniPlatform.Sdk.IoC.IContainerResolver`` is denoted. 
Next example shows component ``A`` acquires access to IoC-contaner because component type becomes known while being executed.

.. code-block:: csharp
   :emphasize-lines: 5,12

    public class A
    {
        private readonly IContainerResolver _resolver;
    
        public A(IContainerResolver resolver)
        {
            _resolver = resolver;
        }
    
        public void SomeMethod<T>()
        {
            var b = _resolver.Resolve<B<T>>();
    
            b.DoSomething();
        }
    }
    
    
    public class B<T>
    {
        public void DoSomething() { /* ... */ }
    }


Resolving dependencies at Runtime
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. index:: IContainerResolver.Resolve()

``InfinniPlatform.Sdk.IoC.IContainerResolver`` interface lets get dependency by any of afore mentioned way. ``Resolve()`` serves those purposes and has two reloads.

.. code-block:: csharp

    // Способ 1
    IMyService myService = resolver.Resolve<IMyService>();

    // Способ 2
    object myService = resolver.Resolve(typeof(IMyService));

.. index:: IContainerResolver.TryResolve()

If service is not registered, method ``Resolve()`` will throw an exeption. This can be bypassed two ways, first one is to use method ``TryResolve()``.

.. code-block:: csharp

    // Way 1
    
    IMyService myService;
    
    if (resolver.TryResolve<IMyService>(out myService))
    {
        // ...
    }
    
    // Way 2
    
    object myService;
    
    if (resolver.TryResolve(typeof(IMyService), out myService))
    {
        // ...
    }

.. index:: IContainerResolver.ResolveOptional()

Second is to use method ``ResolveOptional()``.

.. code-block:: csharp

    // Way 1
    
    IMyService myService = resolver.ResolveOptional<IMyService>();
    
    if (myService != null)
    {
        // ...
    }
    
    // Way 2
    
    object myService = resolver.ResolveOptional(typeof(IMyService));
    
    if (myService != null)
    {
        // ...
    }


.. index:: IContainerResolver.Services
.. index:: IContainerResolver.IsRegistered()

Checking registrations
~~~~~~~~~~~~~~~~~~~~~~

To check the configuration of IoC-container one may call a list of registered services ``Services``.
To check the status of registration of a particular service one should use method ``IsRegistered()``. 

.. code-block:: csharp

    // Way 1
    
    if (resolver.IsRegistered<IMyService>())
    {
        // ...
    }
    
    // Way 2
    
    if (resolver.IsRegistered(typeof(IMyService)))
    {
        // ...
    }


.. _`IEnumerable<T>`: https://msdn.microsoft.com/en-US/library/9eekhta0(v=vs.110).aspx
.. _`Lazy<T>`: https://msdn.microsoft.com/en-US/library/dd642331(v=vs.110).aspx
.. _`Lazy<T>.Value`: https://msdn.microsoft.com/en-US/library/dd642177(v=vs.110).aspx
