class Auth < ApplicationRecord
	#include ImageUrl
	include Imageable

	
	PERMIT_COLUMNS = [:description, :authable_type, :authable_id, images_attributes: [:id, :image, :imagable_type, :imagable_id, :_destroy]]

  belongs_to :authable, polymorphic: true, optional: true

	delegate :targets, to: :authable, allow_nil: true
	before_create :check_user_auth

	private 

	def check_user_auth
		puts "checkeckekc" if (self.authable.auths.present? && self.authable_type == "User")
	end
end
