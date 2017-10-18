module Netvice
  module Sanitizer
    extend self

    SENSITIVE_FIELDS = [:user_id, :id, :password, :code, :email]

    def obfuscate_sensitive_data(hash)
      return hash unless hash.is_a?(Hash)

      obfuscated = {}
      hash.each do |key, value|
        case value
        when Hash
          obfuscated[key] = obfuscate_sensitive_data(value)
        else
          obfuscated[key] = SENSITIVE_FIELDS.include?(key.to_s.downcase.to_sym) ?
            '?' : value
        end
      end
      obfuscated
    end # obfuscate_sensitive_data
  end # Sanitizer
end # Netvice
