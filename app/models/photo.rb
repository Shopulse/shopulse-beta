class Photo < ActiveRecord::Base
	belongs_to :product
	attr_accessible :photo
	attr_accessible :photo_file_name
	has_attached_file :photo,
	:styles => {
		thumb: '100x100>',
		square: '200x200#',
		medium: '300x300>'
	},
	size: {
		less_than: 5.megabytes
	}
end
