Rails.application.routes.draw do

  mount ActionCable.server => '/cable'

  devise_for :users,
  controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :products do
    resources :requests, only: [:new, :create, :update, :index] do
      resources :ureviews, only: [:new, :create]
    end
    resources :reviews, only: [:new, :create]
  end

  resources :users, only: [:show, :edit, :update]
  resources :conversations, only: [:index] do
    resources :messages
   end


  resources :orders, only: [:show, :create] do
    resources :payments, only: [:new, :create]
  end

  notify_to :users, with_devise: :users

  get '/acceptedrequests', to: 'users#accepted', as: 'user_ac-requests'
  get '/pendingrequests', to: 'users#pending', as: 'user_pe-requests'
  get '/declinedrequests', to: 'users#declined', as: 'user_de-requests'

  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
