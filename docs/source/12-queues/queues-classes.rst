Working with Message Queue
==========================

Samples can be viewed, downloaded and tried free of charge here `InfinniPlatform.Northwind <https://github.com/InfinniPlatform/InfinniPlatform.Northwind>`_


.. index:: ITaskProducer
.. index:: IBroadcastProducer

Message Producer
----------------

To send messages in :doc:`task queue <queues-types>` one should use ``ITaskProducer`` interface.

.. code-block:: csharp
   :emphasize-lines: 3,15,18

    public class SomePublisher
    {
        public SomePublisher(ITaskProducer taskProducer)
        {
            _taskProducer = taskProducer;
        }

        private readonly ITaskProducer _taskProducer;

        public async Task<object> SendMessages(SomeMessage message)
        {
            // ...

            // Asynchrounous call
            await _taskProducer.PublishAsync(message);

            // Synchronous call
            _taskProducer.Publish(message);

            // ...
        }
    }

To send messages to :doc:`broadcast queue <queues-types>` one should use ``IBroadcastProducer`` interface.

.. code-block:: csharp
   :emphasize-lines: 3,15,18

    public class SomePublisher
    {
        public SomePublisher(IBroadcastProducer broadcastProducer)
        {
            _broadcastProducer = broadcastProducer;
        }

        private readonly IBroadcastProducer _broadcastProducer;

        public async Task<object> SendMessages(SomeMessage message)
        {
            // ...

            // Asynchrounous call
            await _broadcastProducer.PublishAsync(message);

            // Synchronous call
            _broadcastProducer.Publish(message);

            // ...
        }
    }


Message Consumer
----------------

.. index:: TaskConsumerBase<T>

To recieve a consumer from :doc:`task queue <queues-types>` one should create successor from base class ``TaskConsumerBase<T>``.

.. code-block:: csharp
   :emphasize-lines: 1,3

    public class SomeConsumer : TaskConsumerBase<SomeMessage>
    {
        protected override async Task Consume(Message<SomeMessage> message)
        {
            // Message logic processing
        }
    }

.. index:: BroadcastConsumerBase<T>

To recieve a consumer from :doc:`broadcast queue <queues-types>` следует создать наследник от базового класса ``BroadcastConsumerBase<T>``.

.. code-block:: csharp
   :emphasize-lines: 1,3

    public class SomeConsumer : BroadcastConsumerBase<SomeMessage>
    {
        protected override async Task Consume(Message<SomeMessage> message)
        {
            // Message logic processing
        }
    }

.. index:: IOnDemandConsumer<T>

To recieve message from :doc:`task queue <queues-types>` one should use upon request ``IOnDemandConsumer`` interface.

.. code-block:: csharp
   :emphasize-lines: 3,12

    public class SomeConsumer
    {
        public SomeConsumer(IOnDemandConsumer onDemandConsumer)
        {
            _onDemandConsumer = onDemandConsumer;
        }

        private readonly IOnDemandConsumer _onDemandConsumer;

        public async Task<SomeMessage> GetMessage()
        {
            var message = await _onDemandConsumer.Consume<SomeMessage>("OnDemandQueueName");

            return (message != null) ? (SomeMessage)message.GetBody() : null;
        }
    }


.. index:: IContainerBuilder.RegisterConsumers()

Registering Consumers
---------------------

To :doc:`register in IoC-container </02-ioc/container-builder>` all consumers declared in the app container one may use an extension method ``RegisterConsumers()``.

.. code-block:: csharp

    builder.RegisterConsumers(assembly);

To :doc:`register in IoC-container </02-ioc/container-builder>` a set of consumers one should publicly register their types as in example below.

.. code-block:: csharp
   :emphasize-lines: 3,8

    // Registration of task queue message consumer 
    builder.RegisterType<SomeTaskConsumer>()
           .As<ITaskConsumer>()
           .SingleInstance();

    // Registration of broadcast queue message consumer
    builder.RegisterType<SomeBroadcastConsumer>()
           .As<IBroadcastConsumer>()
           .SingleInstance();


.. index:: QueueNameAttribute

Defining Queue Name
-------------------

If one sends and recieves messages without declaring queue type some default rules are applied. The queue name is the message full name.

.. code-block:: csharp

    namespace InfinniPlatform.Northwind.Queues
    {
        public class SomeMessage
        {
            /* messages of this type are sent into the queue as
               "InfinniPlatform.Northwind.Queues.SomeMessage" */
        }
    }

To define a queue name one should use an attribute ``QueueNameAttribute``  which marks customer class.

.. code-block:: csharp

    [QueueName("DynamicQueue")]
    public class SomeConsumer : BroadcastConsumerBase<SomeMessage>
    {
        protected override async Task Consume(Message<SomeMessage> message)
        {
            /* This customer will process only those messages that are sent
               into the queue with name "DynamicQueue" */
        }
    }
