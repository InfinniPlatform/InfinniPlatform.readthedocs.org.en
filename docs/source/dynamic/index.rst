.. index:: DynamicDocument

Dynamic Objects
===============

Dynamic objects expose members such as properties and methods at run time, instead of in at compile time. This enables you to create objects to work
with structures that do not match a static type or format. Having created an instance of such object makes possible to bind a set of properties to it.
This behavior is made possible by 'late binding' with using of keyword ``dynamic``. Basic usage of dynamic objects is processing of non-structured and
non-formalized data.


Creating Dynamic Objects
------------------------

InfinniPlatform has dynamic object represented by DynamicDocument_.

.. code-block:: csharp

    dynamic instance = new DynamicDocument();


Setting Properties of Dynamic Objects
-------------------------------------

Dynamic object instance can be created with pre-defined properties:

.. code-block:: csharp

    dynamic instance = new DynamicDocument
                       {
                           { "Property1", 123 },
                           { "Property2", "Abc" },
                           { "Property3", DateTime.Now },
                           {
                               "Property4", new DynamicDocument
                                            {
                                                { "SubProperty1", 456 },
                                                { "SubProperty2", "Def" }
                                            }
                           }
                       };

or define properties later:

.. code-block:: csharp

    instance.Property1 = 123;
    instance.Property2 = "Abc";
    instance.Property3 = DateTime.Now;
    instance.Property4 = new DynamicDocument();
    instance.Property4.SubProperty1 = 456;
    instance.Property4.SubProperty2 = "Def";

Value property may define a link to delegate:

.. code-block:: csharp

    instance.Sum = new Func<int, int, int>((a, b) => a + b);


Getting Properties of Dynamic Objects
-------------------------------------

Defining properties of dynamic object is identical to defining properties of regular classes: 

.. code-block:: csharp

    var property1 = instance.Property1; // 123
    var property2 = instance.Property2; // "Abc"
    var property3 = instance.Property3; // DateTime.Now
    var property4 = instance.Property4;
    var subProperty1 = property4.SubProperty1; // 456
    var subProperty2 = instance.Property4.SubProperty2; // "Def"
    var sum = instance.Sum(2, 3); // 5


Recommendations to work with Dynamic Objects
--------------------------------------------

Dynamic objects simplify processing of non-structured data and at the same time increases chance of error due to the fact that expressions workin with
dynamic objects being built are not affected by syntax analysis. Any expression's result which formed by calling to either dynamic object or its
properties is the dynamic object itself. Thus if the result type of dynamic object is not defined may cause large code blocks which is uncontrollable
at the building stage. Also you should bear in mind about lack of information in exception stack that may arise while building dynamic code.

This is very important, due to mentioned reasons, to exactly define the result type of dynamic expression and use keyword ``dynamic`` where it is indeed
applicable. In case you don't use non-structured data objects, particular properties of data types can be often easily defined. Good rule is to define
type in advance to avoid errors of type conversion and even in case of getting one you will be aware of its reasons. 

.. code-block:: csharp

    int property1 = instance.Property1; // 123
    string property2 = instance.Property2; // "Abc"
    DateTime property3 = instance.Property3; // DateTime.Now
    dynamic property4 = instance.Property4;
    int subProperty1 = property4.SubProperty1; // 456
    string subProperty2 = instance.Property4.SubProperty2; // "Def"
    int sum = instance.Sum(2, 3); // 5


Serialization of Dynamic Objects
--------------------------------

Class instances DynamicDocument_ can be serialized and deserialized to/from JSON. You my find additional info here :doc:`/serialization/index`.


.. _`DynamicDocument`: ../api/reference/InfinniPlatform.Dynamic.DynamicDocument.html
