# Many Ruby JSON implementations will throw exceptions if data is
# not in a consistent UTF-8 format. THis processor looks for invalid
# encodings and fixes them
module Dero::Processor::Utf8
  extend self

  # slightly misnamed -- actually its purpose is to remove any bytes with
  # invalid encoding.
  REPLACEMENT = "".freeze

  def process!(value)
    case value
    when Hash
      !value.frozen? ?
        value.merge!(value) { |_, v| process! v } :
        value.merge(value) { |_, v| process! v }
    when Array
      !value.frozen? ?
        value.map! { |v| process! v } :
        value.map { |v| process! v }
    when String
      # Encoding::BINARY (Encoding::ASCII_8BIT) is a special binary encoding.
      # valid_encoding? will always return true because it contains all
      # codepoints, so instead we check if it only contains actual ASCII
      # codepoints, and if not we assume it's actually just UTF8 and scrub
      # accordingly
      if value.encoding == Encoding::BINARY && !value.ascii_only?
        value = value.dup
        value.force_encoding(Encoding::UTF_8)
      end
      return value if value.valid_encoding?
      remove_invalid_bytes(value)
    else
      value
    end
  end

  private

  def remove_invalid_bytes(string)
    if String.method_defined?(:scrub!)
      string.scrub!(REPLACEMENT)
    else
      string.chars.map do |char|
        char.valid_encoding? ? char : REPLACEMENT
      end.join
    end
  end # remove_invalid_bytes
end # Utf8
