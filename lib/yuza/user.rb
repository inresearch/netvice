module Yuza
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
      resp = Yuza.http.get("/users/#{id}")
      return Yuza::User.new(resp.body['data']) if resp.body["success"]

      errors = resp.body["errors"]
      if errors["base"] && errors["base"] =~ /find.+with.+id/i
        return nil
      else
        fail Yuza::Error, errors
      end
    end

    # returns User
    def save!(body={user: to_h})
      body = body.to_json
      resp = Yuza.http.patch("/users/#{id}", body)
      if resp.body["success"]
        return self.class.where_id(id)
      else
        fail Netvice::RuntimeError, "Saving failed. Got: #{resp.body}"
      end
    end

    def save(body={user: to_h})
      save!(body) rescue false
    end

    # returns Yuza::Response
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

      resp = Yuza.http.post("/sessions", body)
      if resp.body["success"]
        return Yuza::Session.new(resp.body["data"])
      end
      false
    end

    # returns User instance, will insert/update password
    def change_password(password, repeat_password)
      fail ArgumentError, "Password not match" unless password == repeat_password

      body = {
        password: {
          app: Netvice.configuration.app,
          password: password
        }
      }

      save!(body)
    end

    def inspect
      inspector([:id])
    end
  end # User
end # Yuza
