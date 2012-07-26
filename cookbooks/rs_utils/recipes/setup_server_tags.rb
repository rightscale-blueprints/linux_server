# Cookbook Name:: rs_utils
# Recipe:: setup_server_tags
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

log "Setup RightScale tags."

unless (node.has_key? :rightscale and node.has_key? :cloud)
  log 'Not attached to RightScale, skipping tags setup.'
  return
end

# RightScale unique identifier
log "Adding server tag for UUID #{node['rightscale']['instance_uuid']}."
begin
  right_link_tag "server:uuid=#{node['rightscale']['instance_uuid']}" if defined?(RightScale)
rescue
  log("Failed setting RightScale tag, server:uuid=#{node['rightscale']['instance_uuid']}") { level :debug }
end

# these are cloud-dependent (and on supported clouds only, TODO generics)
# Add a tag for each private IP address
i=0
while node['cloud']['private_ips'] && node.cloud.private_ips[i] do 
  ip = node['cloud']['private_ips'][i]
  log "Adding private ip tag for ip address #{ip}."
  begin
    right_link_tag "server:private_ip_#{i}=#{ip}" if defined?(RightScale) if defined?(RightScale)
  rescue
    log("Failed setting RightScale tag, server:private_ip_#{i}=#{ip}") { level :debug }
  end
  i += 1
end
# Add a tag for each public IP address
i=0
while node['cloud']['public_ips'] && node['cloud']['public_ips'][i] do 
  ip = node['cloud']['public_ips'][i]
  log "Adding public ip tag for ip address #{ip}."
  begin
    right_link_tag "server:public_ip_#{i}=#{ip}"
  rescue
    log("Failed setting RightScale tag, server:public_ip_#{i}=#{ip}") { level :debug }
  end
  i += 1
end

# for future versions which can use system chef and not sandbox (ohai resource might need reload in rs; tested not working in rl 5.6)
#right_link_tag "node:lsb_description=#{node['lsb']['description'].gsub(' ', '_')}"
#right_link_tag "node:chef_version=#{node['chef_packages']['chef']['version']}"