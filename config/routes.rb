# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

# sidekiq session
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: '_interslice_session'

Rails.application.routes.draw do
  mount ApplicationAPI => '/api'
  mount Sidekiq::Web => '/sidekiq'
end
