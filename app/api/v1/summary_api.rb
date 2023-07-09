# frozen_string_literal: true

module V1
  #
  # Some interfaces for user base information
  # @author hubery.cui
  #
  class SummaryAPI < ApplicationAPI
    namespace :summary do
      # #-- User management correlation API --
      namespace :month do
        include Summary::MonthAPI
      end
      namespace :annual do
        include Summary::AnnualAPI
      end
    end
  end
end
