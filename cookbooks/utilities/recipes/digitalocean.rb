# Encoding: UTF-8
#
# Cookbook Name:: utilities-metal
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

require 'chef_metal'
require 'chef_metal/fog'

with_fog_provisioner(
  provider: 'DigitalOcean',
  digitalocean_client_id: ENV['DIGITALOCEAN_CLIENT_ID'],
  digitalocean_api_key: ENV['DIGITALOCEAN_API_KEY']
)

fog_key_pair 'personal-rsa' do
  public_key_path File.expand_path('~/.ssh/id_rsa.pub')
  private_key_path File.expand_path('~/.ssh/id_rsa')
end
