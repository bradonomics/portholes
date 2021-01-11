Rails.application.routes.draw do

  root "folders#show"

  devise_for :user
  # controllers: {
  #   sessions: 'users/sessions'
  # },
  # path: "",
  # path_names: {
  #   sign_in: "login",
  #   sign_out: "logout",
  #   sign_up: "register"
  # }

  get "folder/:permalink" => "folders#show", as: "folder_permalink"
  resources :folders, path: "/folder" do
    member do
      get :download
      patch :sort
    end
  end

  resources :articles, path: "/article" do
    member do
      patch :archive
      patch :unarchive
    end
  end
  # resources :articles, only: [:index]

end
