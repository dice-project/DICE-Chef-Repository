# Scylla

Cookbook for installing ScyllaDB cluster. Keep in mind that this cookbook is
meant to be used in conjunction with Cloudify.


## Required attributes that need to be manually provided

If this cookbook is not used from Cloudify Chef plugin, make sure at least
`node['cloudify']['runtime_properties']['seed']` and
`node['cloudify']['properties']['configuration']` attributes are set. For more
information on what exactly can be done, consult `.kitchen.yml` file that
contains setup instructions for minimalistic Scylla cluster.
