Getting Started
===============

This article will help you getting started with basic settings to begin app development.

Examples of Using
-----------------

Clone app example:

.. code-block:: bash

    > git clone https://github.com/InfinniPlatform/InfinniPlatform.Northwind.git

Open a file ``InfinniPlatform.Northwind.sln`` in Visual Studio and build it to run pressing (``F5``).

Check if it is up and running:

.. code-block:: bash

    > curl http://localhost:9900

Examples of Deploy
------------------

Install Infinni.Node utility to continue with deployment InfinniPlatform apps
(:download:`download a Windows installation script Infinni.Node  <../_files/Infinni_Node_Install.bat>`).

The latest version is installed by default:

.. code-block:: bash

    > Infinni_Node_Install.bat # installs the latest version of Infinni.Node

You can install any `version <http://nuget.infinnity.ru/packages/Infinni.Node/>`_ of utility from the repository:

.. code-block:: bash

    > Infinni_Node_Install.bat <version> # installs specified version of Infinni.Node

When script finishes Infinni.Node will be placed into the folder ``Infinni.Node.X`` (where ``X`` - version number) in the same folder where script was
run. Change folder as in example below:

.. code-block:: bash

    > cd Infinni.Node.1.2.0.19-master

Install the app:

.. code-block:: bash

    > Infinni.Node.exe install -i "InfinniPlatform.Northwind" -p

Start the app:

.. code-block:: bash

    > Infinni.Node.exe start -i "InfinniPlatform.Northwind"

Check if it is running:

.. code-block:: bash

    > curl http://localhost:9900

System Requirements
-------------------

For Developers
~~~~~~~~~~~~~~

- `PowerShell`_ 3.0 (and above)
- `Git`_
- `NuGet`_
- `curl`_
- `Visual Studio Community`_

Requirement for Windows deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Windows Server 2008 R2 SP1 (or SP2) x64, Windows Server 2012 (или 2012 R2) x64
- `Microsoft .NET Framework 4.5`_

Requirement for Linux deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Ubuntu 14.04.4 LTS x64
- `Mono 4.2`_

Additional Environments
~~~~~~~~~~~~~~~~~~~~~~~

- `MongoDB`_ (in case of 'document store' using)
- `RabbitMQ`_ (in case of 'message bus' using)
- `Redis`_ (in case of cluster deployment)
- `ELK`_ (in case of utilizing monitoring)

.. _PowerShell: https://msdn.microsoft.com/en-us/powershell
.. _Git: https://git-scm.com/downloads
.. _Nuget: https://dist.nuget.org/index.html
.. _curl: https://curl.haxx.se/download.html
.. _Visual Studio Community: https://www.visualstudio.com/ru-ru/products/visual-studio-community-vs.aspx
.. _Microsoft .NET Framework 4.5: https://www.microsoft.com/ru-ru/download/details.aspx?id=30653
.. _Mono 4.2: http://www.mono-project.com/download/
.. _MongoDB: https://www.mongodb.com/download-center
.. _RabbitMQ: https://www.rabbitmq.com/download.html
.. _Redis: http://redis.io/download
.. _ELK: https://www.elastic.co/products
