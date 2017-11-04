module Netvice
  class ConnectionPipeline
    include Netvice::Inspector
    include Netvice::Initable

    attr_accessor :name, :path_proc, :body_proc
    attr_accessor :for

    def after_initialize(states={})
      @path_proc = -> (path) {path} unless @path_proc
      @body_proc = -> (body) {body} unless @body_proc
      @for = %i[get patch post delete] unless @for
      @for.map!(&:to_sym)
    end

    def inspect
      inspector([:name])
    end

    def call(path, body)
      [path_proc.(path), body_proc.(body)]
    end

    def for_method?(method)
      method = method.to_s.downcase.to_sym unless method.is_a?(Symbol)
      @for.include?(method)
    end
  end
end
