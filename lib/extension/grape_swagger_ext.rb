# frozen_string_literal: true

module Grape
  #
  # grape_swagger Endpoint
  #
  # @author hubery.cui
  #
  class Endpoint
    alias _response_object response_object
    alias _expose_params_from_model expose_params_from_model

    #
    # Rewrite extends the way swagger generates response data, adding a structure for the interface to return basic information about the result
    #
    # note gem version: grape-swagger 1.4.0 grape-swagger-entity 0.5.1, if gem upgrade,
    # need to confirm whether the response_object method supports the current extension mode
    # @overload response_object(route, options)
    #
    # @author hubery.cui
    #
    # @param [Grape::Router::Route] route Indicates the route information of the grape interface
    # @param [Hash] options swagger configuration information
    # @param [Class] default_entity Entity of the interface that returns the result basic information
    #
    # @return [Hash] response data swagger document information
    #
    def response_object(route, options, default_entity = V1::Entities::BaseEntity)
      # Gets the native method return
      result = _response_object(route, options)

      # Get basic information about the result returned by the interface. [BaseEntity]
      parsed_response = GrapeSwagger::Entity::Parser.new(default_entity, self).call
      base_entity = GrapeSwagger::DocMethods::BuildModelDefinition.parse_params_from_model(parsed_response, default_entity, model_name(default_entity))

      codes(route).each do |info|
        next if info[:model].nil?

        code = info[:code]
        ref = result[code][:schema]['$ref']

        result[code][:schema] = base_entity
        result[code][:schema][:properties][:data]['$ref'] = ref
      end

      result
    end

    #
    # Rewrite the method that extends swagger to get the result structure of the entity return
    # When the set entity is an empty entity class specified by the item content, the content of the entity is set to an empty hash instead of throwing an exception
    #
    # @author hubery.cui
    #
    # @param [Class] model Incoming object type (this project is generally entity)
    # @param [Class] empty_entity Indicates the empty entity type
    #
    # @return [String] Converted swagger identification name
    #
    def expose_params_from_model(model, empty_entity = V1::Entities::EmptyEntity)
      _expose_params_from_model(model)
    rescue GrapeSwagger::Errors::SwaggerSpec => e
      raise e unless model == empty_entity

      # 处理同gem内expose_params_from_model方法
      model_name = model_name(model)
      @definitions[model_name] = {}
      model_name
    end
  end
end
