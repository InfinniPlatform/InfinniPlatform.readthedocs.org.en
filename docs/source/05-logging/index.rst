Monitoring and Diagnostics
==========================

InfinniPlatform is fully integrated with ASP.NET Core and supports a logging API that works with a variety of logging providers. Built-in providers
let you send logs to one or more destinations, and you can plug in a third-party logging framework. This article shows how to use the logging API
and providers in your code.


.. index:: ILogger<T>

Using ILogger<T>
----------------

To create logs, get an `ILogger<T>`_ object using :doc:`dependency injection </02-ioc/index>` mechanism and store it in a field, then call logging
methods on that logger object.

.. code-block:: csharp
   :emphasize-lines: 5,7,12

    public class MyComponent
    {
        private readonly ILogger<MyComponent> _logger;

        public MyComponent(ILogger<MyComponent> logger)
        {
            _logger = logger;
        }

        public void DoSomethig()
        {
            _logger.LogInformation("Hello!");
        }
    }


.. index:: IPerformanceLogger<T>

Using IPerformanceLogger<T>
---------------------------

To log performance metrics you can use `IPerformanceLogger<T>`_. Using this component is as easy as using `ILogger<T>`_. The implementation of
the `IPerformanceLogger<T>`_ is based on `ILogger<T>`_ and use ``typeof(IPerformanceLogger<T>)`` as a logger category (a pointer to an event source).
So you can recognize log events of the `IPerformanceLogger<T>`_ and route them to a separate writer.

.. code-block:: csharp
   :emphasize-lines: 5,7,26

    public class MyComponent
    {
        private readonly IPerformanceLogger<MyComponent> _perfLogger;

        public MyComponent(IPerformanceLogger<MyComponent> perfLogger)
        {
            _perfLogger = perfLogger;
        }

        public void DoSomethig()
        {
            var startTime = DateTime.Now;

            Exception exception = null;

            try
            {
                // Some code which duration is logged
            }
            catch (Exception e)
            {
                exception = e;
            }
            finally
            {
                _perfLogger.Log(nameof(DoSomethig), startTime, exception);
            }
        }
    }

.. note:: The above example is quite wordy and inconvenient. Nonetheless you can reduce this difficulties using, for instance, the `Delegation pattern`_
          or some kind of AOP_ tools.


.. _loggerName:

The Logger Name
---------------

By default `ILogger<T>`_ uses ``T`` as the type who's name is used for the logger name. And with it the logger name is produced as the fully qualified
name of the ``T``, including its namespace and excluding any generic arguments even if they exist. So if you, for instance, have two classes ``A`` and
its generic analogue ``A<T>``, the logger names for the both will be the same. In practice it is inconvenient because it can be difficult to define
who is the real source of an event without looking at the code. Also if the component has a unique name using its full name is unnecessary and decreases
readability of the logs.

To solve above problems InfinniPlatform integrates with the logging API and sets the own rules of building logger names. According to these rules the
logger name of the ``ILogger<T>`` is produced as C#-like representation of the type ``T``, including its generic arguments if they exist.

For example, say you have the ``MyComponent`` type as below which tries to get the ``logger`` for itself. In this case the ``logger`` name will be
``Namespace.To.The.MyComponent`` and that is no differences with the default logic.

.. code-block:: csharp
   :emphasize-lines: 5

    namespace Namespace.To.The
    {
        class MyComponent
        {
            public MyComponent(ILogger<MyComponent> logger)
            {
                // ...
            }

            // ...
        }
    }

Differences begin with generic types. Suppose the ``MyComponent`` is generic. In this case the ``logger`` name depends on ``T``
and will be ``Namespace.To.The.MyComponent<T>`` where ``T`` is C#-like representation of the type ``T``. For example, the name
of the ``ILogger<MyComponent<SomeType>>`` will be ``Namespace.To.The.MyComponent<Other.Namespace.To.The.SomeType>``. Thus you
know exactly which component is the event source and can make right decision looking at the event.

.. code-block:: csharp
   :emphasize-lines: 3,5

    namespace Namespace.To.The
    {
        class MyComponent<T>
        {
            public MyComponent(ILogger<MyComponent<T>> logger)
            {
                // ...
            }

            // ...
        }
    }

.. note:: In any case the logger name for generic types will contain information about generic arguments because it can be important during analysis.


