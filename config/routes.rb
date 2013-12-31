PostitTemplate::Application.routes.draw do
  root to: 'posts#index'

  get '/register', to: 'users#new', as: 'register' #this creates a named route called 'register' automatically
                                  #as: 'register' is not necessary in this particular case, but I'm putting it in to be explicit.
  get '/login', to: 'sessions#new' #with these 'sessions' we're creating a resourceful entity called 'sessions' (which doesn't have to be named 'sessions') in order to have access to 'new', 'create', 'destroy' methods, but without having to create a model; we can thus use non-model-backed helper methods in the new.html.erb template
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy', as: 'logout' # , as: 'logout' is redundant and thus not necessary.
  get '/pin', to: 'sessions#pin' #using same route with different HTTP verb to the same 'pin' action; this (on this line) gives us a helper method called 'pin_path' which we'll use in 'sessions_controller.rb'-->redirect_to pin_path
  post '/pin', to: 'sessions#pin' #for the 'get' request there is a default 'pin' action which simply renders the template, even if there is no actual defined 'pin' method in the controller; BUT, with the 'post' request there is no such default action/method: it has to be specifically delineated in the controller; interestingly, the 'pin' action is used by both the 'get' and the 'post' requests

  resources :posts, except: [:destroy] do
    member do # w/in a member we specify the HTTP verb (post, here) and then we specify an action (:vote, here)
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