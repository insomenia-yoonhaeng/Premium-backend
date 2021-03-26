class Tutee < User

	has_many :project_tutees, dependent: :nullify
end
