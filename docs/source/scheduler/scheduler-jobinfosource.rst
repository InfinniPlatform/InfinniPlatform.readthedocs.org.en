.. index:: IJobInfoSource

Job Info Source
===============

To schedule jobs you need to define the source, that is, implement the IJobInfoSource_ interface. After an application is started the scheduler gets
all :doc:`registered </ioc/container-builder>` sources and inquires them to get scheduled jobs and make initialization.


Registering Job Info Source
---------------------------

Job sources are created and managed by :doc:`IoC container </ioc/index>` so the sources must be :doc:`registered </ioc/container-builder>`:

.. code-block:: csharp

    builder.RegisterType<MyJobInfoSource>().As<IJobInfoSource>().SingleInstance();

To register all sources of an assembly use the `RegisterJobHandlers()`_ helper:

.. code-block:: csharp

    builder.RegisterJobInfoSources(assembly);


.. _persistent-job-info-source:

Persistent Job Info Source
--------------------------

The scheduler allows to add jobs and manage them at runtime using IJobScheduler_. By default added at runtime jobs are stored in the memory of the web
server so they will be lost after restarting the application. To store jobs in a persistent storage you should install an implementation of
:doc:`the document storage </document-storage/index>` or implement the IJobSchedulerRepository_ interface, then the jobs will be scheduled
even after restarting the application.


Job Info Source Example
-----------------------

To define a job info source you need to implement the IJobInfoSource_ interface.

.. code-block:: js

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


.. _`IJobInfoSource`: ../api/reference/InfinniPlatform.Scheduler.IJobInfoSource.html
.. _`IJobScheduler`: ../api/reference/InfinniPlatform.Scheduler.IJobScheduler.html
.. _`IJobSchedulerRepository`: ../api/reference/InfinniPlatform.Scheduler.IJobSchedulerRepository.html
