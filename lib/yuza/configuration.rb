class Netvice::Yuza::Configuration
  include Netvice::Configurable
  include Netvice::Dimensionable
  include Netvice::Endpointable

  config_field :reauthenticate_interval, 30

  # secret is very sensitive, it shouldn't be revealed. should be kept in backend
  # and if possible be kept through environment variable, and if possible is
  # rotated every month, weeks, or days
  config_field :secret, 'YOUR-YUZA-SECRET-TOKEN'
end # Netvice::Yuza::Configuration
