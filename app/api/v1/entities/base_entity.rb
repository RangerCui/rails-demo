# frozen_string_literal: true

module V1
  module Entities
    #
    # Generic return result Entity
    #
    # @author hubery.cui
    #
    class BaseEntity < ApplicationEntity
      expose :code, documentation: { type: Integer, desc: 'Return result code' }
      expose :message, documentation: { type: String, desc: 'Return result information' }
      expose :data, documentation: { type: Hash, desc: 'Return result body' }
      expose :timestamps, documentation: { type: Time, desc: 'Return timestamp' }
    end
  end
end
