PostitTemplate::Application.routes.draw do
  root to: 'posts#index'

  get '/register', to: 'users#new', as: 'register' #this creates a named route called 'register' automatically
                                  #as: 'register' is not necessary in this particular case, but I'm putting it in to be explicit.
  get '/login', to: 'sessions#new' #with these 'sessions' we're creating a resourceful entity called 'sessions' (which doesn't have to be named 'sessios') in order to have access to 'new', 'create', 'destroy' methods, but without having to create a model; we can thus use non-model-backed helper methods in the new.html.erb template
  post '/login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  resources :posts, except: [:destroy] do
    resources :comments, only: [:create]
  end

  resources :categories, only: [:new, :create, :show]
  resources :users, only: [:create]

end
