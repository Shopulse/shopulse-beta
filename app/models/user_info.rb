class UserInfo < ActiveRecord::Base
	attr_accessible :email, :name, :first_name, :last_name, :address, :city, :province, :country, :postal_code, :phone
	attr_accessible :admin
	has_many :products
end
