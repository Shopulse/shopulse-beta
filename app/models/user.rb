class User < ActiveRecord::Base
	devise :database_authenticatable, :registerable,
	:recoverable, :rememberable, :trackable, :validatable

	attr_accessible :email, :password, :password_confirmation, :remember_me
	has_one :user_info

	after_create :default_create_user_info

	def default_create_user_info
		create_user_info
		self.user_info.email = self.email
		self.save
	end
end
