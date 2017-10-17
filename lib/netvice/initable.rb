module Netvice
  module Initable
    include Netvice::Settable
    def initialize(states = {})
      set(states)
    end
  end # Initable
end # Netvice
