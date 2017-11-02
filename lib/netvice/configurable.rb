module Netvice
  # Make it easy to define configurable fields (used for configuration dsl)
  module Configurable
    # listing all configurations that's actually used/called somewhere
    ATTRIBUTES = {}

    def self.included(base)
      base.extend(StaticMethods)
    end

    module StaticMethods
      def config_field(field_name, default=nil)
        field_name = field_name.to_sym
        ATTRIBUTES[self] = {} unless ATTRIBUTES[self]
        ATTRIBUTES[self][field_name] = {default: default}

        class_eval do
          # define field name that will return the config field value if no
          # arg is given. if there is arg, it will set the value. if the arg
          # is given with block, the value received will be yielded back for
          # further manipulation before it's set.
          define_method(field_name) do |*args|
            given_val = args[0]
            instance_name = :"@#{field_name}"
            if args.size.zero?
              instance_variable_get(instance_name)
            else
              if block_given?
                given_val = yield given_val
              end
              instance_variable_set(instance_name, given_val)
            end
          end # configuration field definition

          # init field name to its default value
          define_method("reset_#{field_name}!") do
            if ATTRIBUTES[self.class]
              field_config = ATTRIBUTES[self.class][field_name]
              default = field_config[:default]
              default = default.() if default.is_a?(Proc)
              send(field_name, default)
              return true
            end
            false
          end # reset
        end # class_eval
      end # config_field
    end # StaticMethods

    def initialize
      return unless ATTRIBUTES[self.class]
      ATTRIBUTES[self.class].each do |field_name, _|
        send("reset_#{field_name}!")
      end
      setup()
    end # initialize

    def setup
    end

    def config
      Netvice.configuration
    end
  end # Configurable
end # Netvice
