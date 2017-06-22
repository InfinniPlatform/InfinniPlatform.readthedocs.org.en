Specifications
==============

Direct access to the `IDocumentStorage<TDocument>`_ or IDocumentStorage_ provokes uncontrolled increasing number of query types. If you still working
in this style after for a while you will see that the same queries are implemented in different ways and one query works fine but its analogue is
very slow. Then you will lose control and not able to enumerate which queries go to the storage. All of these provokes bugs and makes support difficult.
In fact an application as a rule has only few typical queries and it will be fine having them in one place.

Repository_ and Specifications_ patterns come to the rescue. InfinniPlatform implements these patterns and provides two base classes:
`Specification<TDocument>`_ (for :ref:`typed context <typed>`) and Specification_ (for :ref:`dynamic context <dynamic>`).


.. index:: ISpecification<TDocument>
.. index:: Specification<TDocument>

Specifications for Typed Documents
----------------------------------

Suppose we need to organize a storage of some articles and we know each article has date, author, title, text and can be in two states: draft and published.

.. code-block:: csharp

    class Article : Document
    {
        public DateTime Date { get; set; }
        public string Author { get; set; }
        public string Title { get; set; }
        public string Text { get; set; }
        public ArticleState State { get; set; }

        // ...
    }

    enum ArticleState
    {
        Draft = 0,
        Published = 1
    }

And in the most of the cases we need to fetch published articles for the specified period:

.. code-block:: csharp
   :emphasize-lines: 1,12-14

    class GetPublishedArticles : Specification<Article>
    {
        private readonly DateTime _start;
        private readonly DateTime _end;

        public GetPublishedArticles(DateTime start, DateTime end)
        {
            _start = start;
            _end = end;
        }

        public override Expression<Func<Article, bool>> Filter =>
            a => a.Date >= _start && a.Date <= _end
                 && a.State == ArticleState.Published;
    }

After that it will be right to create appropriate repository of the articles:

.. code-block:: csharp
   :emphasize-lines: 17-20

    interface IArticleRepository
    {
        IEnumerable<Article> GetArticles(ISpecification<Article> specification);

        // ...
    }

    class ArticleRepository : IArticleRepository
    {
        private readonly IDocumentStorage<Article> _storage;

        public ArticleRepository(IDocumentStorageFactory factory)
        {
            _storage = factory.GetStorage<Article>();
        }

        public IEnumerable<Article> GetArticles(ISpecification<Article> specification)
        {
            return _storage.Find(specification.Filter).ToList();
        }

        // ...
    }

And use it to fetch articles:

.. code-block:: csharp

    IArticleRepository repository;
    DateTime start, end;

    // ...

    ISpecification<Article> specification = new GetPublishedArticles(start, end);
    IEnumerable<Article> publishedArticles = repository.GetArticles(specification);


.. index:: ISpecification
.. index:: Specification

Specifications for Dynamic Documents
------------------------------------

Let's consider the same example as above but in dynamic context. Declare specification:

.. code-block:: csharp
   :emphasize-lines: 1,12-14

    class GetPublishedArticles : Specification
    {
        private readonly DateTime _start;
        private readonly DateTime _end;

        public GetPublishedArticles(DateTime start, DateTime end)
        {
            _start = start;
            _end = end;
        }

        public override Func<IDocumentFilterBuilder, object> Filter =>
            a => a.And(a.Gte("Date", _start), a.Lte("Date", _end),
                       a.Eq("State", ArticleState.Published));
    }

Declare the repository of the articles:

.. code-block:: csharp
   :emphasize-lines: 17-20

    interface IArticleRepository
    {
        IEnumerable<DynamicDocument> GetArticles(ISpecification specification);

        // ...
    }

    class ArticleRepository : IArticleRepository
    {
        private readonly IDocumentStorage _storage;

        public ArticleRepository(IDocumentStorageFactory factory)
        {
            _storage = factory.GetStorage("Article");
        }

        public IEnumerable<DynamicDocument> GetArticles(ISpecification specification)
        {
            return _storage.Find(specification.Filter).ToList();
        }

        // ...
    }

And use it to fetch articles:

.. code-block:: csharp

    IArticleRepository repository;
    DateTime start, end;

    // ...

    ISpecification specification = new GetPublishedArticles(start, end);
    IEnumerable<DynamicDocument> publishedArticles = repository.GetArticles(specification);


Composing Specifications
------------------------

The specification classes `Specification<TDocument>`_ and Specification_ override ``!``, ``&`` and ``|`` operators and implement, respectively,
negation, conjunction and disjunction. Thus you can compose existing specifications instead of creating new.

.. code-block:: csharp

    // Not
    var notSpecification = !specification;

    // And
    var andSpecification = specification1 & specification2 & specification3;

    // Or
    var orSpecification = specification1 | specification2 | specification3;


.. _`Repository`: https://martinfowler.com/eaaCatalog/repository.html
.. _`Specifications`: https://www.martinfowler.com/apsupp/spec.pdf

.. _`IDocumentStorage`: ../api/reference/InfinniPlatform.DocumentStorage.IDocumentStorage.html
.. _`IDocumentStorage<TDocument>`: ../api/reference/InfinniPlatform.DocumentStorage.IDocumentStorage-1.html

.. _`ISpecification`: ../api/reference/InfinniPlatform.DocumentStorage.Specifications.ISpecification.html
.. _`Specification`: ../api/reference/InfinniPlatform.DocumentStorage.Specifications.Specification.html
.. _`ISpecification<TDocument>`: ../api/reference/InfinniPlatform.DocumentStorage.Specifications.ISpecification-1.html
.. _`Specification<TDocument>`: ../api/reference/InfinniPlatform.DocumentStorage.Specifications.Specification-1.html
