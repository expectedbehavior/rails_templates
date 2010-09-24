ActionController::Routing::Routes.draw do |map|
  map.signup        "signup",        :controller => "users", :action => "new"
  map.login         "login",         :controller => "user_sessions", :action => "new"
  map.logout        "logout",        :controller => "user_sessions", :action => "destroy"

  map.resources :password_resets, :only => [ :new, :create, :edit, :update ]
  map.resources :user_sessions, :only => [ :new, :create, :destroy ]
  map.resources :users, :except => [ :destroy, :index ]

  map.root :controller => "home"
end
