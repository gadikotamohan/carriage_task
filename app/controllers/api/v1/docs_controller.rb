module API::V1
  class DocsController < ActionController::Base
    include Swagger::Blocks

    swagger_root do
      key :swagger, '2.0'
      info do
        key :version, '1.0.0'
        key :title, 'Try carriage API v1'
        key :description, 'Try carriage API<br/>Authentication needs to passed in request header - Authorization: Token token={token};client_key={client_key};device_id={device_id}'
        key :termsOfService, ''
        contact do
          key :name, 'Try carriage API Team'
        end
      end

      security_definition :Authorization do
        key :type, :apiKey
        key :name, :Authorization
        key :in, :header
        key :description, 'Authorization Token'
      end

      tag do
        key :name, 'auth'
        key :description, 'User Authentication'
      end
      tag do
        key :name, 'user'
        key :description, 'User Details'
      end
      security do
        key :Authorization, []
      end

      key :host, Figaro.env.host
      key :basePath, '/api/v1'
      key :consumes, ['application/json']
      key :produces, ['application/json']
    end

    SWAGGERED_CLASSES = [
      API::V1::AuthController,
      API::V1::Auth::BasicAuthController,
      API::V1::UsersController,
      API::V1::ListsController,
      API::V1::CardsController,
      API::V1::CommentsController,
      self
    ].freeze


    swagger_schema :ListData do
      property :id, type: :string
      property :title, type: :string
    end

    swagger_schema :ListDetails do
      property :id, type: :string
      property :title, type: :string
      property :cards, type: :object do
        key :'$ref', :CardData
      end
    end

    swagger_schema :CardData do
      property :id, type: :string
      property :title, type: :string
    end

    swagger_schema :CardDetails do
      property :id, type: :string
      property :title, type: :string
      property :description, type: :string
    end

    swagger_schema :User do
      property :id, type: :string
      property :first_name, type: :string
      property :last_name, type: :string
      property :email, type: :string
    end


    swagger_schema :Pagination do
      property :current_page, type: :integer
      property :next_page, type: :integer
      property :prev_page, type: :integer
    end

    swagger_schema :SessionData do
      property :token, type: :string
      property :id, type: :string
      property :user, type: :object do
        property :id, type: :string
        property :first_name, type: :string
        property :last_name, type: :string
        property :email, type: :string
      end
    end

    swagger_schema :ResponseMessage do
      property :message, type: :string
      property :errors, type: :array do
        items do
          key :type, :string
        end
      end
    end

    def index
      render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
    end

  end
end
