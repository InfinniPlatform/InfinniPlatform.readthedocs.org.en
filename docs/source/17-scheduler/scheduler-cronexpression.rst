CRON Expression
===============

Schedule of job execution is defined as `CRON <https://en.wikipedia.org/wiki/Cron>`_ style expression . ``cron`` is a classical job scheduler in UNIX
like OSes utilized to run periodical tasks. CRON expressions define schedule in calendar style. For instance, "at 8:00 each day from Monday to Friday"
or "at 13:30 each last Friday of month". CRON expressions is a powerful and simple tool which require not much of efforts to get accustomed to.


CRON Expression Syntax
----------------------

CRON expression is a single line consists of 6 or 7 parts divided by spaces. Each part is a condition for schedule and all of them get joined in
accordance by logical multiplication (AND). The scheme below shows the structure of CRON expression. Expression parts are marked with ``*`` and
lines show descriptions.

.. code-block:: bash
   :emphasize-lines: 9

    ┌───────────── Second
    │ ┌────────────── Minute
    │ │ ┌─────────────── Hour
    │ │ │ ┌──────────────── Day of month
    │ │ │ │ ┌───────────────── Month
    │ │ │ │ │ ┌───────────────── Day of week
    │ │ │ │ │ │ ┌───────────────── Year
    │ │ │ │ │ │ │
    * * * * * * *

CRON expression parts can contain any of the allowed values, along with various combinations of the allowed special characters for that part. Table
below describes allowed values and allowed special characters for each part.

.. csv-table::
   :header: "Part Name", "Mandatory", "Allowed Values", "Allowed Special Characters"

    "Second",       "Yes",  "0-59",                  "``,`` ``-`` ``*`` ``/``"
    "Minute",       "Yes",  "0-59",                  "``,`` ``-`` ``*`` ``/``"
    "Hour",         "Yes",  "0-23",                  "``,`` ``-`` ``*`` ``/``"
    "Day of Month", "Yes",  "1-31",                  "``,`` ``-`` ``*`` ``/`` ``?`` ``L`` ``W``"
    "Month",        "Yes",  "1-12 (1 - January)",    "``,`` ``-`` ``*`` ``/``"
    "Days of week", "Yes",  "1-7 (1 - Sunday)",      "``,`` ``-`` ``*`` ``/`` ``?`` ``L`` ``#``"
    "Year",         "No",   "1970-2099",             "``,`` ``-`` ``*`` ``/``"


CRON Special Characters
-----------------------

:``*``: Used to define all possible values. For example, ``*`` for *minutes* means "each minute".

:``,``: Used to enumerate values. For example, ``2,4,6`` for *week days* means "Monday, Wednesday and Friday".

:``-``: Used to define values range. For example, ``10-12`` for *hours* means "10, 11 and 12 hours".

:``/``: Used to define reiteration periods. For example, ``0/15`` for *seconds* means "0, 15, 30 и 45 seconds" while ``5/15`` means "5, 20, 35 and 50
        seconds"; ``1/3`` for *month days* means "every 3 days from 1st day of month".

:``?``: Represents lack of specific value. Using of this character is allowed in one of the two parts - *day of month* or *day of week*, but not in
        both at once. For example, to plan a job execution on 10th day of each month and each week then *day of month* is defined as ``10`` while
        *day of week* is defined as ``?``.

:``L``: Has different meaning in each of the two parts - *day of month* and *day of week*. For example, value ``L`` for *day of month* means
        "the last day of the month" (31 for January, 29 for February in leap year). The same value for *day of week* means "the last day of week" -
        ``7`` (Saturday). However if used in the *day of week* parts after another value, it means "the last defined week day of month". For example,
        ``6L`` means "the last Friday of month". You can also specify an offset from the last day of the month, such as ``L-3``. For example, ``L-3``
        for *day of month* means "before 3 days until last day of the month".

:``W``: Used to specify the weekday (Monday-Friday) nearest the given day of month. For example, ``15W`` for *day of month* means "the nearest weekday
        to the 15th of the month". For example, if 15th is Saturday, job will be executed on 14th on Friday. If 15th is Sunday, job will be executed
        on 16th on Monday. If 15th is Thursday, job will be execute on 15th on Thursday. However if value is equal ``1W`` and 1st is Saturday then job
        will be executed on 3rd on Monday, because this rule defines jobs to be executed within one month. Combination ``LW`` is allowed and means
        "last weekday day of the month".

:``#``: Used to define the **n**-th day of week in a month. For example, ``6#3`` for *day of week* means "3rd Friday of month", ``2#1`` -
        "the 1st Monday of the month", ``4#5`` - "the 5th Wednesday of the month". 


.. index:: IJobInfoBuilder

Defining CRON Expression
------------------------

CRON expression can be used when :doc:`job info </17-scheduler/index>` is created. In this case one of ``CronExpression()`` methods can be used which
is defined in ``InfinniPlatform.Scheduler.Contract.IJobInfoBuilder`` interface.

.. code-block:: csharp
   :emphasize-lines: 7,8

    IJobInfoFactory factory;

    ...

    // Job "SomeJob" will be executed daily
    // at 10:35 by SomeJobHandler handler
    factory.CreateJobInfo<SomeJobHandler>("SomeJob",
        b => b.CronExpression("0 35 10 * * ?"))

As you can see CRON expressions are simple and main principle of building expressions is quite clear. But it is quite easy to forget meaning of parts
CRON expression or some rules of building expressions. So ``CronExpression()`` method has a few overloads which uses `DSL`_ (Domain Specific Language)
concept. DSL is represented as `fluent interface`_. Next example shows recently reviewed example but with using DSL-version of ``CronExpression()``
method.

