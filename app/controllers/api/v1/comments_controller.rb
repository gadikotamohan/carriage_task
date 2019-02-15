module API::V1
  class CommentsController < BaseController
    before_action :load_and_authorize, only: [:update, :show, :destroy]
    before_action :mandate_resource_type, only: :index

    swagger_path '/comments' do
      operation :get do
        key :description, 'List comments'
        key :tags, ['comments']
        parameter name: :page, in: :query, type: :string, required: false
        parameter name: :resource_type, in: :query, type: :string, required: true

        response 200 do
          key :description, 'Comments'
          schema do
            property :comments, type: :object do
              key :type, :array
              items do
                key :'$ref', :CommentData
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
      comments = policy_scope(Comment).includes(:user).where(resource_type: params[:resource_type].classify).page(params[:page])
      comments.without_count
      comments_hash = ActiveModel::Serializer::CollectionSerializer.new(comments, serializer: CommentInfoSerializer)
      render json: { comments: comments_hash, pagination: pagination_meta(comments) }
    end

    swagger_path '/comments' do
      operation :post do
        key :description, 'Create Comment'
        key :tags, ['comments']
        parameter name: :content, in: :formData, type: :string, format: :string, required: true
        parameter name: :resource_id, in: :formData, type: :string, format: :string, required: false
        parameter name: :resource_type, in: :formData, type: :string, format: :string, required: false
        parameter name: :parent_id, in: :formData, type: :string, format: :string, required: false

        response 200 do
          key :description, 'Success'
          schema do
            key '$ref', :CommentDetails
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
      comment = current_user.comments.create(comment_params)
      authorize comment
      if comment.persisted?
        render json: comment, serializer: CommentDetailsSerializer
      else
        render json: { message: "Cannot create comment", errors: comment.errors.full_messages}, status: :bad_request
      end
    end

    swagger_path '/comments/{id}' do
      operation :put do
        key :description, 'update comment'
        key :tags, ['comments']
        parameter name: :id, in: :path, type: :string, format: :string, required: true
        parameter name: :content, in: :formData, type: :string, format: :string, required: true

        response 200 do
          key :description, 'Success'
          schema do
            key '$ref', :CommentDetails
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
      comment_params.delete :resource_type
      comment_params.delete :resource_id
      if comment.update(comment_params)
        render json: comment, serializer: CommentDetailsSerializer
      else
        render json: { message: "cannot update comment/reply", errors: comment.errors.full_messages}, status: :bad_request
      end
    end

    swagger_path '/comments/{id}' do
      operation :get do
        key :description, 'Comment Details'
        key :tags, ['comments']
        parameter name: :id, in: :path, type: :string, format: :string, required: true
        response 200 do
          key :description, 'Success'
          schema do
            key '$ref', :CommentDetails
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
      render json: comment, serializer: CommentDetailsSerializer
    end


    swagger_path '/comments/{id}' do
      operation :delete do
        key :description, 'Delete Comment'
        key :tags, ['comments']
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
      comment.destroy
      if comment.persisted?
        render json: { message: "Unable to delete comment", errors: comment.errors.full_messages}, status: :bad_request
      else
        render json: { message: "deleted comments", errors: []}, status: :ok
      end
    end

    private
      def comment_params
        params.permit :content, :resource_id, :resource_type, :parent_id
      end

      def mandate_resource_type
        if params[:resource_type].blank?
          return render json: { error: "'resource_type' params is mandatory", errors: []}, status: :bad_request 
        end
        resource_type = params[:resource_type].classify
        Rails.const_get(resource_type) rescue not_found
      end

      def comment
        @comment ||= policy_scope(Comment).where(id: params[:id]).first or not_found
      end

      def load_and_authorize
        authorize comment
      end
  end
end