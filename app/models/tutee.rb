class Tutee < User
	belongs_to :project, optional: true
end
