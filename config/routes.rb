ShopulseBeta::Application.routes.draw do
	resources :products

	devise_for :users, :controllers => {:sessions => 'sessions', :registrations => 'registrations', :passwords => 'passwords'} do
		get 'users/sign_out', :to => "sessions#destroy"
	end
	
	root :to => 'products#index'
	
	get '/admin', :to => 'user_infos#admin'
	get '/boutique', :to => 'user_infos#boutique'
	match ':controller(/:action(/:id))(.:format)'
end