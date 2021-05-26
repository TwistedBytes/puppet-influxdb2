# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'influxdb2_setup',
  docs: <<-EOS,
@summary a influxdb2_setup type
@example
influxdb2_setup { 'foo':
  ensure => 'present',
}

This type provides Puppet with the capabilities to manage ...

EOS
  features: [ 'simple_get_filter' ],
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
    password: {
      type: 'String',
      desc: 'The name of the resource you want to manage.',
      behaviour: :parameter,
      is_sensitive: true,
    },
    organisation: {
      type: 'String',
      desc: 'The name of the resource you want to manage.',
      behaviour: :parameter,
    },
    bucket: {
      type: 'String',
      desc: 'The name of the resource you want to manage.',
      behaviour: :parameter,
    },
    retention: {
      type: 'String',
      desc: 'The name of the resource you want to manage.',
      behaviour: :parameter,
    },
  },
)
