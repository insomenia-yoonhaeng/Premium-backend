module ImageUrl
	included do
		mount_uploader :image, ImageUploader
	end

	def image_path size = :square
		image ? image.url size : ' '
	end
end