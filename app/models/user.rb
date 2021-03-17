class User < ApplicationRecord
	include ImageUrl
	include Imageable
  
	PERMIT_COLUMNS = [:email, :password_digest, :user_type, :phone, :name, :info, images: []]
	
	has_secure_password
end