Job Scheduler via REST Services
===============================

There is the REST service to manage the job scheduler. By security reasons this service available only on a host where the application works.


.. http:get:: /scheduler/

    Checks whether the scheduler is started and returns the number of planned and paused jobs.

    :resheader Content-Type: application/json
    :statuscode 200: OK

.. http:get:: /scheduler/jobs

    Returns a list of jobs which is in specified state.

    :query string state: Optional. One of the two values: ``planned`` or ``paused``.
    :query int skip: Optional. By default - ``0``.
    :query int take: Optional. By default - ``10``.
    :resheader Content-Type: application/json
    :statuscode 200: OK

.. http:get:: /scheduler/jobs/(string:id)

    Returns :doc:`status </17-scheduler/scheduler-jobinfo>` of the specified job.

    :param string id: The job unique identifier.
    :resheader Content-Type: application/json
    :statuscode 200: OK

.. http:post:: /scheduler/jobs/(string:id)

    Adds or updates the specified job.

    :param string id: The job unique identifier.
    :form body: :doc:`The job info </17-scheduler/scheduler-jobinfo>`.
    :reqheader Content-Type: application/json
    :resheader Content-Type: application/json
    :statuscode 200: OK

.. http:delete:: /scheduler/jobs/(string:id)

    Deletes the specified job.

    :param int id: The job unique identifier.
    :resheader Content-Type: application/json
    :statuscode 200: OK

.. http:post:: /scheduler/pause

    Pauses the specified jobs.

    :query string ids: Optional. Job identifiers, listed by comma.
    :resheader Content-Type: application/json
    :statuscode 200: OK

.. http:post:: /scheduler/resume

    Resumes the specified jobs.

    :query string ids: Optional. Job identifiers, listed by comma.
    :resheader Content-Type: application/json
    :statuscode 200: OK

.. http:post:: /scheduler/trigger

    Invokes processing the specified jobs despite their schedule.

    :query string ids: Optional. Job identifiers, listed by comma.
    :form body: The data to job processing.
    :reqheader Content-Type: application/json
    :resheader Content-Type: application/json
    :statuscode 200: OK
