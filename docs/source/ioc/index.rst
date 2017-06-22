IoC Container
=============

Modern applications have of configurable, related **components**. The more complicated app logic is, the more complicated components and its relations
are. The key to the successful app development is the principle of writing decoupled code. This rule underlines that every component must be isolated
and ideally must not rely on dependencies from the other components. Decoupled apps are the most flexible and easily maintainable. They can be tested
with less efforts and time. 

All InfinniPlatform app components get managed by IoC_-container which main goal is to simplify and automate writing of decoupled code. IoC_-container
stores list of app components and automatically defines relations between them and controls lifetime of each one.

.. toctree::

    container-module.rst
    container-builder.rst
    container-resolver.rst
    container-lifetime.rst


.. _IoC: http://martinfowler.com/articles/injection.html
