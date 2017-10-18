module Netvice
  module Inspector
    def inspector(fields=[])
      fields_str = ""
      fields.each do |field|
        field_val = send(field)
        fields_str << " #{field}=#{field_val}" if field_val
      end

      "#<#{self.class}#{fields_str}>"
    end
  end
end
