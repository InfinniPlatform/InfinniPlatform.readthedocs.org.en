.. index:: Date
.. index:: Time

Serialization Dates and Times
=============================

The problem comes from the JSON spec itself: there is no literal syntax for dates in JSON. The spec has objects, arrays, strings, integers, and floats,
but it defines no standard for what a date looks like. The default format used by ``JsonObjectSerializer`` is the `ISO 8601`_ standard.

.. code-block:: csharp
   :emphasize-lines: 5,16

    var value = new Person
                {
                    FirstName = "John",
                    LastName = "Smith",
                    Birthday = new DateTime(2000, 1, 2, 3, 4, 5) // It will be serialized as ISO 8601
                };

    var serializer = new JsonObjectSerializer(withFormatting: true);

    var json = serializer.ConvertToString(value);

    Console.WriteLine(json);
    //{
    //  "FirstName": "John",
    //  "LastName": "Smith",
    //  "Birthday": "2000-01-02T03:04:05"
    //}

But sometimes we need to work only with either date part or time part. For these goals there are two special types: ``InfinniPlatform.Sdk.Types.Date``
and ``InfinniPlatform.Sdk.Types.Time``. The ``JsonObjectSerializer`` supports these types and serializes them using next rules.

* ``Date`` is serialized as a `64-bit signed integer`_ which is the Unix time, defined as the number of seconds that have elapsed since 00:00:00 (UTC), 1 January 1970.
* ``Time`` is serialized as a `double-precision floating-point number`_ which is the number of seconds that have elapsed since 00:00:00.

.. code-block:: csharp
   :emphasize-lines: 5,6,13,14,25,26

    public class Person
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public Date BirthDay { get; set; }
        public Time BirthTime { get; set; }
    }

    var value = new Person
                {
                    FirstName = "John",
                    LastName = "Smith",
                    BirthDay = new Date(2000, 1, 2),
                    BirthTime = new Time(3, 4, 5)
                };

    var serializer = new JsonObjectSerializer(withFormatting: true);

    var json = serializer.ConvertToString(value);

    Console.WriteLine(json);
    //{
    //  "FirstName": "John",
    //  "LastName": "Smith",
    //  "BirthDay": 946771200,
    //  "BirthTime": 11045.0
    //}

.. _`ISO 8601`: https://en.wikipedia.org/wiki/ISO_8601
.. _`Unix time`: https://en.wikipedia.org/wiki/Unix_time
.. _`64-bit signed integer`: https://msdn.microsoft.com/en-US/library/system.int64(v=vs.110).aspx
.. _`double-precision floating-point number`: https://msdn.microsoft.com/en-US/library/system.double(v=vs.110).aspx
