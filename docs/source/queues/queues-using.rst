Using Message Queue
===================

InfinniPlatform has an abstraction for work with message queue. Currently there is one implementation based on RabbitMQ_. To use this implementation
you need to make next steps.

**1.** Install Erlang_

**2.** Install RabbitMQ_

**3.** Install ``InfinniPlatform.MessageQueue.RabbitMQ`` package:

.. code-block:: bash

    dotnet add package InfinniPlatform.MessageQueue.RabbitMQ -s https://www.myget.org/F/infinniplatform/

**4.** Call `AddRabbitMqMessageQueue()`_ in ``ConfigureServices()``:

.. code-block:: csharp
   :emphasize-lines: 11

    using System;

    using InfinniPlatform.AspNetCore;

    using Microsoft.Extensions.DependencyInjection;

    public class Startup
    {
        public IServiceProvider ConfigureServices(IServiceCollection services)
        {
            services.AddRabbitMqMessageQueue();

            // ...

            return services.BuildProvider();
        }

        // ...
    }


.. index:: ITaskProducer
.. index:: ITaskConsumer

Using Task Queue
----------------

To send messages in a :ref:`task queue <taskQueue>` use the ITaskProducer_ interface:

.. code-block:: csharp
   :emphasize-lines: 10,21

    public class MyMessage
    {
        // ...
    }

    public class MyComponent
    {
        private readonly ITaskProducer _producer;

        public MyComponent(ITaskProducer producer)
        {
            _producer = producer;
        }

        public async Task DoSomething(MyMessage message)
        {
            MyMessage message;

            // ...

            await _producer.PublishAsync(message);

            // ...
        }
    }

To receive messages from a :ref:`task queue <taskQueue>` implement the ITaskConsumer_ interface:

.. code-block:: csharp
   :emphasize-lines: 1,3

    public class MyConsumer : TaskConsumerBase<MyMessage>
    {
        protected override async Task Consume(Message<MyMessage> message)
        {
            // Message handling
        }
    }

Consumers of the :ref:`task queue <taskQueue>` must be :doc:`registered in IoC-container </ioc/container-builder>`:

.. code-block:: csharp

    builder.RegisterType<MyConsumer>().As<ITaskConsumer>().SingleInstance();


.. index:: IBroadcastProducer
.. index:: IBroadcastConsumer

Using Broadcast Queue
---------------------

To send messages in a :ref:`broadcast queues <broadcastQueue>` use the IBroadcastProducer_ interface:

.. code-block:: csharp
   :emphasize-lines: 10,21

    public class MyMessage
    {
        // ...
    }

    public class MyComponent
    {
        private readonly IBroadcastProducer _producer;

        public MyComponent(IBroadcastProducer producer)
        {
            _producer = producer;
        }

        public async Task DoSomething(MyMessage message)
        {
            MyMessage message;

            // ...

            await _producer.PublishAsync(message);

            // ...
        }
    }

To receive messages from a :ref:`broadcast queues <broadcastQueue>` implement the IBroadcastConsumer_ interface:

.. code-block:: csharp
   :emphasize-lines: 1,3

    public class MyConsumer : BroadcastConsumerBase<MyMessage>
    {
        protected override async Task Consume(Message<MyMessage> message)
        {
            // Message handling
        }
    }

Consumers of the :ref:`broadcast queues <broadcastQueue>` must be :doc:`registered in IoC-container </ioc/container-builder>`:

.. code-block:: csharp

    builder.RegisterType<MyConsumer>().As<IBroadcastConsumer>().SingleInstance();


.. _`Erlang`: http://www.erlang.org/
.. _`RabbitMQ`: https://www.rabbitmq.com/

.. _`ITaskProducer`: ../api/reference/InfinniPlatform.MessageQueue.ITaskProducer.html
.. _`ITaskConsumer`: ../api/reference/InfinniPlatform.MessageQueue.ITaskConsumer.html
.. _`IBroadcastProducer`: ../api/reference/InfinniPlatform.MessageQueue.IBroadcastProducer.html
.. _`IBroadcastConsumer`: ../api/reference/InfinniPlatform.MessageQueue.IBroadcastConsumer.html
.. _`TaskConsumerBase<T>`: ../api/reference/InfinniPlatform.MessageQueue.TaskConsumerBase-1.html
.. _`AddRabbitMqMessageQueue()`: ../api/reference/InfinniPlatform.AspNetCore.RabbitMqMessageQueueExtensions.html#InfinniPlatform_AspNetCore_RabbitMqMessageQueueExtensions_AddRabbitMqMessageQueue_IServiceCollection_
