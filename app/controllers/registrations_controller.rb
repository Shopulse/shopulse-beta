class RegistrationsController < Devise::RegistrationsController
	skip_before_filter :authenticate

	def create
		super
		# redirect_to :controller => "UserInfos", :action => "edit_profile"
	end

	def after_sign_up_path_for(resource)
		"/UserInfos/edit_profile"
	end
end