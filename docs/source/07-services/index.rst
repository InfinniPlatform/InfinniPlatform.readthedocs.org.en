HTTP Services
=============

InfinniPlatform provides lightweight customizable API for building HTTP based services. With it you can handle ``GET``, ``POST``, ``PUT``, ``PATCH``
and ``DELETE`` requests. It is very easy to create new HTTP service just look at the following code.

.. code-block:: csharp

    public class HelloHttpService : IHttpService
    {
        public void Load(IHttpServiceBuilder builder)
        {
            builder.Get["/"] = request => Task.FromResult<object>("Hello World");
        }
    }

InfinniPlatform fully integrated with `NancyFx`_ - lightweight, low-ceremony, framework for building HTTP based services. So you have all benefits of
`NancyFx`_ and can use all features of InfinniPlatform.


.. toctree::

    services-module.rst
    services-routing.rst
    services-request.rst
    services-response.rst
    services-interception.rst


.. _`NancyFx`: http://nancyfx.org/
