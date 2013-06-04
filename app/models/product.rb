class Product < ActiveRecord::Base
	belongs_to :user_info
	attr_accessible :brand, :description, :gender, :material, :name, :price, :sale_price, :sizes
	attr_accessible :photos, :photos_attributes

	has_many :photos
	accepts_nested_attributes_for :photos, :allow_destroy => true
end
