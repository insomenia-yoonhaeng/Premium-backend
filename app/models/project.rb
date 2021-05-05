class Project < ApplicationRecord
	include ImageUrl
	include Imageable
	acts_as_paranoid
	
	PERMIT_COLUMNS = [:experience_period, :description, :deposit, :image, :title, :category_id]
	
  belongs_to :tutor, optional: true
	has_many :attendances, dependent: :nullify
	belongs_to :category, optional: true
end
