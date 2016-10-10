.. index:: IJobInfo 

Job Info
========

To plan a job one should create an information which includes at least handler type and its call time. ``InfinniPlatform.Scheduler.Contract.IJobInfo``
interface defines a structure about job information.

Job Info Properties
-------------------

* ``Id`` is an unique job identifier. Required attribute. Formed automatically and represents joint properties for ``Group`` and ``Name``, divided by
  ``.`` symbol. Used to form an :ref:`unique identifier of job instance <job-handler-context>` during the call of
  :doc:`handler </17-scheduler/scheduler-jobhandler>`.

* ``Group``. Job group name. Required attribute. Used to form an unique job ``Id`` and may logically group jobs. If a group is not defined then
  ``Default`` is used.

* ``Name``. Job name. Required attribute. Used to form an unique job ``Id``, must be unique in ``Group``. No default value.

* ``State``. Job execution state. Required attribute. By default the job is always planned to be executed - ``JobState.Planned`` however one can define
  job in paused state - ``JobState.Paused`` to further resume it by a trigger or :ref:`request <resume-job>`.

* ``MisfirePolicy``. Misfire job policy. Required attribute. By default all misfired jobs are ignored - ``JobMisfirePolicy.DoNothing`` however scheduler
  can execute all jobs right away and can further proceed in accordance with schedule - ``JobMisfirePolicy.FireAndProceed``.

* ``HandlerType``. Job handler type. Required attribute. Job handler full name including a namespace and assembly name in which handler is declared.
  Used to invoke the handler.

* ``Description``. Job description. Optional attribute. For example, detailed job logic description. Anything that can be needed for understanding of
  proceedings.

* ``StartTimeUtc``. Start time job planning (UTC). Optional attribute. Planned immediately to be executed as put in the scheduler otherwise from the
  defined time. Start time should not exceed end time ``EndTimeUtc``.

* ``EndTimeUtc``. End time job planning (UTC). Optional attribute. Planned immediately until the end of app execution otherwise till the defined time.
  End time should be less than its start time ``StartTimeUtc``.

* ``CronExpression``. Job handler schedule in :doc:`CRON </17-scheduler/scheduler-cronexpression>` style. Optional attribute. Defines schedule in
  calendar style. If it is not defined a first fire time coincides with start time ``StartTimeUtc``.

* ``Data``. Job data. Optional attribute. Value of this attribute is available in :ref:`job data context <job-handler-context>`. Value of this
  attribute must be :doc:`serializable </06-serialization/index>`.

.. note:: Job scheduler considers values of all attributes merging all conditions by logical multiplication (AND).


.. index:: IJobInfoFactory

Creating Job Info
-----------------

To create information about job the following factory is used ``InfinniPlatform.Scheduler.Contract.IJobInfoFactory``, offering a few overloads of method
``CreateJobInfo()``. Method signature ``CreateJobInfo()`` uses  `DSL`_ (Domain Specific Language) which is represented as `fluent interface`_.

.. code-block:: csharp
   :emphasize-lines: 7,8

    IJobInfoFactory factory;

    ...

    // Job "SomeJob" will be executed daily
    // at 10:35 by job handler SomeJobHandler
    factory.CreateJobInfo<SomeJobHandler>("SomeJob",
        b => b.CronExpression(e => e.AtHourAndMinuteDaily(10, 35)))


.. _DSL: https://en.wikipedia.org/wiki/Domain-specific_language
.. _`fluent interface`: http://martinfowler.com/bliki/FluentInterface.html
