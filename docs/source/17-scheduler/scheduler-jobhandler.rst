.. index:: IJobHandler

Job Handler
===========

Each schedule must relate to an implementation of the IJobHandler_ interface. As a result the handler will be invoked according to its schedule.

.. note:: A job handler must analyze all possible situation. For example, when the handler was invoked but previous handling has not finished yet;
          there are misfire tasks because the application was stopped for a while; the handler was invoked early than it was planned; the handler was
          not invoked at the exact time, and so forth.


Registering Job Handlers
------------------------

Job handlers are created and managed by :doc:`IoC container </02-ioc/index>` so the handlers must be :doc:`registered </02-ioc/container-builder>`:

.. code-block:: csharp

    builder.RegisterType<MyJobHandler>().AsSelf().As<IJobHandler>().SingleInstance();

To register all handlers of an assembly use the `RegisterJobHandlers()`_ helper:

.. code-block:: csharp

    builder.RegisterJobHandlers(assembly);


.. _job-handler-context:
.. index:: IJobHandlerContext

Job Handler Context
-------------------

When a job handler is invoked it gets an information to process task. This information is called the job handler context and presented as
the IJobHandlerContext_ interface. The IJobHandlerContext_ interface has next properties.

:InstanceId_:           The unique job instance identifier. Formed automatically with using IJobInfo_. Each instance is handled only once by some cluster node.

:FireTimeUtc_:          The actual time the trigger fired. For instance the scheduled time may have been ``10:00:00`` but the actual fire time may have been ``10:00:03`` if the scheduler was too busy.

:ScheduledFireTimeUtc_: The scheduled time the trigger fired for. For instance the scheduled time may have been ``10:00:00`` but the actual fire time may have been ``10:00:03`` if the scheduler was too busy.

:PreviousFireTimeUtc_:  Gets the previous fire time or ``null`` if the handler was invoked the first time.

:NextFireTimeUtc_:      Gets the next fire time ot ``null`` if the handler will not be invoked anymore.

:Data_:                 The job data which is defined by :doc:`the job info </17-scheduler/index>`.


Job Handler Example
-------------------

To define a job handler you need to implement the IJobHandler_ interface.

.. code-block:: csharp

    class MyJobHandler : IJobHandler
    {
        public async Task Handle(IJobInfo jobInfo, IJobHandlerContext context)
        {
            await Console.Out.WriteLineAsync($"Greetings from {nameof(MyJobHandler)}!");
        }
    }


.. _`IJobInfo`: ../api/reference/InfinniPlatform.Scheduler.IJobInfo.html
.. _`IJobHandler`: ../api/reference/InfinniPlatform.Scheduler.IJobHandler.html
.. _`RegisterJobHandlers()`: ../api/reference/InfinniPlatform.Scheduler.SchedulerExtensions.html#InfinniPlatform_Scheduler_SchedulerExtensions_RegisterJobHandlers_InfinniPlatform_IoC_IContainerBuilder_Assembly_
.. _`IJobHandlerContext`: /api/reference/InfinniPlatform.Scheduler.IJobHandlerContext.html

.. _`InstanceId`: ../api/reference/InfinniPlatform.Scheduler.IJobHandlerContext.html#InfinniPlatform_Scheduler_IJobHandlerContext_InstanceId
.. _`FireTimeUtc`: ../api/reference/InfinniPlatform.Scheduler.IJobHandlerContext.html#InfinniPlatform_Scheduler_IJobHandlerContext_FireTimeUtc
.. _`ScheduledFireTimeUtc`: ../api/reference/InfinniPlatform.Scheduler.IJobHandlerContext.html#InfinniPlatform_Scheduler_IJobHandlerContext_ScheduledFireTimeUtc
.. _`PreviousFireTimeUtc`: ../api/reference/InfinniPlatform.Scheduler.IJobHandlerContext.html#InfinniPlatform_Scheduler_IJobHandlerContext_PreviousFireTimeUtc
.. _`NextFireTimeUtc`: ../api/reference/InfinniPlatform.Scheduler.IJobHandlerContext.html#InfinniPlatform_Scheduler_IJobHandlerContext_NextFireTimeUtc
.. _`Data`: ../api/reference/InfinniPlatform.Scheduler.IJobHandlerContext.html#InfinniPlatform_Scheduler_IJobHandlerContext_Data
