ActionController::Routing::Routes.draw do |map|
  map.resources :password_resets, :olny => [:new, :edit, :create, :update]

  map.resources :votes
  
  map.resources :user_sessions, :only => [:new, :create, :destroy]

  # special case for login
  map.login 'login', :controller => "user_sessions", :action => "new"
  map.logout 'logout', :controller => "user_sessions", :action => "destroy"

  map.resources :users, :member => {:activate => :post, :deactivate => :post} do |user|
    user.resources :emails
    user.resources :moods, :member => {:activate => :post, :copy => :get }, :collection => { :list_activate => :any}  do |pref|
      pref.resources :preferences, :collection => { :change => :get, :save => :post }
    end
  end

  map.resources :restaurants, :collection => {:choose => :get} do |restaurant|
    restaurant.resources :visits
  end

  map.resources :tags

  map.resources :taggings
  
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"
  map.root :controller => "main"

  map.connect '/spin', :controller => "restaurants", :action => "mail_choices"
  map.connect '/wondertwins', :controller => "main", :action => "mail_warnings"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'

  map.graph '/graph/:action/:id/graph.png', :controller => 'graphs'
end
