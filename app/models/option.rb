class Option < ApplicationRecord
  belongs_to :tutor
  belongs_to :chapter

  PERMIT_COLUMNS = [ options: [:weight, :id] ]

  enum status: %i(prepare progress complete)

  ransacker :status, formatter: proc {|v| statuses[v]}

  enum holiday: %i(normal holiday)

end
