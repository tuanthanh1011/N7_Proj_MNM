Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      resources :students, only: [:index, :show, :create, :update, :destroy] do
        collection do
          post 'search' => 'students#search'
        end
      end

      resources :auth, only: [] do
        post 'login', on: :collection, to: 'auth#login'
        post 'logout', on: :collection, to: 'auth#logout'
        post 'refresh', on: :collection, to: 'auth#refresh'
      end

      resources :interviews, only: [] do
        get '', on: :collection, to: 'interview#index'
      end

      resources :student_interview, only: [] do
        post '', on: :collection, to: 'student_interview#create'
      end
      
    end
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
