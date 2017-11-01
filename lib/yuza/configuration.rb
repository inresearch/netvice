class Netvice::Yuza::Configuration
  include Netvice::Configurable
  include Netvice::Dimensionable
  include Netvice::Endpointable

  config_field :reauthenticate_interval, 30
end # Netvice::Yuza::Configuration
