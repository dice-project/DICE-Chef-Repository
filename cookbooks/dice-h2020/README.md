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

  Key                                                        | Description
  ---                                                        | -----------
  ["dice-h2020"]["conf-optim"]["ds-container"]               | Deployment services container UUID reserved for the CO
  ["dice-h2020"]["deployment-service"]["url"]                | URL of the DICE deployment service's instance
  ["dice-h2020"]["deployment-service"]["username"]           | deployment services credentials - username
  ["dice-h2020"]["deployment-service"]["password"]           | deployment services credentials - password
  ["dice-h2020"]["d-mon"]["url"]                             | URL of the DICE monitoring service

The following attributes can be changed if needed:

  Key                                                        | Description
  ---                                                        | -----------
  ["dice-h2020"]["conf-optim"]["co-version"]                 | Version of the Configuration Optimization tool to install
  ["dice-h2020"]["conf-optim"]["co-installpath"]             | Install Configuration Optimization tool into this path
  ["dice-h2020"]["conf-optim"]["release-url"]                | URL of the Configuration Optimization's release
  ["dice-h2020"]["conf-optim"]["matlab-url"]                 | URL where the MATLAB Compiler Runtime R2015a resides
  ["dice-h2020"]["conf-optim"]["matlab-installpath"]         | Install MATLAB into this path
  ["dice-h2020"]["deployment-service"]["tools-install-path"] | Install DICE deployment service CLI tools into this path



TODO: List your cookbook attributes here.

e.g.
#### dice-h2020::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['dice-h2020']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### dice-h2020::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `dice-h2020` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[dice-h2020]"
  ]
}
```

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: TODO: List authors
