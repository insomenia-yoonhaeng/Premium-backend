class Tutor < User
	include Authable

	has_many :projects, dependent: :nullify
end
