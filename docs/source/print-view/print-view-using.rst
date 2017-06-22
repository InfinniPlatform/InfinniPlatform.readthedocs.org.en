Using Print View
================

To using Print View you have to go through next steps.

**1.** Install wkhtmltopdf_ v0.12.2.4

.. note:: While installing wkhtmltopdf_ better do not change the default installation directory, it allows to avoid needless configuration.

.. note:: If you install wkhtmltopdf_ on Linux without X Server, wkhtmltopdf_ should run via ``xvfb`` as below:

          .. code-block:: bash
             :caption: /usr/local/bin/wkhtmltopdf.sh

              #!/bin/bash
              xvfb-run -a -s "-screen 0 640x480x16" wkhtmltopdf "$@"

          Also do not forget to set the permission for execution:

          .. code-block:: bash

              chmod a+x /usr/local/bin/wkhtmltopdf.sh

**2.** Install ``InfinniPlatform.PrintView`` package:

.. code-block:: bash

    dotnet add package InfinniPlatform.PrintView -s https://www.myget.org/F/infinniplatform/

**3.** Call `AddPrintView()`_ in ``ConfigureServices()``:

.. code-block:: csharp
   :emphasize-lines: 11

    using System;

    using InfinniPlatform.AspNetCore;

    using Microsoft.Extensions.DependencyInjection;

    public class Startup
    {
        public IServiceProvider ConfigureServices(IServiceCollection services)
        {
            services.AddPrintView();

            // ...

            return services.BuildProvider();
        }

        // ...
    }

**4.** Request the IPrintViewBuilder_ instance in the constructor:

.. code-block:: csharp
   :emphasize-lines: 5

    class MyComponent
    {
        private readonly IPrintViewBuilder _builder;

        public MyComponent(IPrintViewBuilder builder)
        {
            _builder = builder;
        }

        // ...
    }

**5.** Create the template using :doc:`Print View Designer </print-view/print-view-designer>`

**6.** Use the `Build()`_ method to generate the document:

.. code-block:: csharp

    Func<Stream> template;
    object dataSource;
    Stream outStream;

    // ...

    await _builder.Build(outStream, template, dataSource, PrintViewFileFormat.Pdf);


.. _`wkhtmltopdf`: https://wkhtmltopdf.org/

.. _`IPrintViewBuilder`: ../api/reference/InfinniPlatform.PrintView.IPrintViewBuilder.html
.. _`Build()`: ../api/reference/InfinniPlatform.PrintView.IPrintViewBuilder.html#InfinniPlatform_PrintView_IPrintViewBuilder_Build_Stream_Func_Stream__System_Object_InfinniPlatform_PrintView_PrintViewFileFormat_
.. _`AddPrintView()`: ../api/reference/InfinniPlatform.AspNetCore.PrintViewExtensions.html#InfinniPlatform_AspNetCore_PrintViewExtensions_AddPrintView_IServiceCollection_
