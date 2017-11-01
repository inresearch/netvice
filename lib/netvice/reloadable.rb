module Netvice
  module Reloadable
    include Netvice::Settable

    def self.included(base)
      base.extend(StaticMethods)
    end

    def reload!
      resource = self.class.send(
        "where_#{self.class.reloadable_by_index_field}",
        send(self.class.reloadable_by_index_field)
      )

      set(resource.to_h)
    end

    module StaticMethods
      def reloadable_by(field_name)
        @reloadable_by = field_name
      end

      def reloadable_by_index_field
        @reloadable_by || :id
      end
    end
  end # Reloadable
end # Netvice::Yuza
