Infinni.Node
============

Utility to manage InfinniPlatform applications.

Installation
------------

Infinni.Node can be installed with `script <http://infinniplatform.readthedocs.io/ru/latest/_downloads/Infinni_Node_Install.bat>`__.

By default latest version of the utility will be installed:

.. code:: bash

    > Infinni_Node_Install.bat # install latest version of Infinni.Node utility

To install specific version you can pass it as script parameter `доступную версию утилиты <http://nuget.infinnity.ru/packages/Infinni.Node/>`__:

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

Дистрибутив приложения выполняется в виде обычного NuGet-пакета, который
должен включать необходимый набор файлов и зависимостей. Пакеты могут
размещаться на любом допустимом NuGet-источнике, включая обычную
файловую систему.

В конфигурационном файле утилиты можно указать несколько
NuGet-источников, которые будут использоваться по умолчанию, если
команда ``install`` была вызвана без явного указания источника. После
установки для приложения будет создан отдельный каталог, который будет
содержать все файлы, содержащиеся в пакете и его зависимостях.

Sandboxes
---------

Утилита поддерживает установку нескольких версий одного и того же
приложения, а также нескольких экземпляров одной и той же версии. Для
каждого экземпляра каждой версии каждого приложения при установке
создается свой рабочий каталог.

Каждое приложение работает в отдельно выделенном процессе под
управлением ``Infinni.NodeWorker.exe``. В рамках этого процесса для
приложения создается отдельный домен приложения, который нацелен на
соответствующий рабочий каталог.

Windows & Linux
---------------

Утилита является кроссплатформенной, поэтому может работать как в
Windows, так и в Linux. Работа в Linux обеспечивается за счет ``Mono``,
поэтому вызов утилиты в командной строке Linux должен начинаться с
команды ``mono``:

.. code:: bash

    > mono Infinni.Node.exe ...

При установке приложений в Windows они уставливаются, как Windows
Services. При установке приложений в Linux они уставливаются, как
Daemons (пока только в виде LSB-совместимого скрипта в init.d). На этом
основные отличия заканчиваются.

Disclaimer
----------

Утилита обеспечивает кроссплатформенную инфраструктуру для управления
приложениями, однако не может гарантировать, что отдельно взятое
приложение является кроссплатформенным. Платформенная независимость
приложения должна обеспечиваться разработчиком самого приложения.
