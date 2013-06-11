class UserInfosController < ApplicationController
	def edit_profile
		@user_info = current_user.user_info
	end

	def update
		@user_info = current_user.user_info
		respond_to do |format|
			if @user_info.update_attributes(params[:user_info])
				format.html { redirect_to :action => 'edit_profile' , notice: 'Successfully Updated! 10/10!' }
				redirect_to :controller => "products", :action => "index"
			else
				format.html { render action: "edit_profile" }
			end
		end
	end
end