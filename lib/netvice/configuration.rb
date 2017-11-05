module Netvice
  class Configuration
    include Netvice::Configurable

    attr_reader :configurers

    config_field(:app, nil) do |val|
      Netvice::Yuza::Connection.class_variable_set(:@@http_conn, nil)
      Netvice::Dero::Connection.class_variable_set(:@@http_conn, nil)
      val
    end

    config_field :logger, -> {defined?(Rails.logger) ? Rails.logger : Logger.new(STDOUT)}

    def self.configurable(subgem)
      self.class_eval do
        configurer = "#{subgem}_configuration"
        define_method(configurer) do # eg: yuza_configuration
          invar = :"@#{configurer}"
          return instance_variable_get(invar) if instance_variable_get(invar) 
          config_class = "Netvice::#{subgem.capitalize}::Configuration"
          config_class = Object.const_get(config_class)
          config_instance = config_class.new
          @configurers[config_class] = config_instance
          instance_variable_set(:"@#{configurer}", config_instance)
          instance_variable_get(invar)
        end

        define_method(subgem) do |&block|
          block ? send(configurer).instance_eval(&block) : send(configurer)
        end
      end
    end

    configurable :yuza
    configurable :dero

    def initialize
      @configurers = {}
      @configurers[self.class] = self
      reset!
    end

    def reset!
      Netvice::Configurable::ATTRIBUTES.each do |config_class, config_definition|
        configuration = configurers[config_class]
        if configuration
          config_definition.keys.each do |config_field|
            reset_method = "reset_#{config_field}!"
            configuration.send(reset_method)
          end
        end
      end
      true
    end
  end # Configuration
end # Netvice::Yuza
