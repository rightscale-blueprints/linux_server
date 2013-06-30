# Cookbook Name:: rightscale
# Recipe:: add_sandbox_to_path
#
# Copyright 2012, Chris Fordham
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# adds path sanity and the rightlink sandbox to ENV['PATH']

r = ruby_block "add rightlink sandbox to path" do
  block do

    # taken from https://github.com/opscode/chef/blob/master/lib/chef/client.rb
    
    SANDBOX_PATHS = %w[/opt/rightscale/sandbox/bin]
    
    def add_sandbox_to_path(env=ENV)
      if Chef::Config[:enforce_path_sanity] && RUBY_PLATFORM !~ /mswin|mingw32|windows/
        existing_paths = env["PATH"].split(':')
        SANDBOX_PATHS.each do |sane_path|
          unless existing_paths.include?(sane_path)
            env_path = env["PATH"].dup
            env_path << ':' unless env["PATH"].empty?
            env_path << sane_path
            env["PATH"] = env_path
          end
        end
      end
    end
    add_sandbox_to_path
  end
  action :nothing
end

r.run_action(:create)