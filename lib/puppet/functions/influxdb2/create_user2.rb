# frozen_string_literal: true

# https://github.com/puppetlabs/puppet-specifications/blob/master/language/func-api.md#the-4x-api
Puppet::Functions.create_function(:"influxdb2::create_user2") do
  dispatch :create_user2 do
    param 'Numeric', :a
    return_type 'Numeric'
  end
  # the function below is called by puppet and and must match
  # the name of the puppet function above. You can set your
  # required parameters below and puppet will enforce these
  # so change x to suit your needs although only one parameter is required
  # as defined in the dispatch method.
  def create_user2(x)
    x * 2
  end

  # you can define other helper methods in this code block as well
end
