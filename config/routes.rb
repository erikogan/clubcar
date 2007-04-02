ActionController::Routing::Routes.draw do |map|
  map.resources :votes

  # special case for login
  map.connect '/users/login', :controller => "users", :action => "login"
  map.connect '/users/logout', :controller => "users", :action => "logout"
  
  map.resources :users do |user|
    user.resources :moods do |pref|
      pref.resources :preferences, :collection => { :change => :get, :save => :post }
    end
  end

  map.resources :restaurants, :collection => {:choose => :get} do |restaurant|
    restaurant.resources :labels, :collection => { :change => :get, :save => :post }
    # restaurant.resources :labels  do |label|
    #   label.resources :tags
    # end
    restaurant.resources :visits
  end

  map.resources :tags

  map.resources :tag_types
  
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
  map.connect '', :controller => "main"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
