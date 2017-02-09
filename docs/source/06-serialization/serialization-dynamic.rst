.. index:: DynamicWrapper

Serialization Dynamic Objects
=============================

The `JsonObjectSerializer`_ supports :doc:`dynamic objects </01-dynamic/index>`.

.. code-block:: csharp
   :emphasize-lines: 1,19

    var value = new DynamicWrapper
                {
                    { "FirstName", "John" },
                    { "LastName", "Smith" },
                    { "Birthday", new DateTime(2000, 1, 2, 3, 4, 5) }
                };

    var serializer = new JsonObjectSerializer(withFormatting: true);

    var json = serializer.ConvertToString(value);

    Console.WriteLine(json);
    //{
    //  "FirstName": "John",
    //  "LastName": "Smith",
    //  "Birthday": "2000-01-02T03:04:05"
    //}

    dynamic result = serializer.Deserialize(json);

    Console.WriteLine(result.FirstName);
    //John

    Console.WriteLine(result.LastName);
    //Smith

    Console.WriteLine(result.Birthday);
    //1/2/2000 3:04:05 AM


.. _`JsonObjectSerializer`: /api/reference/InfinniPlatform.Sdk.Serialization.JsonObjectSerializer.html
