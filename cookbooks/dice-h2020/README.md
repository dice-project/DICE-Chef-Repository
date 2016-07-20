DICE-H2020 Cookbook
===================
This cookbook contains recipes for installing and configuring a selection of
the [DICE](http://www.dice-h2020.org) tools. Currently, this includes the
following:

* [Configuration Optimization](https://github.com/dice-project/DICE-Configuration-BO4CO)

Requirements
------------

### Configuration Optimization

The Configuration Optimization cookbook will run on:

* Ubuntu 14.04 64-bit

Attributes
----------

The following attributes need to be set for the Configuration Optimization to work:

  Key                                                | Description
  ---                                                | -----------
  `["dice-h2020"]["conf-optim"]["ds-container"]`     | Deployment services container UUID reserved for the CO
  `["dice-h2020"]["deployment-service"]["url"]`      | URL of the DICE deployment service's instance
  `["dice-h2020"]["deployment-service"]["username"]` | deployment services credentials - username
  `["dice-h2020"]["deployment-service"]["password"]` | deployment services credentials - password
  `["dice-h2020"]["d-mon"]["url"]`                   | URL of the DICE monitoring service

The following attributes can be changed if needed:

  Key                                                          | Description
  ---                                                          | -----------
  `["dice-h2020"]["conf-optim"]["co-version"]`                 | Version of the Configuration Optimization tool to install
  `["dice-h2020"]["conf-optim"]["co-installpath"]`             | Install Configuration Optimization tool into this path
  `["dice-h2020"]["conf-optim"]["release-url"]`                | URL of the Configuration Optimization's release
  `["dice-h2020"]["conf-optim"]["matlab-url"]`                 | URL where the MATLAB Compiler Runtime R2015a resides
  `["dice-h2020"]["conf-optim"]["matlab-installpath"]`         | Install MATLAB into this path
  `["dice-h2020"]["deployment-service"]["release-url"]`        | URL of the DICE deployment release package
  `["dice-h2020"]["deployment-service"]["tools-install-path"]` | Install DICE deployment service CLI tools into this path



Usage
-----

### Configuration Optimization

Installing the Configuration Optimization involves the following runlist:

```
recipe[apt::default]
recipe[java::default]
recipe[dice-h2020::deployment-service-tool]
recipe[dice-h2020::conf-optim]
```

Here is one quick way for installing Configuration Optimization. In a dedicated
Ubuntu 14.04 host, first install the [Chef Development Kit](https://downloads.chef.io/chef-dk/),
e.g.:

```bash
$ wget https://packages.chef.io/stable/ubuntu/12.04/chefdk_0.15.16-1_amd64.deb
$ sudo dpkg -i chefdk_0.15.16-1_amd64.deb
```

Then obtain this cookbook repository:

```bash
$ git clone https://github.com/dice-project/DICE-Chef-Repository.git
$ cd DICE-Chef-Repository
```

Before we run the installation, we just need to provide the configuration,
pointing to the external services that the Configuration Optimization relies
on. We provide this configuration in a `json` file. Let us name it
`configuration-optimization.json`:

```json
{
  "dice-h2020": {
    "conf-optim": {
      "ds-container": "4a7459f7-914e-4e83-ab40-b04fd1975542"
    }
  }, 
  "deployment-service": {
    "url": "http://10.10.50.3:8000",
    "username": "admin",
    "password": "LetJustMeIn"
  },
  "d-mon": {
    "url": "http://10.10.50.20:5001"
  }
}
```

Now we can start the Chef process:

```bash
$ sudo chef-client -z \
    -o recipe[apt::default],recipe[java::default],recipe[dice-h2020::deployment-service-tool],recipe[dice-h2020::conf-optim] \
    -j configuration-optimization.json 
```

When the execution succeeds, the Configuration Optimization will be installed
in `/opt/co/` by default.

License and Authors
-------------------
Authors: Matej Artac (matej.artac@xlab.si)

License: BSD-3
