module Netvice
  module Dimensions
    module Float
      extend self

      def name
        :float
      end

      def dimable
        [::Float, ::Fixnum, ::NilClass]
      end

      def dimify(value)
        value ? value.to_s : nil
      end

      def undim(value)
        value ? Float(value) : nil
      end
    end
  end
end

Netvice::Dimensionable.register_type(Netvice::Dimensions::Float)
