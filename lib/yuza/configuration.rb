module Yuza
  class Configuration
    include Netvice::Configurable
    include Netvice::Dimensionable

    config_field :host, 'http://localhost'
    config_field :port, 2000
    config_field :timeout, 10
    config_field :reauthenticate_interval, 30

    def base_url
      base_url = host
      base_url = "#{base_url}:#{port}" if port
      base_url
    end

    def user_agent
      "Netinmax" + (config.app ? ":#{config.app}" : "")
    end    
  end # Configuration
end # Yuza
