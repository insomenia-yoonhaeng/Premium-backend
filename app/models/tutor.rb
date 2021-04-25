class Tutor < User
	include Authable

	has_many :projects, dependent: :destroy

	has_many :options
	has_many :chapters, through: :options
end
