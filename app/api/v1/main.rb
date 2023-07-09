# frozen_string_literal: true

module V1
  #
  # Indicates the entry class of the V1 interface
  #
  # @author hubery.cui
  #
  class Main < Grape::API
    VERSION_FLAG = 'v1'

    # Set version
    version VERSION_FLAG, using: :path

    # Mount interface
    mount ::V1::UserAPI
    mount ::V1::BorrowAPI
    mount ::V1::ReturnAPI
    mount ::V1::BookAPI

    # swagger
    add_swagger_documentation(
      base_path: proc { |request| request.host =~ /^example/ ? "/api-example/#{VERSION_FLAG}" : "/api/#{VERSION_FLAG}" },
      add_version: false,
      doc_version: VERSION_FLAG,
      hide_documentation_path: true,
      models: [
        Entities::BaseEntity,
      ]
    )
  end
end
