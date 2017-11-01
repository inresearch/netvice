module Netvice
  class Configuration
    include Netvice::Configurable

    config_field :app, nil
    config_field :logger, Logger.new(STDOUT)

    # listing all configurations that's actually used/called somewhere
    USED_CONFIGURERS = []

    def self.configurable(subgem)
      self.class_eval do
        configurer = "#{subgem}_configuration"
        define_method(configurer) do # eg: yuza_configuration
          USED_CONFIGURERS << configurer unless USED_CONFIGURERS.include?(configurer)
          invar = :"@#{configurer}"
          return instance_variable_get(invar) if instance_variable_get(invar) 
          config_class = Object.const_get("Netvice::#{subgem.capitalize}::Configuration")
          instance_variable_set(:"@#{configurer}", config_class.new)
          instance_variable_get(invar)
        end

        define_method(subgem) do |&block|
          block ? send(configurer).instance_eval(&block) : send(configurer)
        end
      end
    end

    configurable :yuza
    configurable :dero

    def reset!
      USED_CONFIGURERS.each do |used_config|
        config = send(used_config)
        Netvice::Configurable::ATTRIBUTES[config.class].each do |field_name, _|
          config.send("reinit_#{field_name}!")
        end
      end
      true
    end
  end # Configuration
end # Netvice::Yuza
