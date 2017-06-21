Transactions
============

The document storage does not assume supporting transactions in terms of ACID_ but rely that a write operation is atomic on the level of a single
document, even if the operation modifies multiple embedded documents within a single document. When a single write operation modifies multiple
documents, the modification of each document is atomic, but the operation as a whole is not atomic and other operations may interleave. It is
common behavior most of NoSQL_ databases.


Two Phase Commit
----------------

Lack of transactions is known problem and you can solve it using the `Two Phase Commit`_, for example, in a way which is `offered by MondoDB`_.
But there is no silver bullet and if you really need ACID_ transactions you should use appropriate database.


.. index:: IUnitOfWork
.. index:: IUnitOfWorkFactory

Unit of Work
------------

Yet another solution of transactions absence can be the `Unit of Work`_ pattern which is presented as the IUnitOfWork_ interface. You can accumulate
changes in the memory of the web server and then commit them. Until the commit, all changes of the documents remain in the memory and nobody see them.
Thus if during the changes an exception appears, the documents will not be changed. To some degree it works like transactions but if there is some
functional relation between the changes, the unit of work can be unsuitable solution.

To create instance of the IUnitOfWork_ use the IUnitOfWorkFactory_:

.. code-block:: csharp

    IUnitOfWorkFactory factory;

    // ...

    IUnitOfWork unitOfWork = factory.Create();

.. note:: The IUnitOfWork_ can be nested during the HTTP request handling.

The IUnitOfWork_ implements the IDisposable_ interface so it is better to use ``using`` operator:

.. code-block:: csharp

    IUnitOfWorkFactory factory;

    // ...

    using (IUnitOfWork unitOfWork = factory.Create())
    {
        // Inserts, updates, deletes...

        unitOfWork.Commit();
    }

After all changes are applied, invoke `Commit()`_ or `CommitAsync()`_.

Now let's consider full example of using the IUnitOfWork_:

.. code-block:: csharp

    IUnitOfWorkFactory factory;

    // ...

    using (IUnitOfWork unitOfWork = factory.Create())
    {
        unitOfWork.InsertOne(...);
        unitOfWork.InsertMany(...);

        unitOfWork.UpdateOne(...);
        unitOfWork.UpdateMany(...);

        unitOfWork.DeleteOne(...);
        unitOfWork.DeleteMany(...);

        unitOfWork.Commit();
    }


.. _`ACID`: https://en.wikipedia.org/wiki/ACID
.. _`NoSQL`: https://en.wikipedia.org/wiki/NoSQL
.. _`Two Phase Commit`: https://en.wikipedia.org/wiki/Two-phase_commit_protocol
.. _`offered by MondoDB`: https://docs.mongodb.com/manual/tutorial/perform-two-phase-commits/
.. _`Unit of Work`: http://martinfowler.com/eaaCatalog/unitOfWork.html
.. _`IUnitOfWork`: ../api/reference/InfinniPlatform.DocumentStorage.Transactions.IUnitOfWork.html
.. _`Commit()`: ../api/reference/InfinniPlatform.DocumentStorage.Transactions.IUnitOfWork.html#InfinniPlatform_DocumentStorage_Transactions_IUnitOfWork_Commit_System_Boolean_
.. _`CommitAsync()`: ../api/reference/InfinniPlatform.DocumentStorage.Transactions.IUnitOfWork.html#InfinniPlatform_DocumentStorage_Transactions_IUnitOfWork_CommitAsync_System_Boolean_
.. _`IUnitOfWorkFactory`: ../api/reference/InfinniPlatform.DocumentStorage.Transactions.IUnitOfWorkFactory.html
.. _`IDisposable`: https://docs.microsoft.com/en-us/dotnet/api/system.idisposable?view=netframework-4.7
