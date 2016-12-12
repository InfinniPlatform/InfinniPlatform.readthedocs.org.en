Infinni.Node
============

Utility to manage InfinniPlatform applications.

Installation
------------

Infinni.Node can be installed with `script <http://infinniplatform.readthedocs.io/ru/latest/_downloads/Infinni_Node_Install.bat>`__.

By default latest version of the utility will be installed:

.. code:: bash

    > Infinni_Node_Install.bat # install latest version of Infinni.Node utility

To install `specific version <http://nuget.infinnity.ru/packages/Infinni.Node/>`__ you can pass it as script parameter:

.. code:: bash

    > Infinni_Node_Install.bat 1.2.0.19-master # install version '1.2.0.19-master' of Infinni.Node utility

Getting Started
---------------

Install application :

.. code:: bash

    > Infinni.Node.exe install -i <ApplicationName>

Start application:

.. code:: bash

    > Infinni.Node.exe start -i <ApplicationName>

Stop application:

.. code:: bash

    > Infinni.Node.exe stop -i <ApplicationName>

Get application status:

.. code:: bash

    > Infinni.Node.exe status -i <ApplicationName>

Uninstall application:

.. code:: bash

    > Infinni.Node.exe uninstall -i <ApplicationName>

Get help for specific command:

.. code:: bash

    > Infinni.Node.exe help [command]

Packages
--------

Application distributive represents Nuget package that must include necessary
files and dependencies. Packages can be posted on any valid NuGet source,
including file system.

Infinni.Node's configuration file can contain multiple Nuget sources that
will be used by default on ``install`` command call without using specified source.
Installation creates separate directory for files contained in package and it's dependencies.

Sandboxes
---------

Infinni.Node allows to install multiple versions of the same application,
as well as multiple instances of the same version. 
Separate working directory is created for each instance of each version of each application.

Each application runs as separate working process under ``Infinni.NodeWorker.exe``.  
As part of this process, for application creates a separate application domain,
which is aimed at appropriate working directory.

Windows & Linux
---------------

Infinni.Node is a cross-platform utility, so it can run on Windows and Linux operating systems.
Work on Linux is provided by ``Mono``, therefore, calling the utility on Linux command shell must start with
command ``mono``:

.. code:: bash

    > mono Infinni.Node.exe ...

On Windows applications represents as Windows services.
On Linux applications represents as deamons (yet only as LSB-compliant script in init.d).

.. note:: Infinni.Node provides cross-platform infrastructure for application management,
          however, can't guarantee that the individual application is cross-platform.
          Platform independence for individual application shall be ensured by application developer.