# Many Ruby JSON implementations simply throw an exception if circular
# reference is detected. This processor removes circular references from
# hashes and arrays
module Netvice::Dero::Processor::RemoveCircularReferences
  extend self

  def process!(value, visited = [])
    obj_id = value.__id__ 
    return '(...)' if visited.include?(obj_id)
    visited << obj_id if value.is_a?(Array) || value.is_a?(Hash)

    case value
    when Hash
      !value.frozen? ?
        value.merge!(value) { |_, v| process! v, visited } :
        value.merge(value)  { |_, v| process! v, visited }
    when Array
      !value.frozen? ?
        value.map! { |v| process! v, visited } :
        value.map  { |v| process! v, visited }
    else
      value
    end
  end
end # Netvice::Dero::Processor::RemoveCircularReferences
