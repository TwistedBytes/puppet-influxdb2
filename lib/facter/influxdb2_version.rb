Facter.add(:influxdb2_version) do
  setcode do
    if Facter::Util::Resolution.which('influxd')

      # InfluxDB 2.0.6 (git: 4db98b4c9a) build_date: 2021-04-29T16:48:12Z
      version_stdout = Facter::Util::Resolution.exec('influx version')
      match = version_stdout.match(%r{[0-9]+\.[0-9]+\.[0-9]+})

      match ? match[0] : nil
    end
  end
end