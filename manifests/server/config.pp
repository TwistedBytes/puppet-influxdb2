class influxdb2::server::config (

) {
  require ::influxdb2

  file { $influxdb2::config_path:
    ensure  => directory,
    purge   => true,
    recurse => true,
    force   => true,
    owner  => $influxdb2::influxdb_user,
    group  => $influxdb2::influxdb_group,
    mode   => '0700',
  }

  # yaml file, this is easier with automatic quoting / not quoting of string or integer
  file { $influxdb2::config_file:
    ensure  => $influxdb2::ensure,
    content => epp($influxdb2::conf_template, {
      config_options => $influxdb2::default_config_options + $influxdb2::config_options,
    }),
    owner   => $influxdb2::influxdb_user,
    group   => $influxdb2::influxdb_group,
    mode    => '0644',
    notify  => Service[$influxdb2::service_name],
  }

  file { '/etc/default/influxdb2':
    ensure  => $influxdb2::ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp("${module_name}/influxdb_default.epp", {
      config_path => $influxdb2::config_path
    }),
    notify  => Service[$influxdb2::service_name],
  }

}
