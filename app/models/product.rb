class Product < ActiveRecord::Base
	belongs_to :user_info
	attr_accessible :brand, :description, :gender, :images, :material, :name, :price, :sale_price, :sizes	
end
