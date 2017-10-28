module Dero
  class Configuration
    include Netvice::Configurable
    include Netvice::Dimensionable
    include Netvice::Endpointable

    config_field :environments_only, ['production']
  end
end
