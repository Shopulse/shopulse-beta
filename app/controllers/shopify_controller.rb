class ShopifyController < ApplicationController
	skip_before_filter :authenticate
	
	@@temp = 1
	def check_out_create
		@@temp = params
		render :json => @@temp
		10.times { puts params 	}
	end

	def check
		render :json => @@temp
	end
end
