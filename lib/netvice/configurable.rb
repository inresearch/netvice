module Netvice
  module Configurable
    ATTRIBUTES = {}

    def self.included(base)
      base.extend(StaticMethods)
    end

    module StaticMethods
      def config_field(field_name, default)
        ATTRIBUTES[self] = {} unless ATTRIBUTES[self]
        ATTRIBUTES[self][field_name] = {default: default}

        class_eval do
          define_method(field_name) do |*args|
            given_val = args[0]
            instance_name = :"@#{field_name}"
            if args.size.zero?
              instance_variable_get(instance_name)
            else
              instance_variable_set(instance_name, given_val)
            end
          end # define_method
        end # class_eval
      end # config_field
    end # StaticMethods

    def initialize
      return unless ATTRIBUTES[self.class]
      ATTRIBUTES[self.class].each do |field_name, options|
        default = options[:default]
        instance_name = :"@#{field_name}"
        instance_variable_set(instance_name, default)
      end
      setup() if respond_to?(:setup)
    end # initialize

    def config
      Netvice.configuration
    end
  end # Configurable
end # Netvice
