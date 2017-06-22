Data Serialization
==================

Data Serialization is one of the main parts when we talk about transferring data via network. InfinniPlatfrom provides necessary instruments to
serialize and deserialize data using JSON format. Also there are abstractions for extend and customize this mechanism.

InfinniPlatfrom uses `Json.NET`_ - popular high-performance JSON framework for .NET. So you get all capabilities and features this library. Besides
InfinniPlatfrom provides a range high-level abstractions which are well integrated with other services of InfinniPlatfrom. This basic and powerful
mechanism is used in most of cases especially on the system layer but at the same time you do not need to care about it usually.


.. index:: IObjectSerializer
.. index:: IJsonObjectSerializer
.. index:: JsonObjectSerializer

Data Serialization is represented as `JsonObjectSerializer`_ class which implements two interfaces from the same namespace - `IObjectSerializer`_
and `IJsonObjectSerializer`_. The first - `IObjectSerializer`_ declares common methods of serializers. The second - `IJsonObjectSerializer`_ extends
the first and contains few special methods which are appropriate to JSON format.

`JsonObjectSerializer`_ class is thread-safe and it has two singleton instances - `Default`_ and `Formatted`_. `Default`_ instance uses UTF-8 encoding
(without BOM) and serializes objects without formatting. `Formatted`_ instance is the same as `Default`_ but serializes objects with formatting (for
getting easy-to-read JSON). Both of them do not have any other settings which you can pass to the constructor of `JsonObjectSerializer`_. You can use
`Default`_ and `Formatted`_ instances explicitly but if you have access to :doc:`IoC Container </ioc/index>` we strongly recommend getting instance
`IJsonObjectSerializer`_ via IoC. For example acquire `IJsonObjectSerializer`_ through :doc:`a constructor </ioc/container-resolver>` of the class
where you need this dependency. It allows to use the same settings of the data serialization in an application and customize them in one place.


.. toctree::

    serialization-attributes.rst
    serialization-knowntypes.rst
    serialization-converters.rst
    serialization-errors.rst
    serialization-datetime.rst
    serialization-dynamic.rst
    serialization-size.rst


.. _`Json.NET`: http://www.newtonsoft.com/json
.. _`IObjectSerializer`: ../api/reference/InfinniPlatform.Serialization.IObjectSerializer.html
.. _`IJsonObjectSerializer`: ../api/reference/InfinniPlatform.Serialization.IJsonObjectSerializer.html
.. _`JsonObjectSerializer`: ../api/reference/InfinniPlatform.Serialization.JsonObjectSerializer.html
.. _`Default`: ../api/reference/InfinniPlatform.Serialization.JsonObjectSerializer.html#InfinniPlatform_Serialization_JsonObjectSerializer_Default
.. _`Formatted`: ../api/reference/InfinniPlatform.Serialization.JsonObjectSerializer.html#InfinniPlatform_Serialization_JsonObjectSerializer_Formatted
