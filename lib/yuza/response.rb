module Netvice::Yuza
  class Response
    include Netvice::Initable
    attr_accessor :success, :reason

    def success?
      success
    end
  end
end
