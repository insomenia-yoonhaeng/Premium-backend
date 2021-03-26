class Auth < ApplicationRecord
	include ImageUrl
	include Imageable
	
  belongs_to :authable, polymorphic: true, optional: true
end
