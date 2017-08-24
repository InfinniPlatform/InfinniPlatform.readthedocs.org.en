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

.. http:post:: /auth/SignIn/

    Authenticates the user based on the specified user key and password and starts user session.
    User's id, username, email or phone number can be used as user key.
    This method will try to find user using key one-by-one, so can be less effective than methods for specific user key (see below).

    Example:

    .. code-block:: bash

        curl -X POST \
             -H "Content-Type: application/json" \
             -d '{"UserKey":"user1","password":"qwerty"}' \
             http://localhost:5000/auth/SignIn

    :reqheader Content-Type: application/json
    :resheader Content-Type: application/json
    :resheader Set-Cookie: User Cookies
    :statuscode 200: OK
    :statuscode 400: Validation Error
    :statuscode 500: Internal Server Error

.. http:post:: /auth/SignInById/

    Authenticates the user based on the specified name and password and starts user session.

    Example:

    .. code-block:: bash

        curl -X POST \
             -H "Content-Type: application/json" \
             -d '{"Id":"9d63e3d2-cf06-4c85-a8d3-ca634dfc0131","password":"qwerty"}' \
             http://localhost:5000/auth/SignInById

    :reqheader Content-Type: application/json
    :resheader Content-Type: application/json
    :resheader Set-Cookie: User Cookies
    :statuscode 200: OK
    :statuscode 400: Validation Error
    :statuscode 500: Internal Server Error

.. http:post:: /auth/SignInByUserName/

    Authenticates the user based on the specified id and password and starts user session.

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

.. http:post:: /auth/SignInByEmail/

    Authenticates the user based on the specified email and password and starts user session.

    Example:

    .. code-block:: bash

        curl -X POST \
             -H "Content-Type: application/json" \
             -d '{"Email":"user1@infinni.ru","password":"qwerty"}' \
             http://localhost:5000/auth/SignInByEmail

    :reqheader Content-Type: application/json
    :resheader Content-Type: application/json
    :resheader Set-Cookie: User Cookies
    :statuscode 200: OK
    :statuscode 400: Validation Error
    :statuscode 500: Internal Server Error

.. http:post:: /auth/SignInByPhoneNumber/

    Authenticates the user based on the specified phone number and password and starts user session.

    Example:

    .. code-block:: bash

        curl -X POST \
             -H "Content-Type: application/json" \
             -d '{"PhoneNumber":"+73216549877","password":"qwerty"}' \
             http://localhost:5000/auth/SignInByPhoneNumber

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
