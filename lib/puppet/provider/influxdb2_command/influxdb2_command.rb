# frozen_string_literal: true

require 'puppet/resource_api/simple_provider'

# Implementation for the influxdb2_command type using the Resource API.
class Puppet::Provider::Influxdb2Command::Influxdb2Command < Puppet::ResourceApi::SimpleProvider
  def get(context)
    context.debug('Returning pre-canned example data')
    [
      {
        name: 'foo',
        ensure: 'present',
      },
      {
        name: 'bar',
        ensure: 'present',
      },
    ]
  end

  def create(context, name, should)
    context.notice("Creating '#{name}' with #{should.inspect}")
    output = Puppet::Util::Execution.execute("hostname").strip

    context.notice("Creating '#{output}'")
  end

  def update(context, name, should)
    context.notice("Updating '#{name}' with #{should.inspect}")
  end

  def delete(context, name)
    context.notice("Deleting '#{name}'")
  end
end
