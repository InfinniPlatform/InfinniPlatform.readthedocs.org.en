Serialization Error Handling
============================

InfinniPlatform supports error handling during serialization and deserialization. Error handling lets you catch an error and choose whether to handle
it and continue with serialization or let the error bubble up and be thrown in your application.

To handle serialization errors you need to implement the interface ``InfinniPlatform.Sdk.Serialization.ISerializerErrorHandler`` and pass it into
the ``JsonObjectSerializer`` constructor directly or via :doc:`IoC Container </02-ioc/index>`. The ``ISerializerErrorHandler`` has the only one method
``Handle()``. It is called whenever an exception is thrown while serializing or deserializing JSON.

.. note:: The ``IgnoreSerializerErrorHandler`` implements ``ISerializerErrorHandler`` and ignores all exceptions. This handler allows to skip
          properties whose getters and setters can throw exceptions.

Next example ignores all exceptions during serialization and deserialization.

.. code-block:: csharp
   :emphasize-lines: 1,3,5,20,32-35,37,43

    public class IgnoreSerializerErrorHandler : ISerializerErrorHandler
    {
        public bool Handle(object target, object member, Exception error)
        {
            return true;
        }
    }


    public class BadGetter
    {
        public string Property1
        {
            get;
            set;
        }

        public string Property2
        {
            get { throw new Exception(); }
            set { }
        }
    }


    var value = new BadGetter
                {
                    Property1 = "Value1",
                    Property2 = "Value2"
                };

    var errorHandlers = new ISerializerErrorHandler[]
                        {
                            new IgnoreSerializerErrorHandler()
                        };

    var serializer = new JsonObjectSerializer(withFormatting: true, errorHandlers: errorHandlers);

    var json = serializer.ConvertToString(value);

    Console.WriteLine(json);
    //{
    //  "Property1": "Value1"
    //}
