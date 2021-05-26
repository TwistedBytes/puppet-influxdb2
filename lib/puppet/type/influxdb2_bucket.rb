# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'influxdb2_bucket',
  features: ['simple_get_filter'],
  docs: '',
  title_patterns: [
    {
      pattern: %r{^(?<organization>.*[^-])-(?<name>.*)$},
      desc: 'Where the package and the manager are provided with a hyphen seperator',
    },
    {
      pattern: %r{^(?<name>.*)$},
      desc: 'Where only the name is provided',
    }
  ],
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
    organization: {
      type: 'String',
      desc: 'The name of the organization',
      default: "default",
      behaviour: :namevar,
    },
    description: {
      type: 'String',
      desc: 'The description of the resource you want to manage.',
    },
    retention: {
      type: 'Integer',
      desc: 'Duration bucket will retain data in seconds. 0 is infinite. Default is 7 days',
      default: 7 * 86400,
    },
    id: {
      type: 'String',
      desc: 'The description of the resource you want to manage.',
      default:  '',
      behaviour: :read_only,
    },
  },
)
