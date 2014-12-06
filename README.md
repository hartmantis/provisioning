Provisioning
============

Chef-Provisioning definitions for my personal utilities server(s)

Usage
-----
Install all the dependencies with Berkshelf and run Chef:

    bundle exec berks vendor
    bundle exec chef-client -c knife.rb -o utilities::default

To Do
-----
* Set up DNS for every machine
    * Is there a Namecheap gem that's not abandoned?
* Add some shortcut rake tasks
    * berks vendor
    * chef-client -o utilities::...
