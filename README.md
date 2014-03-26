utilities-metal
===============

Chef-metal definitions for my personal utilities server(s)

Usage
-----
Install all the dependencies with Berkshelf and run Chef Metal:

    bundle exec berks install
    bundle exec chef-client -z -o \
        utilities-metal::digitalocean,utilities-metal::machines
