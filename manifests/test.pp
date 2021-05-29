class influxdb2::test (
) {

  influxdb2_command { "foo": }

  influxdb2_setup { "admin":
    ensure       => 'present',
    password     => "test1234",
    organisation => "default",
    bucket       => "default",
    retention    => "12h",
  }

  influxdb2_organization { "test3":
    ensure      => 'present',
    description => "test3 test2"
  }

  influxdb2_organization { "test4":
    ensure      => 'present',
    description => "test3 test1"
  }

  influxdb2_bucket { "test2-test4":
    ensure      => 'present',
    description => "test3 test1"
  }

  influxdb2_bucket { "default-test3":
    ensure      => 'present',
    description => "test3 test1"
  }

  influxdb2_bucket { "default-test5":
    ensure      => 'present',
    description => "test3 test1",
    retention   => 76400,
  }

}