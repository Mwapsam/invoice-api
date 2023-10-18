Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :invoices do
        collection do
          post :send_invoice
        end
      end
      resources :customers
      resources :items
      resources :users do
        collection do
          get :signed_user
        end
      end
      resources :sessions
      resources :audit_logs
    end
  end
end
