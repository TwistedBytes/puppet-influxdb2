# frozen_string_literal: true

require 'json'
require 'net/http'
require 'puppet/resource_api/simple_provider'

# Implementation for the influxdb2_command type using the Resource API.
class Puppet::Provider::Influxdb2Bucket::Influxdb2Bucket < Puppet::ResourceApi::SimpleProvider
  def set(context, changes)
    context.notice("inspect: #{changes.inspect}")

    changes.each do |name, change|
      is = change[:is].nil? ? { name: name, ensure: 'absent' } : change[:is]
      should = change[:should].nil? ? { name: name, ensure: 'absent' } : change[:should]

      if is[:ensure].to_s == 'absent' && should[:ensure].to_s == 'present'
        context.creating(name) do
          create(context, name, should)
        end
      elsif is[:ensure].to_s == 'present' && should[:ensure].to_s == 'present'
        context.updating(name) do
          update(context, name, is, should)
        end
      elsif is[:ensure].to_s == 'present' && should[:ensure].to_s == 'absent'
        context.deleting(name) do
          delete(context, name, is)
        end
      end
    end
  end

  def organizations()
    command = "influx org list --json"
    output = Puppet::Util::Execution.execute(command).strip
    orgs = JSON.parse(output)

    instances = []
    return [] if orgs.nil?

    orgs.map do |org|
      instances << {
        name: org['name'],
        id: org['id'],
      }
    end
    instances
  end


  def get(context, names = nil)
    context.debug('Returning pre-canned example data')

    instances = []

    organizations.each do |org|
      command = "influx bucket list --org #{org[:name]} --json"
      output = Puppet::Util::Execution.execute(command)
      buckets = JSON.parse(output)

      buckets.map do |item|
        # context.notice("incollect #{org[:name]}  '#{item}'")
        instances << {
          name: item['name'],
          ensure: 'present',
          description: item['description'],
          organization: org[:name],
          retention: item['retentionPeriod'] / 1000000000,
          id: item['id'],
        }
      end
    end
    # context.notice("list '#{orgs}'")
    # context.notice("list '#{instances}'")

    instances
  end

  def create(context, name, should)
    context.notice("Creating '#{name}' with #{should.inspect}")
    command = "influx bucket create --org '#{should[:organization]}' --name '#{should[:name]}' --description '#{should[:description]}' --retention '#{should[:retention]}s'"
    output = Puppet::Util::Execution.execute(command).strip
  end

  def update(context, name, is, should)
    context.notice("update '#{name}', #{is} with #{should.inspect}")
    command = "influx bucket update --json --id '#{is[:id]}' --name '#{should[:name]}' --description '#{should[:description]}' --retention '#{should[:retention]}s'"
    output = Puppet::Util::Execution.execute(command).strip

  end

  def delete(context, name, is )
    context.notice("delete '#{name}', #{is[:id]}")
    command = "influx bucket delete --json --org '#{is[:organization]}' --id '#{is[:id]}' --name '#{is[:name]}'"
    output = Puppet::Util::Execution.execute(command).strip
  end

end
