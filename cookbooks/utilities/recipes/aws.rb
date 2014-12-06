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

%w(AWS_ACCOUNT_ID AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY).each do |e|
  fail("This recipe requires the `#{e}` environment variable") if ENV[e].nil?
end

require 'chef/provisioning/fog_driver'

with_driver "fog:AWS:#{ENV['AWS_ACCOUNT_ID']}:us-west-2",
  compute_options: { aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                     aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] }

fog_key_pair 'personal-rsa' do
  public_key_path File.expand_path('~/.ssh/id_rsa.pub')
  private_key_path File.expand_path('~/.ssh/id_rsa')
end

with_machine_options bootstrap_options: { key_name: 'personal-rsa',
                                          image_id: 'ami-37501207',
                                          flavor_id: 't1.micro' }
