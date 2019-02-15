module API::V1
  class CardsController < BaseController
    swagger_path '/cards' do
      operation :get do
        key :description, 'List cards'
        key :tags, ['cards']
        parameter name: :page, in: :query, type: :string, required: false
        response 200 do
          key :description, 'Cards'
          schema do
            property :cards, type: :object do
              key :type, :array
              items do
                key :'$ref', :CardData
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
      cards = policy_scope(Card).page(params[:page])
      cards.without_count
      cards_hash = ActiveModel::Serializer::CollectionSerializer.new(cards, serializer: CardInfoSerializer)
      render json: { cards: cards_hash, pagination: pagination_meta(cards) }
    end

    swagger_path '/cards' do
      operation :post do
        key :description, 'Create Card'
        key :tags, ['cards']
        parameter name: :title, in: :formData, type: :string, format: :string, required: true
        parameter name: :description, in: :formData, type: :string, format: :string, required: true
        parameter name: :list_id, in: :formData, type: :string, format: :string, required: true
        response 200 do
          key :description, 'Success'
          schema do
            key '$ref', :CardDetails
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
      card = current_user.cards.create(card_params)
      if card.persisted?
        render json: card, serializer: CardDetailsSerializer
      else
        render json: { message: "Cannot create card", errors: card.errors.full_messages}, status: :bad_request
      end
    end

    swagger_path '/cards/{id}' do
      operation :put do
        key :description, 'update card'
        key :tags, ['cards']
        parameter name: :id, in: :path, type: :string, format: :string, required: true
        parameter name: :title, in: :formData, type: :string, format: :string, required: true
        parameter name: :description, in: :formData, type: :string, format: :string, required: true

        response 200 do
          key :description, 'Success'
          schema do
            key '$ref', :CardDetails
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
      card = policy_scope(Card).where(id: params[:id]).first or not_found
      card_params.delete(:list_id)
      if card.update(card_params)
        render json: card, serializer: CardDetailsSerializer
      else
        render json: { message: "cannot update card", errors: card.errors.full_messages}, status: :bad_request
      end
    end

    swagger_path '/cards/{id}' do
      operation :get do
        key :description, 'Card Details'
        key :tags, ['cards']
        parameter name: :id, in: :path, type: :string, format: :string, required: true
        response 200 do
          key :description, 'Success'
          schema do
            key '$ref', :CardDetails
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
      card = policy_scope(Card).where(id: params[:id]).first or not_found
      render json: card, serializer: CardDetailsSerializer
    end

    private
      def card_params
        params.permit :title, :description, :list_id
      end
  end
end