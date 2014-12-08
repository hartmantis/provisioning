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

%w(
  AWS_CONFIG_FILE AWS_ACCOUNT_ID AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY
).each do |e|
  fail("This recipe requires the `#{e}` environment variable") if ENV[e].nil?
end

require 'chef/provisioning/aws_driver'
require 'chef/provisioning/fog_driver'

# The AWS driver can currently only read credentials from a file and not
# environment variables.
directory ::File.dirname(ENV['AWS_CONFIG_FILE']) do
  recursive true
end

file ENV['AWS_CONFIG_FILE'] do
  content <<-EOH.gsub(/^ +/, '')
    [default]
    region=us-west-2
    aws_access_key_id=#{ENV['AWS_ACCESS_KEY_ID']}
    aws_secret_access_key=#{ENV['AWS_SECRET_ACCESS_KEY']}
  EOH
  sensitive true
end

with_driver 'aws'

with_data_center 'us-west-2' do
  aws_security_group 'ssh-from-anywhere' do
    inbound_rules [
      { protocol: :tcp, ports: [22], sources: %w(0.0.0.0/0) }
    ]
  end
end

with_driver "fog:AWS:#{ENV['AWS_ACCOUNT_ID']}:us-west-2",
  compute_options: { aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                     aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] }

fog_key_pair node['utilities']['ssh_key']

with_machine_options bootstrap_options: {
  groups: %w(default ssh-from-anywhere),
  key_name: node['utilities']['ssh_key'],
  image_id: 'ami-37501207',
  flavor_id: 't1.micro'
}
