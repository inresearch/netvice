module Netvice::Dero
  autoload :Configuration, "dero/configuration"
  autoload :StaticMethods, "dero/static_methods"
  autoload :Processor, "dero/processor"
  autoload :Connection, "dero/connection"

  module Kernel
    autoload :Line, "dero/kernel/line"
    autoload :Backtrace, "dero/kernel/backtrace"
  end

  module Processor
    autoload :Cookies, "dero/processor/cookies"
    autoload :HttpHeaders, "dero/processor/http_headers"
    autoload :PostData, "dero/processor/post_data"
    autoload :RemoveCircularReferences, "dero/processor/remove_circular_references"
    autoload :Utf8, "dero/processor/utf8" 
    autoload :SensitiveMasker, "dero/processor/sensitive_masker"
  end

  RuntimeError = Class.new(Netvice::RuntimeError)
  extend Netvice::Dero::Connection
  extend Netvice::Dero::StaticMethods
end
