module Yuza
  class Session < Netvice::Model
    attr_accessor :user_id, :code, :app, :expiry_time

    def after_initialize(states={})
      if states['user']
        @user_id = states['user']['id']
      end
    end

    def to_h
      {
        user_id: user_id,
        code: code,
        app: app,
        expiry_time: expiry_time,
        created_at: created_at,
        updated_at: updated_at
      }
    end

    def expiry_time=(timestamp)
      @expiry_time = convert_from_timestamp(timestamp)
    end

    # returns Session
    def self.where_code(code)
      resp = Yuza.http.get("/sessions/#{code}")
      return Yuza::Session.new(resp.body['data']) if resp.body["success"]

      errors = resp.body["errors"]
      if errors["base"] && errors["base"] =~ /find.+with.+id/i
        return nil
      else
        fail Yuza::Error, errors
      end
    end

    def revoke!
      fail NotImplementedError
    end

    def inspect
      inspector([:user_id, :expiry_time, :code])
    end
  end # Session
end # Yuza
