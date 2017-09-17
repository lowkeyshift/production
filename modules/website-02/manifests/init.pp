# Class website-02
#

class website-02 {

    file { '/var/www/html/index.html':
      ensure        => 'present',
      owner         => 'www-data',
      group         => 'www-data',
      mode          => '0640',
      source        => ['puppet:///modules/website/demo_2/demo-website.html'],
      notify        => Service['nginx'], # Restart nginx server if being updated
    }
}
