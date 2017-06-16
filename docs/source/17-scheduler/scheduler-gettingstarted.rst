Getting Started with Job Scheduler
==================================

This is a brief manual to get started with the InfinniPlatform job scheduler.

**1.** Install ``InfinniPlatform.Scheduler.Quartz`` package:

.. code-block:: bash

    dotnet add package InfinniPlatform.Scheduler.Quartz -s https://www.myget.org/F/infinniplatform/

**2.** Call `AddQuartzScheduler()`_ in ``ConfigureServices()``:

.. code-block:: csharp
   :emphasize-lines: 11

    using System;

    using InfinniPlatform.AspNetCore;

    using Microsoft.Extensions.DependencyInjection;

    public class Startup
    {
        public IServiceProvider ConfigureServices(IServiceCollection services)
        {
            services.AddQuartzScheduler();

            // ...

            return services.BuildProvider();
        }

        // ...
    }

**3.** Create MyJobHandler.cs and define :doc:`job handler </17-scheduler/scheduler-jobhandler>`:

.. code-block:: csharp
   :caption: MyJobHandler.cs

    class MyJobHandler : IJobHandler
    {
        public async Task Handle(IJobInfo jobInfo, IJobHandlerContext context)
        {
            await Console.Out.WriteLineAsync($"Greetings from {nameof(MyJobHandler)}!");
        }
    }

**4.** Create MyJobInfoSource.cs and define :doc:`job info source </17-scheduler/scheduler-jobinfosource>`:

.. code-block:: js
   :caption: MyJobInfoSource.cs

    class MyJobInfoSource : IJobInfoSource
    {
        public Task<IEnumerable<IJobInfo>> GetJobs(IJobInfoFactory factory)
        {
            var jobs = new[]
                       {
                           // Job will be handled every 5 seconds
                           factory.CreateJobInfo<MyJobHandler>("MyJob",
                               b => b.CronExpression(e => e.Seconds(i => i.Each(0, 5))))
                       };

            return Task.FromResult<IEnumerable<IJobInfo>>(jobs);
        }
    }

**5.** :doc:`Register in IoC-container </02-ioc/container-builder>` the job handler and the job source:

.. code-block:: csharp

    builder.RegisterType<MyJobHandler>().AsSelf().As<IJobHandler>().SingleInstance();
    builder.RegisterType<MyJobInfoSource>().As<IJobInfoSource>().SingleInstance();


.. _`AddQuartzScheduler()`: ../api/reference/InfinniPlatform.AspNetCore.QuartzSchedulerExtensions.html#InfinniPlatform_AspNetCore_QuartzSchedulerExtensions_AddQuartzScheduler_IServiceCollection_
