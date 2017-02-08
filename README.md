# InfinniPlatform Documentation

This repository contains a major revision of the InfinniPlatform documentation, currently accessible at http://infinniplatform.readthedocs.io/.

## Install

You can build the documentation locally if you have [Python 2.7](https://www.python.org/downloads/) and [Git LFS](https://git-lfs.github.com/).

```bash
git clone https://github.com/InfinniPlatform/InfinniPlatform.readthedocs.org.en.git
cd InfinniPlatform.readthedocs.org.en
pip install -r requirements.txt
cd docs
host_locally.bat
```

Local version of the documentation will be on http://127.0.0.1:8000/.

After that you can change sources and see how it will be looked.

## API Reference

To build [API Reference](http://infinniplatform.readthedocs.io/api/reference/) we use [DocFX](https://dotnet.github.io/docfx/). So after each release
[InfinniPlatform](https://github.com/InfinniPlatform/InfinniPlatform) we update our documentation using next steps.

```bash
cd InfinniPlatform                             # go to the InfinniPlatform repository
git checkout <release branch>                  # checkout to the release branch
git pull                                       # pull latest version
git clean -fdx                                 # clean repository
cd ../InfinniPlatform.readthedocs.org.en/docs  # go to the documentation repository
build_apiReference.bat                         # rebuild API Reference
```

After that we push changes as usual.
