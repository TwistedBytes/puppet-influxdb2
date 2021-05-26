# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'influxdb2_organization',
  features: [],
  docs: '',
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
    description: {
      type: 'String',
      desc: 'The description of the resource you want to manage.',
    },
    id: {
      type: 'String',
      desc: 'The description of the resource you want to manage.',
      default:  '',
      behaviour: :read_only,
    },
  },
  )
