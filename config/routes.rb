Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :students, only: [:index, :show, :create, :update, :destroy]

      resources :auth, only: [] do
        post 'login', on: :collection, to: 'auth#login'
        post 'logout', on: :collection, to: 'auth#logout'
        post 'refresh', on: :collection, to: 'auth#refresh'
        post 'check_cookie', on: :collection, to: 'auth#check_cookie'
      end
      
    end
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
