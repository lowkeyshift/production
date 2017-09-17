#Class: base
#
class base {

  $base_packages = ['openssh-client', 'openssh-server']

  Package {
    ensure        => present,
  }

  package { $base_packages: }
  package { 'nginx': }

  File {
    ensure        => 'present',
    owner         => 'www-data',
    group         => 'www-data',
    mode          => '0640',
  }

  file { '/etc/nginx/sites-available/default':
    require       => Package['nginx'],
    content       => epp('base/nginx/default.epp'),
    notify        => Service['nginx'], # Restart nginx server if being updated
  }

  if $facts['hostname'] == 'agent-01' {

    file { '/var/www/html/index.html':
      require       => Package['nginx'],
      source        => ['puppet:///modules/base/demo_1/demo-website.html'],
      notify        => Service['nginx'], # Restart nginx server if being updated
    }
    file { '/var/www/html/images':
      ensure        => directory,
      notify        => Service['nginx'], # Restart nginx server if being updated
    }
    file { '/var/www/html/images/ny-sidewalk.jpg':
      ensure        => present,
      notify        => Service['nginx'], # Restart nginx server if being updated
    }
  }
  elsif $facts['hostname'] == 'agent-02' {

    file { '/var/www/html/index.html':
      require       => Package['nginx'],
      source        => ['puppet:///modules/base/demo_2/demo-website.html'],
      notify        => Service['nginx'], # Restart nginx server if being updated
    }
  }
  else {
    warning('This host is not a designated demo_app host.')
  }



  file { '/etc/ssh/sshd_config':
    require       => Package[ $ssh_packages ],
    source        => ['puppet:///modules/base/ssh/sshd_config'],
    notify        => Service['ssh'], # Restart ssh server if being updated
  }

  service { 'nginx':
    ensure        => running,
    enable        => true,
  }

  service { 'ssh':
    ensure        => running,
    enable        => true,
    hasstatus     => true,
    hasrestart    => true,
  }

}
