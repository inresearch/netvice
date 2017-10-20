module Netvice
  module Dimensions
    module Fixnum
      extend self

      def name
        :fixnum
      end

      def dimable
        [::Fixnum, ::Float, ::NilClass]
      end

      def dimify(value)
        value ? value.to_i.to_s : nil
      end

      def undim(value)
        value ? Integer(value) : nil
      end
    end
  end
end

Netvice::Dimensionable.register_type(Netvice::Dimensions::Fixnum)
