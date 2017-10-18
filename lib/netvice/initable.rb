module Netvice
  module Initable
    include Netvice::Settable
    def initialize(states = {})
      set(states)
      after_initialize(states)
    end

    def after_initialize(states={})
    end
  end # Initable
end # Netvice
