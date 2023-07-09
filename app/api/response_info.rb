# frozen_string_literal: true

#
# Returns a generic class encapsulated by the result
#
# @author hubery.cui
#
class ResponseInfo
  I18N_MESSAGE_PREFIX = 'api.response_message.'
  UNDEFINED_MESSAGE = 'undefined message.'

  attr_reader :code, :message, :data, :timestamps

  #
  # Construction method
  #
  # @author hubery.cui
  #
  # @param [Integer] code Code of the result
  # @param [Symbol|String|Array] message_generic Specifies the message pattern that returns the result.
  # @param [Object] data returns the result body
  #
  def initialize(code, message_generic, data)
    @code = code
    @message = parse_message(message_generic)
    @data = data
    @timestamps = Time.now.to_i
  end

  #
  # Return json format method that applies to interworking methods in Grape whose format is json
  #
  # @author hubery.cui
  #
  # @return [String] Jsonized string
  #
  def to_json(*_args)
    to_hash.to_json
  end

  #
  # Returns the Hash format content of the standard return result
  #
  # @author hubery.cui
  #
  # @return [Hash] Standard return result
  #
  def to_hash
    {
      code: @code,
      message: @message,
      data: @data,
      timestamps: @timestamps,
    }
  end

  private

  #
  # Generate a prompt message according to the prompt message pattern
  #
  # @author hubery.cui
  #
  # @param [Symbo|String|Array] message_generic message pattern:
  # Symbol - Returns a prompt message according to I18n's response_message
  # String - Returns a prompt message directly with the passed parameter
  # Array - Calls the current method recursively, concatenates all prompt messages with commas and returns them
  #
  # @return [String] Prompt message
  #
  def parse_message(message_generic)
    result = ''
    case message_generic
    when Symbol
      result = I18n.t(I18N_MESSAGE_PREFIX + message_generic.to_s)
    when String
      result = message_generic
    when Array
      message_generic.map do |e|
        result = [result, parse_message(e)].join(',')
      end
    else
      result = UNDEFINED_MESSAGE
    end
    result
  end
end
