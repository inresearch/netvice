module Dero
  class Configuration
    include Netvice::Configurable
    include Netvice::Dimensionable
    include Netvice::Endpointable

    EXCLUDED_EXCEPTIONS = [
      'AbstractController::ActionNotFound',
      'ActionController::InvalidAuthenticityToken',
      'ActionController::RoutingError',
      'ActionController::UnknownAction',
      'ActiveRecord::RecordNotFound',
      'CGI::Session::CookieStore::TamperedWithCookie',
      'Mongoid::Errors::DocumentNotFound',
      'Sinatra::NotFound',
      'ActiveJob::DeserializationError'
    ].freeze

    # if the environment is not on the list, cancel reporting
    config_field(:run_on, ['production']) do |value|
      [value] unless value.is_a?(Array)
    end

    config_field :project
    config_field :log_prefix, "** [Dero]"
    
    # ignore if an exception is an instance of any of the error defined
    config_field :excluding, EXCLUDED_EXCEPTIONS

    # specify the working directory
    config_field(:workdir, -> {(defined?(Rails.root) ? Rails.root.to_s : Dir.pwd)}) do |val|
      Dero::Kernel::Line.instance_variable_set(:@in_app_pattern, nil)
      val
    end

    # specify the http headers that if encountered, will be masked
    config_field(:masked_http_headers, ['Authorization']) do |val|
      Dero::Processor::HttpHeaders.instance_variable_set(:@fields_re, nil)
      val
    end

    DEFAULT_MASKED_FIELDS = %w(
      authorization
      password
      passwd
      pass
      secret
      ssn
      social(.*)?sec
    )
    config_field(:masked_fields, DEFAULT_MASKED_FIELDS) do |val|
      fail ArgumentError, "Must be an array, given: #{val.class}" unless val.is_a?(Array)
      val.map!(&:to_s)
      Dero::Processor::SensitiveMasker.instance_variable_set(:@fields_re, nil)
      (DEFAULT_MASKED_FIELDS + val).uniq
    end

    # takes precedence over defined masked fields. field defined here will
    # never be masked.
    config_field(:unmasked_fields, []) do |val|
      fail ArgumentError, "Must be an array, given: #{val.class}" unless val.is_a?(Array)
      val.map!(&:to_s)
      Dero::Processor::SensitiveMasker.instance_variable_set(:@fields_re, nil)
      val
    end
  end
end
