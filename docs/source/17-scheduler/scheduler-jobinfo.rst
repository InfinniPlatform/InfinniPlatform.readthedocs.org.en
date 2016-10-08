.. index:: IJobInfo 

Job Info
========

To plan a job task one should refer to information about job handler and handler call time. ``InfinniPlatform.Scheduler.Contract.IJobInfo`` interface defines a structure about task information.

Job Info Properties
-------------------

* ``Id`` is an unique job idenificator. Mandatory attribute. Formed automatically and represents joint properties for ``Group`` and ``Name``, divided by ``.`` symbol. Used to form an :ref:` unique job id instance <job-handler-context>` during the call of  :doc:`handler </17-scheduler/scheduler-jobhandler>`.

* ``Group``. Job set name. Mandatory attribute. Used to form an unique job ``Id`` and may logically group jobs. If a group is defined then``Default`` attribute is used.

* ``Name``. Job name. Mandatory attribute. Used to form an unique job ``Id``, must be unique in ``Group``. No default value.

* ``State``. Job execution state. Mandatory attribute. By default the job is always planned to be executed - ``JobState.Planned`` however one can define job in paused state - ``JobState.Paused`` to further resume it by a trigger or  :ref:`request <resume-job>`.

* ``MisfirePolicy``. Misfire job policy. Mandatory attribute. By default all misfired jobs are ignored - ``JobMisfirePolicy.DoNothing`` however planner can execute all jobs right away and can further proceed in accordance with schedule - ``JobMisfirePolicy.FireAndProceed``.

* ``HandlerType``. Job handler type. Mandatory attribute. Job handler full name including a names set and container app name in which hanlder is declared. Used to call the handler.

* ``Description``. Job description. Optional attribute. For example, detailed job logic description. Anything that can be needed for understanding of proceedings.

* ``StartTimeUtc``. Start time job planning (UTC). Optional attribute. Planned immediately to be executed as put in the queue otherwise from the defined time. Start time should not exceed end time ``EndTimeUtc``.

* ``EndTimeUtc``. End time job planning (UTC). Optional attribute. Planned immediately until the end of app execution otherwise till the defined time. End time should be less than its start time ``StartTimeUtc``.

* ``CronExpression``. Job handler schedule in :doc:`CRON </17-scheduler/scheduler-cronexpression>` style.
  Optional attribute. Defines schedule in calendar type. First call time coincides with start time ``StartTimeUtc``.

* ``Data``. Job data. Optional attribute. Value of this attribute is available in
  :ref:`job data context <job-handler-context>`. Value of this attribute must be :doc:`serializable </06-serialization/index>`.

.. note:: Job planner considers values of all attributes merging all contitions by logical multiplication (AND).


.. index:: IJobInfoFactory

Creating Job Info
-----------------

To create info about job the floowing factory is used ``InfinniPlatform.Scheduler.Contract.IJobInfoFactory``,
offering a few reloads of method ``CreateJobInfo()``. Method signature ``CreateJobInfo()`` uses  `DSL`_ (Domain Specific Language - object-oriented language) concept also known as `fluent interface`_.

.. code-block:: csharp
   :emphasize-lines: 7,8

    IJobInfoFactory factory;

    ...

    // Job name "SomeJob" will be executed daily
    // at 10:35 by job handler SomeJobHandler
    factory.CreateJobInfo<SomeJobHandler>("SomeJob",
        b => b.CronExpression(e => e.AtHourAndMinuteDaily(10, 35)))


.. _DSL: https://en.wikipedia.org/wiki/Domain-specific_language
.. _`fluent interface`: http://martinfowler.com/bliki/FluentInterface.html
