Rails.application.routes.draw do
  get "discourse/sso"
  get "discuss" => 'discourse#embed'
  resources :pages, only: [:show]
  use_doorkeeper
  require 'sidekiq/web'
  require "admin_constraint"
  mount Sidekiq::Web, at: '/sidekiq', constraints: AdminConstraint.new

  get "signout" => "sessions#destroy", :as => "signout"
  get "signin" => "sessions#new", :as => "signin"
  get '/robots.txt' => 'robots#robots', :format => :txt

  resources :sessions

  constraints subdomain: 'www' do
    # resources :discussions
    get "activity" => "activities#index", :as => "activity"
    resources :featured_images
    resources :organizations, only: [:index, :show, :new, :create, :edit, :update] do
      resources :lab_organizations, controller: 'organizations/lab_organizations' do
        member do
          post :accept
        end
      end
    end

    # resources :events

    get "verify_email(/:id)", to: "users#verify_email", as: "verify_email"

    %w(tos privacy-policy cookie-policy about choose_locale country_guess).each do |action|
      underscored = action.underscore
      get action => "static##{underscored}", as: underscored
    end

    resources :users
    resources :machines

    resources :brands

    resources :comments, only: [:create]

    resources :recoveries do
      collection do
        get :check_inbox
      end
    end

    get "signup" => "users#new", :as => "signup"
    get "settings" => "users#edit", :as => "settings"

    get "resend_verification_email" => "users#resend_verification_email"

    namespace :backstage do
      get "users/list" => "users#list"
      resources :users do
        resources :roles, controller: 'users/roles', only: [:index, :new, :create, :destroy]
      end
      resources :employees, only: :index
      resources :pages, expect: [:show]
      resources :organizations, only: [:index]
      resources :my_labs, only: [:index]
      resources :my_projects, only: [:index]
      resources :to_approve_labs, only: [:index]
      resources :labs do
        member do
          patch :approve
          patch :reject
          patch :remove
          patch :referee_approves
          patch :referee_rejects
          patch :request_more_info
          patch :referee_requests_admin_approval
          patch :admin_approves
          patch :admin_rejects
          patch :add_more_info
        end
      end
      root to: 'labs#index'
    end

    resources :employees do
      member do
        patch :approve
      end
    end

    get 'events' => 'events#main_index', as: 'events'
    resources :search, only: [:index]
    resources :projects do
      collection do
        get '/tags', action: :search
        get '/lab/:slug', action: :search
        get :map
        get :embed
      end
      get 'mapdata', on: :collection
      resources :steps do
        resources :links
      end
    end
    resources :referee_approval_processes, only: [:destroy]
    resources :contributions, only: [:destroy]
    resources :collaborations, only: [:destroy]
    resources :documents, only: [:destroy]
    resources :facilities, only: [:destroy]

    resources :users do
      resources :favourites, only: [:create, :destroy]
      resources :grades, only: [:create, :destroy]
    end

    get "/labs/docs/:page" => "labs#docs"
    resources :labs do
      resources :events
      resources :admin_applications
      resources :role_applications
      resources :employees
      resources :academics

      get 'mapdata', on: :collection
      # resources :discussions
      member do
        get :manage_admins
      end
      collection do
        get :map
        get :embed
        get :list
      end
    end

    root to: 'static#home'

  end

  constraints subdomain: 'api' do
    get '/' => 'static#api'
    namespace :api, path: '' do
      namespace :v0 do
        get 'me' => 'users#me'
        get 'users' => 'users#search'
        get 'labs/search' => 'labs#search'

        get 'search/all' => 'search#all'
        get 'search/labs' => 'search#labs'
        get 'search/projects' => 'search#projects'
        get 'search/machines' => 'search#machines'

        resources :coupons do
          get "redeem", on: :member
        end
        resources :labs do
          get :map, on: :collection
        end
        resources :projects do
          get :map, on: :collection
        end
      end
      namespace :v1 do
        get 'users' => 'users#search'

      end
    end
  end

  # constraints subdomain: 'api' do
  #   use_doorkeeper
  #   get '/' => 'static#api'
  #   api versions: 1, module: "api/v1" do
  #     get 'me' => 'users#show'
  #     resources :labs, only: [:index]
  #   end
  # end

  get ':id' => 'redirects#show'
end
