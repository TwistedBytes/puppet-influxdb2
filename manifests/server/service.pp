class influxdb2::server::service {

  if $influxdb2::service_enabled {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  service { $influxdb2::service_name:
    ensure     => $service_ensure,
    enable     => $influxdb2::service_enabled,
    hasrestart => true,
    require    => Package[$influxdb2::package_name],
  }

}
