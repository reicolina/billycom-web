class UserSession < Authlogic::Session::Base
  logout_on_timeout false #never log out!
end