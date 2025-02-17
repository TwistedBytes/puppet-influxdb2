class influxdb2::server::service (
  String $startcommand = '/usr/lib/influxdb',
){

  if $influxdb2::service_enabled {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  tbsystemd::unit_file { '/etc/systemd/system/influxdb.service':
    content => {
      'Service' => {
        'User'               => 'influxdb',
        'Group'              => 'influxdb',

        'EnvironmentFile'    => '-/etc/default/influxdb2',
        'ExecStart'          => $startcommand,
        # 'KillMode' => 'control-group',
        'Restart'            => 'on-failure',
        # 'Type' => 'forking',
        # 'PIDFile' => '/var/lib/influxdb/influxd.pid',
        'StateDirectory'     => 'influxdb',
        'StateDirectoryMode' => '0750',
        'LogsDirectory'      => 'influxdb',
        'LogsDirectoryMode'  => '0750',
        'UMask'              => '0027',
        'TimeoutStartSec'    => '0',

        'LimitNOFILE'        => 65536,
      },
      'Install' => {
        'WantedBy' => 'multi-user.target',
        'Alias'    => 'influxd.service',

      },
    },
  }



  service { $influxdb2::service_name:
    ensure     => $service_ensure,
    enable     => $influxdb2::service_enabled,
    hasrestart => true,
    require    => Package[$influxdb2::package_name],
  }

}
