Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'auth/login',           to: 'auth#login'
      post 'auth/refresh',         to: 'auth#refresh'
      post 'auth/forgot_password', to: 'auth#forgot_password'
      post 'auth/reset_password',  to: 'auth#reset_password'

      get 'dashboard', to: 'dashboard#index'

      get 'utenti/me', to: 'utenti#me'
      resources :utenti, only: [:index, :show, :create, :update, :destroy] do
        member do
          patch 'assign_role'
        end
      end

      resources :prodotti, only: [:index, :show, :create, :update, :destroy]
      resources :movimenti, only: [:index, :create]
      resources :tipo_prodotto, only: [:index]
      resources :ruoli, only: [:index]
    end
  end
end