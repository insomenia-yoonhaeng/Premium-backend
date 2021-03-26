class Tutee < User
	include Authable

	belongs_to :project, optional: true
end
