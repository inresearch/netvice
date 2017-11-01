module Netvice::Yuza
  class User < Netvice::Model
    attr_accessor :id, :name, :email, :phone

    def to_h
      {
        id: id,
        name: name,
        email: email,
        phone: phone,
        created_at: created_at,
        updated_at: updated_at
      }
    end

    # returns User
    def self.where_id(id)
      resp = Netvice::Yuza.http.get("/users/#{id}")
      return Netvice::Yuza::User.new(resp.body['data']) if resp.body["success"]

      errors = resp.body["errors"]
      if errors["base"] && errors["base"] =~ /find.+with.+id/i
        return nil
      else
        fail Netvice::Yuza::RuntimeError, errors
      end
    end

    # returns User
    def save!(body={user: to_h})
      resp = Netvice::Yuza.http.patch("/users/#{id}", body)
      if resp.body["success"]
        reload!
      else
        fail Netvice::RuntimeError, "Saving failed. Got: #{resp.body}"
      end
    end

    def save(body={user: to_h})
      save!(body) rescue false
    end

    # returns Netvice::Yuza::Response
    def attempt_login(password)
      body = {
        session: {
          user: {
            email: email,
            password: password,
            app: Netvice.configuration.app 
          },
          validity_minutes: Netvice.configuration.yuza.reauthenticate_interval
        }
      }

      resp = Netvice::Yuza.http.post("/sessions", body)
      if resp.body["success"]
        return Netvice::Yuza::Session.new(resp.body["data"])
      end
      false
    end

    # returns User instance, will insert/update password
    def change_password(old:, new:, repeat:)
      fail ArgumentError, "Password not match" unless new == repeat

      body = {
        password: {
          app: Netvice.configuration.app,
          old: old,
          password: new
        }
      }

      save!(body)
    end

    def inspect
      inspector([:id])
    end
  end # User
end # Netvice::Yuza
