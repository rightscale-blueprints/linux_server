# Cookbook Name:: rs_utils
# Recipe:: setup_monitoring
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

log 'Setup RightScale monitoring.'

return if ( platform?('archlinux') or platform?('mac_os_x') )
return unless defined?(RightScale)

# exclude collectd package so it can't be installed from epel (yum on redhat/centos only)
if node['platform'] =~ /redhat|centos/
  execute "yum_exclude_package_collectd" do
    only_if '[ -e /etc/yum.repos.d/Epel.repo ] && grep epel /etc/yum.repos.d/Epel.repo && ! grep "exclude=collectd" /etc/yum.repos.d/Epel.repo > /dev/null 2>&1'
    command 'echo -e "\n# Do not allow collectd version to be modified.\nexclude=collectd\n" >> /etc/yum.repos.d/Epel.repo'
  end
end

# patch collectd init script, so it uses collectdmon.  
# only needed for CentOS, Ubuntu already does this out of the box.
remote_file "/etc/init.d/collectd" do
  source "collectd-init-centos-with-monitor"
  mode 0755
  only_if "which collectdmon > /dev/null 2>&1"   # only when collectdmon is found installed
  action :nothing
end

package "collectd"

# notify custom init script (to enable collectdmon)for redhat/centos)
package "collectd" do
  notifies :create, resources(:remote_file => "/etc/init.d/collectd"), :immediately
end if node['platform'] =~ /redhat|centos/

package "librrd4" if platform?('ubuntu')  # add rrd library for ubuntu

service "collectd" do
  action :enable  # ensure the service is enabled
end

directory "/etc/collectd" do
  owner "root"
  group "root"
end

# == Create plugin conf dir
directory "#{node['rs_utils']['collectd_plugin_dir']}" do
  owner "root"
  group "root"
  recursive true
end

# collectd main configuration file
template node['rs_utils']['collectd_config'] do
  backup 5
  source "collectd.config.erb"
  notifies :enable, "service[collectd]"
  notifies :restart, "service[collectd]", :delayed
  variables(
    :sketchy_hostname => "#{node['rightscale']['servers']['sketchy']['hostname']}",
    :plugins => node.rs_utils.plugin_list_ary,
    :instance_uuid => node['rightscale']['instance_uuid'],
    :collectd_include_dir => node['rs_utils']['collectd_plugin_dir']
  )
end

# == Monitor Processes from Script Input 
# Write the process file into the include directory from template.
template File.join(node['rs_utils']['collectd_plugin_dir'], 'processes.conf') do
  backup false
  source "processes.conf.erb"
  notifies :restart, resources(:service => "collectd"), :delayed
  variables(
    :monitor_procs => node.rs_utils.process_list_ary,
    :procs_match => node['rs_utils.process_match_list']
  )
end

# install a nightly cron to restart collectd
# Add the task to /etc/crontab, at 04:00 localtime.
cron "collectd" do
  command "service collectd restart > /dev/null"
  minute "00"
  hour   "4"
end

# set rs monitoring tag to active
if node.has_key? :rightscale  
  begin
    right_link_tag "rs_monitoring:state=active"
  rescue
    log("Failed setting RightScale tag, rs_monitoring:state=active") { level :debug }
  end  
end

log "RightScale monitoring setup complete."