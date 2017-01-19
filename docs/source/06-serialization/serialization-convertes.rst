Serialization Convertes
=======================

In some cases JSON view of an object must have a little different representation than it is described in the object type. The differences can be
related to the data schema or the data type of certain fields or properties. There are many reasons for that. For example to store data in a database
or to transfer data by network it is more convenient to use different representation than it is described in the data type. Also perhaps you cannot
change a data type because of using an external library or you have to use different format because of communicating with an external system.

Serialization Convertes provide a way to customize how an object will be serialised and deserialized. For that you need to implement the interface
``InfinniPlatform.Sdk.Serialization.IMemberValueConverter`` and pass it into the ``JsonObjectSerializer`` constructor directly or via
:doc:`IoC Container </02-ioc/index>`.

.. note:: The ``XmlDateMemberValueConverter`` implements ``IMemberValueConverter`` for ``DateTime`` members which have `XmlElementAttribute`_
          with ``DataType`` property equals ``date``. In this case we have to use only the date part of ``DateTime`` value (without the time part).
          The ``XmlDateMemberValueConverter`` handles these cases and converts ``DateTime`` value to ``InfinniPlatform.Sdk.Types.Date`` which can be
          serialised as the Unix time. It can be useful during integration with SOAP services.

The ``IMemberValueConverter`` has three methods:

* ``CanConvert()`` - Checks whether this converter can be applied to specified member.
* ``Convert()`` - Converts an original member value to new format during serialization.
* ``ConvertBack()`` - Converts an original member value back from new format during deserialization.

Next example converts all ``DateTime`` members to the Unix time during serialization and then converts them back to ``DateTime`` during deserialization.

.. code-block:: csharp
   :emphasize-lines: 1,7,16,30,60,63-66,68,76,82

    public class UnixDateTimeConverter : IMemberValueConverter
    {
        private static readonly DateTime UnixTimeZero
            = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);


        public bool CanConvert(MemberInfo member)
        {
            var property = member as PropertyInfo;

            return (property != null)
                && (property.PropertyType == typeof(DateTime)
                    || property.PropertyType == typeof(DateTime?));
        }

        public object Convert(object value)
        {
            var date = value as DateTime?;

            if (date != null)
            {
                var unixTime = (long)date.Value.Subtract(UnixTimeZero).TotalSeconds;

                return unixTime;
            }

            return null;
        }

        public object ConvertBack(Func<Type, object> value)
        {
            var unixTime = (long?)value(typeof(long?));

            if (unixTime != null)
            {
                var date = UnixTimeZero.AddSeconds(unixTime.Value);

                return date;
            }

            return null;
        }
    }


    public class Person
    {
        public string FirstName { get; set; }

        public string LastName { get; set; }

        public DateTime Birthday { get; set; }
    }


    var value = new Person
                {
                    FirstName = "John",
                    LastName = "Smith",
                    Birthday = new DateTime(2000, 1, 1)
                };

    var valueConverters = new IMemberValueConverter[]
                        {
                            new UnixDateTimeConverter()
                        };

    var serializer = new JsonObjectSerializer(withFormatting: true, valueConverters: valueConverters);

    var json = serializer.ConvertToString(value);

    Console.WriteLine(json);
    //{
    //  "FirstName": "John",
    //  "LastName": "Smith",
    //  "Birthday": 946684800
    //}

    var result = serializer.Deserialize<Person>(json);

    Console.WriteLine("{0:yyyy/MM/dd}", result.Birthday);
    // 2000/01/01


.. _`XmlElementAttribute`: https://msdn.microsoft.com/en-US/library/system.xml.serialization.xmlelementattribute(v=vs.110).aspx
