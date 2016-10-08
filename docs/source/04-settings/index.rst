.. index:: AppExtension.json

Application Configuration
=========================

App developers and administrators may configure InfinniPlatform apps using **configuration file**.
Configuration file is a text file with contains app settings in JSON_ format. Developers may define app parameters in this file which will be taken into account in the app code automatically that make the app highly flexible and configurable. App administrators may change configuration parameters values which define the way the app is executed.

Application Configuration File
------------------------------

App configuration file supports UTF-8_ text encoding and keeps app settings in JSON format.
The file must have got name ``AppExtension.json`` and be stored in app's root folder.

.. note:: Name ``AppExtension.json`` refers to that the app is an extention of InfinniPlatform.

Settings are JSON object with many defined properties. Properties of the first level are  **configuration sections** 
Configuration section is described by "key-value" pairs. Key is a name of property while value is a JSON object of any complexity. Each configuration section reflects particular InfinniPlatform module settings or the app settings.

You can see an example of configuration file common structure below. This contains two sections ``section1`` and ``section2``, each one has its own set of properties. Section properties can be of any JSON compatible type (string type in example).
Number, name and content of cofiguration section is defined by the app developer however there are a few pre-defined InfinniPlatform configuration sections


.. code-block:: js
   :emphasize-lines: 3,10
   :caption: AppExtension.json

    {
      /* section1 comment */
      "section1": {
        "Property11": "Value11",
        "Property12": "Value12",
        "Property13": "Value13",
        ...
      },
      /* section2 comment */
      "section2": {
        "Property21": "Value21",
        "Property22": "Value22",
        "Property23": "Value23",
        ...
      },
      ...
    }


.. index:: Environment Variables

Environment Variables
---------------------

For the reasons of administration convenience the app configuration file supports usage of environment variables. You may use simple substitute syntax in example below:

.. code-block:: bash

    ${variable}
    ${variable=default}

``Variable`` is a variable name in environment while ``default`` is a value by default in case if variable is not defined or its value is not set (null string). Setting the default value is optional. 

To define variable value the following search rules are applicable (ranged by priority)

#. Process environment variables
#. User environment variables 
#. Machine environment variables 

Next example shows configuration file environment variables usage: 

.. code-block:: js
   :caption: AppExtension.json

    {
      "myComponent": {
        "Property1": "${VARIABLE1}",
        "Property2": "${VARIABLE2=Value2}"
      },
      ...
    }


.. index:: IAppConfiguration
.. index:: IAppConfiguration.GetSection()

Reading Application Configuration
---------------------------------

To retrieve settings from configuration file it is required to :doc:`get </02-ioc/index>` the interface
``InfinniPlatform.Sdk.Settings.IAppConfiguration`` from IoC-container and call a method ``GetSection()`` passing to it a section name as a parameter that is about to be retrieved.

As an example let's suppose a section ``myComponent`` is defined: 

.. code-block:: js
   :caption: AppExtension.json

    {
      "myComponent": {
        "Property1": true,
        "Property2": 123,
        "Property3": "Abc"
      },
      ...
    }


Then retrieving of the settings can be excecuted as in axample below:

.. code-block:: js
   :emphasize-lines: 3,5

    public class MyComponent
    {
        public MyComponent(InfinniPlatform.Sdk.Settings.IAppConfiguration appConfiguration)
        {
            dynamic myComponentSettings = appConfiguration.GetSection("myComponent");
            bool property1 = myComponentSettings.Property1; // true
            int property2 = myComponentSettings.Property2; // 123
            string property3 = myComponentSettings.Property3; // "Abc"
    
            // ...
        }
    
        // ...
    }

In this example settings were retrieved as a :doc:`dynamic object </01-dynamic/index>`. However, in cases, when structure of teh configuration section can be described in advance it is recommended to define a class that can clearly describe the section content and use strongly typed reloading of method ``GetSection()`` 

.. code-block:: js
   :emphasize-lines: 1,11,13

    public class MyComponentSettings
    {
        public bool Property1 { get; set; }
        public int Property2 { get; set; }
        public string Property3 { get; set; }
    }
    
    
    public class MyComponent
    {
        public MyComponent(InfinniPlatform.Sdk.Settings.IAppConfiguration appConfiguration)
        {
            var myComponentSettings = appConfiguration.GetSection<MyComponentSettings>("myComponent");
            bool property1 = myComponentSettings.Property1; // true
            int property2 = myComponentSettings.Property2; // 123
            string property3 = myComponentSettings.Property3; // "Abc"
    
            // ...
        }
    
        // ...
    }


Integration with IoC Container
------------------------------

While developing own components it is more convenient to retrieve settings using the toolkit and not directly from configuration file. This allows to make the component to be more independent and save time on working with toolkit.
To demonstrate this approach you should modify the above example in a very simple way; just move the logic of configuration section retrieving to the level of IoC-contaner module.

.. code-block:: js
   :emphasize-lines: 3,20-22

    public class MyComponent
    {
        public MyComponent(MyComponentSettings myComponentSettings)
        {
            bool property1 = myComponentSettings.Property1; // true
            int property2 = myComponentSettings.Property2; // 123
            string property3 = myComponentSettings.Property3; // "Abc"
    
            // ...
        }
    
        // ...
    }
    
    
    public class ContainerModule : IContainerModule
    {
        public void Load(IContainerBuilder builder)
        {
            builder.RegisterFactory(r => r.Resolve<IAppConfiguration>().GetSection<MyComponentSettings>("myComponent"))
                   .As<MyComponentSettings>()
                   .SingleInstance();
    
            builder.RegisterType<MyComponent>()
                   .AsSelf()
                   .SingleInstance();
    
            // ...
        }
    }


.. _JSON: http://json.org/
.. _UTF-8: https://tools.ietf.org/html/rfc3629
