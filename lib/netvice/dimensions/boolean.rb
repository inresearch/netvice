module Netvice
  module Dimensions
    module Boolean
      extend self

      def name
        :boolean
      end

      def dimable
        [::TrueClass, ::FalseClass, ::NilClass]
      end

      def dimify(value)
        case value
        when TrueClass then 1
        when FalseClass then 0
        else nil
        end
      end

      def undim(value)
        value ? (value.to_i == 1) : nil
      end
    end
  end
end

Netvice::Dimensionable.register_type(Netvice::Dimensions::Boolean)
