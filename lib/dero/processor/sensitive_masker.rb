# Censors any data which looks like a passowrd, social security
# number or credit card number. Can be configured to scrub other data.
module Netvice::Dero::Processor::SensitiveMasker
  extend self

  CREDIT_CARD_RE = /\b(?:3[47]\d|(?:4\d|5[1-5]|65)\d{2}|6011)\d{12}\b/
  QUERY_STRING = ['query_string', :query_string].freeze
  JSON_STARTS_WITH = ["[", "{"].freeze

  def process!(value, key = nil)
    case value
    when Hash
      !value.frozen? ?
        value.merge!(value) { |k, v| process! v, k } :
        value.merge(value) { |k, v| process! v, k }
    when Array
      !value.frozen? ?
        value.map! { |v| process! v, key } :
        value.map { |v| process v, key }
    when Integer
      matches_regexes?(key, value.to_s) ? Netvice::Dero::Processor::INT_MASK : value
    when String
      if value =~ fields_re && (json = try_parse_json(value))
        process!(json)
        value[0..-1] = JSON.dump(json)
      elsif matches_regexes?(key, value)
        Netvice::Dero::Processor::STRING_MASK
      elsif QUERY_STRING.include?(key)
        sanitize_query_string(value)
      else
        value
      end
    else
      value
    end
  end

  def fields_re
    return @fields_re if @fields_re
    default_fields = Netvice::Dero::Configuration::DEFAULT_MASKED_FIELDS
    used_fields = Netvice.conf.dero.masked_fields
    used_fields = used_fields - Netvice.conf.dero.unmasked_fields
    fields_list_str = used_fields.map do |f|
      Netvice::Dero::Processor.use_boundary?(default_fields, f) ? "\\b#{f}\\b" : f
    end.join("|")
    @fields_re = /#{fields_list_str}/i
  end

  private

  def matches_regexes?(k, v)
    (v =~ CREDIT_CARD_RE) || (k =~ fields_re)
  end

  def sanitize_query_string(query_string)
    query_hash = CGI.parse(query_string)
    Netvice::Dero::Processor::Utf8.process!(query_hash)
    process!(query_hash)
    URI.encode_www_form(query_hash)
  end

  def try_parse_json(string)
    return unless string.start_with?(*JSON_STARTS_WITH)
    JSON.parse(string) rescue nil
  end
end # Netvice::Dero::Processor::SensitiveMasker
