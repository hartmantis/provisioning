# Encoding: UTF-8
#
# Cookbook Name:: utilities
# Recipe:: digitalocean
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

%w(image_name flavor_name region_name client_id api_key).each do |a|
  if node['utilities']['digitalocean'][a].nil?
    fail('This recipe requires the ' <<
         "`node['utilities']['digitalocean'][#{a}]` attribute")
  end
end

require 'chef/provisioning/fog_driver'

with_driver 'fog:DigitalOcean',
  compute_options: {
    digitalocean_client_id: node['utilities']['digitalocean']['client_id'],
    digitalocean_api_key: node['utilities']['digitalocean']['api_key']
  }

fog_key_pair node['utilities']['ssh_key']

with_machine_options bootstrap_options: {
  key_name: node['utilities']['ssh_key'],
  image_name: node['utilities']['digitalocean']['image_name'],
  flavor_name: node['utilities']['digitalocean']['flavor_name'],
  region_name: node['utilities']['digitalocean']['region_name']
}
