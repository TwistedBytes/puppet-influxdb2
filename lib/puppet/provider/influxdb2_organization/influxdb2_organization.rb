# frozen_string_literal: true

require 'json'
require 'net/http'
require 'puppet/resource_api/simple_provider'

# Implementation for the influxdb2_command type using the Resource API.
class Puppet::Provider::Influxdb2Organization::Influxdb2Organization < Puppet::ResourceApi::SimpleProvider
  def set(context, changes)
    changes.each do |name, change|
      is = change[:is].nil? ? { name: name, ensure: 'absent' } : change[:is]
      should = change[:should].nil? ? { name: name, ensure: 'absent' } : change[:should]

      if is[:ensure].to_s == 'absent' && should[:ensure].to_s == 'present'
        context.creating(name) do
          create(context, name, should)
        end
      elsif is[:ensure].to_s == 'present' && should[:ensure].to_s == 'present'
        context.updating(name) do
          update(context, name, is[:id], should)
        end
      elsif is[:ensure].to_s == 'present' && should[:ensure].to_s == 'absent'
        context.deleting(name) do
          delete(context, name, is[:id])
        end
      end
    end
  end

  def get(context, names = nil)
    context.debug('Returning pre-canned example data')

    command = "influx org list --json"
    output = Puppet::Util::Execution.execute(command).strip
    orgs = JSON.parse(output)

    instances = []
    return [] if orgs.nil?


    orgs.map do |org|
      # context.notice("incollect '#{org}'")
      instances << {
        name: org['name'],
        ensure: 'present',
        description: org['description'],
        id: org['id'],
      }
    end

    # context.notice("list '#{orgs}'")
    # context.notice("list '#{instances}'")

    instances
  end

  def create(context, name, should)
    context.notice("Creating '#{name}' with #{should.inspect}")
    command = "influx org create --json --name '#{should[:name]}' --description '#{should[:description]}'"
    output = Puppet::Util::Execution.execute(command).strip
  end

  def update(context, name, id, should)
    context.notice("update '#{name}', #{id} with #{should.inspect}")
    command = "influx org update --json --id '#{id}' --name '#{should[:name]}' --description '#{should[:description]}'"
    output = Puppet::Util::Execution.execute(command).strip

  end

  def delete(context, name, id )
    context.notice("delete '#{name}', #{id}")
    command = "influx org delete --json --id '#{id}'"
    output = Puppet::Util::Execution.execute(command).strip
  end

end
