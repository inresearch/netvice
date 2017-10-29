# Handles backtrace parsing line by line. Inspired by Rails, Airbrake, and
# Raven's implementation
class Dero::Kernel::Line
  RB_EXTENSION = ".rb".freeze

  RUBY_INPUT_FORMAT = /
    ^ \s* (?: [a-zA-Z]: | uri:classloader: )? ([^:]+ | <.*>):
    (\d+)
    (?: :in \s `([^']+)')?$
  /x

  JAVA_INPUT_FORMAT = /^(.+)\.([^\.]+)\(([^\:]+)\:(\d+)\)$/

  APP_DIRS_PATTERN = /(bin|exe|app|config|lib|test)/

  attr_reader :file, :number, :method, :module_name

  # Prases a single line of a given backtrace
  # @param [String] unparsed_line The raw line from +caller+ or some backtrace
  # @return [Line] The parsed backtrace line
  def self.parse(unparsed_line)
    ruby_match = unparsed_line.match(RUBY_INPUT_FORMAT)
    if ruby_match
      _, file, number, method = ruby_match.to_a
      file.sub!(/\.class$/, RB_EXTENSION)
      module_name = nil
    else
      java_match = unparsed_line.match(JAVA_INPUT_FORMAT)
      _, module_name, method, file, number = java_match.to_a
    end
    new(file, number, method, module_name)
  end

  def initialize(file, number, method, module_name)
    self.file = file
    self.number = number
    self.method = method
    self.module_name = module_name
  end

  def in_app?
    !(file =~ self.class.in_app_pattern).nil?
  end

  # Reconstructs the line in a readable fashion
  def to_s
    "#{file}:#{number}:in `#{method}'"
  end

  def ==(other)
    to_s == other.to_s
  end

  def self.in_app_pattern
    return @in_app_pattern if @in_app_pattern
    project_root = Netvice.conf.dero.workdir
    @in_app_pattern = Regexp.new("^(#{project_root}/)?#{APP_DIRS_PATTERN}")
  end

  private

  attr_writer :file, :number, :method, :module_name
end
