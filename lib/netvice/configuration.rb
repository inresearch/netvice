require "yuza/configuration"

module Netvice
  class Configuration
    include Netvice::Configurable

    config_field :app, nil
    config_field :logger, Logger.new(STDOUT)

    def setup
      @yuza_configuration = Yuza::Configuration.new
    end

    def yuza(&block)
      if block_given?
        @yuza_configuration.instance_eval(&block)
      else
        @yuza_configuration
      end
    end
  end # Configuration
end # Yuza
