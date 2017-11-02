module Netvice
  module Endpointable
    def self.included(base)
      base.class_eval do
        include Netvice::Configurable

        config_field(:host, 'http://localhost') do |val|
          val.end_with?('/') ? val[0..-2] : val
        end
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
      "netvice #{Netvice::VERSION}" + (config.app ? "/#{config.app}" : "")
    end    
  end
end
