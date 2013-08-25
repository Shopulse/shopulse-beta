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
		current_user.create_user_info if current_user.user_info == nil
		@user_info = current_user.user_info
		@admin = false
		if @user_info.admin
			@user_info = UserInfo.find params[:id] if @user_info.admin && params[:id]
			@admin = true
		end
	end

	def merchant_agreement

	end

	def update
		current_user.create_user_info if current_user.user_info == nil
		user_info = current_user.user_info
		if user_info.admin == true
			user_info = UserInfo.find(params[:user_info][:user_id])
			params[:user_info].delete :user_id
		end

		respond_to do |format|
			if user_info.update_attributes params[:user_info]
				format.html { redirect_to '/' }
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