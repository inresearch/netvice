module Yuza
  class Session < Netvice::Model
    attr_accessor :id, :user_id, :code, :app, :expiry_time, :invalid
    reloadable_by :code

    def after_initialize(states={})
      if states['user'] && states['user']['id']
        @user_id = states['user']['id']
      end
    end

    def to_h
      {
        id: id,
        user_id: user_id,
        code: code,
        app: app,
        expiry_time: expiry_time,
        invalid: invalid,
        created_at: created_at,
        updated_at: updated_at
      }
    end

    def expiry_time=(timestamp)
      @expiry_time = convert_from_timestamp(timestamp)
    end

    def invalid?
      invalid
    end

    def valid?
      !invalid?
    end

    # returns Session
    def self.where_code(code)
      resp = Yuza.http.get("/sessions/#{code}")
      return Yuza::Session.new(resp.body['data']) if resp.body["success"]

      errors = resp.body["errors"]
      if errors["base"] && errors["base"] =~ /find.+with.+id/i
        return nil
      else
        fail Yuza::RuntimeError, errors
      end
    end

    def revoke!
      resp = Yuza.http.delete("/sessions/#{code}/revoke")

      if resp.body["errors"] && resp.body["errors"].any?
        fail Yuza::RuntimeError, resp.body["errors"]
      end
      set(resp.body["data"])
      true
    end

    def inspect
      inspector([:expiry_time])
    end

    def user
      return @user if @user
      @user = Yuza::User.where_id(user_id)
    end
  end # Session
end # Yuza
