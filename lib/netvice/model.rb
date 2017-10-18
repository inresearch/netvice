module Netvice
  class Model
    include Netvice::Inspector
    include Netvice::Initable
    include Netvice::Timestampable
    include Netvice::Reloadable
  end
end
