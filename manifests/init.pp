# == Class: influxdb2
#
class influxdb2 (

  $version                     = 'installed',
  $ensure                      = 'present',
  $service_enabled             = true,
  $service_name                = 'influxdb',
  $package_name                = 'influxdb2',
  $manage_install              = true,

  $conf_template               = "${module_name}/config.toml.epp",
  $config_path                 = '/etc/influxdb',
  # yaml because of easy string/integer quotation
  $config_file                 = '/etc/influxdb/config.yaml',

  Hash $default_config_options = {
    'bolt-path'         => '/var/lib/influxdb/influxd.bolt',
    'engine-path'       => '/var/lib/influxdb/engine',
    'query-concurrency' => 30,
  },

  # see https://docs.influxdata.com/influxdb/v2.0/reference/config-options/ for all options
  # use the "Configuration key" naming
  Hash $config_options         = {
    'query-concurrency' => 20,
  },

  $reporting_disabled          = false,

  $influxdb_user               = 'influxdb',
  $influxdb_group              = 'influxdb',


) {
  require ::resource_api

  case $::osfamily {
    'Debian', 'RedHat', 'Amazon': {
      $manage_repos = true
    }
    'Archlinux': {
      $manage_repos = false
    }
    default: {
      fail("Unsupported managed repository for osfamily: ${::osfamily}, operatingsystem: ${::operatingsystem},\
      module ${module_name} currently only supports managing repos for osfamily RedHat, Debian and Archlinux")
    }
  }

  class { 'influxdb2::server::install': } ->
  class { 'influxdb2::server::config': } ->
  class { 'influxdb2::server::service': }

}
