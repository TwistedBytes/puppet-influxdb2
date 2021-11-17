class influxdb2::client (
  $ensure         = "installed",
  $package_name   = 'influxdb2-cli',
  $manage_install = true,
  $manage_repos   = true,
) {

  Exec {
    path => '/usr/bin:/bin',
  }

  if $manage_repos {
    require ::influxdb2::repo
  }

  if $manage_install {
    package { $package_name:
      ensure => $ensure,
      tag    => 'influxdb2',
    }
  }
}
