node default {
  class { 'sensu':
    # Server config
    rabbitmq_password => 'd2fj2h02FG83dh2A0hd',
    server            => true,
    dashboard         => true,
    api               => true,
    plugins           => [
      'puppet:///data/sensu/plugins/ntp.rb',
      'puppet:///data/sensu/plugins/postfix.rb'
    ],
    # Client config
    subscriptions      => 'sensu-test',
    rabbitmq_host      => 'localhost',
  }

  sensu::handler { 'default':
    command => 'mail -s \'sensu alert\' ops@foo.com',
  }

  sensu::check { 'check_ntp':
    command     => 'PATH=$PATH:/usr/lib/nagios/plugins check_ntp_time -H pool.ntp.org -w 30 -c 60',
    handlers    => 'default',
    subscribers => 'sensu-test'
  }
  
  class { '::rabbitmq':
    delete_guest_user => true,
  }
  
  rabbitmq_user { 'sensu':
    password => 'd2fj2h02FG83dh2A0hd',
  }
}
