class RegistrationsController < Devise::RegistrationsController
	skip_before_filter :authenticate	

	def create
		super
	end
end