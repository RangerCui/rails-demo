# frozen_string_literal: true

#
# Interface exception control center
# Catch the specified exception and return it with the HTTP status code set to 200
#
# @author hubery.cui
#
module ExceptionManager
  extend ActiveSupport::Concern

  included do
    # ----------------------------------- Exception capture ---------------------------------- #

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      render_error(e.message, code: ::ResponseCode::API_PARAMS_ERROR, message: :api_params_error)
    end

  end

  # ------------------------------------ class method ----------------------------------- #
  class_methods do
    #
    # Logical layer exception map
    #
    # @author hubery.cui
    #
    #
    # @param [Symbol] type Logical layer exception type
    #
    # @return [Hash] error message {code: error code, message: error message}
    #
    def command_error_mapper(type)
      error_mapper = {
        invalid: [ResponseCode::CMD_VALIDATE_INVALID_ERROR, :cmd_validate_invalid_error],
        required: [ResponseCode::CMD_VALIDATE_REQUIRED_ERROR, :cmd_validate_required_error],
      }

      {
        code: error_mapper[type]&.[](0) || ResponseCode::CMD_VALIDATE_ERROR,
        message: error_mapper[type]&.[](1) || :cmd_validate_error,
      }
    end
  end
end
