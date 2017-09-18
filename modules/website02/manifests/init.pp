# Class website02
#

class website02 {

    file { '/var/www/html/index.html':
      ensure => 'present',
      owner  => 'www-data',
      group  => 'www-data',
      mode   => '0640',
      source => ['puppet:///modules/website02/demo_2/demo-website.html'],
      notify => Service['nginx'], # Restart nginx server if being updated
    }
}
