class Option < ApplicationRecord
  belongs_to :tutor
  belongs_to :chapter

  PERMIT_COLUMNS = [ options: [:title, :weight] ]

  enum status: %i(prepare progress complete)

  ransacker :status, formatter: proc {|v| statuses[v]}

end
