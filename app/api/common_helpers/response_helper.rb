# frozen_string_literal: true

module CommonHelpers
  #
  # Send the help class
  #
  # @author hubery.cui
  #
  module ResponseHelper
    #
    # Interface processing successful return result
    #
    # @author hubery.cui
    #
    # @param [Object] data The actual body of content returned will be converted to json and added to the returned result;
    # You can pass any instance of the to_json method (which must return String) inside
    # @example Hash type
    #   render_ok({id: 1})
    # will call the to_json method inside the Hash and convert it to a json string
    # @example ActiveRecord type
    #   render_ok(Bid::Info.last)
    # Calls the to_json method inside ActiveRecord to convert the fields inside the model into json strings
    # @example ActForm::Command type
    #   render_ok(Bid::GetInfoCommand.run(params))
    # calls the result method inside ActForm::Command, converting it first to Hash and then to json string
    # @param [Class] with constructs the return result based on an Entity class
    # @param [Integer] code Specifies the number of the metadata returned. The default value is 10000. Because this method is a successful return method,
    # the number less than 10000 is not supported; It is recommended to pass the constant to ResponseCode
    # @param [String|Symbol] message Indicates the metadata message returned. The default value is' request succeeded '. When passing a Symbol,
    # the corresponding copy is found in the api/response_message of I18. Recommendation Symbol
    #
    # @return [ResponseInfo] Returns an instance of the result
    #
    def render_ok(data, with: nil, code: ::ResponseCode::SUCCESS, message: :success)
      exec_render(data, code, message, with)
    end

    #
    # 方法别名
    # @method def render_success
    #
    alias render_success render_ok

    #
    # Return result of interface processing failure
    #
    # @author hubery.cui
    #
    # @param [Object] data The actual body of content returned will be converted to json and added to the returned result; You can pass any instance of the to_json method (which must return a String) inside (it is recommended to pass the Command instance in, the system will attach a different error code to the specified error).
    # @param [Class] with constructs the return result based on an Entity class
    # @param [Integer] code Specifies the number of the metadata returned. The default value is 1. Because this method is a successful return method, the number greater than 9999 is not supported. It is recommended to pass the constant to ResponseCode
    # @param [String|Symbol] message Indicates the metadata message returned. The default value is' Request failed '. When passing a Symbol, the corresponding copy is found in the api/response_message of I18. Recommendation Symbol
    #
    # @return [ResponseInfo] Returns an instance of the result
    # If the incoming data is Command, the system will automatically encapsulate and generate the corresponding error code. The following is a separate description of Command
    # ResponseInfo will have a fixed structure:
    #       { type: { attribute: [message] } }
    # type is the type of the error, which defaults to :invalid if it is not set separately when Command adds the error message
    # attribute Indicates the error field, which is consistent with the attribute content
    # message is an error message that is set by the user
    # At the same time, code and message that return the result meta information also have special encapsulation processing,
    #
    def render_failed(data, with: nil, code: ::ResponseCode::FAILED, message: :failed)
      exec_render(data, code, message, with, has_error: true)
    end

    #
    # The interface failed to process and threw an exception directly
    #
    # @author hubery.cui
    #
    # @see render_failed
    #
    def render_error(data, with: nil, code: ::ResponseCode::FAILED, message: :failed)
      error!(render_failed(data, with: with, code: code, message: message).to_hash, 200)
    end

    #
    # Standard interface processing method
    #
    # @author hubery.cui
    #
    # @param [ApplicationCommand] Indicates the logical instance of command
    # @param [Class] with constructs the return result based on an Entity class
    # @param [Integer] code Specifies the number of the returned metadata
    # @param [String|Symbol] message Indicates the returned metadata information
    #
    # @return [ResponseInfo] Returns an instance of the result
    #
    def render_std(command, with: nil, code: nil, message: nil)
      option = { with: with }
      option[:code] = code if code
      option[:message] = message if message
      if command.success?
        render_ok(command, option)
      else
        render_failed(command, option)
      end
    end

    #
    # Standard interface processing method, when there is an exception directly thrown
    #
    # @author hubery.cui
    #
    # @param [ApplicationCommand] Indicates the logical instance of command
    # @param [Class] with constructs the return result based on an Entity class
    # @param [Integer] code Specifies the number of the returned metadata
    # @param [String|Symbol] message Indicates the returned metadata information
    #
    # @return [ResponseInfo] Returns an instance of the result
    #
    def render_std!(command, with: nil, code: nil, message: nil)
      option = { with: with }
      option[:code] = code if code
      option[:message] = message if message
      binding.pry
      if command.success?
        render_ok(command, option)
      else

        render_error(command, option)
      end
    end

    # ----------------------------------- Private method ----------------------------------- #
    private

    #
    # Execute interface return result encapsulation
    #
    # @author hubery.cui
    #
    # @param [Object] data The actual body of content returned will be converted to json and added to the returned result;
    # You can pass any instance of the to_json method (which must return String) inside
    # @example Hash type
    #   render_ok({id: 1})
    # will call the to_json method inside the Hash and convert it to a json string
    # @example ActiveRecord type
    #   render_ok(Bid::Info.last)
    # Calls the to_json method inside ActiveRecord to convert the fields inside the model into json strings
    # @example ActForm::Command type
    #   render_ok(Bid::GetInfoCommand.run(params))
    # calls the result method inside ActForm::Command, converting it first to Hash and then to json string
    # @param [Integer] code Specifies the number of the metadata returned. The default value is 10000. Because this method is a successful return method,
    # the number less than 10000 is not supported; It is recommended to pass the constant to ResponseCode
    # @param [String|Symbol] message Indicates the metadata message returned. The default value is' request succeeded '. When passing a Symbol,
    # the corresponding copy is found in the api/response_message of I18. Recommendation Symbol
    # @param [Class] entity_class Entity Class. If it is empty, the content body will not be generated through Entity
    # @param [Boolean] has_error Whether there is an error, used to distinguish between return success and return failure
    #
    # @return [ResponseInfo] Returns an instance of the result
    #
    def exec_render(data, code, message, entity_class = nil, has_error: false)
      # Set the ReponseInfo parameter
      self_code = code
      self_message = message
      self_data = data

      if !has_error
        # Process data when there are no errors
        self_entity_class = render_with(entity_class)
        self_data = self_data.result if self_data.class <= ActForm::Command
        self_data = self_entity_class.represent(self_data) if self_entity_class.present? && self_entity_class <= Grape::Entity
      else
        # has error
        if self_data.class <= ActForm::Command
          # If data is Commmand, perform generic processing for validation
          errors = data.errors
          error_types = errors.map(&:type).uniq

          if error_types.count == 1
            # Single-type errors directly return error information
            error_mapper = ApplicationAPI.command_error_mapper(error_types.first)

            self_code = error_mapper[:code]
            self_message = error_mapper[:message]
            self_data = errors.messages
          else
            self_code = ResponseCode::CMD_VALIDATE_MIX_ERROR
            self_message = :cmd_validate_mix_error
            self_data = command_mix_error_data(errors)
          end
        end
      end

      ResponseInfo.new(self_code, self_message, self_data)
    end

    #
    # Get return result dependencies
    # If the calling method is not set, the entity set by the interface route is used
    #
    # @author hubery.cui
    #
    # @param [Object] with returns the result dependent content
    #
    # @return [Object] Returns the result dependent content
    #
    def render_with(with)
      with || try(:route)&.entity
    end

    #
    # Get mixed exception data for Command
    # is converted to a generic exception data structure and returned
    #
    # @author hubery.cui
    #
    # @param [ActiveModel::Errors] errors Command returns the exception data content
    #
    # @return [Hash] abnormal data
    # @example Example
    #   command.erros
    #   => #<ActiveModel::Errors:0x00007f871e895128 ...  @errors=[
    # #<ActiveModel::Error attribute=id, type=invalid, options={:message=>"ID range is invalid "}>,
    # #<ActiveModel::Error attribute=id, type=joke, options={:message=>"HAHAHA "}>
    #]>
    #   command_mix_error_data(command.erros)
    # = > {: invalid = > {: id = > [" id range is not in conformity with the provisions "]}, : joke = > {: id = > [" HAHAHA mischievous "]}}
    #
    def command_mix_error_data(errors)
      errors.group_by(&:type).transform_values do |e|
        e.group_by(&:attribute).transform_values do |f|
          f.map(&:message)
        end
      end
    end
  end
end
