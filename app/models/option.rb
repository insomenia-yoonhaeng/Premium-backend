class Option < ApplicationRecord
  belongs_to :tutor
  belongs_to :chapter

  enum status: %i(prepare progress complete)

  ransacker :status, formatter: proc {|v| statuses[v]}

end
