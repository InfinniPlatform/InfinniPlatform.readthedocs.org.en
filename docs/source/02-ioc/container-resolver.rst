Resolving dependencies
======================

Once components :doc:`registered </02-ioc/container-builder>` they can be retrieved. Retrieving process of a single component instance by another using
IoC-container is called **dependency resolving**. In InfinniPlatform apps all dependencies passed via class constructors.


Resolving Direct Dependency
---------------------------

In most cases a direct dependency is defined between components. Next example component ``A`` depends on component ``B``. In the very moment when app
requests component ``A``, first IoC-container creates component ``B`` then pass newly created component into constructor of component ``A``. If component
``B`` depends on other components they will be created beforehand.

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

Dependencies of an enumerable type provide multiple implementations of the same service (interface). Next example component ``A`` is dependant on all
components of type ``B``. All components of type ``B`` will be created and passed to component ``A`` via constructor as an instance of `IEnumerable<T>`_.

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

A lazy dependency is not instantiated until its first use. This appears where the dependency is infrequently used, or expensive to construct. To take
advantage of this, use a `Lazy<T>`_ in the constructor. Next example shows component ``A`` depends on component ``B`` but gets that dependency via
lazy initialization while requesting a property `Lazy<T>.Value`_ for the first time.

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

Using an auto-generated factory is applicable in case if it is required to create more than one instance of dependency or decision to create dependency
can be done in runtime. Next example shows that component ``A`` depends on component ``B`` however it gets this dependency right before its usage.

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

Using an auto-generated factory is also applicable in case if there are strongly-typed parameters in the resolution function. Next example shows that
component ``A`` depends on component ``B`` but gets this dependency right before its usage having passed to the factory function parameter values
required to create component ``B``.

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

If factory function has duplicate types in the input parameter list one should define its delegate.

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

In case if it is required to make a universal factory of components which type is knowable in runtime, for example as in generic-type case, or working
component logic depends on configuration of IoC-container, one can obtain a direct access to container using IContainerResolver_. Next example shows
component ``A`` acquires access to IoC-container because component type becomes known in runtime.

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

The IContainerResolver_ interface lets get dependency by any of afore mentioned way. `Resolve()`_ serves those purposes and has two reloads.

.. code-block:: csharp

    // Way 1
    IMyService myService = resolver.Resolve<IMyService>();

    // Way 2
    object myService = resolver.Resolve(typeof(IMyService));

.. index:: IContainerResolver.TryResolve()

If service is not registered, method `Resolve()`_ will throw an exception. This can be bypassed two ways, first one is to use method `TryResolve()`_.

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

Second is to use method `ResolveOptional()`_.

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

To check the configuration of IoC-container one may call a list of registered services Services_. To check the status of registration of a particular
service one should use method `IsRegistered()`_. 

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


.. _`IContainerResolver`: /api/reference/InfinniPlatform.IoC.IContainerResolver.html
.. _`Services`: /api/reference/InfinniPlatform.IoC.IContainerResolver.html#InfinniPlatform_IoC_IContainerResolver_Services
.. _`IsRegistered()`: /api/reference/InfinniPlatform.IoC.IContainerResolver.html#InfinniPlatform_IoC_IContainerResolver_IsRegistered_Type_
.. _`Resolve()`: /api/reference/InfinniPlatform.IoC.IContainerResolver.html#InfinniPlatform_IoC_IContainerResolver_Resolve_Type_
.. _`TryResolve()`: /api/reference/InfinniPlatform.IoC.IContainerResolver.html#InfinniPlatform_IoC_IContainerResolver_TryResolve_Type_System_Object__
.. _`ResolveOptional()`: /api/reference/InfinniPlatform.IoC.IContainerResolver.html#InfinniPlatform_IoC_IContainerResolver_ResolveOptional_Type_

.. _`IEnumerable<T>`: https://docs.microsoft.com/en-us/dotnet/api/system.collections.generic.ienumerable-1?view=netcore-1.1
.. _`Lazy<T>`: https://docs.microsoft.com/en-us/dotnet/api/system.lazy-1?view=netcore-1.1
.. _`Lazy<T>.Value`: https://docs.microsoft.com/en-us/dotnet/api/system.lazy-1.value?view=netcore-1.1#System_Lazy_1_Value
