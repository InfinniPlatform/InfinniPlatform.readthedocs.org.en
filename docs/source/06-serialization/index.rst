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

Data Serialization is represented as ``InfinniPlatform.Sdk.Serialization.JsonObjectSerializer`` class which implements two interfaces from the same
namespace - ``IObjectSerializer`` and ``IJsonObjectSerializer``. The first - ``IObjectSerializer`` declares common methods of serializers. The second -
``IJsonObjectSerializer`` extends the first and contains few special methods which are appropriate to JSON format.

``JsonObjectSerializer`` class is thread-safe and it has two singleton instances - ``JsonObjectSerializer.Default`` and ``JsonObjectSerializer.Formated``.
``Default`` instance uses UTF-8 encoding (without BOM) and serializes objects without formatting. ``Formated`` instance is the same as ``Default`` but
serializes objects with formatting (for getting easy-to-read JSON). Both of them do not have any other settings which you can pass to the constructor
of ``JsonObjectSerializer``. You can use ``Default`` and ``Formated`` instances explicitly but if you have access to :doc:`IoC Container </02-ioc/index>`
we strongly recommend getting instance ``IJsonObjectSerializer`` via IoC. For example acquire ``IJsonObjectSerializer`` through
:doc:`a constructor </02-ioc/container-resolver>` of the class where you need this dependency. It allows to use the same settings
of the data serialization in an application and customize them in one place.


.. toctree::

    serialization-attributes.rst
    serialization-knowntypes.rst
    serialization-convertes.rst
    serialization-errors.rst
    serialization-datetime.rst
    serialization-dynamic.rst
    serialization-size.rst


.. _`Json.NET`: http://www.newtonsoft.com/json
