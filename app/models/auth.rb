class Auth < ApplicationRecord
	#include ImageUrl
	include Imageable

	
	PERMIT_COLUMNS = [:description, :authable_type, :authable_id, images_attributes: [:id, :image, :imagable_type, :imagable_id, :_destroy]]

  belongs_to :authable, polymorphic: true, optional: true

	delegate :tutee, to: :authable, allow_nil: true
	before_create :check_user_auth

	private 

	def check_user_auth
		throw(:abort) if (self.authable.auths.present? && self.authable_type == "User" && self.authable.type == "Tutor")
	end
end
