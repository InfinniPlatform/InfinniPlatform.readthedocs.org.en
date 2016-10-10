View Engine
===========

InfinniPlatform includes a module that can generate presentation layer. It receives **template** and **data model** (optionally) based on which
generates HTML-document. At this moment only `Razor markup <http://www.w3schools.com/aspnet/razor_intro.asp>`_ is supported.


Creating a View
---------------

You can start to implement Razor-presentation by using ``IHttpService`` interface which returns ``ViewHttpResponse`` as the result.

.. code-block:: csharp

    public class RazorViewsHttpService : IHttpService
    {
        public void Load(IHttpServiceBuilder builder)
        {
            builder.ServicePath = "/razor";

            // Getting Razor-presentation Index.cshtml, posting dynamic data model.
            builder.Get["/Index"] = request =>
                                    {
                                        var model = new DynamicWrapper
                                                    {
                                                        { "Title", "Title" },
                                                        { "Data1", "Somedata" },
                                                        { "Data2", DateTime.Now }
                                                    };

                                        var view = new ViewHttpResponce("Index", model);

                                        return Task.FromResult<object>(view);
                                    };

            // Getting Razor-пpesentation About.cshtml, without posting data model.
            builder.Get["/About"] = request => Task.FromResult<object>(new ViewHttpResponce("About"));
        }
    }


View Template Example
---------------------

.. code-block:: html

    @{
    }

    <!-- To get access to data model use variable @Model -->
    <h2>@Model["Title"]</h2>
    <p>'Index' view successfully loaded.</p>
    <p>Data1 field = @Model["Data1"]</p>
    <p>Data2 field = @Model["Data2"]</p>
