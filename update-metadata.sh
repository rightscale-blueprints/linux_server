#!/bin/sh -e

# generate metadata.json for upstream opscode cookbooks that have no metadata.json
knife cookbook metadata apache2 -o cookbooks/
knife cookbook metadata build-essential -o cookbooks/
knife cookbook metadata collectd -o cookbooks/
knife cookbook metadata collectd_plugins -o cookbooks/
knife cookbook metadata cron -o cookbooks/
knife cookbook metadata ntp -o cookbooks/
knife cookbook metadata postfix -o cookbooks/
knife cookbook metadata python -o cookbooks/
knife cookbook metadata resolver -o cookbooks/
knife cookbook metadata rightscale -o cookbooks/
knife cookbook metadata ruby -o cookbooks/
knife cookbook metadata rubygems -o cookbooks/
knife cookbook metadata sudo -o cookbooks/
knife cookbook metadata system -o cookbooks/
knife cookbook metadata yum -o cookbooks/