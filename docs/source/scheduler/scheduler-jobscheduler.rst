.. index:: IJobScheduler

Job Scheduler Management
========================

To manage the scheduler use the IJobScheduler_.


.. _add-or-update-job:
.. index:: IJobScheduler.AddOrUpdateJob
.. index:: IJobScheduler.AddOrUpdateJobs

Adding and Updating Jobs
------------------------

The `AddOrUpdateJob()`_ method adds or updates a :doc:`job information </scheduler/scheduler-jobinfo>`. By default added at runtime jobs are stored
in the memory of the web server so they will be lost after restarting the application. To store jobs in a persistent storage you should install an
implementation of :doc:`the document storage </document-storage/index>` or implement the IJobSchedulerRepository_ interface, then the jobs will be
scheduled even after restarting the application. To add several jobs at once use the `AddOrUpdateJobs()`_ method. Also you can add a Paused_ job and
not start planning it not immediately after the addition.


.. _delete-job:
.. index:: IJobScheduler.DeleteJob
.. index:: IJobScheduler.DeleteJobs
.. index:: IJobScheduler.DeleteAllJobs

Deleting Jobs
-------------

The `DeleteJob()`_ method deletes the specified job. After that the job will be unscheduled and removed from :ref:`the storage <persistent-job-info-source>`.
Thus you cannot resume :ref:`resume <resume-job>` the job after its the deletion. Nonetheless, jobs are declared in :doc:`the code </scheduler/scheduler-jobinfosource>`
will be stopped just until restarting the application. To delete several jobs at once use `DeleteJobs()`_ or `DeleteAllJobs()`_ methods.


.. _pause-job:
.. index:: IJobScheduler.PauseJob
.. index:: IJobScheduler.PauseJobs
.. index:: IJobScheduler.PauseAllJobs

Pausing Jobs
------------

The `PauseJob()`_ method stops scheduling the specified job. To pause several jobs at once use `PauseJobs()`_ or `PauseAllJobs()`_ methods.


.. _resume-job:
.. index:: IJobScheduler.ResumeJob
.. index:: IJobScheduler.ResumeJobs
.. index:: IJobScheduler.ResumeAllJobs

Resuming Jobs
-------------

The `ResumeJob()`_ method starts scheduling the specified job. To pause several jobs at once use `ResumeJobs()`_ or `ResumeAllJobs()`_ methods.


.. _trigger-job:
.. index:: IJobScheduler.TriggerJob
.. index:: IJobScheduler.TriggerJobs
.. index:: IJobScheduler.TriggerAllJob

Triggering Jobs
---------------

The `TriggerJob()`_ method invokes processing the specified job despite its schedule. Before triggering a job make sure it is Planned_. To trigger
several jobs at once use `TriggerJobs()`_ or `TriggerAllJob()`_ methods.


.. index:: IJobScheduler.IsStarted
.. index:: IJobScheduler.GetStatus

Getting Job Scheduler Status
----------------------------

There are two additional methods getting the scheduler status: `IsStarted()`_ and `GetStatus()`_. The `IsStarted()`_ method checks whether the scheduler
is started and returns ``true`` if it is started. The `GetStatus()`_ method allows to check status of the current jobs.

.. code-block:: csharp

    IJobScheduler jobScheduler;

    // ...

    var plannedCount = await jobScheduler.GetStatus(i => i.Count(j => j.State == JobState.Planned)); 


.. _`IJobSchedulerRepository`: ../api/reference/InfinniPlatform.Scheduler.IJobSchedulerRepository.html
.. _`IJobInfoSource`: ../api/reference/InfinniPlatform.Scheduler.IJobInfoSource.html
.. _`AddOrUpdateJob()`: ../api/reference/InfinniPlatform.Scheduler.IJobScheduler.html#InfinniPlatform_Scheduler_IJobScheduler_AddOrUpdateJob_InfinniPlatform_Scheduler_IJobInfo_
.. _`AddOrUpdateJobs()`: ../api/reference/InfinniPlatform.Scheduler.IJobScheduler.html#InfinniPlatform_Scheduler_IJobScheduler_AddOrUpdateJobs_IEnumerable_InfinniPlatform_Scheduler_IJobInfo__
.. _`DeleteJob()`: ../api/reference/InfinniPlatform.Scheduler.IJobScheduler.html#InfinniPlatform_Scheduler_IJobScheduler_DeleteJob_System_String_
.. _`DeleteJobs()`: ../api/reference/InfinniPlatform.Scheduler.IJobScheduler.html#InfinniPlatform_Scheduler_IJobScheduler_DeleteJobs_IEnumerable_System_String__
.. _`DeleteAllJobs()`: ../api/reference/InfinniPlatform.Scheduler.IJobScheduler.html#InfinniPlatform_Scheduler_IJobScheduler_DeleteAllJobs
.. _`PauseJob()`: ../api/reference/InfinniPlatform.Scheduler.IJobScheduler.html#InfinniPlatform_Scheduler_IJobScheduler_PauseJob_System_String_
.. _`PauseJobs()`: ../api/reference/InfinniPlatform.Scheduler.IJobScheduler.html#InfinniPlatform_Scheduler_IJobScheduler_PauseJobs_IEnumerable_System_String__
.. _`PauseAllJobs()`: ../api/reference/InfinniPlatform.Scheduler.IJobScheduler.html#InfinniPlatform_Scheduler_IJobScheduler_PauseAllJobs
.. _`ResumeJob()`: ../api/reference/InfinniPlatform.Scheduler.IJobScheduler.html#InfinniPlatform_Scheduler_IJobScheduler_ResumeJob_System_String_
.. _`ResumeJobs()`: ../api/reference/InfinniPlatform.Scheduler.IJobScheduler.html#InfinniPlatform_Scheduler_IJobScheduler_PauseJobs_IEnumerable_System_String__
.. _`ResumeAllJobs()`: ../api/reference/InfinniPlatform.Scheduler.IJobScheduler.html#InfinniPlatform_Scheduler_IJobScheduler_ResumeAllJobs
.. _`TriggerJob()`: ../api/reference/InfinniPlatform.Scheduler.IJobScheduler.html#InfinniPlatform_Scheduler_IJobScheduler_TriggerJob_System_String_InfinniPlatform_Dynamic_DynamicDocument_
.. _`TriggerJobs()`: ../api/reference/InfinniPlatform.Scheduler.IJobScheduler.html#InfinniPlatform_Scheduler_IJobScheduler_TriggerJobs_IEnumerable_System_String__InfinniPlatform_Dynamic_DynamicDocument_
.. _`TriggerAllJob()`: ../api/reference/InfinniPlatform.Scheduler.IJobScheduler.html#InfinniPlatform_Scheduler_IJobScheduler_TriggerAllJob_InfinniPlatform_Dynamic_DynamicDocument_
.. _`IsStarted()`: ../api/reference/InfinniPlatform.Scheduler.IJobScheduler.html#InfinniPlatform_Scheduler_IJobScheduler_IsStarted
.. _`GetStatus()`: ../api/reference/InfinniPlatform.Scheduler.IJobScheduler.html#InfinniPlatform_Scheduler_IJobScheduler_GetStatus__1_Func_IEnumerable_InfinniPlatform_Scheduler_IJobStatus____0__
.. _`Paused`: ../api/reference/InfinniPlatform.Scheduler.JobState.html
.. _`Planned`: ../api/reference/InfinniPlatform.Scheduler.JobState.html
