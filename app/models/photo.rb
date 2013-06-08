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

	before_create :randomize_file_name

	private
	
	def randomize_file_name
		extension = File.extname(photo_file_name).downcase
		self.photo.instance_write(:file_name, "#{SecureRandom.hex(16)}#{extension}")
	end
end
