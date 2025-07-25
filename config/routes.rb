Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "home", to: "static_pages#home", as: :home
    get "help", to: "static_pages#help", as: :help
  end
end
