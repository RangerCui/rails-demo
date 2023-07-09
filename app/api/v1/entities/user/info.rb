# frozen_string_literal: true

module V1
  module Entities
    module User
      #
      # user base info entity
      #
      # @author hubery.cui
      #
      class Info < ApplicationEntity
        expose :id, documentation: { type: Integer, desc: 'user id' }
        expose :name, documentation: { type: String, desc: 'user name' }
        expose :email, documentation: { type: String, desc: 'email' }
      end
    end
  end
end
