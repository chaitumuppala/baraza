Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations',
                                    sessions: 'sessions', passwords: 'passwords' }

  resources :articles do
    member do
      get 'approve_form'
      get 'edit'
      patch 'approve'
      patch 'home_page_order_update'
    end
    collection do
      get 'search', as: 'search'
    end
  end

  resources :users do
    member do
      get :change_email_form
      patch :change_email
    end
  end

  resources :newsletters do
    member do
      get 'preview'
    end
    collection do
      post :subscribe
    end
  end

  resources :authors

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  resources :tags, only: [:index]
  # You can have the root of your site routed with "root"
  root 'home#index'

  get '/contact', to: 'static#contact'
  get '/about', to: 'static#about'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
