module Netvice
  # Provides the ability to define dynamic attributes, that will be
  # aggregated into a hash. It provides means to add/remove field
  # without the need of database migration.
  module Dimensionable
    DIMS = {}
    TYPES = {}

    def self.included(base)
      base.extend(StaticMethods)
    end

    def self.register_type(mod)
      TYPES[mod.name] = mod
    end

    def dim_instance_name(field_name)
      :"@dimensionable_#{field_name}"
    end

    def set_dim(field_name, value)
      val_cls = value.class
      dim_definition = DIMS[self.class][field_name.to_sym]
      dim_type = dim_definition.as
      dim_mod = dim_definition.implementer

      if value.nil? && !dim_definition.nullable?
        fail Netvice::WrongDimension, "Not-nullable: #{field_name}"
      end

      unless dim_mod.dimable.include?(value.class)
        fail Netvice::WrongDimension, "Instance of #{value.class} is unacceptable as #{dim_type}"
      end

      instance_variable_set(dim_instance_name(field_name), value)
    end

    def get_dim(field_name)
      instance_variable_get(dim_instance_name(field_name))
    end

    def instance_dimensions
      values = {}
      Netvice::Dimensionable::DIMS[self.class].each do |dimension, dim_definition|
        values[dimension] = dim_definition.implementer.dimify(get_dim(dimension))
      end
      values
    end

    def load_dimensions(hash)
      real_values = {}
      hash.each do |field_name, value|
        dim_definition = Netvice::Dimensionable::DIMS[self.class][field_name.to_sym]
        real_value = dim_definition.implementer.undim(value)
        real_values[field_name] = real_value
      end
      set(real_values)
      self
    end

    module StaticMethods
      def dim(field_name, as: :string, nullable: true)
        DIMS[self] = {} unless DIMS[self]
        DIMS[self][field_name] = DimDefinition.new(as: as, nullable: nullable)

        self.class_eval do
          define_method("#{field_name}=") do |value|
            set_dim(field_name, value)
          end

          define_method(field_name) do
            get_dim(field_name)
          end
        end # class_eval
      end # dim
    end # StaticMethods

    class DimDefinition
      include Netvice::Initable
      attr_accessor :as, :nullable

      def nullable?
        nullable
      end

      def implementer
        Netvice::Dimensionable::TYPES[as]
      end
    end # DimDefinition
  end # Dimensionable
end # Netvice

[:array, :boolean, :fixnum, :float, :hash, :string].each do |type|
  # force load of dim types
  require_relative "dimensions/#{type}"
end
