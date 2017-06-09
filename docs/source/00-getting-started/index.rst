Getting Started
===============

Below you will find the steps to build your first ASP.NET Core app powered by InfinniPlatform.

Let's start by building a simple "Hello, world!" app.

**1.** Install .NET Core. See installation steps for Windows, macOS, and Linux `here <https://dot.net/core>`_.

**2.** Create a new ASP.NET Core project

.. code-block:: bash

    mkdir myapp
    cd myapp
    dotnet new web

**3.** Install InfinniPlatform.Core package

.. code-block:: bash

    dotnet add package InfinniPlatform.Core -s https://www.myget.org/F/infinniplatform/ -v 2.3.8-*

**4.** Create MyHttpService.cs and define an HTTP service

.. code-block:: csharp
   :caption: MyHttpService.cs
   :emphasize-lines: 11,12

    using System.Threading.Tasks;

    using InfinniPlatform.Http;

    namespace myapp
    {
        class MyHttpService : IHttpService
        {
            public void Load(IHttpServiceBuilder builder)
            {
                builder.Get["/hello"] = async request =>
                    await Task.FromResult("Hello from InfinniPlatform!");
            }
        }
    }

**5.** Create MyAppContainerModule.cs and register the HTTP service

.. code-block:: csharp
   :caption: MyAppContainerModule.cs
   :emphasize-lines: 10

    using InfinniPlatform.Http;
    using InfinniPlatform.IoC;

    namespace myapp
    {
        class MyAppContainerModule : IContainerModule
        {
            public void Load(IContainerBuilder builder)
            {
                builder.RegisterType<MyHttpService>().As<IHttpService>().SingleInstance();
            }
        }
    }

**6.** Update the code in Startup.cs to use InfinniPlatform

.. code-block:: csharp
   :caption: Startup.cs
   :emphasize-lines: 15,20

    using System;

    using InfinniPlatform.AspNetCore;
    using InfinniPlatform.IoC;

    using Microsoft.AspNetCore.Builder;
    using Microsoft.Extensions.DependencyInjection;

    namespace myapp
    {
        public class Startup
        {
            public IServiceProvider ConfigureServices(IServiceCollection services)
            {
                services.AddContainerModule(new MyAppContainerModule());

                return services.BuildProvider();
            }

            public void Configure(IApplicationBuilder app, IContainerResolver resolver)
            {
                app.UseDefaultAppLayers(resolver);
            }
        }
    }

**7.** Restore the packages

.. code-block:: bash

    dotnet restore -s https://www.myget.org/F/infinniplatform/

**8.** Run the app (the dotnet run command will build the app when it's out of date)

.. code-block:: bash

    dotnet run

**9.** Browse to http://localhost:5000/hello

**10.** Press Ctrl+C to stop the app
