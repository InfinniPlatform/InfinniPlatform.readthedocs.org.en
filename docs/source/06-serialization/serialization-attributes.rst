Serialization Attributes
========================

Attributes can be used to control how ``JsonObjectSerializer`` serializes and deserializes .NET objects.


.. index:: NonSerializedAttribute

NonSerializedAttribute
----------------------

The `NonSerializedAttribute`_ excludes a field or property from serialization. By default public fields and properties are included to serialization.
Standard .NET serialization attribute `NonSerializedAttribute`_ allows to exclude specific properties from a resultant JSON. Usually it is useful to
exclude properties which can be calculated from other fields.

.. code-block:: csharp
   :emphasize-lines: 9

    public class Person
    {
        public string FirstName { get; set; }

        public string LastName { get; set; }

        public DateTime Birthday { get; set; }

        [NonSerialized]
        public int Age { get; set; }
    }


.. index:: SerializerVisibleAttribute

SerializerVisibleAttribute
--------------------------

The ``SerializerVisibleAttribute`` includes a field or property to serialization. By default non-public fields and properties as well as properties
with non-public setters (or without them) are excluded from serialization. This attribute is the opposite `NonSerializedAttribute`.

.. code-block:: csharp
   :emphasize-lines: 3,6

    public class Document
    {
        [SerializerVisible]
        public object _id { get; internal set; }

        [SerializerVisible]
        public DocumentHeader _header { get; internal set; }
    }


.. index:: SerializerPropertyNameAttribute

SerializerPropertyNameAttribute
-------------------------------

The ``SerializerPropertyNameAttribute`` sets specified property name while serialization. By default, the JSON property will have the same name as
the .NET property. This attribute allows the name to be customized.

.. code-block:: csharp
   :emphasize-lines: 3,6

    public class Person
    {
        [SerializerPropertyName("forename")]
        public string FirstName { get; set; }

        [SerializerPropertyName("surname")]
        public string LastName { get; set; }
    }


.. _`NonSerializedAttribute`: https://msdn.microsoft.com/en-US/library/system.nonserializedattribute(v=vs.110).aspx
