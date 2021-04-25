Rails.application.routes.draw do
  #devise_for :users
  # devise_scope :users do
  #   post "/users/sign_up" => "devise/registrations#create"
  # end
  devise_for :users,
    path: '',
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'signup'
    },
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      omniauth_callbacks: 'users/omniauth_callbacks'
    }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # post 'users/sign_in', to: 'authentication#login'
  # delete 'users/sign_out', to: 'authentication#logout'
  # post 'users/sign_up', to: 'users#create'
  get '/get_current_user', to: 'users#get_current_user'
  resources :users, except: :create
	resources :projects
  resources :auths
  resources :books do
    get :get_list, on: :collection
  end
  
end
