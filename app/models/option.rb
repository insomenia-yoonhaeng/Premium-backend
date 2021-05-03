class Option < ApplicationRecord
  belongs_to :tutor
  belongs_to :chapter

  PERMIT_COLUMNS = [ options: [:weight, :chapter_id] ]

  enum status: %i(prepare progress complete)

  ransacker :status, formatter: proc {|v| statuses[v]}

end
