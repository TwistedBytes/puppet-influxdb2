/**
  *
  */
define influxdb2::config::bucket (
  Optional[Enum[present, absent]]  $ensure = 'present',
  Optional[String] $description            = '',
) {

  influxdb2_bucket { $name:
    ensure      => $ensure,
    description => $description
  }

}