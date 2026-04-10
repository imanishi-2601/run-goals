Rails.application.routes.draw do
  root "homes#top"

  # =========================================================
  # ユーザー
  # =========================================================
  # 新規登録（サインアップ）
  # ログイン
  devise_for :users # devise標準のルーティングを使用

  resources :users, only: [:show, :edit, :update, :destroy]

  # コミュニティ
  resources :communities do
    resources :community_memberships, only: [:index, :create, :update, :destroy]
    resources :posts
    # 管理者移行用のルート
    member do
      patch :request_owner_transfer
      patch :accept_owner_transfer
      patch :reject_owner_transfer
    end
  end

  get "search", to: "search#index"

  # マイページ
  # get "users/show" => "users#"

  # 全投稿一覧用
  resources :posts

  # =========================================================
  # 管理者
  # =========================================================
  namespace :admins do
    root "communities#index"

    get "sign_in", to: "sessions#new"
    post "sign_in", to: "sessions#create"
    delete "sign_out", to: "sessions#destroy"

    resources :communities do
      resources :community_memberships, only: [:index, :create, :update, :destroy]
      resources :posts, only: [:index]
    end
    resources :posts, only: [:index]
    resources :users
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end