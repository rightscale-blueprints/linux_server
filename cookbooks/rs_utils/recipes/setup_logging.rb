# Cookbook Name:: rs_utils
# Recipe:: setup_logging
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

log 'Setup RightScale remote syslog logging.'

unless defined?(RightScale)
  log 'Not attached to RightScale, skipping logging setup.'
  return
end

# for some reason the package resource returns Platform archlinux not found, using all defaults. (Unsupported platform?) on arch atm.
( log "setup_logging not yet supported on archlinux" and return) if node['platform'] == 'archlinux'

# todo: add a return if in non-EC2 as only ec2 is supported for lumberjacks at this time

# == rsyslog usually conflicts and should be removed first (via package manager; known kernel proc kill in centos)
if platform?('centos', 'redhat')
  service "rsyslog" do
    action :stop
  end
  service "rsyslog" do
    action :disable
  end
  # avoids removing dependencies of rsyslog such as rightscale and lsb packages
  execute "remove_rsyslog" do
    command "( rpm -qi rsyslog && rpm --nodeps -e rsyslog ) || echo 'skipping rsyslog removal.'"
  end
end

package "syslog-ng"

service "syslog-ng" do
  action :nothing
end

# /dev/null for syslog-ng
execute "ensure_dev_null.syslog-ng" do
  creates "/dev/null.syslog-ng"
  command "mknod /dev/null.syslog-ng c 1 3"
end

begin
  lumberjack_host = node['rightscale']['servers']['lumberjack']['hostname']
rescue
  lumberjack_host = ""
end
begin
  lumberjack_identifier = node['rightscale']['servers']['lumberjack']['identifier']
rescue
  lumberjack_identifier = ""
end

( log "exiting setup_logging early as no lumberjack host found" and return) if lumberjack_host == ""

# == Configure syslog
template "/etc/syslog-ng/syslog-ng.conf" do
  source "syslog.erb"
  variables ({
    :apache_log_dir => (node['platform'] == 'centos') ? "httpd" : "apache2",
    :lumberjack_host => "#{lumberjack_host}",
    :lumberjack_identifier => "#{lumberjack_identifier}"
  })
  notifies :restart, resources(:service => "syslog-ng"), :delayed
end

# ensure everything in /var/log is owned by root, not syslog
Dir.glob("/var/log/*").each do |f|
  if ::File.directory?(f)
    directory f do 
      owner "root" 
    end
  else
    file f do 
      owner "root" 
    end
  end
end

# setup log file rotation (this should be moved a logrotate recipe)
remote_file "/etc/logrotate.conf" do
  source "logrotate.conf"
end
  
remote_file node['rs_utils']['logrotate_config'] do
  source "logrotate.d.syslog"
end unless node['rs_utils']['logrotate_config'] == nil

# fix/workaround for /var/log/boot.log issue
file "/var/log/boot.log" 

# tag required to activate logging
begin
   right_link_tag "rs_logging:state=active"
 rescue
   log("Failed setting RightScale tag, rs_logging:state=active") { level :debug }
 end