.. code-block:: csharp
   :emphasize-lines: 7,8

    IJobInfoFactory factory;

    ...

    // Job "SomeJob" will be executed daily
    // at 10:35 by SomeJobHandler handler
    factory.CreateJobInfo<SomeJobHandler>("SomeJob",
        b => b.CronExpression(e => e.AtHourAndMinuteDaily(10, 35)))


.. index:: ICronExpressionBuilder

CRON Expressions Examples
-------------------------

You can see examples of CRON expressions below: left - original CRON expression, right - lambda-expression to build the same expression with using
``InfinniPlatform.Scheduler.Contract.ICronExpressionBuilder``.

:``* * * * * ?``:
    .. code-block:: csharp

        // Each second.
        b => { }

:``0 0 12 * * ?``:
    .. code-block:: csharp

        // Daily at 12:00.
        b => b.AtHourAndMinuteDaily(12, 00)

:``0 15 10 * * ?``:
    .. code-block:: csharp

        // Daily at 10:15.
        b => b.AtHourAndMinuteDaily(10, 15)

:``0 * 14 * * ?``:
    .. code-block:: csharp

        // Daily each minute from 14:00 to 14:59.
        b => b.Hours(i => i.Each(14))
              .Minutes(i => i.Every())
              .Seconds(i => i.Each(0))

:``0 0/5 14 * * ?``:
    .. code-block:: csharp

        // Daily each 5 minute from 14:00 to 14:55.
        b => b.Hours(i => i.Each(14))
              .Minutes(i => i.Each(0, 5))
              .Seconds(i => i.Each(0))

:``0 0/5 14,18 * * ?``:
    .. code-block:: csharp

        // Daily each 5 minutes from 14:00 to 14:55 and from 18:00 to 18:55.
        b => b.Hours(i => i.EachOfSet(14, 18))
              .Minutes(i => i.Each(0, 5))
              .Seconds(i => i.Each(0))

:``0 0-5 14 * * ?``:
    .. code-block:: csharp

        // Daily each minute с 14:00 по 14:05.
        b => b.Hours(i => i.Each(14))
              .Minutes(i => i.EachOfRange(0, 5))
              .Seconds(i => i.Each(0))

:``0 10,44 14 * 3 4``:
    .. code-block:: csharp

        // Each Wednesday of March at 14:10 and 14:44.
        b => b.Hours(i => i.Each(14))
              .Minutes(i => i.EachOfSet(10, 44))
              .Seconds(i => i.Each(0))
              .Month(i => i.Each(Month.March))
              .DayOfWeek(i => i.Each(DayOfWeek.Wednesday))

:``0 15 10 * * 2-6``:
    .. code-block:: csharp

        // Each day from Monday to Friday at 10:15.
        b => b.AtHourAndMinuteDaily(10, 15)
              .DayOfWeek(i => i.EachOfRange(DayOfWeek.Monday, DayOfWeek.Friday))

:``0 15 10 15 * *``:
    .. code-block:: csharp

        // 15th each month at 10:15.
        b => b.AtHourAndMinuteDaily(10, 15)
              .DayOfMonth(i => i.Each(15))

:``0 15 10 L * *``:
    .. code-block:: csharp

        // Last day of month each month at 10:15.
        b => b.AtHourAndMinuteDaily(10, 15)
              .DayOfMonth(i => i.EachLast())

:``0 15 10 L-2 * *``:
    .. code-block:: csharp

        // Before 2 days until last day of every month at 10:15.
        b => b.AtHourAndMinuteDaily(10, 15)
              .DayOfMonth(i => i.EachLast(2))

:``0 15 10 * * 6L``:
    .. code-block:: csharp

        // Each last Friday of every month at 10:15.
        b => b.AtHourAndMinuteDaily(10, 15)
              .DayOfWeek(i => i.EachLast(DayOfWeek.Friday))

:``0 15 10 * * 6L 2016-2020``:
    .. code-block:: csharp

        // Each last Friday of every month at 10:15 from 2016 to 2020 год.
        b => b.AtHourAndMinuteDaily(10, 15)
              .DayOfWeek(i => i.EachLast(DayOfWeek.Friday))
              .Year(i => i.EachOfRange(2016, 2020))

:``0 15 10 * * 6#3``:
    .. code-block:: csharp

        // Each 3rd Friday of every month at 10:15.
        b => b.AtHourAndMinuteDaily(10, 15)
              .DayOfWeek(i => i.EachNth(DayOfWeek.Friday, 3))

:``0 0 12 1/5 * *``:
    .. code-block:: csharp

        // Each 5 days from 1st day of every month at 12:00.
        b => b.AtHourAndMinuteDaily(12, 00)
              .DayOfMonth(i => i.Each(1, 5))

:``0 11 11 11 11 *``:
    .. code-block:: csharp

        // Every 11th November at 11:11.
        b => b.AtHourAndMinuteDaily(11, 11)
              .DayOfMonth(i => i.Each(11))
              .Month(i => i.Each(Month.November))

:``0 15 10 * * 2,4,6``:
    .. code-block:: csharp

        // Each Monday, Wednesday and Friday at 10:15.
        b => b.AtHourAndMinuteOnGivenDaysOfWeek(10, 15,
                    DayOfWeek.Monday,
                    DayOfWeek.Wednesday,
                    DayOfWeek.Friday)

:``0 15 10 1,10,15 * *``:
    .. code-block:: csharp

        // 1th, 10th and 15th day at 10:15.
        b => b.AtHourAndMinuteMonthly(10, 15,
                    1, 10, 15)


.. _DSL: https://en.wikipedia.org/wiki/Domain-specific_language
.. _`fluent interface`: http://martinfowler.com/bliki/FluentInterface.html
