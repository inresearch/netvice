module Netvice
  module Dimensions
    module String
      extend self

      def name
        :string
      end

      def dimable
        [::String, ::NilClass]
      end

      def dimify(value)
        value ? value.to_s : nil
      end

      def undim(value)
        value ? value.to_s : nil
      end
    end
  end
end

Netvice::Dimensionable.register_type(Netvice::Dimensions::String)
