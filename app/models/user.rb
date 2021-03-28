class User < ApplicationRecord
	include ImageUrl
	include Imageable
	include Likable
  
	PERMIT_COLUMNS = [:email,:image, :password, :phone, :name, :type, :info, :status, images: []]
	
	has_secure_password

  ransacker :status, formatter: proc {|v| statuses[v]}

  enum status: %i(default approving approved canceled)
end
