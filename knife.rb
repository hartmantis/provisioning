# Encoding: UTF-8

local_mode true
chef_zero.enabled true
cache_path File.expand_path('../.chef/.cache', __FILE__)
cookbook_path [
  File.expand_path('../cookbooks', __FILE__),
  File.expand_path('../berks-cookbooks', __FILE__)
]
private_key_write_path File.expand_path('~/.ssh')
