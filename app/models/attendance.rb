class Attendance < ApplicationRecord
	include Authable

  belongs_to :project
  belongs_to :tutee

end
