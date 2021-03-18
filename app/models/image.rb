class Image < ApplicationRecord
	include ImageUrl
  belongs_to :imageable, polymorphic: true, optional: true
end
