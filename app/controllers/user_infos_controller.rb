class UserInfosController < ApplicationController
	skip_before_filter :authenticate, :only => [:merchant_agreement, :boutique]
	before_filter :admin_check, :only => :admin
	
	private
	def admin_check
		if current_user.user_info.admin == false
			redirect_to '/'
		end
	end

	public

	def edit_profile
		@user_info = current_user.user_info
	end

	def merchant_agreement

	end

	def update
		user_info = current_user.user_info
		respond_to do |format|
			if user_info.update_attributes params[:user_info]
				format.html { 
					redirect_to :controller => "products", :action => "index"
				}
			else
				format.html { render action: "edit_profile" }
			end
		end
	end

	def admin

	end

	def boutique

	end
end