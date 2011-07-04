class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper # helper is auto available for views, but not controller, so we need to include it explicitly.
end 