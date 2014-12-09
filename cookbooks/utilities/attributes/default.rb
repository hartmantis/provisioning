# Encoding: UTF-8
#
# Cookbook Name:: utilities
# Attributes:: default
#
# Copyright 2014, Jonathan Hartman
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

default['utilities']['cloud_provider'] = 'digitalocean'
default['utilities']['ssh_key'] = 'provisioning'

default['utilities']['aws'] = {
  'image_id' => 'ami-37501207', # Ubuntu 14.04 x64
  'flavor_id' => 't1.micro', # 0.613GB--smallest possible
  'region' => 'us-west-2',
  'config_file' => ENV['AWS_CONFIG_FILE'],
  'account_id' => ENV['AWS_ACCOUNT_ID'],
  'access_key_id' => ENV['AWS_ACCESS_KEY_ID'],
  'secret_access_key' => ENV['AWS_SECRET_ACCESS_KEY']
}

default['utilities']['digitalocean'] = {
  'image_name' => '14.04 x64',
  'flavor_name' => '512MB',
  'region_name' => 'New York 3',
  'client_id' => ENV['DIGITALOCEAN_CLIENT_ID'],
  'api_key' => ENV['DIGITALOCEAN_API_KEY']
}
