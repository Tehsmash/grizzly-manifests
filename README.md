Grizzly-manifests for Ubuntu MaaS Environment
=============================================

In order to use these manifests to install OpenStack in your environment 
* Copy the contents of the manifests folder into your /etc/puppet/manifests directory on your puppet master. 
* Copy the templates folder into /etc/puppet
* Run `python /etc/puppet/manifests/openstack/scripts/puppet_modules.py`
* Modify /etc/puppet/manifests/openstack/nodes.pp to match your environment
* Either add `import './openstack/nodes.pp'` to your site.pp or rename site.pp.example to site.pp
