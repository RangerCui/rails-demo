# frozen_string_literal: true

module V1
  module Entities
    module Account
      #
      # account info Entity
      #
      # @author hubery.cui
      #
      class Info < ApplicationEntity
        expose :id, documentation: { type: Integer, desc: 'user id' }
        expose :balance, documentation: { type: Float, desc: 'account balance' }
        expose :status, documentation: { type: Integer, desc: 'account status' }
      end
    end
  end
end
