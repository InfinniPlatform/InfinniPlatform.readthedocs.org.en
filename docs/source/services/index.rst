HTTP Services
=============

InfinniPlatform provides lightweight customizable API for building HTTP based services. With it you can handle ``GET``, ``POST``, ``PUT``, ``PATCH``
and ``DELETE`` requests. It is very easy to create new HTTP service just look at the following code.

.. code-block:: csharp

    class MyHttpService : IHttpService
    {
        public void Load(IHttpServiceBuilder builder)
        {
            builder.Get["/hello"] = async request =>
                await Task.FromResult("Hello from InfinniPlatform!");
        }
    }


.. toctree::

    services-module.rst
    services-routing.rst
    services-request.rst
    services-response.rst
    services-interception.rst
