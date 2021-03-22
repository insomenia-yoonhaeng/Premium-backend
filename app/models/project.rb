class Project < ApplicationRecord
  belongs_to :tutor, optional: true
	has_many :tutties, dependent: :nullify
end
