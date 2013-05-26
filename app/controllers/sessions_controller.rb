class SessionsController < Devise::SessionsController
	skip_before_filter :authenticate

	# DELETE /resource/sign_out
	def destroy
		signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))		
		redirect_to '/users/sign_in'
	end

	def create
		super
		# resource = warden.authenticate!(:scope => resource_name, :reacall => :failure)
		# return sign_in_and_redirect(resource_name, resource)
	end

	def sign_in_and_redirect(resource_or_scope, resource = nil)
		scope = Devise::Mapping.find_scope!(resource_or_scope)
		resource ||= resource_or_scope
		sign_in(scope, resource) unless warden.user(scope) == resource
		# return render :json => {:success => true}
	end

	def failure
		return render :json => {:success => false, :errors => ['loging failed']}
	end
end