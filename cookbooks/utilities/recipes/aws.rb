# Encoding: UTF-8
#
# Cookbook Name:: utilities
# Recipe:: aws
#
# Copyright 2014, Jonathan Hartman
#
# All rights reserved - Do Not Redistribute
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

%w(config_file account_id access_key_id secret_access_key region).each do |a|
  if node['utilities']['aws'][a].nil?
    fail("This recipe requires the `node['utilities']['aws']['#{a}']` " <<
         'attribute')
  end
end

require 'chef/provisioning/aws_driver'
require 'chef/provisioning/fog_driver'

# The AWS driver can currently only read credentials from a file and not
# environment variables.
directory ::File.dirname(node['utilities']['aws']['config_file']) do
  recursive true
end

file node['utilities']['aws']['config_file'] do
  content <<-EOH.gsub(/^ +/, '')
    [default]
    aws_access_key_id=#{node['utilities']['aws']['access_key_id']}
    aws_secret_access_key=#{node['utilities']['aws']['secret_access_key']}
  EOH
  sensitive true
end

with_driver 'aws'

aws_security_group 'ssh-from-anywhere' do
  inbound_rules [
    { protocol: :tcp, ports: [22], sources: %w(0.0.0.0/0) }
  ]
end

region = node['utilities']['aws']['region']
with_driver "fog:AWS:#{node['utilities']['aws']['account_id']}:#{region}",
  compute_options: {
    aws_access_key_id: node['utilities']['aws']['access_key_id'],
    aws_secret_access_key: node['utilities']['aws']['secret_access_key']
  }

fog_key_pair node['utilities']['ssh_key']

with_machine_options bootstrap_options: {
  groups: %w(default ssh-from-anywhere),
  key_name: node['utilities']['ssh_key'],
  image_id: node['utilities']['aws']['image_id'],
  flavor_id: node['utilities']['aws']['flavor_id']
}
