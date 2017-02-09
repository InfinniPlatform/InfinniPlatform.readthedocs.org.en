Serialization Known Types
=========================

By default `JsonObjectSerializer`_ does not include any type information into resultant JSON. So if a serializable type contains a property with
an abstract type serialization will be successful but not deserialization. It is because `JsonObjectSerializer`_ does not have any information
about specific type of the property.

.. code-block:: csharp
   :emphasize-lines: 20,21,33,45-47

    public interface I
    {
    }


    public class A : I
    {
        public string PropertyA { get; set; }
    }


    public class B : I
    {
        public string PropertyB { get; set; }
    }


    public class C
    {
        public I Property1 { get; set; }
        public I Property2 { get; set; }
    }


    var value = new C
                {
                    Property1 = new A { PropertyA = "ValueA" },
                    Property2 = new B { PropertyB = "ValueB" }
                };

    var serializer = new JsonObjectSerializer(withFormatting: true);

    var json = serializer.ConvertToString(value);

    Console.WriteLine(json);
    //{
    //  "Property1": {
    //    "PropertyA": "ValueA"
    //  },
    //  "Property2": {
    //    "PropertyB": "ValueB"
    //  }
    //}

    serializer.Deserialize<C>(json);
    // JsonSerializationException:  Could not create an instance of type I.
    // Type is an interface or abstract class and cannot be instantiated.

To solve this problem you can use `KnownTypesContainer`_ and pass it into the `JsonObjectSerializer`_ constructor directly or via :doc:`IoC Container </02-ioc/index>`.
Known types allow to include type information into resultant JSON during serialization and rely on it during deserialization. All you need is to add
an unique alias for each type which can be use as value of a property with abstract type.

.. code-block:: csharp
   :emphasize-lines: 7-9,13,18,23,29

    var value = new C
                {
                    Property1 = new A { PropertyA = "ValueA" },
                    Property2 = new B { PropertyB = "ValueB" }
                };

    var knownTypes = new KnownTypesContainer()
        .Add<A>("A")
        .Add<B>("B");

    var serializer = new JsonObjectSerializer(withFormatting: true, knownTypes: knownTypes);

    var json = serializer.ConvertToString(value);

    Console.WriteLine(json);
    //{
    //  "Property1": {
    //    "A": {
    //      "PropertyA": "ValueA"
    //    }
    //  },
    //  "Property2": {
    //    "B": {
    //      "PropertyB": "ValueB"
    //    }
    //  }
    //}

    var result = serializer.Deserialize<C>(json);

    Console.WriteLine(((A)result.Property1).PropertyA);
    // ValueA

    Console.WriteLine(((B)result.Property2).PropertyB);
    // ValueB


.. _`JsonObjectSerializer`: /api/reference/InfinniPlatform.Sdk.Serialization.JsonObjectSerializer.html
.. _`KnownTypesContainer`: /api/reference/InfinniPlatform.Sdk.Serialization.KnownTypesContainer.html
