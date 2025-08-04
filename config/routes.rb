Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'sessions',
    registrations: 'registrations'
  }
  resources :users, only: [:index]

end
