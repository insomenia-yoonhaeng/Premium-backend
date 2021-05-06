class Attendance < ApplicationRecord
	include Authable

  belongs_to :project
  belongs_to :tutee

  enum status: %i(trial full)

  ransacker :status, formatter: proc {|v| statuses[v]}
end
