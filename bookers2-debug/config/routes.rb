Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "homes#top"
  get "home/about"=>"homes#about"
  get "search" => "searches#search"
  get 'chat/:id' => 'chats#show', as: 'chat'
  resources :chats, only: [:create]
  devise_for :users
  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
   resource :favorites, only: [:create, :destroy]

   resources :book_comments, only: [:create, :destroy]

  end

  resources :users, only: [:index,:show,:edit,:update] do
     get "search", to: "users#search"
   
   resource :relationships, only: [:create, :destroy]
     get 'relationships/followings' => 'relationships#followings', as: 'followings'
     get 'relationships/followers'  => 'relationships#followers', as: 'followers'
  end
  
  resources :groups, except: [:destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