.. index:: LoggerNameAttribute

LoggerNameAttribute
~~~~~~~~~~~~~~~~~~~

Some components can have unique name or represent known abstraction in your system so there are no reasons to have full qualified name for the logger
of these components. In these cases you can use the LoggerNameAttribute_ and define the own component name.

.. note:: The LoggerNameAttribute_ can be useful feature during refactoring which includes renaming of the types. Also it force you think harder
          when you choose a name for your component and imagine how it will be represented in the log.

In the next example the name of the ``ILogger<MyComponent>`` will be ``MySubsystem``.

.. code-block:: csharp
   :emphasize-lines: 3,6

    namespace Namespace.To.The
    {
        [LoggerName("MySubsystem")]
        class MyComponent
        {
            public MyComponent(ILogger<MyComponent> logger)
            {
                // ...
            }

            // ...
        }
    }

In case of the generic types the behavior is similar. For example, the name of the ``ILogger<MyComponent<SomeType>>`` will be ``MySubsystem<Other.Namespace.To.The.SomeType>``.

.. code-block:: csharp
   :emphasize-lines: 3,6

    namespace Namespace.To.The
    {
        [LoggerName("MySubsystem")]
        class MyComponent<T>
        {
            public MyComponent(ILogger<MyComponent<T>> logger)
            {
                // ...
            }

            // ...
        }
    }

Also you can apply LoggerNameAttribute_ to ``SomeType`` then the logger name will be shorter - ``MySubsystem<SomeType>``.

.. code-block:: csharp
   :emphasize-lines: 1

    [LoggerName("SomeType")]
    class SomeType
    {
        // ...
    }


How to configure Serilog
------------------------

.. note:: Serilog_ is one of the most popular logging framework and has lots of ways to configuration. Here is one of them and we give it as an example.

Serilog_ provides `sinks` for writing log events to storage in various formats. In our example we split log events by two streams. The first -
the application event log - catches all events, excepting events of `IPerformanceLogger<T>`_. The second - the application performance log -
catches the only events of `IPerformanceLogger<T>`_. The first stream writes to one file the second to another, both use
the ``Serilog.Sinks.RollingFile.RollingFileSink``.

**1.** Define the log output template.

.. code-block:: csharp

    string outputTemplate =
        "{Timestamp:o}|{Level:u3}|{RequestId}|{UserName}|{SourceContext}|{Message}{NewLine}{Exception}";

This template uses a number of built-in properties:

:``TimeStamp``:     The event's timestamp, as a DateTimeOffset (``o`` means using ISO 8601, see `format strings and properties`_).

:``Level``:         The log event level, formatted as the full level name. For more compact level names, use a format such as ``{Level:u3}``
                    or ``{Level:w3}`` for three-character upper- or lowercase level names, respectively.

:``SourceContext``: :ref:`The logger name <loggerName>`. Usually it is full name of the component type who is the event source.

:``Message``:       The log event's message, rendered as plain text.

:``NewLine``:       A property with the value of `System.Environment.NewLine`_.

:``Exception``:     The full exception message and stack trace, formatted across multiple lines.

Also there are two our properties which will be described later:

:``RequestId``:     The unique identifier of the HTTP request during which the event occurred.

:``UserName``:      The user name of the HTTP request during which the event occurred.

**2.** Define the function which splits the application event log and the application performance log:

.. code-block:: csharp

    Func<LogEvent, bool> performanceLoggerFilter = 
        Matching.WithProperty<string>(
            Constants.SourceContextPropertyName,
            p => p.StartsWith(nameof(IPerformanceLogger)));

**3.** Configure Serilog_ logger:

.. code-block:: csharp

    Log.Logger = new LoggerConfiguration()
        // Configures the minimum level - Information
        .MinimumLevel.Information()
        // It will be described later
        .Enrich.With(new HttpContextLogEventEnricher(httpContextAccessor))
        // Writes log events to Console (all events)
        .WriteTo.LiterateConsole(outputTemplate: outputTemplate)
        // The application event log
        .WriteTo.Logger(lc => lc.Filter.ByExcluding(performanceLoggerFilter)
                                .WriteTo.RollingFile("logs/events-{Date}.log",
                                                     outputTemplate: outputTemplate))
        // The application performance log
        .WriteTo.Logger(lc => lc.Filter.ByIncludingOnly(performanceLoggerFilter)
                                .WriteTo.RollingFile("logs/performance-{Date}.log",
                                                     outputTemplate: outputTemplate))
        // Create a logger using the above configuration
        .CreateLogger();

