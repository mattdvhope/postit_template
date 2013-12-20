PostitTemplate::Application.routes.draw do
  root to: 'posts#index'

  get '/register', to: 'users#new', as: 'register' #this creates a named route called 'register' automatically
                                  #as: 'register' is not necessary in this particular case, but I'm putting it in to be explicit.
  get '/login', to: 'sessions#new' #with these 'sessions' we're creating a resourceful entity called 'sessions' (which doesn't have to be named 'sessions') in order to have access to 'new', 'create', 'destroy' methods, but without having to create a model; we can thus use non-model-backed helper methods in the new.html.erb template
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy', as: 'logout' # , as: 'logout' is redundant and thus not necessary.

  resources :posts, except: [:destroy] do
    member do # w/in a member we specify the HTTP verb (post, here) and then we specify an action (:vote)
      post :vote # 'post' here is the HTTP verb; it will require an 'id' in the middle of the URL (/posts/3/vote); therefore this 'id' is exposed to every member of that URL (both sides of the '3' (.../3/...))
    end          # this gives us the ability to process a 'vote' for a 'post'; the post_id is built into the URL

    resources :comments, only: [:create] do
      member do
        post :vote # 'post' is the HTTP verb
      end
    end
  end

  resources :categories, only: [:new, :create, :show]
  resources :users, only: [:show, :create, :edit, :update]

end

# POST /posts/3/vote => 'PostController#vote'
# POST /comments/4/vote => 'CommentsController#vote'