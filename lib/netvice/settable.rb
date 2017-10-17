module Netvice
  module Settable
    def set(states={})
      unless states.is_a?(Hash)
        fail ArgumentError, "Expecting a hash got: #{states} (#{states.class})"
      end

      states.each do |field, value|
        setter = "#{field}="
        if respond_to?(setter)
          send(setter, value)
        end
      end
    end # set
  end # Settable
end # Netvice
