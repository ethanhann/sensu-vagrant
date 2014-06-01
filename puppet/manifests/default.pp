node default {
  include '::apt'

# Sensu
  package { 'sensu-plugin':
    ensure   => 'installed',
    provider => 'gem',
  }

  class { 'sensu':
  # Server config
    rabbitmq_password => 'd2fj2h02FG83dh2A0hd',
    server            => true,
    dashboard         => true,
    api               => true,
  # Client config
    subscriptions     => 'sensu-test',
    rabbitmq_host     => 'localhost',
    client_name       => 'sensu-client',
    require           => [Class['::rabbitmq'], Class['redis'], Package['sensu-plugin']],
  }

# Rabbit MQ
  class { '::rabbitmq':
    delete_guest_user => true,
  }

  rabbitmq_vhost { '/sensu':
    ensure  => present,
    require => Class['::rabbitmq'],
  }

  rabbitmq_user { 'sensu':
    admin    => true,
    password => 'd2fj2h02FG83dh2A0hd',
    require  => Class['::rabbitmq'],
  }

  rabbitmq_user_permissions { 'sensu@/sensu':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
    require              => Class['::rabbitmq'],
  }

# Redis
  class { 'redis': }
}
