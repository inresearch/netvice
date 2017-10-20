module Netvice
  module Dimensions
    module Hash
      extend self

      def name
        :hash
      end

      def dimable
        [::Hash, ::NilClass]
      end

      def dimify(value)
        value ? JSON.dump(value) : nil
      end

      def undim(value)
        value ? JSON.parse(value) : nil
      end
    end
  end
end

Netvice::Dimensionable.register_type(Netvice::Dimensions::Hash)
