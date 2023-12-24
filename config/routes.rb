Rails.application.routes.draw do
  namespace :api do
    get 'v1/student_activity_controller'
    namespace :v1 do

      resources :students, only: [] do
        post 'search', on: :collection, to: 'students#search'
        get 'admin', on: :collection, to: 'student_admin#index'
        get ':id', on: :collection, to: 'students#show'
      end

      resources :volunteers, only: [] do
        get 'admin', on: :collection, to: 'student_admin#show_volunteer'
        delete 'admin/:id', on: :collection, to: 'student_admin#delete_student_volunteer'
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

      resources :student_interview, only: [] do
        patch 'admin/:id', on: :collection, to: 'student_interview_admin#update'
        get 'admin/:id', on: :collection, to: 'student_interview_admin#show'
        get 'admin', on: :collection, to: 'student_interview_admin#index'
      end

      resources :interviews, only: [] do
        get 'admin', on: :collection, to: 'interview_admin#index_admin'
        patch 'admin/:id', on: :collection, to: 'interview_admin#update'
        post 'admin', on: :collection, to: 'interview_admin#create'
        delete 'admin/:id', on: :collection, to: 'interview_admin#destroy'
      end

      resources :activities, only: [] do
        get 'admin', on: :collection, to: 'activity_admin#index'
        patch 'admin/:id', on: :collection, to: 'activity_admin#update'
        get 'admin/:id', on: :collection, to: 'activity_admin#show'
        post 'admin', on: :collection, to: 'activity_admin#create'
        delete 'admin/:id', on: :collection, to: 'activity_admin#destroy'
        delete ':idActivity/:idStudent', on: :collection, to: 'activity#show'
      end 

      resources :student_activity, only: [] do
        post 'admin', on: :collection, to: 'student_activity_admin#create'
      end

    end
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
