class Product < ActiveRecord::Base
	belongs_to :user_info
	attr_accessible :brand, :description, :gender, :material, :name, :price, :sale_price, :sizes
	attr_accessible :photos, :photos_attributes
	attr_accessible :product_type
	attr_accessible :shopify_id

	has_many :photos
	accepts_nested_attributes_for :photos, :allow_destroy => true

	def complete_product?
		list = self.attribute_names - ['gender']
		list.each do |key|
			return false if self[key] == nil || self[key] == ""
		end
		return true
	end
end
