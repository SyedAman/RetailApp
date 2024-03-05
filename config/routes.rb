Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    resources :products do
      collection do
        get 'search'
        get 'approval-queue', to: 'approval_queues#index'
      end
    end
    put 'products/approval-queue/:id/approve', to: 'approval_queues#approve'
    put 'products/approval-queue/:id/reject', to: 'approval_queues#reject'
  end
end
