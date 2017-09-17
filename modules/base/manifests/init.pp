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
    $demo_type = 'demo_1'
  }
  elsif $facts['hostname'] == 'agent-02' {
    $demo_type = 'demo_2'
  }
  else {
    warning('This host is not a designated demo_app host.')
  }

  file { '/var/www/html':
    require       => Package['nginx'],
    source        => ['puppet:///modules/base/$demo_type/demo-website.html'],
    notify        => Service['nginx'], # Restart nginx server if being updated
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
