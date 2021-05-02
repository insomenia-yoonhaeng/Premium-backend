class Tutee < User
	has_many :attendances, dependent: :nullify
	has_many :auths, through: :attendances, foreign_key: "authable_id"
	has_many :projects, through: :attendances
end
