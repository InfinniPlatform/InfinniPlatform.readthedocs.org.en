.. index:: IJobInfo 

Job Info
========

To plan a job one should create an information which includes at least handler type and its call time. The IJobInfo_ interface has next properties.


Job Info Properties
-------------------

:Id_:             Unique job identifier. Required attribute. Formed automatically and represents joint properties for Group_ and Name_, divided by
                  ``.`` symbol. Used to form an :ref:`unique identifier of job instance <job-handler-context>` during the call of
                  :doc:`handler </scheduler/scheduler-jobhandler>`.

:Group_:          Job group name. Required attribute. Used to form an unique job Id_ and may logically group jobs. If a group is not defined then
                  ``Default`` is used.

:Name_:           Job name. Required attribute. Used to form an unique job Id_, must be unique in Group_. No default value.

:State_:          Job execution state. Required attribute. By default the job is always planned to be executed - Planned_ however one can define job
                  in paused state - Paused_ to further resume it by a trigger or :ref:`request <resume-job>`.

:MisfirePolicy_:  Misfire job policy. Required attribute. By default all misfired jobs are ignored - DoNothing_ however scheduler can execute all jobs
                  right away and can further proceed in accordance with schedule - FireAndProceed_.

:HandlerType_:    Job handler type. Required attribute. Job handler full name including a namespace and assembly name in which handler is declared.
                  Used to invoke the handler.

:Description_:    Job description. Optional attribute. For example, detailed job logic description. Anything that can be needed for understanding of
                  proceedings.

:StartTimeUtc_:   Start time job planning (UTC). Optional attribute. Planned immediately to be executed as put in the scheduler otherwise from the
                  defined time. Start time should not exceed end time EndTimeUtc_.

:EndTimeUtc_:     End time job planning (UTC). Optional attribute. Planned immediately until the end of app execution otherwise till the defined time.
                  End time should be less than its start time StartTimeUtc_.

:CronExpression_: Job handler schedule in :doc:`CRON </scheduler/scheduler-cronexpression>` style. Optional attribute. Defines schedule in calendar
                  style. If it is not defined a first fire time coincides with start time StartTimeUtc_.

:Data_:           Job data. Optional attribute. Value of this attribute is available in :ref:`job data context <job-handler-context>`. Value of this
                  attribute must be :doc:`serializable </serialization/index>`.

.. note:: Job scheduler considers values of all attributes merging all conditions by logical conjunction.


.. index:: IJobInfoFactory

Creating Job Info
-----------------

To create information about job the following factory is used IJobInfoFactory_, offering a few overloads of method `CreateJobInfo()`_.
Method signature `CreateJobInfo()`_ uses  `DSL`_ (Domain Specific Language) which is represented as `fluent interface`_.

.. code-block:: csharp
   :emphasize-lines: 7,8

    IJobInfoFactory factory;

    ...

    // Job "MyJob" will be executed daily
    // at 10:35 by job handler MyJobHandler
    factory.CreateJobInfo<MyJobHandler>("MyJob",
        b => b.CronExpression(e => e.AtHourAndMinuteDaily(10, 35)))


.. _DSL: https://en.wikipedia.org/wiki/Domain-specific_language
.. _`fluent interface`: http://martinfowler.com/bliki/FluentInterface.html

.. _`IJobInfo`: ../api/reference/InfinniPlatform.Scheduler.IJobInfo.html
.. _`Id`: ../api/reference/InfinniPlatform.Scheduler.IJobInfo.html#InfinniPlatform_Scheduler_IJobInfo_Id
.. _`Name`: ../api/reference/InfinniPlatform.Scheduler.IJobInfo.html#InfinniPlatform_Scheduler_IJobInfo_Name
.. _`Group`: ../api/reference/InfinniPlatform.Scheduler.IJobInfo.html#InfinniPlatform_Scheduler_IJobInfo_Group
.. _`State`: ../api/reference/InfinniPlatform.Scheduler.IJobInfo.html#InfinniPlatform_Scheduler_IJobInfo_State
.. _`MisfirePolicy`: ../api/reference/InfinniPlatform.Scheduler.IJobInfo.html#InfinniPlatform_Scheduler_IJobInfo_MisfirePolicy
.. _`HandlerType`: ../api/reference/InfinniPlatform.Scheduler.IJobInfo.html#InfinniPlatform_Scheduler_IJobInfo_HandlerType
.. _`Description`: ../api/reference/InfinniPlatform.Scheduler.IJobInfo.html#InfinniPlatform_Scheduler_IJobInfo_Description
.. _`StartTimeUtc`: ../api/reference/InfinniPlatform.Scheduler.IJobInfo.html#InfinniPlatform_Scheduler_IJobInfo_StartTimeUtc
.. _`EndTimeUtc`: ../api/reference/InfinniPlatform.Scheduler.IJobInfo.html#InfinniPlatform_Scheduler_IJobInfo_EndTimeUtc
.. _`CronExpression`: ../api/reference/InfinniPlatform.Scheduler.IJobInfo.html#InfinniPlatform_Scheduler_IJobInfo_CronExpression
.. _`Data`: ../api/reference/InfinniPlatform.Scheduler.IJobInfo.html#InfinniPlatform_Scheduler_IJobInfo_Data
.. _`JobState`: ../api/reference/InfinniPlatform.Scheduler.JobState.html
.. _`Planned`: ../api/reference/InfinniPlatform.Scheduler.JobState.html
.. _`Paused`: ../api/reference/InfinniPlatform.Scheduler.JobState.html
.. _`JobMisfirePolicy`: ../api/reference/InfinniPlatform.Scheduler.JobMisfirePolicy.html
.. _`DoNothing`: ../api/reference/InfinniPlatform.Scheduler.JobMisfirePolicy.html
.. _`FireAndProceed`: ../api/reference/InfinniPlatform.Scheduler.JobMisfirePolicy.html
.. _`IJobInfoFactory`: ../api/reference/InfinniPlatform.Scheduler.IJobInfoFactory.html
.. _`CreateJobInfo()`: ../api/reference/InfinniPlatform.Scheduler.IJobInfoFactory.html#InfinniPlatform_Scheduler_IJobInfoFactory_CreateJobInfo_Type_System_String_System_String_Action_InfinniPlatform_Scheduler_IJobInfoBuilder__
