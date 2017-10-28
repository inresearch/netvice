module Netvice
  module Endpointable
    def self.included(base)
      base.class_eval do
        config_field :host, 'http://localhost'
        config_field :port, 2000
        config_field :timeout, 10
      end
    end

    def base_url
      base_url = host
      base_url = "#{base_url}:#{port}" if port
      base_url
    end

    def user_agent
      "Netinmax" + (config.app ? ":#{config.app}" : "")
    end    
  end
end
