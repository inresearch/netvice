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
  end
end
