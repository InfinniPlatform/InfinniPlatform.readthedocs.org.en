IoC Container
=============

Modern applications comprise of configurable, interlinked **components**. The more sophisticated app logic is, the more complicated components and its links are. The key to the successful app development is the principle of writing decoupled code. This rule underlines that every component must be isolated and ideally deprived of dependenicies from the other components. Decoupled apps are the most flexible and easily maintainable. They can be tested with with less efforts and time. 

All InfinniPlatform app components get managed by IoC_-container which main goal is to simlify and automate writing of deoupled code. IoC_-container stores list of app components and automatically defines links between them and conrols lifetime of each one.

.. toctree::

    container-module.rst
    container-builder.rst
    container-resolver.rst
    container-lifetime.rst


.. _IoC: http://martinfowler.com/articles/injection.html
