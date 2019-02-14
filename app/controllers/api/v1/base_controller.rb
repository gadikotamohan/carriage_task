module API::V1
  class BaseController < ActionController::API
    include Swagger::Blocks
    include ActionController::HttpAuthentication::Token::ControllerMethods
    include Pundit

    before_action :load_session
    before_action :authenticate!


    # For action specific secret code requirment, use array of actions ['show', 'index'] as value
    SECRET_CODE_REQUIRED_PAGES=
      { 'orders/evouchers': ['index'],
        'profile/secret_questions': ['verify_passcode']
      }.with_indifferent_access

    private

    def load_session
      authenticate_with_http_token do |token, options|
        device_id = options.delete(:device_id)
        @current_session = Session.where(device_id: device_id, token: token).first
      end
    end

    def authenticate
      if @current_session && @current_session.user
        @current_user = @current_session.user
        @current_user.current_session = @current_session
      end
    end

    def authenticate!
      if @current_session
        unless @current_session.valid_session?
          render json: { message: "Session Expired" }, status: :unauthorized
          return
        end

        if @current_user = @current_session.user
          @current_user.current_session = @current_session
        end
      end
      render json: { message: "Invalid Credentials" }, status: :unauthorized unless @current_user
    end

    def current_user
      @current_user
    end

    def pagination_meta(collection)
      { current_page: collection.current_page, next_page: collection.next_page, prev_page: collection.prev_page }
    end

    def session_params
      @session_params ||= current_user.current_session&.as_json&.extract!('client_name', 'app_version')
    end

    def not_found
      raise ActionController::RoutingError.new('Not Found')
    end

  end
end
