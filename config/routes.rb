Rails.application.routes.draw do
  resources :fyber_offers, only: :index do
    collection do
      get 'search'
    end
  end

  root 'fyber_offers#index'
end
