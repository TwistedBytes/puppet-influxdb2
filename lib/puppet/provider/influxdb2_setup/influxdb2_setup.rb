# frozen_string_literal: true

require 'json'
require 'net/http'
require 'puppet/resource_api/simple_provider'

# Implementation for the influxdb2_command type using the Resource API.
class Puppet::Provider::Influxdb2Setup::Influxdb2Setup < Puppet::ResourceApi::SimpleProvider
  def get(context, names = nil)
    context.debug('Returning pre-canned example data')
    setup_done = issetup

    return [] if setup_done

    names.collect { |name, content|
      {
        name: name,
        ensure: 'present',
      }
    }
  end

  def create(context, name, should)
    command = "influx setup -u #{should[:name]} -p '#{should[:password]}' -b #{should[:bucket]} -o #{should[:organisation]} -r #{should[:retention]} -f --json"
    output = Puppet::Util::Execution.execute(command).strip
  end

  def update(context, name, should)
    # not supported
  end

  def delete(context, name)
    # not supported
  end

  def issetup()
    uri = URI("http://localhost:8086/api/v2/setup")
    http = Net::HTTP.new uri.host, uri.port
    req = Net::HTTP::Get.new uri.request_uri
    response = rest http, req, false

    js = JSON.parse(response.body)
    js['allowed']
  end

  # Perform a REST API request against the indicated endpoint.
  #
  # @return Net::HTTPResponse
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  def rest(http, \
                req, \
                validate_tls = false, \
                timeout = 10
  )

    req['Accept'] = 'application/json'

    http.read_timeout = timeout
    http.open_timeout = timeout
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE unless validate_tls

    begin
      http.request req
    rescue EOFError => e
      # Because the provider attempts a best guess at API access, we
      # only fail when HTTP operations fail for mutating methods.
      unless %w[GET OPTIONS HEAD].include? req.method
        raise Puppet::Error,
              "Received '#{e}' from the Influxdb API. Are your API settings correct?"
      end
    end
  end

  # rubocop:enable Metrics/CyclomaticComplexity
end
