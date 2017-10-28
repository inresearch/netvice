require "yuza/configuration"

module Netvice
  class Configuration
    include Netvice::Configurable

    config_field :app, nil
    config_field :logger, Logger.new(STDOUT)

    def self.configurable(subgem)
      self.class_eval do
        configurer = "#{subgem}_configuration"
        define_method(configurer) do # eg: yuza_configuration
          invar = :"@#{configurer}"
          return instance_variable_get(invar) if instance_variable_get(invar) 
          instance_variable_set(:"@#{configurer}", Yuza::Configuration.new)
          instance_variable_get(invar)
        end

        define_method(subgem) do |&block|
          block ? send(configurer).instance_eval(&block) : send(configurer)
        end
      end
    end

    configurable :yuza
    configurable :dero
  end # Configuration
end # Yuza
