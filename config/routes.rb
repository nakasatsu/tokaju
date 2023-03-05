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
  
  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end
  
  scope module: :public do
    root to: 'homes#top'
    
    get '/posts/filter' => 'posts#filter'
    resources :posts do
      resources :post_comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
    end
    
    resources :users, only: [:show, :edit, :update] do
      member do
        get :favorites
      end
    end
    
    get '/search' => 'searches#search'
    get '/search/filter' => 'searches#filter'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
