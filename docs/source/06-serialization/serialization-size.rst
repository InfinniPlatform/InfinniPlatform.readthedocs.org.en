Reducing Serialized JSON Size
=============================

One of the common problems encountered when serializing .NET objects to JSON is that the JSON ends up containing a lot of unwanted properties and values.
This can be especially significant when returning JSON to the client. More JSON means more bandwidth and a lower performance. To solve the issue of
unwanted JSON, InfinniPlatform has a range of built-in options to fine-tune what gets written from a serialized object.

By default public fields and properties are included to serialization. Adding the `NonSerializedAttribute`_ to a property tells the serializer to
always skip writing it to the JSON result.

.. code-block:: csharp
   :emphasize-lines: 9

    public class Person
    {
        // Included in JSON
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public DateTime Birthday { get; set; }

        // Ignored
        [NonSerialized]
        public int Age { get; set; }
    }

If a class has many properties and you only want to serialize a small subset of them, then adding `NonSerializedAttribute`_ to all the others will be
tedious and error prone. The way to solve this scenario is to add the `DataContractAttribute`_ to the class and `DataMemberAttribute`_ to the properties
to serialize. Only the properties you mark up will be serialized.

.. code-block:: csharp
   :emphasize-lines: 1,5,7,9

    [DataContract]
    public class Person
    {
        // Included in JSON
        [DataMember]
        public string FirstName { get; set; }
        [DataMember]
        public string LastName { get; set; }
        [DataMember]
        public DateTime Birthday { get; set; }

        // Ignored
        public int Age { get; set; }
    }

Also you can change property names and make them shorter using :ref:`SerializerPropertyNameAttribute <serializerpropertynameattribute-ref>` (but it can
influence on readability your JSON).

.. code-block:: csharp
   :emphasize-lines: 3,5,7

    public class Person
    {
        [SerializerPropertyName("fn")]
        public string FirstName { get; set; }
        [SerializerPropertyName("ln")]
        public string LastName { get; set; }
        [SerializerPropertyName("bd")]
        public DateTime Birthday { get; set; }
    }

The ``JsonObjectSerializer`` allows to format JSON which is easy-to-read. It is great for readability when you are developing. Disabling formatting on
the other hand keeps the JSON result small, skipping all unnecessary spaces and line breaks to produce the most compact and efficient JSON possible.

.. code-block:: csharp
   :emphasize-lines: 7,17

    var value = new Person
                {
                    FirstName = "John",
                    LastName = "Smith"
                };

    var serializer = new JsonObjectSerializer(withFormatting: true);

    var json = serializer.ConvertToString(value);

    Console.WriteLine(json);
    //{
    //  "FirstName": "John",
    //  "LastName": "Smith"
    //}

    serializer = new JsonObjectSerializer(withFormatting: false);

    json = serializer.ConvertToString(value);

    Console.WriteLine(json);
    //{"FirstName":"John","LastName":"Smith"}

For more complex cases you can use :doc:`serialization converters </06-serialization/serialization-converters>` which provide a way to customize how
an object will be serialized and deserialized, including changing serialization behavior at runtime.


.. _`NonSerializedAttribute`: https://docs.microsoft.com/en-us/dotnet/api/system.nonserializedattribute?view=netcore-1.1
.. _`DataContractAttribute`: https://docs.microsoft.com/en-us/dotnet/api/system.runtime.serialization.datacontractattribute?view=netcore-1.1
.. _`DataMemberAttribute`: https://docs.microsoft.com/en-us/dotnet/api/system.runtime.serialization.datamemberattribute?view=netcore-1.1
