# PRIVATE CLASS: do not use directly
class influxdb2::server::install {
  require ::influxdb2

  Exec {
    path => '/usr/bin:/bin',
  }

  if $influxdb2::manage_repos {
    require ::influxdb2::repo
  }

  if $influxdb2::manage_install {
    if $influxdb2::ensure == 'absent' {
      $_ensure = $influxdb2::ensure
    } else {
        $_ensure = $influxdb2::version
    }

    package { $influxdb2::package_name:
      ensure => $_ensure,
      tag    => 'influxdb2',
    }
  }
}
