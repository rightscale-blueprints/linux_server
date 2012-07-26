# Cookbook Name:: rs_utils
# Recipe:: default
#
# Copyright (c) 2011 RightScale Inc
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

log('Setting up RightScale.') { level :debug }

if defined?(RightScale)
  package "debian-helper-scripts" if node['platform'] == 'ubuntu' && node['lsb.codename'] == 'hardy'

  # recipes for a default install (setup_tools is not included as its problematic/hits bugs and gems are not in a repos)
  include_recipe "rs_utils::setup_timezone"
  include_recipe "rs_utils::setup_hostname"
  include_recipe "rs_utils::setup_server_tags"
  include_recipe "rs_utils::setup_monitoring"
  include_recipe "rs_utils::setup_logging"
  include_recipe "rs_utils::setup_ssh"
  include_recipe "rs_utils::setup_mail"
else
  log('Not attached to RightScale, skipping.') { level :debug }
  return
end