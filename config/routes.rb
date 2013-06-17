ShopulseBeta::Application.routes.draw do
	resources :products

	devise_for :users, :controllers => {:sessions => 'sessions', :registrations => 'registrations'} do
		get 'users/sign_out', :to => "sessions#destroy"
	end
	
	root :to => 'products#index'
	
	get '/admin', :to => 'user_infos#admin'
	match ':controller(/:action(/:id))(.:format)'
end