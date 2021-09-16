Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#index'
  resources :merchants, only: :index do
    get '/dashboard', controller: :merchants, action: :show, as: 'dashboard'
    resources :items, only: :index
    resources :invoices, only: :index
  end

  namespace :admin do
    get '/', to: 'dashboard#index', as: 'dashboard'
    resources :merchants, except: :delete
    resources :invoices, only: [:index, :show]
  end

end
