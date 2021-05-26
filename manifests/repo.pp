class influxdb2::repo {

  case $::osfamily {
    'Debian': {
      class { 'influxdb2::repo::apt': }
    }
    'RedHat': {
      class { 'influxdb2::repo::yum': }
    }
    default: {
      fail("Unsupported managed repository for osfamily: ${::osfamily}, operatingsystem: ${::operatingsystem},\
      module ${module_name} currently only supports managing repos for osfamily RedHat and Debian")
    }
  }
}
