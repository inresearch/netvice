# Remove any HTTP cookies from the event data
module Netvice::Dero::Processor::Cookies
  extend self

  def process!(data)
    process_symbol!(data) if data[:request]
    process_string!(data) if data['request']
    data
  end

  private

  def process_symbol!(data)
    data[:request][:cookies] = Netvice::Dero::Processor::STRING_MASK
    
    if data[:request][:headers]['Cookie']
      data[:request][:headers]['Cookie'] = Netvice::Dero::Processor::STRING_MASK
    end

    if data[:request][:headers][:Cookie]
      data[:request][:headers][:Cookie] = Netvice::Dero::Processor::STRING_MASK
    end
  end

  def process_string!(data)
    data['request']['cookies'] = Netvice::Dero::Processor::STRING_MASK if data['request']['cookies']

    return unless data['request']['headers'] && data['request']['headers']['Cookie']
    data['request']['headers']['Cookie'] = Netvice::Dero::Processor::STRING_MASK
  end
end
