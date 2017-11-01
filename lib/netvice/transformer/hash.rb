module Netvice::Transformer::Hash
  extend self

  def deep_transform_keys(hash, &block)
    unless hash.is_a?(Hash)
      fail ArgumentError, "Expecting hash, given: #{hash} (#{hash.class})"
    end

    result = {}
    hash.each do |key, value|
      result[yield(key)] = value.is_a?(Hash) ?
        deep_transform_keys(value, &block) :
        value
    end
    result
  end

  def deep_symbolize_keys(hash)
    deep_transform_keys(hash) { |key| key.to_sym rescue key }
  end
end
