module API::V1
  class ListsController < BaseController
    before_action :load_and_authorize, only: [:show, :update, :destroy]

    swagger_path '/lists' do
      operation :get do
        key :description, 'List lists'
        key :tags, ['lists']
        parameter name: :page, in: :query, type: :string, required: false
        response 200 do
          key :description, 'Lists'
          schema do
            property :lists, type: :object do
              key :type, :array
              items do
                key :'$ref', :ListData
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
      lists = policy_scope(List).page(params[:page])
      lists.without_count
      lists_hash = ActiveModel::Serializer::CollectionSerializer.new(lists, serializer: ListSerializer)
      render json: { lists: lists_hash, pagination: pagination_meta(lists) }
    end

    swagger_path '/lists' do
      operation :post do
        key :description, 'Create List'
        key :tags, ['lists']
        parameter name: :title,     in: :formData, type: :string, required: true
        response 200 do
          key :description, 'Success'
          schema do
            key '$ref', :ListDetails
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

    def create
      list = List.new(list_params.merge(user_ids: current_user.id))
      authorize list
      if list.save
        render json: list, serializer: ListDetailsSerializer
      else
        render json: { message: "Cannot create list", errors: list.errors.full_messages}, status: :bad_request
      end
    end

    swagger_path '/lists/{id}' do
      operation :put do
        key :description, 'Update List'
        key :tags, ['lists']
        parameter name: :id, in: :path, type: :string, format: :string, required: true
        parameter name: :list, in: :body, required: true do
          key :description, 'List body.'
          schema do
            property :title, type: :string, required: true
            property :add_user_ids, type: :object do
              key :type, :array
              items do
                key :'$ref', :string
              end
            end
            property :remove_user_ids, type: :object do
              key :type, :array
              items do
                key :'$ref', :string
              end
            end
          end
        end
        response 200 do
          key :description, 'Success'
          schema do
            key '$ref', :ListData
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

    def update
      if list.update(list_params)
        render json: list, serializer: ListDetailsSerializer
      else
        render json: { message: "cannot update list", errors: list.errors.full_messages}, status: :bad_request
      end
    end

    swagger_path '/lists/{id}' do
      operation :get do
        key :description, 'List Details'
        key :tags, ['lists']
        parameter name: :id, in: :path, type: :string, format: :string, required: true
        response 200 do
          key :description, 'Success'
          schema do
            key '$ref', :ListDetails
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

    def show 
      render json: list, serializer: ListDetailsSerializer
    end

    swagger_path '/lists/{id}' do
      operation :delete do
        key :description, 'delete list'
        key :tags, ['lists']
        parameter name: :id, in: :path, type: :string, format: :string, required: true
        response 200 do
          key :description, 'Success'
          schema do
            key '$ref', :ResponseMessage
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

    def destroy
      list.destroy
      if list.persisted?
        render json: { message: "Unable to delete list", errors: list.errors.full_messages}, status: :bad_request
      else
        render json: { message: "deleted list", errors: []}, status: :ok
      end
    end

    private
      def list_params
        params.permit :title, add_user_ids: [], remove_user_ids: []
      end

      def list
        @list ||= policy_scope(List).where(id: params[:id]).first or not_found        
      end

      def load_and_authorize
        authorize list 
      end

  end
end