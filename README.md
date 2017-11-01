# Netvice

Manages microservices. On library and data structure changes, please help
ensure updating the compatibility, and change it if necessary.

## User

Compatible with: alpha1.

Configuration file (`config/yuza.rb`):

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

Usage example:

```ruby
user = Netvice::Yuza::User.where_id("5")
user.name = "Adam"
user.save
user.change_password(old: "Password01", new: "Password02", repeat: "Password02")
user.attempt_login("Password01")
```

## Dero

Compatible with: alpha1.

Configuration file (`config/dero.rb`):

```ruby
Netvice.configure do
  dero do
    integrate_with: :rails
    integrate_with: :sidekiq
    
    project :my_awesome_app
  end
end
```

Usage example:

```ruby
Netvice::Dero.capture_exception(exc)
Netvice::Dero.user_context email: 'foo@example.com' # bind the logged in user
Netvice::Dero.extra_context account_type: 'premium' # filterable context
```
