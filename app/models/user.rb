class User < ApplicationRecord
	include ImageUrl
	include Imagable
  has_secure_password
end