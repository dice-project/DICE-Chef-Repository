django-global Cookbook
======================
Installs python django in a global environment (i.e., not using python virtual environments).

Requirements
------------
Runs only on Ubuntu.

#### cookbooks
- `python` - django-global needs the python cookbook.

Attributes
----------
TODO: List your cookbook attributes here.

e.g.
#### django-global::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['django-global']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### django-global::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `django-global` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[django-global]"
  ]
}
```

License and Authors
-------------------
Authors: TODO: List authors
