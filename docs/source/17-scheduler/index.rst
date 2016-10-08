Job Scheduler
=============

Some applications may require execution of jobs accordingly particular time schedule.  These tasks can be done by using **job scheduler** and installed as a separate InfinniPlatform package ``InfinniPlatform.Scheduler``.

InfinniPlatform scheduler can run jobs in accordance with specific time or period. Two key definitions of scheduler :doc:`schedule </17-scheduler/scheduler-cronexpression>` and :doc:`job handler </17-scheduler/scheduler-jobhandler>`. Those can be bound by "one to many" relation. Schedule describes a specific handler call time while the handler may be used in many schedules. This ensures the job handler's reccuring usage in different schedules.

Job hanndler's call may expose a specific :ref:`context of job processing <job-handler-context>`, which contain information about schedule, handler call time, the latest and the next call time, additionally it may contain extra data defined by developer. Processing context is specified as **job** or **job instance**. Each job processing is executed in background as a separate thread.

Планировщик InfinniPlatform job scheduler may run scheduled tasks in *claster infrustructure*. This feature is delivered by  :doc:`message queue </12-queues/index>` that guarantees processing of the job by one of the clusters nodes while computing power is equally distributed among the cluster nodes to avoid excessive the nodes' high loads.

.. toctree::

    scheduler-gettingstarted.rst
    scheduler-jobinfo.rst
    scheduler-cronexpression.rst
    scheduler-jobhandler.rst
    scheduler-jobinfosource.rst
    scheduler-jobscheduler.rst
    scheduler-settings.rst
