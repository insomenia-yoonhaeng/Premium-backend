class User < ApplicationRecord
	include ImageUrl
	include Imageable
  
	PERMIT_COLUMNS = [:email,:image, :password, :user_type, :phone, :name, :info, :status, images: []]
	
	has_secure_password

  ransacker :status, formatter: proc {|v| statuses[v]}

  enum user_type: %i(tuty tutor)

  enum status: %i(default approving approved canceled)
end
