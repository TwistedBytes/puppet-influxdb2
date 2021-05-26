# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'influxdb2_command',
  docs: <<-EOS,
@summary a influxdb2_command type
@example
influxdb2_command { 'foo':
  ensure => 'present',
}

This type provides Puppet with the capabilities to manage ...

EOS
  features: [],
  attributes: {
    ensure: {
      type: 'Enum[present, absent]',
      desc: 'Whether this resource should be present or absent on the target system.',
      default: 'present',
    },
    name: {
      type: 'String',
      desc: 'The name of the resource you want to manage.',
      behaviour: :namevar,
    },
  },
)
