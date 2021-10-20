Rails.application.routes.draw do

  # root "folders#show"
  # root to: "folders#show", permalink: "unread"

  root to: redirect('/folder/unread')

  # devise_for :user
  devise_for :user,
  controllers: {
    registrations: 'users/registrations'
  },
  path: "",
  path_names: {
    sign_in: "login",
    sign_out: "logout",
    sign_up: "register",
    edit: "settings"
  }

  # get '/user', to: redirect('/folder/unread')

  get "folder/:permalink" => "folders#show", as: "folder_permalink"
  get "folder/:permalink/download" => "folders#download", as: "download_folder"
  patch "folder/:id/archive-all" => "folders#archive_all", as: "archive_all"
  resources :folders, path: "/folder" do
    member do
      patch :sort
    end
  end

  # get "article/new" => "article#create", as: "new_article"
  # delete "article/:permalink" => "article#destroy", as: "delete_article"
  # patch "article/:permalink/archive" => "article#archive", as: "archive_article"
  # patch "article/:permalink/unarchive" => "article#unarchive", as: "unarchive_article"
  resources :articles, path: "/article" do
    member do
      patch :archive
      patch :unarchive
    end
  end
  # resources :articles, only: [:index]
  get "export" => "articles#export", as: "export"

  namespace :hello, defaults: { format: 'js' } do
    # resources :articles
    get ":hello_token" => "articles#index"
    post ":hello_token" => "articles#create"
  end

  post "billing", to: "billing#create", as: "billing_create"
  post "billing/edit", to: "billing#edit", as: "billing_edit"
  resources :webhooks, only: [:create]

end
