module Netvice
  module Dimensions
    module Array
      extend self

      def name
        :array
      end

      def dimable
        [::Array, ::NilClass]
      end

      def dimify(value)
        value ? JSON.dump(value) : nil
      end

      def undim(value)
        value ? JSON.parse(dump) : nil
      end
    end
  end
end

Netvice::Dimensionable.register_type(Netvice::Dimensions::Array)
