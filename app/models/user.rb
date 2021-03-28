class User < ApplicationRecord
	include ImageUrl
	include Imageable
  
	PERMIT_COLUMNS = [:email, :image, :password, :phone, :name, :type, :info, :status, images_attributes: [:id, :image, :imagble_type, :imageble_id]]
	
	has_secure_password

  ransacker :status, formatter: proc {|v| statuses[v]}

  enum status: %i(default approving approved canceled)
end
