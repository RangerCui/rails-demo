# frozen_string_literal: true

module V1
  module Entities
    #
    # When no data need to be returned,
    # only a successful code need to be returned to notify the front-end interface
    # that the invocation succeeded, and this entity is returned
    #
    # @author hubery.cui
    #
    class EmptyEntity < ApplicationEntity
    end
  end
end
