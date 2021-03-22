class Tutor < User
	has_many :projects, dependent: :nullify
end
