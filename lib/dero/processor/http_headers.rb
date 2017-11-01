# Remove all HTTP headers which match a regex. By default, this will only
# remove the "Auth" header, but can be configured to remove others.
module Dero::Processor::HttpHeaders
  extend self

  def process!(data)
    process_symbol!(data) if data[:request]
    process_string!(data) if data['request']
    data
  end

  def fields_re
    return @fields_re if @fields_re
    fields_list_str = fields.map do |f|
      Dero::Processor.use_boundary?(fields, f) ? "\\b#{f}\\b" : f
    end.join("|")
    @fields_re = /#{fields_list_str}/i
  end

  def fields
    Netvice.conf.dero.masked_http_headers
  end

  private

  def process_symbol!(data)
    return unless data[:request][:headers]

    data[:request][:headers].keys.select { |k| fields_re.match(k.to_s) }.each do |k|
      data[:request][:headers][k] = Dero::Processor::STRING_MASK
    end
  end

  def process_string!(data)
    return unless data['request']['headers']

    data['request']['headers'].keys.select { |k| fields_re.match(k) }.each do |k|
      data['request']['headers'][k] = Dero::Processor::STRING_MASK
    end
  end
end
