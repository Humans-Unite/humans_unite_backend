class WebController < ActionController::Base
  # This handles HTML views, sessions, cookies, etc.
  protect_from_forgery with: :exception
end