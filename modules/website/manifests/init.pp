# Class website
#

class website {

    file { '/var/www/html/index.html':
      ensure        => 'present',
      owner         => 'www-data',
      group         => 'www-data',
      mode          => '0640',
      source        => ['puppet:///modules/website/demo_1/demo-website.html'],
      notify        => Service['nginx'], # Restart nginx server if being updated
    }
}
