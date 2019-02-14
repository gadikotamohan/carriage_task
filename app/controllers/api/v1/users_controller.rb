module API::V1
  class UsersController < BaseController

    swagger_path '/users' do
      operation :get do
        key :description, 'List users'
        key :tags, ['users']
        parameter name: :page, in: :query, type: :string, required: false
        response 200 do
          key :description, 'Users'
          schema do
            property :users, type: :object do
              key :type, :array
              items do
                key :'$ref', :User
              end
            end
            property :pagination, type: :object do
              key :'$ref', :Pagination
            end
          end
        end
        response 400 do
          key :description, 'Bad Request'
          schema do
            key '$ref', :ResponseMessage
          end
        end
        response 401 do
          key :description, 'Auth Failure'
          schema do
            key '$ref', :ResponseMessage
          end
        end
        response 403 do
          key :description, 'Forbidden'
          schema do
            key '$ref', :ResponseMessage
          end
        end
        response 412 do
          key :description, 'Prerequisite Failed'
          schema do
            key '$ref', :ResponseMessage
          end
        end
        response 500 do
          key :description, 'Internal Server Error'
          schema do
            key '$ref', :ResponseMessage
          end
        end
      end
    end


    def index
      users = policy_scope(User).page(params[:page])
      users.without_count
      user_hash = ActiveModel::Serializer::CollectionSerializer.new(users, each_serializer: UserSerializer)
      render json: { users: user_hash, pagination: pagination_meta(users) }
    end
  end
end