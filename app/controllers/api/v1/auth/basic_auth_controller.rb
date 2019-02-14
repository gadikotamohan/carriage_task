module API::V1
  class Auth::BasicAuthController < BaseController
    include BCrypt

    skip_before_action :authenticate!, only: [:create, :registration]
    before_action :ensure_email_param

    swagger_path '/auth/basic' do
      operation :post do
        key :description, 'Authenticate with Email and Password'
        key :tags, ['auth']
        parameter name: :email,     in: :formData, type: :string, format: :email, required: true
        parameter name: :password,  in: :formData, type: :string, format: :password, required: true
        parameter name: :device_id, in: :formData, type: :string, required: true
        parameter name: :notification_token, in: :formData, type: :string, required: false
        parameter name: :client_key, in: :formData, type: :string, required: true
        parameter name: :client_name, in: :formData, type: :string, required: true do
          key :description, 'iOSApp, AndroidApp, WebBrowser'
        end
        parameter name: :client_version, in: :formData, type: :string, required: true do
          key :description, 'Version of Mobile OS, or Web Browser Agent name'
        end
        parameter name: :app_version, in: :formData, type: :string, required: false do
          key :description, 'Version of Mobile App, or Web Browser'
        end
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

    swagger_path '/auth/basic?' do
      operation :post do
        key :description, 'Authenticate with Mobile and Password'
        key :tags, ['auth']
        parameter name: :phone,     in: :formData, type: :string, format: :email, required: true
        parameter name: :password,  in: :formData, type: :string, format: :password, required: true
        parameter name: :device_id, in: :formData, type: :string, required: true
        parameter name: :client_key, in: :formData, type: :string, required: true
        parameter name: :client_name, in: :formData, type: :string, required: true do
          key :description, 'iOSApp, AndroidApp, WebBrowser'
        end
        parameter name: :client_version, in: :formData, type: :string, required: true do
          key :description, 'Version of Mobile OS, or Web Browser Agent name'
        end
        parameter name: :app_version, in: :formData, type: :string, required: false do
          key :description, 'Version of Mobile App, or Web Browser'
        end
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

    def create
      user = User.where(email: params[:email]).first
      authentication = BasicAuthentication.where(user_id: user.id).first if user

      if authentication.present? && !authentication.account_locked? && authentication.valid_password?(params[:password])
        # reset
        session = authentication.sessions.where( device_id: params[:device_id] ).first
        session ||= authentication.sessions.new(session_params.merge(user: authentication.user))
        session.generate_token
        # Extend expiry
        session.app_version = session_params[:app_version]
        if session.save
          render json: session, adapter: :attributes, status: :ok
        else
          render json: { message: "Failed to create session", errors: session.errors.messages }, status: 401
        end
      else
        render json: { message: "Incorrect email or password" }, status: 401
      end
    end

    swagger_path '/auth/basic/registration' do
      operation :post do
        key :description, 'Register using Email and Password'
        key :tags, ['auth']
        parameter name: :email,     in: :formData, type: :string, format: :email, required: true
        parameter name: :first_name,      in: :formData, type: :string, format: :string, required: true
        parameter name: :last_name,      in: :formData, type: :string, format: :string, required: true
        parameter name: :password,  in: :formData, type: :string, format: :password, required: true
        parameter name: :device_id, in: :formData, type: :string, required: true
        parameter name: :client_name, in: :formData, type: :string, required: true do
          key :description, 'iOSApp, AndroidApp, WebBrowser'
        end
        parameter name: :client_version, in: :formData, type: :string, required: true do
          key :description, 'Version of Mobile OS, or Web Browser Agent name'
        end
        parameter name: :app_version, in: :formData, type: :string, required: false do
          key :description, 'Version of Mobile App, or Web Browser'
        end
        response 200 do
          key :description, 'Registration Successful'
          schema do
            key '$ref', :SessionData
          end
        end
        response 202 do
          key :description, 'Registration Pending OTP Verification'
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
          key :description, 'Registration Failure'
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

    def registration
      params[:email].downcase!
      unless User.where(email: params[:email]).count.zero?
        render json: { message: "Email is already in use" }, status: :unauthorized
      else
        profile_params = {source: profile_source_params.to_h}
        user = User.create(user_params.merge({profile: profile_params}))
        authentication = BasicAuthentication.create(auth_params.merge(user: user, uid: nil, expires_at: nil)) if user && user.persisted?
        session = authentication.sessions.create(session_params.merge(user: user)) if authentication&.persisted?
        if session&.persisted?
          render json: session, adapter: :attributes, otp: nil, status: 200
        else
          render json: { message: "Registration failed", errors: user.errors.messages.presence || ( authentication && authentication.errors.messages ) }, status: :unauthorized
        end
      end
    end

    private

    def user_params
      params.permit :email, :phone, :first_name, :last_name
    end

    def auth_params
      params.permit :password
    end

    def session_params
      params.permit :device_id, :notification_token, :client_name, :client_version, :app_version
    end

    def profile_source_params
      params.permit(:client_name, :client_version).merge({ip_address: request.remote_ip})
    end

    def ensure_email_param
      render json: { message: "Email should not be blank" }, status: 401 unless params[:email].present?
    end

  end
end
