class Netvice::Dero::Kernel::Backtrace
  attr_reader :lines

  def self.parse(backtrace, opts = {})
    ruby_lines = backtrace.is_a?(Array) ? backtrace : backtrace.split(/\n\s*/)

    filters = opts[:filters] || []
    filtered_lines = ruby_lines.to_a.map do |line|
      filters.reduce(line) do |nested_line, proc|
        proc.call(nested_line)
      end
    end.compact

    lines = filtered_lines.map do |unparsed_line|
      Netvice::Dero::Kernel::Line.parse(unparsed_line)
    end

    new(lines)
  end

  def initialize(lines)
    self.lines = lines
  end

  def to_s
    content = []
    lines.each { |line| content << line }
    content.join("\n")
  end

  def ==(other)
    if other.respond_to?(:lines)
      lines == other.lines
    else
      false
    end
  end

  private
  
  attr_writer :lines
end
