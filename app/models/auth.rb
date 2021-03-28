class Auth < ApplicationRecord
	#include ImageUrl
	include Imageable
	
	PERMIT_COLUMNS = [:description, :authable_type, :authable_id, images_attributes: [:id, :image, :imagable_type, :imagable_id, :_destroy]]

  belongs_to :authable, polymorphic: true, optional: true
end
