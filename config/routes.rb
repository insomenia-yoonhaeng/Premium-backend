Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'users/sign_in', to: 'authentication#login'
  delete 'users/sign_out', to: 'authentication#logout'
  post 'users/sign_up', to: 'users#create'
  resources :users
	resources :projects
end
