class UserInfo < ActiveRecord::Base
	attr_accessible :email
	has_many :products
end
