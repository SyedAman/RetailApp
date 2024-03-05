Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

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
