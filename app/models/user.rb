class User < ApplicationRecord
	include ImageUrl
	include Imageable
  has_secure_password
end