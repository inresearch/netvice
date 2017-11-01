# Remove any HTTP Post request bodies
module Netvice::Dero::Processor::PostData
  extend self

  def process!(data)
    process_symbol(data) if data[:request]
    process_string(data) if data['request']
    data
  end

  private

  def process_symbol(data)
    return unless data[:request][:method] == 'POST'
    data[:request][:data] = Netvice::Dero::Processor::STRING_MASK
  end

  def process_string(data)
    return unless data['request']['method'] == 'POST'
    data['request']['data'] = Netvice::Dero::Processor::STRING_MASK
  end
end
