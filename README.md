memcached
=========

A Perl test for connection to memcached service with perl.

on the scripts folder, you can find scrips to run memcached as a service. This script was tested in CentOS.

References:
  http://duntuk.com/how-install-memcached-centos-memcached-php-extension-centos
  https://www.lullabot.com/blog/article/installing-memcached-redhat-or-centos
    
Destinations:
  scripts/memcached -> /etc/init.d/
  scripts/start-memcached -> /usr/local/lib/
  
And configure memcached as service
  $ chkconfig memcached on
 
Test that all is ok:
  $ telnet localhost 11211
  
If everithing is ok, you will connect without problems.
