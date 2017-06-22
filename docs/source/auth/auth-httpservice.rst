Auth HTTP Service
=================

There is predefined HTTP service for authentication.

**1.** Install ``InfinniPlatform.Auth.HttpService`` package:

.. code-block:: bash

    dotnet add package InfinniPlatform.Auth.HttpService -s https://www.myget.org/F/infinniplatform/

**2.** Call `AddAuthHttpService()`_ in ``ConfigureServices()``:

.. code-block:: csharp
   :emphasize-lines: 11

    using System;

    using InfinniPlatform.AspNetCore;

    using Microsoft.Extensions.DependencyInjection;

    public class Startup
    {
        public IServiceProvider ConfigureServices(IServiceCollection services)
        {
            services.AddAuthHttpService();

            // ...

            return services.BuildProvider();
        }

        // ...
    }

After that next authentication API will be available via HTTP.

.. http:post:: /auth/SignInInternal/

    Authenticates the user based on the specified name and password and starts user session.

    Example:

    .. code-block:: bash

        curl -X POST \
             -H "Content-Type: application/json" \
             -d '{"UserName":"user1","password":"qwerty"}' \
             http://localhost:5000/auth/SignInInternal

    :reqheader Content-Type: application/json
    :resheader Content-Type: application/json
    :resheader Set-Cookie: User Cookies
    :statuscode 200: OK
    :statuscode 400: Validation Error
    :statuscode 500: Internal Server Error


.. http:post:: /auth/SignOut/

    Terminates the user session.

    Example:

    .. code-block:: bash

        curl -X POST http://localhost:5000/auth/SignOut

    :resheader Set-Cookie:
    :statuscode 200: OK
    :statuscode 400: Validation Error
    :statuscode 500: Internal Server Error



.. _`AddAuthHttpService()`: ../api/reference/InfinniPlatform.AspNetCore.AuthHttpServiceExtensions.html#InfinniPlatform_AspNetCore_AuthHttpServiceExtensions_AddAuthHttpService_IServiceCollection_
