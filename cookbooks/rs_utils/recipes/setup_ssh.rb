# Cookbook Name:: rs_utils
# Recipe:: setup_ssh
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

log "Install private SSH key."

unless node.has_key? :rs_utils and node.rs_utils.has_key? :private_ssh_key and !(node.rs_utils.private_ssh_key.nil? or node.rs_utils.private_ssh_key.empty?)
  # remove existing key if set to '' (empty)
  if !node.rs_utils.private_ssh_key.nil? and node.rs_utils.private_ssh_key.empty?
    unless !File.exist?('/root.ssh/id_rsa')
      log 'Empty private SSH key provided, removing key.'
      File.delete('/root.ssh/id_rsa')
    else
      log 'No existing private SSH key, skipping removal.'
    end
  else
    log "No private SSH key provided, skipping."
  end
  return
end

directory "/root/.ssh" do
  recursive true
end

log "Copying key to /root/.ssh/id_rsa."

template "/root/.ssh/id_rsa" do
  source "id_rsa.erb"
  mode 0600
  variables(
    :private_ssh_key => "#{node.rs_utils.private_ssh_key}"
  )
end