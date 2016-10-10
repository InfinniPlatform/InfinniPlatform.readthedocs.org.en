Getting Started with Job Scheduler
==================================

This is a brief manual to get started with the InfinniPlatform job scheduler.

Installing Job Scheduler
------------------------

InfinniPlatform job scheduler is a NuGet-package ``InfinniPlatform.Scheduler`` which you may install by running a command in `Package Manager Console`_.

.. code-block:: bash

    PM> Install-Package InfinniPlatform.Scheduler -Pre


Job Handling Example
--------------------

Add to the project a file ``SomeJobHandler.cs`` for defining :doc:`job handler </17-scheduler/scheduler-jobhandler>`.

.. code-block:: js
   :caption: SomeJobHandler.cs
   :emphasize-lines: 6,8

    using System;
    using System.Threading.Tasks;

    using InfinniPlatform.Scheduler.Contract;

    public class SomeJobHandler : IJobHandler
    {
        public async Task Handle(IJobInfo jobInfo, IJobHandlerContext context)
        {
            await Console.Out.WriteLineAsync($"Greetings from {nameof(SomeJobHandler)}!");
        }
    }

Add to the project a file ``SomeJobInfoSource.cs`` for defining :doc:`job info source </17-scheduler/scheduler-jobinfosource>`.

.. code-block:: js
   :caption: SomeJobInfoSource.cs
   :emphasize-lines: 6,8,13,14

    using System.Collections.Generic;
    using System.Threading.Tasks;

    using InfinniPlatform.Scheduler.Contract;

    public class SomeJobInfoSource : IJobInfoSource
    {
        public Task<IEnumerable<IJobInfo>> GetJobs(IJobInfoFactory factory)
        {
            var jobs = new[]
                       {
                           // Job will be handled every 5 seconds
                           factory.CreateJobInfo<SomeJobHandler>("SomeJob",
                               b => b.CronExpression(e => e.Seconds(i => i.Each(0, 5))))
                       };

            return Task.FromResult<IEnumerable<IJobInfo>>(jobs);
        }
    }

:doc:`Register in IoC-container </02-ioc/container-builder>` job handlers and job sources.

.. code-block:: js
   :caption: ContainerModule.cs
   :emphasize-lines: 10,11

    using InfinniPlatform.Scheduler.Contract;
    using InfinniPlatform.Sdk.IoC;

    public class ContainerModule : IContainerModule
    {
        public void Load(IContainerBuilder builder)
        {
            var assembly = typeof(ContainerModule).Assembly;

            builder.RegisterJobHandlers(assembly);
            builder.RegisterJobInfoSources(assembly);

            // Other dependencies...
        }
    }


.. _`Package Manager Console`: http://docs.nuget.org/consume/package-manager-console
