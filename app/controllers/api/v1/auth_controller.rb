module API::V1
  class AuthController < BaseController
    skip_after_action :verify_authorized
    skip_before_action :authenticate!, only: [:test]

    swagger_path '/auth' do
      operation :get do
        key :description, 'Get Authentication Session Status.'
        key :tags, ['auth']
        response 200 do
          key :description, 'Auth Correct'
          schema do
            key '$ref', :SessionData
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
      render json: current_user.current_session, adapter: :attributes, status: 200
    end


    # For development purpose.
    swagger_path '/auth/test' do
      operation :get do
        key :description, 'Test Authentication Session Status using Token. Note : This is for debugging purpose, and not to be used for development.'
        key :tags, ['auth']
        parameter name: :token,     in: :query, type: :string, required: true
        response 200 do
          key :description, 'Auth Correct'
          schema do
            key '$ref', :SessionData
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

    def test
      session = Session.where(token:params[:token]).first
      render json: { Authorization: "Token token=#{session.token};device_id=#{session.device_id}",
                     session: session, authenticaiton: session.authentication, user: session.user }, status: :ok
    end

    swagger_path '/auth' do
      operation :delete do
        key :description, 'Delete Authentication Session'
        key :tags, ['auth']
        response 200 do
          key :description, 'Success'
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
      current_user.current_session.destroy
      render json: { message: "Logged out" }, status: :ok
    end

  end
end
