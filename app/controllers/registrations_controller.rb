class RegistrationsController < Devise::RegistrationsController
	skip_before_filter :authenticate

	def create
		super
		# redirect_to :controller => "UserInfos", :action => "edit_profile"
	end

	def destroy
		if current_user.user_info.admin == true
			user_info = UserInfo.find params[:id]
			user_info.products.delete_all
			user = User.find user_info.user_id
			user_info.destroy
			user.destroy
			redirect_to :controller => 'admin', :action => 'index'
		else
			super
		end
	end

	def after_sign_up_path_for(resource)
		"/UserInfos/edit_profile"
	end
end