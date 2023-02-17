Rails.application.routes.draw do
  # 管理者用
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
  
  namespace :admin do
    get '/' => 'homes#top'
    get 'users/unsubscribe' => 'users#unsubscribe'
    resources :users, only: [:index, :show, :destroy]
    resources :posts, only: [:index, :show, :destroy]
  end
  
  # 会員用
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }
  
  scope module: :public do
    root to: 'homes#top'
    
    resources :posts, only: [:new, :create, :show, :destroy] do
      resources :post_comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
    end
    
    resources :users, only: [:show, :edit, :update] do
      member do
        get :favorites
      end
    end
    
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
