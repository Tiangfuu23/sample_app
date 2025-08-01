Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "home", to: "static_pages#home", as: :home
    get "help", to: "static_pages#help", as: :help

    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    resources :users, only: :show

    get "/login", to: 'sessions#new'
    post "/login", to:'sessions#create'
    delete "/logout", to: 'sessions#destroy'
  end
end
