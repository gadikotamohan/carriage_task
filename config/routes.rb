Rails.application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :docs, only: [:index]
      resource :auth, only: [:show, :destroy], controller: 'auth' do
        collection do
          get :test # For development purpose.
          resource :basic, only: [:create], controller: 'auth/basic_auth' do
            post :registration
          end
        end
      end
      resources :users, only: :index
      resources :lists
    end
  end
end
