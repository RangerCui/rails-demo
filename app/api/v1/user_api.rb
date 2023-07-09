# frozen_string_literal: true

module V1
  #
  # Some interfaces for user base information
  # @author hubery.cui
  #
  class UserAPI < ApplicationAPI
    namespace :user do
      # #-- User management correlation API --
      namespace :manage do
        include User::ManageAPI
      end
      namespace :info do
        include User::InfoAPI
      end
    end
  end
end