**4.** Add to the ``Startup`` class registration Serilog_:

.. code-block:: csharp
   :emphasize-lines: 14,17

    public class Startup
    {
        // ...

        public void Configure(IApplicationBuilder app,
                              IContainerResolver resolver,
                              ILoggerFactory loggerFactory,
                              IApplicationLifetime appLifetime,
                              IHttpContextAccessor httpContextAccessor)
        {
            // Configure logger (see above)...

            // Register Serilog
            loggerFactory.AddSerilog();

            // Ensure any buffered events are sent at shutdown
            appLifetime.ApplicationStopped.Register(Log.CloseAndFlush);

            // ...
        }
    }

**5.** Declare the ``HttpContextLogEventEnricher`` class which provides ``RequestId`` and ``UserName`` properties.

.. code-block:: csharp

    using Microsoft.AspNetCore.Http;

    using Serilog.Core;
    using Serilog.Events;

    class HttpContextLogEventEnricher : ILogEventEnricher
    {
        private const string RequestIdProperty = "RequestId";
        private const string UserNameProperty = "UserName";


        public HttpContextLogEventEnricher(IHttpContextAccessor httpContextAccessor)
        {
            _httpContextAccessor = httpContextAccessor;
        }


        private readonly IHttpContextAccessor _httpContextAccessor;


        public void Enrich(LogEvent logEvent, ILogEventPropertyFactory propertyFactory)
        {
            var context = _httpContextAccessor.HttpContext;

            if (context != null)
            {
                var requestId = context.TraceIdentifier ?? "";
                var requestIdProperty = propertyFactory.CreateProperty(RequestIdProperty, requestId);
                logEvent.AddPropertyIfAbsent(requestIdProperty);

                var userName = context.User?.Identity?.Name ?? "";
                var userNameProperty = propertyFactory.CreateProperty(UserNameProperty, userName);
                logEvent.AddPropertyIfAbsent(userNameProperty);
            }
        }
    }

Here's an example of what you see in the the application event log:

.. code-block:: text
   :caption: logs/events-20170609.log

    2017-06-09T17:01:50.1335297+05:00|INF|0HL5F5T7R11QM||Microsoft.AspNetCore.Hosting.Internal.WebHost|Request starting HTTP/1.1 GET http://localhost:9900/  
    2017-06-09T17:01:50.6985948+05:00|INF|0HL5F5T7R11QM||Microsoft.AspNetCore.Hosting.Internal.WebHost|Request finished in 578.6941ms 200 application/json; charset=utf-8
    2017-06-09T17:01:50.7546117+05:00|INF|0HL5F5T7R11QN||Microsoft.AspNetCore.Hosting.Internal.WebHost|Request starting HTTP/1.1 GET http://localhost:9900/favicon.ico  
    2017-06-09T17:01:50.7856106+05:00|INF|0HL5F5T7R11QN||Microsoft.AspNetCore.Hosting.Internal.WebHost|Request finished in 31.2093ms 200 application/json
    2017-06-09T17:01:54.3309882+05:00|INF|0HL5F5T7R11QO||Microsoft.AspNetCore.Hosting.Internal.WebHost|Request starting HTTP/1.1 GET http://localhost:9900/info/scheduler  
    2017-06-09T17:01:54.4770051+05:00|INF|0HL5F5T7R11QO||Microsoft.AspNetCore.Hosting.Internal.WebHost|Request finished in 145.2151ms 200 application/json; charset=utf-8
    2017-06-09T17:01:54.5060098+05:00|INF|0HL5F5T7R11QP||Microsoft.AspNetCore.Hosting.Internal.WebHost|Request starting HTTP/1.1 GET http://localhost:9900/favicon.ico  
    2017-06-09T17:01:54.5140225+05:00|INF|0HL5F5T7R11QP||Microsoft.AspNetCore.Hosting.Internal.WebHost|Request finished in 8.0024ms 200 application/json
    2017-06-09T17:01:57.8511674+05:00|INF|0HL5F5T7R11QQ||Microsoft.AspNetCore.Hosting.Internal.WebHost|Request starting HTTP/1.1 GET http://localhost:9900/scheduler/jobs?skip=0&take=10  
    2017-06-09T17:01:58.0921584+05:00|INF|0HL5F5T7R11QQ||Microsoft.AspNetCore.Hosting.Internal.WebHost|Request finished in 240.4372ms 200 application/json; charset=utf-8
    2017-06-09T17:01:58.1196721+05:00|INF|0HL5F5T7R11QR||Microsoft.AspNetCore.Hosting.Internal.WebHost|Request starting HTTP/1.1 GET http://localhost:9900/favicon.ico  
    2017-06-09T17:01:58.1281824+05:00|INF|0HL5F5T7R11QR||Microsoft.AspNetCore.Hosting.Internal.WebHost|Request finished in 8.9547ms 200 application/json

