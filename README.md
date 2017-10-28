# Netvice

Manages the microservice of Netinmax.

```ruby
Netvice.configure do
  app  "pageok"
  logger Rails.logger

  yuza do
    host "http://localhost"
    port 5000
  end
end
```

## User

```ruby
user = Yuza::User.where_id("5")
user.name = "Adam"
user.save
user.change_password(old: "Password01", new: "Password02", repeat: "Password02")
user.attempt_login("Password01")
```

## Dero

```ruby

```
