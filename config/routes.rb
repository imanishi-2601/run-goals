Rails.application.routes.draw do
  root "homes#top"
  get "community_memberships/index"
  get "community_memberships/create"
  get "community_memberships/update"
  get "community_memberships/destroy"
  get "posts/index"
  get "posts/show"
  post "posts/new" => "posts#create"  # データを追加（保存）するため
  get "posts/edit"


  # =========================================================
  # ユーザー
  # =========================================================
  # 新規登録（サインアップ）
  # ログイン
  devise_for :users

  resources :users

  # コミュニティ
  resources :communities do
    collection do
      get :search
    end

    resources :community_memberships, only: [:index, :create, :update, :destroy]
    resources :posts, only: [:index]
  end

  resources :users, only: [:show, :edit, :update, :destroy]
  get "search", to: "search#index"

  # マイページ
  # get "users/show" => "users#"

  # 投稿
  resources :posts

  # =========================================================
  # 管理者
  # =========================================================
  namespace :admins do
    resources :communities
    resources :communities, only: [:index, :show, :update, :destroy]
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
