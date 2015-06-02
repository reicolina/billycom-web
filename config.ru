# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Source::Application

  DelayedJobWeb.use Rack::Auth::Basic do |username, password|
  	hashed_password = Digest::SHA512.hexdigest(password)
    username == Source::Application.config.master_user && hashed_password == Source::Application.config.master_hash
  end
