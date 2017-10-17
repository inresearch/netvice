# Netvice

Manages the microservice of Netinmax.

```ruby
Netvice.configure do
  yuza do
    host "http://localhost"
    port 5000
    app  "pageok"
  end
end
```

## User

```ruby
user = Yuza::User.where_id("5")
user.name = "Adam"
user.save
user.change_password("Password01", "Password01")
user.attempt_login("Password01")
```
