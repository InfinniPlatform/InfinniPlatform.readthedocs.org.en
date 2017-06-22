Application Configuration
=========================

Developers and administrators use **configuration files** to customize their applications without programming. Usually configuration file is a text
file which contains an application settings. But files are not the only way to configure applications there are a lot of other configuration sources
at least command-line arguments and environment variables. `The configuration API in ASP.NET Core`_ provides a way of configuring an app based on
a list of name-value pairs that can be read at runtime from multiple sources. The name-value pairs can be grouped into a multi-level hierarchy.
There are configuration providers for:

* File formats (INI_, JSON_, and XML_)
* Command-line arguments
* Environment variables
* In-memory .NET objects
* `An encrypted user store`_
* `Azure Key Vault`_
* `Custom providers`_

Each configuration value maps to a string key. There’s built-in binding support to deserialize settings into a custom POCO_ object (a simple .NET
class with properties). All of these tools can make your application highly flexible and simplify deploying and supporting.


Application Configuration File
------------------------------

Configuration files are one of the most common way to configure an application. Recently JSON_ became popular format to representing an application
settings. The settings are represented as JSON object with many defined properties. Properties of the first level are **configuration sections**
which described by "key-value" pairs. Key is a name of property while value as a rule is a JSON object of any complexity. Each configuration
section reflects settings of an subsystem or a particular component.

You can see an example of configuration file common structure below. This contains two sections ``section1`` and ``section2``, each one has its own
set of properties. Section properties can be of any JSON compatible type (string type in example). Number, name and content of configuration section
is defined by the app developer however there are a few pre-defined InfinniPlatform configuration sections.

.. code-block:: js
   :caption: AppConfig.json

    {
      "section1": {
        "Property11": "Value11",
        "Property12": "Value12",
        "Property13": "Value13"
      },
      "section2": {
        "Property21": "Value21",
        "Property22": "Value22",
        "Property23": "Value23",
      }
    }

The following highlighted code hooks up the JSON file configuration provider to one source.

.. code-block:: csharp
   :emphasize-lines: 13

    using Microsoft.AspNetCore.Hosting;
    using Microsoft.Extensions.Configuration;
    using Microsoft.Extensions.DependencyInjection;

    public class Startup
    {
        private readonly IConfigurationRoot _configuration;

        public Startup(IHostingEnvironment env)
        {
            var builder = new ConfigurationBuilder()
                    .SetBasePath(env.ContentRootPath)
                    .AddJsonFile("AppConfig.json", optional: true, reloadOnChange: true);

            _configuration = builder.Build();
        }

        // ...
    }

It's typical to have different configuration settings for `different environments`_, for example, development, test and production. Thus you can
improve previous example by adding a source of the environment.

.. code-block:: csharp
   :emphasize-lines: 14

    using Microsoft.AspNetCore.Hosting;
    using Microsoft.Extensions.Configuration;
    using Microsoft.Extensions.DependencyInjection;

    public class Startup
    {
        private readonly IConfigurationRoot _configuration;

        public Startup(IHostingEnvironment env)
        {
            var builder = new ConfigurationBuilder()
                    .SetBasePath(env.ContentRootPath)
                    .AddJsonFile("AppConfig.json", optional: true, reloadOnChange: true)
                    .AddJsonFile($"AppConfig.{env.EnvironmentName}.json", optional: true);

            _configuration = builder.Build();
        }

        // ...
    }

See `AddJsonFile()`_ for an explanation of the parameters.

.. note:: Configuration sources are read in the order they are specified and the latest overrides previous.

After configuration settings it is time to define an application options. The options pattern uses custom options classes to represent a group of
related settings. We recommended that you create decoupled classes for each feature within your app. Decoupled classes follow:

* `The Interface Segregation Principle`_ : Classes depend only on the configuration settings they use.
* `Separation of Concerns`_ : Settings for different parts of your app are not dependent or coupled with one another.

The options class must be non-abstract with a public parameterless constructor. For the abovementioned ``section1`` an appropriate options class can
have next form:

.. code-block:: csharp

    public class MyOptions
    {
        public string Property11 { get; set; }
        public string Property12 { get; set; }
        public string Property13 { get; set; }
    }

