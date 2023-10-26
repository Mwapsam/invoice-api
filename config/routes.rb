Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :invoices do
        collection do
          post :send_invoice
          get :load_invoices
        end
        member do
          get 'one_invoice/:token', action: :one_invoice
        end
      end
      resources :customers
      resources :items
      resources :users do
        collection do
          get :signed_user
        end
      end
      resources :sessions do
        collection do
          post :single_session
        end
      end
      resources :audit_logs
      resources :payments do
        collection do
          post :send_money
        end
      end
    end
  end
end
