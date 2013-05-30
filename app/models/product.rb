class Product < ActiveRecord::Base
	belongs_to :user_info
	attr_accessible :brand, :description, :gender, :images, :material, :name, :price, :sale_price, :sizes

	has_attached_file :images,
	:styles => {
		thumb: '100x100>',
		square: '200x200#',
		medium: '300x300>'
	},
    :storage => :s3,    
    size: {
		less_than: 5.megabytes
	},
	:path => "/:style/:id/:filename"
end