And in the application performance log:

.. code-block:: text
   :caption: logs/performance-20170609.log

    2017-06-09T17:01:54.4129957+05:00|INF|0HL5F5T7R11QO||IPerformanceLogger<JobScheduler>|{ "IsStarted": 2 }
    2017-06-09T17:01:54.4179953+05:00|INF|0HL5F5T7R11QO||IPerformanceLogger<JobScheduler>|{ "GetStatus": 1 }
    2017-06-09T17:01:54.4189952+05:00|INF|0HL5F5T7R11QO||IPerformanceLogger<JobScheduler>|{ "GetStatus": 0 }
    2017-06-09T17:01:54.4204952+05:00|INF|0HL5F5T7R11QO||IPerformanceLogger<JobScheduler>|{ "GetStatus": 0 }
    2017-06-09T17:01:54.4250023+05:00|INF|0HL5F5T7R11QO||IPerformanceLogger<IHttpService>|{ "GET::/info/scheduler": 91 }
    2017-06-09T17:01:54.4740019+05:00|INF|0HL5F5T7R11QO||IPerformanceLogger<GlobalHandlingAppLayer>|{ "GET::/info/scheduler": 141 }
    2017-06-09T17:01:54.5090235+05:00|INF|0HL5F5T7R11QP||IPerformanceLogger<IHttpService>|{ "GET::/{id}": 0 }
    2017-06-09T17:01:54.5120237+05:00|INF|0HL5F5T7R11QP||IPerformanceLogger<GlobalHandlingAppLayer>|{ "GET::/favicon.ico": 4 }
    2017-06-09T17:01:58.0791573+05:00|INF|0HL5F5T7R11QQ||IPerformanceLogger<JobScheduler>|{ "GetStatus": 1 }
    2017-06-09T17:01:58.0811566+05:00|INF|0HL5F5T7R11QQ||IPerformanceLogger<IHttpService>|{ "GET::/scheduler/jobs": 221 }
    2017-06-09T17:01:58.0891579+05:00|INF|0HL5F5T7R11QQ||IPerformanceLogger<GlobalHandlingAppLayer>|{ "GET::/scheduler/jobs": 236 }
    2017-06-09T17:01:58.1231732+05:00|INF|0HL5F5T7R11QR||IPerformanceLogger<IHttpService>|{ "GET::/{id}": 0 }
    2017-06-09T17:01:58.1261729+05:00|INF|0HL5F5T7R11QR||IPerformanceLogger<GlobalHandlingAppLayer>|{ "GET::/favicon.ico": 4 }


.. _`ILogger<T>`: https://docs.microsoft.com/ru-ru/aspnet/core/api/microsoft.extensions.logging.ilogger-1
.. _`IPerformanceLogger<T>`: ../api/reference/InfinniPlatform.Logging.IPerformanceLogger-1.html
.. _`LoggerNameAttribute`: ../api/reference/InfinniPlatform.Logging.LoggerNameAttribute.html
.. _`format strings and properties`: https://docs.microsoft.com/en-us/dotnet/api/system.globalization.datetimeformatinfo?view=netcore-1.1
.. _`System.Environment.NewLine`: https://docs.microsoft.com/en-us/dotnet/api/system.environment.newline?view=netcore-1.1#System_Environment_NewLine
.. _`Delegation pattern`: https://en.wikipedia.org/wiki/Delegation_pattern
.. _`AOP`: https://en.wikipedia.org/wiki/Aspect-oriented_programming
.. _`Serilog`: https://serilog.net/
