# frozen_string_literal: true

require 'grape'

#
# API interface base class
#
# @author hubery.cui
#
class ApplicationAPI < Grape::API
  include ::ExceptionManager

  # Universal request header
  GENERAL_HEADERS = {
    'Content-Type' => 'application/json;charset=UTF-8',
    'Set-Cookie' => 'HttpOnly;Secure;SameSite=Strict',
  }.freeze

  ACCESS_CONTROL_ALLOW_HEADERS = ['Access-Control-Allow-Origin', 'Content-Type'].freeze

  # Example Add interface cross-domain Settings
  insert_before 0, Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: ACCESS_CONTROL_ALLOW_HEADERS, methods: %i[get post options delete]
    end
  end

  # Add interface middleware
  insert_after Grape::Middleware::Formatter, Grape::Middleware::Logger

  # Sets the ContentType of the Response
  content_type :json, 'application/json;charset=UTF-8'

  # default JSON
  default_format :json
  default_error_formatter :json

  # Set general help
  helpers ::CommonHelpers

  before do
    GENERAL_HEADERS.each { |key, value| header key, value }
  end

  before_validation do
    # Whether the request source is legitimate
    # Malicious request detection
    # User rights authentication
    # authenticate_permission!
  end

  # Example Mount the V1 interface
  mount ::V1::Main
end