There is a way reading options directly nevertheless the more elegant method is using :doc:`dependency injection </ioc/index>` mechanism.

.. code-block:: csharp

    // Direct reading of the configuration section
    MyOptions options = _configuration.GetSection("section1").Get<MyOptions>();

In the following code, the ``MyOptions`` class is added to the service container and bound to configuration.

.. code-block:: csharp
   :emphasize-lines: 21,22

    using Microsoft.AspNetCore.Hosting;
    using Microsoft.Extensions.Configuration;
    using Microsoft.Extensions.DependencyInjection;

    public class Startup
    {
        private readonly IConfigurationRoot _configuration;

        public Startup(IHostingEnvironment env)
        {
            var builder = new ConfigurationBuilder()
                    .SetBasePath(env.ContentRootPath)
                    .AddJsonFile("AppConfig.json", optional: true, reloadOnChange: true)
                    .AddJsonFile($"AppConfig.{env.EnvironmentName}.json", optional: true);

            _configuration = builder.Build();
        }

        public IServiceProvider ConfigureServices(IServiceCollection services)
        {
            // Register the configuration section which MyOptions binds against
            services.Configure<MyOptions>(_configuration.GetSection("section1"));

            // ...
        }

        // ...
    }

The following component uses :doc:`dependency injection </ioc/index>` on `IOptions<TOptions>`_ to access settings:

.. code-block:: csharp
   :emphasize-lines: 5

    public class MyComponent
    {
        private readonly MyOptions _options;

        public MyComponent(IOptions<MyOptions> optionsAccessor)
        {
            _options = optionsAccessor.Value;
        }

        // ...
    }


.. index:: Environment Variables

Environment Variables
---------------------

Environment Variables are yet another popular way to configure an application.

.. code-block:: csharp
   :emphasize-lines: 15

    using Microsoft.AspNetCore.Hosting;
    using Microsoft.Extensions.Configuration;
    using Microsoft.Extensions.DependencyInjection;

    public class Startup
    {
        private readonly IConfigurationRoot _configuration;

        public Startup(IHostingEnvironment env)
        {
            var builder = new ConfigurationBuilder()
                    .SetBasePath(env.ContentRootPath)
                    .AddJsonFile("AppConfig.json", optional: true, reloadOnChange: true)
                    .AddJsonFile($"AppConfig.{env.EnvironmentName}.json", optional: true)
                    .AddEnvironmentVariables();

            _configuration = builder.Build();
        }

        // ...
    }

Configuration sources are read in the order they are specified. In the code above, the environment variables are read last. Any configuration values
set through the environment would replace those set in the two previous providers.

.. note:: A best practice is to specify environment variables last, so that the local environment can override anything set in deployed configuration files.


.. _`The configuration API in ASP.NET Core`: https://docs.microsoft.com/en-us/aspnet/core/fundamentals/configuration
.. _`INI`: https://en.wikipedia.org/wiki/INI_file
.. _`JSON`: http://json.org/
.. _`XML`: http://www.w3.org/XML/
.. _`An encrypted user store`: https://docs.microsoft.com/en-us/aspnet/core/security/app-secrets
.. _`Azure Key Vault`: https://docs.microsoft.com/en-us/aspnet/core/security/key-vault-configuration
.. _`Custom providers`: https://docs.microsoft.com/en-us/aspnet/core/fundamentals/configuration#custom-config-providers
.. _`POCO`: https://en.wikipedia.org/wiki/Plain_Old_CLR_Object
.. _`different environments`: https://docs.microsoft.com/en-us/aspnet/core/fundamentals/environments
.. _`AddJsonFile()`: https://docs.microsoft.com/ru-ru/aspnet/core/api/microsoft.extensions.configuration.jsonconfigurationextensions
.. _`The Interface Segregation Principle`: https://en.wikipedia.org/wiki/Interface_segregation_principle
.. _`Separation of Concerns`: https://en.wikipedia.org/wiki/Separation_of_concerns
.. _`IOptions<TOptions>`: https://docs.microsoft.com/en-us/aspnet/core/api/microsoft.extensions.options.ioptions-1
