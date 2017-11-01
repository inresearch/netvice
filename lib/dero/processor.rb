module Netvice::Dero::Processor
  extend self

  STRING_MASK = "*********".freeze
  INT_MASK = 0
  REGEX_SPECIAL_CHARS = %w(. $ ^ { [ ( | ) * + ?).freeze

  def has_special_characters?(string)
    REGEX_SPECIAL_CHARS.select { |r| string.include?(r) }.any?
  end

  # determine if the field should be having boundary (not inclusive match)
  # usually used for user-defined additional field
  def use_boundary?(fields, string)
    !fields.include?(string) && !has_special_characters?(string)
  end
end
