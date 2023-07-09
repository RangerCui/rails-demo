# frozen_string_literal: true

module V1
  module Entities
    module Order
      #
      # order info Entity
      #
      # @author hubery.cui
      #
      class Info < ApplicationEntity
        expose :id, documentation: { type: Integer, desc: 'order id' }
        expose :actual_return_time, documentation: { type: Integer, desc: 'book actual return time' }
        expose :amount, documentation: { type: Integer, desc: 'order amount' }
        expose :borrowed_at, documentation: { type: Integer, desc: 'book borrowed at' }
        expose :estimated_return_time, documentation: { type: Date, desc: 'book estimated return time' }
        expose :status, documentation: { type: Integer, desc: 'order status' }
        expose :book_id, documentation: { type: Integer, desc: 'order book id' }
      end
    end
  end
end

