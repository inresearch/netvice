module Netvice::Yuza::Paths
  extend self

  def base_url
    Netvice.conf.yuza.base_url
  end

  # accepts: get and post
  def signin_url
    "#{base_url}/users/signin"
  end

  # accepts: get and post
  def signup_url
    "#{base_url}/users/signup"
  end
end
